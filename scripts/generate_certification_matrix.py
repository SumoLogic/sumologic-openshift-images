#!/usr/bin/env python3
"""
Generate certification matrix by comparing images between two Helm chart versions.
This script identifies new and updated images that need Red Hat OpenShift certification.
"""

import json
import sys
import argparse
from datetime import datetime, timezone


def parse_image(image_ref):
    """Parse image reference into components"""
    image_ref = image_ref.strip()
    
    if ':' in image_ref:
        repo, tag = image_ref.rsplit(':', 1)
        name = repo.split('/')[-1]
        registry = '/'.join(repo.split('/')[:-1]) if '/' in repo else ''
        
        return {
            'full_reference': image_ref,
            'registry': registry,
            'repository': repo,
            'name': name,
            'tag': tag
        }
    return None


def get_latest_version(versions):
    """Get the latest version from a list, preferring semantic versions over 'latest' tag"""
    # Filter out 'latest' tags
    non_latest = [v for v in versions if v['tag'] != 'latest']
    if non_latest:
        # Return the last one (assuming sorted order from list-images.py)
        return non_latest[-1]
    # If only 'latest' tags, return the first one
    return versions[0] if versions else None


def read_images(file_path):
    """Read and parse images from a file"""
    with open(file_path, 'r') as f:
        images = [parse_image(line.strip()) for line in f if line.strip()]
        images = [img for img in images if img]
    return images


def group_by_name(images):
    """Group images by name"""
    by_name = {}
    for img in images:
        name = img['name']
        if name not in by_name:
            by_name[name] = []
        by_name[name].append(img)
    return by_name


def get_latest_images(images):
    """Get the latest version of each image by name"""
    by_name = group_by_name(images)
    latest = {}
    for name, versions in by_name.items():
        latest_version = get_latest_version(versions)
        if latest_version:
            latest[name] = latest_version
    return latest


def detect_changes(previous_latest, target_latest):
    """Detect new and updated images"""
    images_to_certify = []
    
    for name, target_img in target_latest.items():
        if name not in previous_latest:
            # Brand new image
            images_to_certify.append({
                **target_img,
                'change_type': 'new',
                'previous_version': None
            })
        elif previous_latest[name]['tag'] != target_img['tag']:
            # Version updated
            images_to_certify.append({
                **target_img,
                'change_type': 'updated',
                'previous_version': previous_latest[name]['tag']
            })
    
    return images_to_certify


def generate_matrix(previous_file, target_file, previous_version, target_version, output_file):
    """Generate certification matrix"""
    
    # Read images
    previous_images = read_images(previous_file)
    target_images = read_images(target_file)
    
    # Get latest versions
    previous_latest = get_latest_images(previous_images)
    target_latest = get_latest_images(target_images)
    
    # Detect changes
    images_to_certify = detect_changes(previous_latest, target_latest)
    
    # Generate certification matrix
    matrix = {
        'metadata': {
            'generated_at': datetime.now(timezone.utc).isoformat(),
            'previous_helm_version': previous_version,
            'target_helm_version': target_version
        },
        'summary': {
            'total_images_in_target': len(target_images),
            'total_unique_images': len(target_latest),
            'images_needing_certification': len(images_to_certify),
            'new_images': sum(1 for img in images_to_certify if img['change_type'] == 'new'),
            'updated_images': sum(1 for img in images_to_certify if img['change_type'] == 'updated')
        },
        'images': images_to_certify
    }
    
    # Save certification matrix
    with open(output_file, 'w') as f:
        json.dump(matrix, f, indent=2)
    
    # Print summary
    print(f"✅ Certification matrix generated: {len(images_to_certify)} images need certification")
    print(f"   - New images: {matrix['summary']['new_images']}")
    print(f"   - Updated images: {matrix['summary']['updated_images']}")
    
    return matrix


def main():
    parser = argparse.ArgumentParser(
        description='Generate certification matrix by comparing Helm chart versions'
    )
    parser.add_argument(
        '--previous-images',
        required=True,
        help='Path to file containing images from previous version'
    )
    parser.add_argument(
        '--target-images',
        required=True,
        help='Path to file containing images from target version'
    )
    parser.add_argument(
        '--previous-version',
        required=True,
        help='Previous Helm chart version (e.g., v4.17.1)'
    )
    parser.add_argument(
        '--target-version',
        required=True,
        help='Target Helm chart version (e.g., v4.18.0)'
    )
    parser.add_argument(
        '--output',
        default='certification_matrix.json',
        help='Output file path (default: certification_matrix.json)'
    )
    
    args = parser.parse_args()
    
    try:
        generate_matrix(
            args.previous_images,
            args.target_images,
            args.previous_version,
            args.target_version,
            args.output
        )
        return 0
    except Exception as e:
        print(f"❌ Error: {e}", file=sys.stderr)
        return 1


if __name__ == '__main__':
    sys.exit(main())
