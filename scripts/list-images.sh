#!/usr/bin/env bash

# Usage: VERSION='' ./scripts/list-images.sh, VERSION='3.3.0' ./scripts/list-images.sh
VERSION="${VERSION}"

set -euo pipefail

helm repo add sumologic https://sumologic.github.io/sumologic-kubernetes-collection 2> /dev/null 1>&2
helm repo update 2> /dev/null 1>&2

# Get values of all `image` prperties, and every of every line containing `-image` word, which is usually part of argument name in operators
helm template collection sumologic/sumologic \
  --namespace sumologic \
  --debug \
  --version "${VERSION}" \
  -f ./scripts/values.yaml \
  2> /dev/null | \
  grep -P '(^\s*image:|-image)' | \
  sed 's/ *//g' | \
  sed 's/^.*=//g' | \
  sed 's/image://g' | \
  sed 's/"//g' | \
  sort | \
  uniq
