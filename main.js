var parser = require('./grammar');
var fs = require('fs');
var _ = require('underscore');
var es = require('escodegen');
var util = require('util');

var input = process.argv[2];
input = fs.readFileSync(input, 'utf8');

var result = parser.parse(input);


console.log('\n\n ast \n\n');
console.log(JSON.stringify(result, null, 4));

console.log('\n\n js \n\n');
var js = es.generate(result);

console.log(js);


fs.writeFileSync('out.js', js);
