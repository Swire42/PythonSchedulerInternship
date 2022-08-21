# Intro

pybind11 helps creating bindings between C++ and Python.

The aim here would be to bring the ghOSt userspace library to Python.

# PyBind & Bazel

To be able to use PyBind with Bazel, several things have to be done.

## Importing pybind

First of all, one needs to bring pybind into the project scope.

To to that, one must add a `new_local_repository` entry in the `WORKSPACE` file, with had-oc content.

## Using shared libraries

Some libraries are statically linked to agents. This is obviously incompatible with pybind trying to produce a shared library.

To fix this for `libbpf` one needs to edit `third-party/linux.BUILD` change all `libbpf.a` to `libbpf.so`, create a `libbpf.so.0` copy, and list both of these in the option `out_shared_libs`. The presence of this last option informs Bazel that the target builds a shared library, instead of the default static library.

## Creating a target for the binding code

As of now I am not sure on the right way to do this, as the offial pybind build options are generated using python commands, and I don't know how to/if it is possible to run them in bazel.

Anyhow, as a quick fix, one can add the option by manually expanding the python commands.

# Proof of concept

I was able to use Python as a launcher for a C++ agent:

- I renamed `main` to `main_cpp` in the C++ agent
- I added some binding code to export `main_cpp`
- I did all the steps above to make pybind work with bazel.
- I wrote a python script which printed some line and then executed `main_cpp`.
- It worked.

# Automated bindings

The ghOSt API is big, and having to write bindings manually seems to not be an option, all the more that it is a project still in active development.

## Using binder

Binder is a huge project with the aim of automatically generating bindings using pybind.

### Fixing includes

`binder` is incomplete and tries to include internal headers from the standard library. This can be fixed by adding header pairs in `source/type.cpp`

### Errors

There are more errors left after that. Right now I don't know if they are related to binder bugs, binder limitations, pybind bugs, or misuse.

## Using cppast

One possible approach is to use the libclang api to work with an AST and generate bindings.

Cppast helps with that. It can be found [here](https://github.com/foonathan/cppast)

### Holes

Cppast is based on libclang. Libclang is full of holes, and does not parse files completely, leaving raw tokens here and there.
Cppast actively tries to fix these holes, but does not entirely succeed.

### Template instanciation

Cppast does not recognize template instanciations, and labels them as template specialisations.
Moreover, it does not parse the arguments, leaving us with raw tokens.
