{

function genericArithmeticOperation(operator) {
    return function(s) {
        if (s.length === 2) {
            return {
                type: 'BinaryExpression',
                operator: operator,
                left: s[0],
                right: s[1]
            };
        }

        if (s.length === 1) {
            return s[0];
        }

        return {
            type: 'BinaryExpression',
            operator: operator,
            left: s[0],
            right: genericArithmeticOperation(operator)(rest(s))
        };
    };
}


  var builtins = {
    '+': genericArithmeticOperation('+'),
    '-': genericArithmeticOperation('-'),
    '*': genericArithmeticOperation('*'),
    '/': genericArithmeticOperation('/'),
    'cons': function(s) {
      return {
        type: 'ExpressionStatement',
        expression: {
          type: 'CallExpression',
          callee: {
            type: 'MemberExpression',
            computed: false,
            object: s[1],
            property: {
              type: 'Identifier',
              name: 'concat'
            }
          },
          'arguments': [s[0]]
        }
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
    return [{
      type: 'ReturnStatement',
      argument: s[0].expression ? s[0].expression : s[0]
    }];
  }

  var log = console.log;
}
program
  = s:sexp+ "\n"*  { return { 
      type: 'Program',
      body: [
      s[0]
      /* { */
      /*   type: 'ExpressionStatement', */
      /*   expression: s[0] */
      /* } */
      ]
    }}

sexp
  = _ a:atom _ { return a; }
  / _ l:list _ { return l; }
  / _ v:vector _ { return v; }

atom
  = d:[0-9]+ _ { return {type: 'Literal', value: numberify(d)}; }
  / '"' d:(!'"' sourcechar)* '"' _ { return {type: 'Literal', value: makeStr(d) }}
  / s:[-+/*_<>=a-zA-Z\.]+ _ { return {type: 'Identifier', name: s.join("")};}

sourcechar
  = .

list
  = "()" { return []; }
  /  _ "(" _ s:sexp+ _ ")" _ {
    if (s[0].name === 'def') {
      return {
            type: 'VariableDeclaration',
            declarations: [
                {
                    type: 'VariableDeclarator',
                    id: s[1],
                    init: s[2]
                }
            ],
            kind: 'var'
      }
    } 
    
    if (s[0].name === 'fn') {
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

    if (Object.keys(builtins).indexOf(s[0].name) > -1) {
      return builtins[s[0].name](rest(s));
    }

      return {
        /* type: 'ExpressionStatement', */
        /* expression: { */
          type: 'CallExpression',
          callee: s[0],
          'arguments': s.slice(1)
        /* } */
    }
  }

vector
  = "[]" { return []; }
  / _ "[" _ a:atom+ _ "]" _ { return {type: 'ArrayExpression', elements: a};}

 _
  = [\n ]*
