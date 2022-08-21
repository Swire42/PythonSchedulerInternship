# Binding ghost

## Problem with templates

The ghOSt userspace library relies much on templates for its high level concepts.
This is a problem when creating bindings for another language: We must find ways to create C++ classes that are generic enough to be used as template arguments without restricting possibilities.
