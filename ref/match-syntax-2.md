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


A \<pattern s-expression\> can be (), which matches the empty list, a boolean, number, character, vector, a symbol or (quote \<pattern s-expression\> ...). A \<pattern s-expression\> matches an \<arg-expression\> that is exactly like it.


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
<predicate pattern> -> (? <predicate> <pattern>)
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
(match-letrec (<match-let clause> ...) <body>)
<match-let clause> -> (<pattern> <arg-expression>) |
                      <binding spec>
```
