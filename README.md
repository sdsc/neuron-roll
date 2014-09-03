# SDSC "neuron" roll

## Overview

This roll bundles neuron

For more information about the various packages included in the neuron roll please visit their official web pages:

- <a href="http://www.neuron.yale.edu" target="_blank"></a> is .


## Requirements

To build/install this roll you must have root access to a Rocks development
machine (e.g., a frontend or development appliance).

If your Rocks development machine does *not* have Internet access you must
download the appropriate neuron source file(s) using a machine that does
have Internet access and copy them into the `src/<package>` directories on your
Rocks development machine.


## Dependencies

gnucompiler and mpi rolls


## Building

To build the neuron-roll, execute these instructions on a Rocks development
machine (e.g., a frontend or development appliance):

```shell
% make default 2>&1 | tee build.log
% grep "RPM build error" build.log
```

If nothing is returned from the grep command then the roll should have been
created as... `neuron-*.iso`. If you built the roll on a Rocks frontend then
proceed to the installation step. If you built the roll on a Rocks development
appliance you need to copy the roll to your Rocks frontend before continuing
with installation.

This roll builds neuron with the latest gnu compilers and openmpi

## Installation

To install, execute these instructions on a Rocks frontend:

```shell
% rocks add roll *.iso
% rocks enable roll neuron
% cd /export/rocks/install
% rocks create distro
% rocks run roll neuron | bash
```

In addition to the software itself, the roll installs neuron environment
module files in:

```shell
/opt/modulefiles/applications/.(compiler)/neuron
```


## Testing

The neuron-roll includes a test script which can be run to verify proper
installation of the neuron-roll documentation, binaries and module files. To
run the test scripts execute the following command(s):

```shell
% /root/rolltests/neuron.t 
ok 1 - neuron is installed
ok 2 - neuron test run
ok 3 - neuron module installed
ok 4 - neuron version module installed
ok 5 - neuron version module link created
1..5
```
