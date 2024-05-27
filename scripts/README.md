# Scripts

Description of scripts in this directory:

- [list-images.py](./list-images.py) - script which is used to list all images used in the Sumo Logic Kubernetes Collection Helm Chart
- [build-push-all.sh](./build-push-all.sh) - script which is used to build and push [UBI](https://catalog.redhat.com/software/base-images) based container images and push them to Red Hat container registry
- [submit_image.sh](./submit_image.sh) - script which is used to submit image to Red Hat container registry and certify the image.
  environment variables:

  - `CONTAINER_PROJECT_ID` - container project ID from [connect.redhat.com/](https://connect.redhat.com/)
  - `CONTAINER_REGISTRY_KEY` - container registry key from [connect.redhat.com/](https://connect.redhat.com/)
  - `PYAXIS_API_TOKEN` -  pyxis API key from  [connect.redhat.com/](https://connect.redhat.com/), please see [api-keys](https://connect.redhat.com/account/api-keys)
  - `SUMOLOGIC_IMAGE` - UBI based image name e.g. `public.ecr.aws/sumologic/metrics-server:0.7.0-debian-12-r8-ubi`
