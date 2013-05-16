inertia
=======

A LISP to Javascript compiler.

*work in progress*

*a learning exercise*

Read the [accompanying blog post][4].


How it works
------------

It uses [PEG.js][1] to parse the source to a [Parser API][2] compatible AST.
The AST is then transformed to Javascript via [escodegen][3].

It can optionally compress the output via Uglify.

Example
-------

Source:

```clojure
(def name "honza")

(def greet
  (fn [name]
    (console.log "hey" name)))

(greet name)
```

Output:

```js
var name = 'honza';
var greet = function (name) {
    return console.log('hey', name);
};
greet(name);
```

Usage
-----

    Usage: inertia [options] <file...>

    Options:

        -h, --help           output usage information
        -V, --version        output the version number
        -t, --ast            Print the AST
        -o, --output [file]  Redirect output to file
        -c, --compress       Minify with uglify

You can use the Makefile to install the dependencies:

    $ make install

Or to build the compiler:

    $ make

Or to build all the examples:

    $ make example


What works
----------

* `def`
* `list`
* `+`, `-`, `*`, `/`, `=`, `!=`, `<`, `>`, `<=`, `>=`
* `if`
* `(fn [] ...)`
* `{}`, `{"name" "honza"}`
* comments `;;`
* `let`

Standard library
----------------

* nth
* first
* rest
* second
* last
* partition
* cons
* conj
* get
* map
* filter
* update (update a key in a map `(update obj key value)`

**Note**: The standard library functions are modelled after Clojure.

TODO
----

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
[4]: http://honza.ca/2013/05/building-a-lisp-to-javascript-compiler
