# Custom binding tool for the ghOSt library

Honnestly, this tool is a mess. Maynly because it is built on top of other incomplete and messy tool (namely cppast, itself built on top of libclang).

The tools attempts to generate a file that is somewhat close to the binding file one would want.
The more templates, macros and pointers are involved, the more the file needs to be edited manually.

## Features

The tool handles (fully or partly) the following C++ and PyBind features:

- only headers are required
- multiple files support (necessary cross-file inheritance)
- namespaces as python modules (can be nested)
- structs and classes as python classes (can be nested inside other classes)
  - public members, including const and static members
  - public methods
  - most public constructors
- inheritance
- templates through explicit instanciation (note: this is buggy due to limitations of cppast and lack of time)
- pybind trampolines for classes with virtual methods, to allow overriding methods from Python.

Note that currently it explicitely does not support:

- Global variables (could be achieved with getters and setters that integrate well in Python)
- Macros/preprocessor stuff (not likely to be achieved, this is a (huge) limitation of cppast, note that the use of macros usually prevents the output from compiling, and meeds to be fixed by hand)
- Pointers (there might be pybind limitations on this side)
- Protected members and methods (could be achieved)
- nested template arguments (they are not parsed by cppast, however the workaround could be enhanced)
- move constructors

## Global structure

The global structure of this tool is that it builds `PB_*` objects from cppast entities, essentially visiting the AST while doing so.

Then, by the use of several print functions, it prints the binding source code, in 2 main steps:

- prelude / trampolines : This step defines the helper classes needed by pybind to allow overriding functions from python
- binding : This steps creates the python modules and their content by binding

## Points of interest

### Template instanciation

The tool only works with fully instanciated templates.
Template parameters substitution is done by the `std::string Context::to_string(cppast::cpp_type const&)` function.

### Readable bindings

To produce as readable as possible bindings, the tool heavily relies on `using` statements to bring namespaces into scope and such things.
It also tries to encapsulate things in braces blocks to prevent name collisions.

This is much better than Binder: Binder usually produces much more code, and seems to recurse through included files, ending up including core C++ headers that are not supposed to be included manually. (This last point can be fixed in the Binder source code though)

### Binding several files

To bind several files, the tool proceeds by merging `PB_*` objects. Objects with the same names are merged.

## Issues and limitations

### Inheriting from a class outside of the current file fails

This issue is a problem of cppast. Classes from included files are not brought correctly (if at all) into the class index fo cppast, causing references to fail.
Trying to read one file and then the other while keeping the same index results in a Segmentation Fault.

### Template instanciation

Template instanciation is quite broken in cppast.
This tool makes it work, kind of.
The parsing of arguments is very barbaric: it works under the assumption that every comma token is an argument separator. (which might not be the case with nested templates for instance)
Also, the instanciation system is only intended for typename/class arguments.

# Tough points

* Be carefull about `,` in templates arguments!
* Problems with trampoline functions returning `unique_ptr`s: https://github.com/pybind/pybind11/issues/1962
* Protected functions (see pybind doc)
* Recognize function signatures: `void ForEachTask(typename TaskAllocator<PyTask>::TaskCallbackFunc)` vs `void ForEachTask(ghost::TaskAllocator<PyTask>::TaskCallbackFunc)`
* Pointers lifetime (`keep_alive`)

# Todo (manual version working)

- Protected methods (Publicist)
- Fix template class trampoline constructors (remove template arguments in constructor name)
- wrap commas in trampoline methods (`using parent = `, `using ret = `)
