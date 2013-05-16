var parser = require('./inertia/grammar');
var UglifyJS = require("uglify-js");
var fs = require('fs');
var es = require('escodegen');
var util = require('util');
var program = require('commander');

program
    .version('0.3.1')
    .usage('[options] <file...>')
    .option('-t, --ast', 'Print the AST')
    .option('-o, --output [file]', 'Redirect output to file')
    .option('-c, --compress', 'Minify with uglify')
    .parse(process.argv);

if (program.args.length === 0) {
    console.log('Missing file.');
    process.exit(1);
}

var input, ast, js, lib;

input = program.args[0];
input = fs.readFileSync(input, 'utf8');

lib = fs.readFileSync('./inertia/lib.js', 'utf8');

ast = parser.parse(input);

if (program.ast) {
    console.log(JSON.stringify(ast, null, 4));
    process.exit(0);
}

js = lib + es.generate(ast);

if (program.compress) {
    js = UglifyJS.minify(js, {fromString: true}).code;
}

if (program.output) {
    fs.writeFileSync(program.output, js, 'utf8');
    process.exit(0);
}

console.log(js);
