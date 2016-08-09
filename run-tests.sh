#!/usr/bin/env sh

make
make example

node examples/arrays.js
node examples/objects.js
node examples/simple.js
node examples/usemodule.js

exit 0;
