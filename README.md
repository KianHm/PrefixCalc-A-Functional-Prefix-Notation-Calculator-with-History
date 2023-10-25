# PrefixCalc-A-Functional-Prefix-Notation-Calculator-with-History
This project provides an expression calculator that interprets and evaluates mathematical expressions in prefix notation. It also maintains a history of previous evaluations so that users can utilize past results in subsequent calculations. The program has been designed to catch and handle input errors.
Features
--------

- Prefix Notation: Users can input expressions using prefix notation for easy computation.
- History Management: Every successful evaluation is stored with a unique history ID. These historical values can be retrieved and used in future expressions.
- Error Handling: The calculator intelligently handles user errors, providing feedback such as "Invalid Expression" when necessary.

Usage
-----

1. Run the program. It will immediately prompt you for an expression.
2. Input an expression in prefix notation.
3. If the expression is valid, the result will be displayed with its history ID. If not, an error message will be shown.
4. You can use previously computed results in your new expressions by referencing their history ID with the `$n` notation, where `n` is the history ID.

Expressions
-----------

Expressions can be:
- Values: Literal numbers (integers).
- Binary Operators: 
  - `+`: Add the results of two expressions.
  - `*`: Multiply the results of two expressions.
  - `/`: Divide the first expression by the second (Beware of division by zero).
- Unary Operator: 
  - `-`: Negate the value of an expression.
- History Reference: 
  - `$n`: Use the result with the history ID `n`.

For instance, to evaluate \(2 \times $1 + $2\), you would input `+ * 2 $1 $2`.

Tips and Recommendations
------------------------

- Decompose the problem. Avoid the urge to do everything in one function.
- Implement specialized functions for different expression types. These functions should return a two-element list where the first element is the evaluation result and the second element contains the remaining characters of the expression.
- Approach the problem step-by-step. Start with pseudocode or a rough outline, then translate it to functional computation, and finally, write the actual code.
- Always test individual functions before integrating them.

Built-in Utility Functions
--------------------------

You might find these Scheme functions helpful during development:

- Conversion Functions: `string->list`, `list->string`, `string->number`
- Character Checks: `char-numeric?`, `char-whitespace?`, `char=?`, `string=?`
- IO Operations: `read-line`, `display`, `displayln`
- Others: `begin`, `apply`
Compilation
-----------

To compile the PrefixCalc project:
A racket application is needed in order to run the program.

1. Navigate to the project directory:
   cd path/to/PrefixCalc 
2. Use the Scheme compiler (assuming you're using a generic one for this example):
   scheme-compiler racket Calculator.rkt 
