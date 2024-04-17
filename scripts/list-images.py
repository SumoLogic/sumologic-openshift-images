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
    parser.add_argument("--version", help="helm chart version", default="")
    return parser.parse_args()

def get_sumo_images(version, values):
    subprocess.check_output(f'helm repo add sumologic https://sumologic.github.io/sumologic-kubernetes-collection'.split(' '))
    subprocess.check_output(f'helm repo update'.split(' '))
    command = f'helm template collection sumologic/sumologic --namespace=sumologic --debug --version={args.version} --values={args.values}'
    output = subprocess.check_output(command.split(" "))

    matches = re.findall(r'(?:\s*image:\s*|-image=|prometheus-config-reloader=)(.*?)\\n', str(output))
    if matches == None:
        sys.exit(-1)
    
    for match in matches:
        # Detect Fluent Bit image used by Tailing Sidecar
        if re.match('.*tailing-sidecar:.*', match):
            try:
                content = urllib.request.urlopen(f"https://raw.githubusercontent.com/SumoLogic/tailing-sidecar/v{match.split(':')[-1]}/sidecar/fluentbit/Dockerfile").read()
            except urllib.error.HTTPError:
                content = urllib.request.urlopen(f"https://raw.githubusercontent.com/SumoLogic/tailing-sidecar/v{match.split(':')[-1]}/sidecar/Dockerfile").read()
            fluent_bit_matches = re.findall('FROM (fluent/fluent-bit:.*?)\\\\n', str(content))
            if fluent_bit_matches == None:
                sys.exit(-1)
            matches.extend(fluent_bit_matches)
            

    # use set to remove duplicates
    return sorted({match.strip('\'"') for match in matches})

if __name__ == '__main__':
    args = parse_args()
    images = get_sumo_images(args.version, args.values)
    
    for i in images:
        print(i)
