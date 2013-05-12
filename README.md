inertia
=======

A LISP to Javascript compiler.

*work in progress*

*a learning exercise*

How it works
------------

It uses [PEG.js][1] to parse the source to a [Parser API][2] compatible AST.
The AST is then transformed to Javascript via [escodegen][3].

It can optionally compress the output via Uglify.

Usage
-----

    Usage: inertia [options] <file...>

    Options:

        -h, --help           output usage information
        -V, --version        output the version number
        -t, --ast            Print the AST
        -o, --output [file]  Redirect output to file
        -c, --compress       Minify with uglify

What works
----------

* `def`
* `list`
*  `cons`
* `+`, `-`, `*`, `/`
* `(fn [] ...)`

TODO
----

* Objects
* `if`, `==`
* `let`
* `map`, `filter`, `first`, `rest`, etc.
* Macro support

License
-------

BSD, short and sweet

Feedback
--------

All feedback is most welcome.  Open an issue for any purpose.

[1]: http://pegjs.majda.cz/
[2]: https://developer.mozilla.org/en-US/docs/SpiderMonkey/Parser_API
[3]: https://github.com/Constellation/escodegen
