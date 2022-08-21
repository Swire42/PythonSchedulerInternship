# C++ template library

GhOSt exposes a C++, template-based library, with classes one is supposed to inherit from.
When working with other languages, this not only requires for a very strong binding layer, but also to work around the templates.
The solution I went for is to write generic-enough instanciations of the templates in C++, to later work with them in Python.
This generic instance approach clearly comes at a cost.

As a conclusion, while templates are good and very efficient in pure C++, they are stupidly annoying when working with another language, and are most likely to introduce additional overheads in these cases.


# Working with a C++ AST

There does not seem to be a complete working standalone AST generator for C++ for now.

"If you're writing a tool that needs access to the C++ AST (i.e. documentation generator, reflection library, …), your only option apart from writing your own parser is to use clang. It offers three interfaces for tools, but the only one that really works for standalone applications is libclang. However, libclang has various limitations and does not expose the entire AST." (cppast/README.md)

According to Jonathan Muller (author of cppast), the only alternative to his cppast is libclang (on which cppast is based), which is according to him even more broken.
Cppast, is still broken for some things, such as explicit template instanciation, where the generator first fail to recognize it as such and labels it as a template specialization, and them just gives up and returns raw tokens when asked for the arguments.

An issue was open by Jonathan Muller on this behavior several years ago, with no update or fix since then.

"the implemented parser uses various workarounds/hacks to provide a parser that breaks only in rare edge cases you won't notice" (cppast/README.md)
-> Well actually I did, and quite often.

# Double free or corruption

I create a python object from a C++ function that returns a pointer using the `reference` policy.
When python object isn't needed anymore, a `double free or corruption (out)` error occurs.

This error ended up being due to a misplacement of the `py::return_value_policy::reference`.
Adding it on the correct function fixed the problem

# GIL deadlock

The Global Interpreter Lock, present in both CPython and PyPy, causes deadlocks when the main thread waits for agent to finish their startup, because it captures the GIL while doing so.
The solution is to manually release the GIL while doing pure C++ operations.
