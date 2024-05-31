# sumologic-openshift-images

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
