#!/usr/bin/env python3

import subprocess
import sys
import argparse
import re
import urllib.error
import urllib.request

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--values", help="path to values.yaml", required=True)
    parser.add_argument("--fetch-base", help="should it fetch base images (e.g. Fluent Bit for Tailing Sidecar)", action=argparse.BooleanOptionalAction)
    parser.add_argument("--version", help="helm chart version", default="")
    return parser.parse_args()

def get_sumo_images(version, values, fetch_base):
    subprocess.check_output(f'helm repo add sumologic https://sumologic.github.io/sumologic-kubernetes-collection'.split(' '))
    subprocess.check_output(f'helm repo update'.split(' '))
    command = f'helm template collection sumologic/sumologic --namespace=sumologic --debug --version={version} --values={values}'
    output = subprocess.check_output(command.split(" "))

    matches = re.findall(r'(?:\s*image:\s*|-image=|prometheus-config-reloader=)(.*?)\\n', str(output))
    if matches == None:
        sys.exit(-1)
    
    for match in matches:
        if fetch_base:
            # Detect Fluent Bit image used by Tailing Sidecar (only for versions < 0.19.0)
            # Note: v0.19.0+ uses otelcol, v0.20.0+ removed fluentbit directories entirely
            if re.match('.*tailing-sidecar:.*', match):
                version = match.split(':')[-1]
                # Skip base image detection for versions >= 0.19.0 as they use otelcol, not fluentbit
                try:
                    version_parts = version.split('.')
                    major = int(version_parts[0])
                    minor = int(version_parts[1]) if len(version_parts) > 1 else 0
                    if major > 0 or (major == 0 and minor >= 19):
                        print(f"Info: Skipping base image detection for tailing-sidecar v{version} (uses otelcol, not fluentbit)", file=sys.stderr)
                        continue
                except (ValueError, IndexError):
                    pass  # If version parsing fails, try to fetch anyway
                
                try:
                    content = urllib.request.urlopen(f"https://raw.githubusercontent.com/SumoLogic/tailing-sidecar/v{version}/sidecar/fluentbit/Dockerfile").read()
                except urllib.error.HTTPError:
                    try:
                        content = urllib.request.urlopen(f"https://raw.githubusercontent.com/SumoLogic/tailing-sidecar/v{version}/sidecar/Dockerfile").read()
                    except urllib.error.HTTPError:
                        print(f"Warning: Could not fetch Dockerfile for tailing-sidecar v{version}. Skipping base image detection.", file=sys.stderr)
                        continue
                
                fluent_bit_matches = re.findall('FROM (fluent/fluent-bit:.*?)\\\\n', str(content))
                if fluent_bit_matches == None:
                    sys.exit(-1)
                matches.extend(fluent_bit_matches)
            

    # use set to remove duplicates
    return sorted({match.strip('\'"') for match in matches})

if __name__ == '__main__':
    args = parse_args()
    images = get_sumo_images(args.version, args.values, args.fetch_base)
    
    for i in images:
        print(i)
