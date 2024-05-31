# sumologic-openshift-images

This repository contains [UBI][ubi] based versions of container images used in [the Sumo Logic Kubernetes Collection Helm Chart][helm_chart].
These [UBI][ubi] based versions of container images are used in [the Sumo Logic Kubernetes Collection Helm Operator][helm_operator]
and all of them need to pass Red Hat Certification, for details please see [Red Hat Software Certification Workflow Guide][red_hat_guide].

[ubi]: https://catalog.redhat.com/software/base-images
[helm_chart]: https://github.com/SumoLogic/sumologic-kubernetes-collection
[helm_operator]: https://github.com/SumoLogic/sumologic-kubernetes-collection-helm-operator
[red_hat_guide]: https://access.redhat.com/documentation/en-us/red_hat_software_certification/2024/html/red_hat_software_certification_workflow_guide/index

## Container certification

To build and certify UBI based container images please open [actions][actions]:

- run `check` workflow, analyze logs and make steps according to log messages.
- run `certify` workflow, analyze logs and make steps according to log messages.

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
