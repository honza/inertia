{

  function partition(n, coll) {
      if (coll.length % n !== 0) {
          throw Error('Uneven number of elements.');
      }

      if (coll.length === 0) {
          return [];
      }
      return [coll.slice(0, n)].concat(partition(n, coll.slice(n)));
  }

  function makeObject(arr) {
    var pairs = partition(2, arr);
    var properties = map(function(p) {
      var k = p[0], v = p[1];
      return {
        key: k,
        value: v
      }
    }, pairs);

    return {
        type: 'ObjectExpression',
        properties: properties
    }

  }

  function processCallExpression(s) {
    var callee = first(s),
        args = rest(s)

    args = map(function(s) {
      if (s.expression && s.expression.type === 'CallExpression') {
        return s.expression;
      } else {
        return s;
      }
    }, args);

    return {
      type: 'ExpressionStatement',
      expression: {
        type: 'CallExpression',
        callee: callee,
        'arguments': args
      }
    }

  }

  function genericArithmeticOperation(operator) {
      return function(s) {
          if (s.length === 2) {
              return {
                  type: 'BinaryExpression',
                  operator: operator,
                  left: first(s),
                  right: first(rest(s))
              };
          }

          if (s.length === 1) {
              return first(s);
          }

          return {
              type: 'BinaryExpression',
              operator: operator,
              left: first(s),
              right: genericArithmeticOperation(operator)(rest(s))
          };
      };
  }

  var builtins = {
    '+': genericArithmeticOperation('+'),
    '-': genericArithmeticOperation('-'),
    '*': genericArithmeticOperation('*'),
    '/': genericArithmeticOperation('/'),
    'list': function(s) {
      return {
        type: 'ArrayExpression',
        elements: s
      }
    }
  };

  function numberify(n) {
    return parseInt(n.join(""), 10);
  }

  function map(fn, arr) {
    var result = [];
    for (var i = 0; i < arr.length; i++) {
        result.push(fn(arr[i]));
    }
    return result;
  }

  function makeStr(n) {
    return map(function(i) {
      return i[1];
    }, n).join("");
  }

  function rest(a) {
    return a.slice(1);
  }

  function first(a) {
    if (a.length > 0) {
      return a[0];
    } else {
      return null;
    }
  }

  function init(a) {
    return a.slice(0, -1);
  }

  function last(a) {
    return a.slice(-1);
  }

  function returnStatement(s) {
    s = first(s);
    return [{
      type: 'ReturnStatement',
      argument: s.expression ? s.expression : s
    }];
  }

  var log = console.log;
}


program
  = s:sexp+ "\n"*  { return {
      type: 'Program',
      body: s
    };}

sexp
  = _ a:atom _ { return a; }
  / _ l:list _ { return l; }
  / _ v:vector _ { return v; }
  / _ o:object _ { return o; }

atom
  = d:[0-9]+ _ { return {type: 'Literal', value: numberify(d)}; }
  / '"' d:(!'"' sourcechar)* '"' _ { return {type: 'Literal', value: makeStr(d) }}
  / s:[-+/*_<>=a-zA-Z\.]+ _ { return {type: 'Identifier', name: s.join("")};}

sourcechar
  = .

list
  = "()" { return []; }
  /  _ "(" _ s:sexp+ _ ")" _ {
    if (first(s).name === 'def') {
      return {
        type: 'VariableDeclaration',
        declarations: [{
          type: 'VariableDeclarator',
          id: s[1],
          init: s[2].expression? s[2].expression : s[2]
        }],
        kind: 'var'
      };
    }

    if (first(s).name === 'fn') {
      return {
        type: 'FunctionExpression',
        id: null,
        params: s[1].elements ? s[1].elements : s[1],
        body: {
          type: 'BlockStatement',
          body: init(rest(rest((s)))).concat(returnStatement(last(rest(s))))
        }
      };
    }

    if (Object.keys(builtins).indexOf(first(s).name) > -1) {
      return builtins[first(s).name](rest(s));
    }

    return processCallExpression(s);

  }

vector
  = "[]" { return []; }
  / _ "[" _ a:atom+ _ "]" _ { return {type: 'ArrayExpression', elements: a};}
  / _ "[" _ o:object+ _ "]" _ { return {type: 'ArrayExpression', elements: o};}

object
  = "{}" { return {type: 'ObjectExpression', properties: []}; }
  / _ "{" _ a:atom+ _ "}" _ { return makeObject(a); }

_
  = [\n, ]*
