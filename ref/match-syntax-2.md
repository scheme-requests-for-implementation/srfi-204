A pattern matcher has the following form:  
```
(match <arg-expression> <clause> <clause> ... )
<clause> -> (<pattern> <body>) |
            (<pattern>  (=> <non-pattern identifier>) <body>)
```
Syntax: it is an error if \<arg-expression\> does not match a pattern in any of the
clauses. It is an error for the \<non-pattern identifier\> to be a pattern variable.
  
A pattern can have one of the following forms:  
```
<pattern> -> (<pattern> ...) |  
            #(<pattern> ...) |
               <pattern identifier> |  
               <pattern s-expression> |  
               <tail pattern> |  
               <ellipsis pattern> |  
               <record pattern> |  
               <getter or setter pattern> |  
               <field pattern> |  
               <predicate pattern> |  
               <boolean pattern> |  
               <tree pattern> |  
               <quasi-quote pattern> |  
               _
```  
Syntax: A \<pattern identifier\> is any identifier except <code>and or not set! get! $ struct object _ ... \_\_\_
=..
\*\*\*
\*..
= ? quote quasi-quote unquote-splicing</code>
and can be used as a pattern variable. A pattern variable will match any value.  


A \<pattern s-expression\> can be  a boolean, number, character, vector, a (quote symbol) or (quote \<pattern s-expression\> ...). A \<pattern s-expression\> matches an \<arg-expression\> that is exactly like it. (A symbol in a quoted s-expression does not need a separate quote).


A tail pattern has the form:
```
<tail pattern> -> (<pattern> <pattern> ... . <pattern>) |
                 #(<pattern> <pattern> ... . <pattern>)
```
An ellipsis pattern has the form:
```
<ellipsis pattern> -> (<pattern> <pattern> ... <ellipsis form> <pattern> ...) |
                     #(<pattern> <pattern> ... <ellipsis form> <pattern> ...)
<ellipsis form> -> ... |
                   ___ |
                   =.. <number> |
                   *.. <number 1> <number 2>
```
Syntax: It is an error for a list to contain more than one ellipsis form or tail pattern, but the patterns that list contains can contain additional ellipsis forms or tail patterns. It is an error for \<number 2\> to be less than \<number 1\>.


A record pattern has the form:
```
<record pattern> -> ($ <record type> <pattern> <pattern> ...) |
                    (struct <record type> <pattern> <pattern> ...) |
                    (object <record type> (<slot name> <pattern>) (<slot name> <pattern>) ...)
<record type> -> implementation dependent
<slot name> -> <identifier>
```
Syntax: It is an error for the number of patterns in the $ or struct forms to exceed the number of fields in the record. It is an error if the record does not have a field named \<slot name\>. If a record is exported from a library without its \<record type\>, this form cannot be used.


 A getter or setter pattern has the form:
```
<getter or setter pattern> -> (get! <pattern identifier>) |
                              (set! <pattern identifier>)
```


A field pattern has the form:
```
<field pattern> -> (= <operator> <pattern>)
```

A predicate pattern has the form:
```
<predicate pattern> -> (? <predicate> <pattern> ...)
```


A boolean pattern has the form:
```
<boolean pattern> -> (and <pattern> ...) |
                     (or  <pattern> ...) |
                     (not <pattern> <pattern> ...)
```
Syntax: It is an error for not patterns to be empty. It is an error to refer to the same variable inside and outside a not pattern.

A tree pattern has the form:
```
<tree pattern> -> (<pattern> *** <pattern>)
```
Syntax: It is an error to combine \*\*\* with ..., \_\_\_, ., \*.., or =.. .

A quasi-quote pattern has the form:
```
<quasi-quote pattern> -> `<quasi-quote datum> |
                         (quasi-quote <quasi-quote datum>)
<quasi-quote datum> -> <pattern s-expression> |
                       <identifier> |
                       (<quasi-quote contents> ...)
<quasi-quote contents> -> <quasi-quote datum> |
                          ,<pattern> |
                          (unquote <pattern>) |
                          ,@<pattern> |
                          (unquote-splicing <pattern>) 
```


Syntax: identifiers in unquoted patterns are subject to the same naming constraints as other pattern variables. ,@/unquote-splicing is a type of ellipsis pattern so it is a syntax error if a list contains this pattern in combination with tail, or other ellipsis patterns (=.. and \*.. have to be unquoted to be interpreted as ellipsis patterns).

A _ pattern is a wildcard that will match anything but does not bind.


Helper forms:
```
(match-lambda <clause> <clause> ...)
(match-lambda* <clause> <clause> ...)
(match-let (<match-let clause> ...) <body>)
(match-let <identifier> (<match-let clause> ...) <body>)
(match-let\* (<match-let clause> ...) <body>)
(match-letrec (<match-let clause> ...) <body>)
<match-let clause> -> (<pattern> <arg-expression>) |
                      <binding spec>
```

Semantics: The use of match takes an expression and compares it to a series of patterns, beginning with the leftmost. When the expression matches a pattern, it evaluates the corresponding body, with any bindings formed in the pattern. A  failure pattern assigns a zero-argument function to a procedure so that if it is determined in the body that the match actually failed, that procedure can be called to restart matching at the next argument. 

A pattern identifier (which is any identifier except <code>and or not set! get! $ struct object _ ... \_\_\_ =..  \*\*\* \*.. = ? quote quasi-quote unquote-splicing</code>) will match and bind anything, and bind it to that pattern variable. The special identifier _ matches anything but does not bind. The forms (\<pattern\> ...) and #(\<pattern\> ...) match lists and vectors whose elements match the contained patterns (() and #() match the empty list and vector).


A pattern s-expression matches literal values.

A tail pattern matches the rest of a list or vector.

A pattern followed by ellipsis matches zero or more times. A pattern followed by <code>=.. k</code> matches k times. A pattern followed by <code>\*.. k j</code> matches between k and j times (inclusive).

The <code>$</code> and <code>struct</code> syntax of record patterns match record fields positionally. The <code>object<code> record pattern matches an identifier against the record field slot names. This pattern may not be available (because an implementation has not made the necessary record introspection forms available) or may not be available for a particular record (because the record type is not exported).

Getter and setter functions bind a zero- and one-argument function to their identifier. The getter function returns the value of its match when called, and the setter function will take a new value to set its match to.

A field pattern <code>(= \<operator\> \<pattern\> ...)</code> applies operator (a one argument function) to what it is matching, and then matches the return value against its pattern. A predicate pattern <code>(? \<predicate\> \<pattern\>)</code> is similar in that it applies its predicate to a value, but if the predicate is true, that value is then matched against all additional patterns.

A boolean pattern has one of the forms <code>(and \<pattern\> ...), (or \<pattern\> ...), (not \<pattern\> \<pattern\> ...)</code>. All of the forms in an and pattern must match, and an empty and pattern is true. At least one of the forms in the or pattern must match, and an empty or is false. None of the forms in a not pattern should match and an empty not is a syntax error.

In a tree pattern (\<left pattern\> \*\*\* \<right pattern\>), the /<left pattern\> represents a path to the subtree that matches the \<right pattern\>.

In a quasi-quote pattern, \<pattern s-expressions\> and \<identifiers\> match their literal values (as symbols in the case of \<identifiers\>). Unquoted \<pattern\>s match as usual, and unquote-spliced \<pattern\>s have ellipsis matching.

<code>match-lambda</code> produces a one-argument lambda expression that matches its argument. <code>match-lambda\*</code> makes a lambda expression that accepts any number of arguments and matches against a list of those arguments.


<code>match-let</code> <code>match-let\*</code> and <code>match-letrec</code> both allow binding a name to a value through either standard let/letrec syntax or by matching a pattern against a value.
