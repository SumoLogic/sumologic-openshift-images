# sumologic-openshift-images

This repository contains [UBI][ubi] based versions of container images used in [the Sumo Logic Kubernetes Collection Helm Chart][helm_chart].
These [UBI][ubi] based versions of container images are used in [the Sumo Logic Kubernetes Collection Helm Operator][helm_operator]
and all of them need to pass Red Hat Certification, for details please see [Red Hat Software Certification Workflow Guide][red_hat_guide].

[ubi]: https://catalog.redhat.com/software/base-images
[helm_chart]: https://github.com/SumoLogic/sumologic-kubernetes-collection
[helm_operator]: https://github.com/SumoLogic/sumologic-kubernetes-collection-helm-operator
[red_hat_guide]: https://access.redhat.com/documentation/en-us/red_hat_software_certification/2024/html/red_hat_software_certification_workflow_guide/index

## Container certification (Preferred method)

We can certify two types of images from this repo,
1. Components built from this repo.
2. Components built from a different repo. Ex, sumologic-otel-collector, tailing-sidecar etc.

To build and certify UBI based container images please open [actions][actions]:
### 1. Build and certify components from this repo
 - To build components from this repo, use check, build and push worflows to do the respective operations on sumologic public AWS ECR repo.
Once new components are built, use certify operation to push to openshift repository.

### 2. Certify components from other repo
- check, build and push workflows aren't applicable for components from other repositories like sumologic-otel-collector, we just use this repo to certify them.
- Goto respective components public ECR repository and choose the version to certify.
  Ex. repository: sumologic-otel-collector , version: 0.130.1-sumo-0
- Enable force push operation when certifying these components.

**Important Note**: While using both the above methods, always make sure to use a new version which is not already present in redhat connect repository for the component which you're trying to update unless you are specifically trying to update an existing component.



## Container certification (Legacy method, preserving since we have the workflows and need to understand what they do)

To build and certify UBI based container images please open [actions][actions]:

- run [Manually check all container images][check] workflow, analyze logs and make steps according to log messages.
- run [Manually certify all container images][certify] workflow, analyze logs and make steps according to log messages.

To get list of certified images make following steps:

- login to Red Hat Container registry, e.g.:
  
  ```bash
  docker login registry.connect.redhat.com -u <USER_NAME>
  ```

- run:

  ```bash
  make verify
  ```

If some of images are not pushed to Red Hat Container registry, please verify the status in [Red Hat Partner Connect][connect_red_hat].

All the scripts used for container certification can be found in [scripts](./scripts/) directory,
for details please see [documentation](./scripts/README.md).

[actions]: https://github.com/SumoLogic/sumologic-openshift-images/actions
[connect_red_hat]: https://connect.redhat.com/
[check]: https://github.com/SumoLogic/sumologic-openshift-images/actions/workflows/check.yml
[certify]: https://github.com/SumoLogic/sumologic-openshift-images/actions/workflows/certify.yml

## Development environment

Prepared development environment with all necessary components is available as virtual machine.

### Prerequisites

Please install the following:

- [VirtualBox](https://www.oracle.com/virtualization/technologies/vm/downloads/virtualbox-downloads.html)
- [Vagrant](https://www.vagrantup.com/)

#### MacOS

```bash
brew install --cask virtualbox
brew install --cask vagrant
```

#### ARM hosts (Apple M1, and so on)

You'll need to use QEMU instead of VirtualBox to use Vagrant on ARM. The following instructions will assume an M1 Mac as the host:

1. Install QEMU: `brew install qemu`
2. Install the QEMU vagrant provider: `vagrant plugin install vagrant-qemu`
3. Provision the VM with the provider: `vagrant up --provider=qemu`

### Setting up

You can set up the Vagrant environment with just one command:

```bash
vagrant up
```

After successful installation you can ssh to the virtual machine with:

```bash
vagrant ssh
```

To remove virtual machine use:

```bash
vagrant destroy
```
