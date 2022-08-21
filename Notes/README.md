# Introduction

## Installing the kernel and dependencies

- Install a fresh Ubuntu 20.04 on the computer.
- Use [my custom installer](https://github.com/Swire42/ghost-installer) to install the latest kernel version.
- The ghOSt kernel is now available in grub: version `5.11.0+`

## Cloning a userspace component

The standard repo from google can be found [here](https://github.com/google/ghost-userspace)

Be sure to always keep your kernel and userspace components in sync!

From now on, `$USERSPACE` refer to the location where you cloned the userspace component.

## Testing your install

Make sure you are running the ghOSt kernel : `uname -r` should return `5.11.0+`.

First, you want to make sure that you are able to build the userspace component: go to `$USERSPACE` and run `bazel build ...`. (`...` means everything).

Second, you might want to make sure all self-tests pass, using `bazel test ...`.

Note: As I am writing these lines, neither of those succeed. But I am still able to run some agents as they do not require everything to work.

## Starting a ghOSt agent.

There are several scheduler agents available. You can find their targets in `$USERSPACE/BUILD`, their names usually start or finish by `agent`.

To start an agent, type this, with super-user privileges: `bazel run foo_agent` where `foo_agent` if the name of the target you want to run. For instance `fifo_per_cpu_agent`.

The agents use Abseil to provide command line options, you can get a list of options using:
`bazel run foo_agent -- --helpfull`

Example: `# bazel run fifo_per_cpu_agent -- --firstcpu 0 --ncpus 8`

## Interacting with agents/enclaves

Currently, you can interact with agents as they run by writing to several files. Doing so does not require super-user privileges.

### Attaching a task

To schedule a task with an agent, one can use this:
`foo/bar & echo $! >> /sys/fs/ghost/enclave_1/tasks`

### Destroying enclave after an agent has crashed

Sometimes, after a bad crash, you will find yourself unable to start an agent again. This is because the enclave was not properly closed. It can be destroyed by writing "destroy" in a specific file:
`echo destroy > /sys/fs/ghost/enclave_1/ctl`



# Common errors and problems

## Out-of-sync

When updating the userspace component, don't forget to get latest kernel too!

Having out-of-sync components will result in an assert failure at runtime, in `ghost.h`.

## Bad crash

After a bad crash the enclave might still be running.
See above how to destroy an enclave.

## Redefinition of function pointers from `bpf_helpers.h`

If you have issues with redefinitions in `bpf_helpers.h`, look at [the github issue](https://github.com/google/ghost-userspace/issues/20)
