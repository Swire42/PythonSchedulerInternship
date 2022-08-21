# pybind and raw pointers

Raw pointers seem to cause intricate error messages.
For now the solution is to comment them:
`sed -i '/def.*opology/s/^/\/\//' gen.cc`

# cppast giving up on complex types

Complex types (macros, `std::unique_ptr`) crash cppast type recognition, and are therefore considered `int`. It is necessary to replace them manually.

# operator= deleted

If operator= is deleted, using `def_readwrite` fails, and must be replaced by `def_readonly`.
