
(match \<arg-expr\> \<clause\><sup>+</sup>)  
(match-lambda \<clause\><sup>+</sup>)  
(match-lambda\* \<clause\><sup>+</sup>)  
(match-let <identifier><sup>?</sup> (\<match-let clause\><sup>+</sup>) \<body\><sup>+</sup>)  
(match-letrec (\<match-let clause\><sup>+</sup>) \<body\><sup>+</sup>)  
  
\<arg-expr\> -> \<expression\>  
\<clause\> -> (\<pattern\> \<body\>) |  
              (\<pattern\> \<failure clause\> \<body\>)  
\<match-let clause\> -> (\<pattern\> \<arg-expr\>) |  
                        \<binding spec\>  
  
\<pattern\> -> (\<pattern\><sup>+</sup>) |  
               \<pattern identifier\> |  
               \<pattern expression\> |  
               \<tail pattern\> |  
               \<ellipsis pattern\> |  
               \<record pattern\> |  
               \<getter or setter pattern\> |  
               \<field pattern\> |  
               \<predicate pattern\> |  
               \<boolean pattern\> |  
               \<tree pattern\> |  
               \<quasi-quote pattern\> |  
               _  
\<failure clause\> -> (=\> \<identifier\>)  
  
\<pattern identifier\> -> \<identifier\> except quote quasi-quote unquote-splicing  
                                         and or not set! get! \*** =.. \*.. = ?  
                                         @ struct object ... ___ _  
\<pattern expression> -> () |  
                         \<boolean\> |  
                         \<number\> |  
                         \<character\> |  
                         \<quotation\> |  
                         \<vector\>  
\<tail pattern\> -> (\<pattern\><sup>+</sup> . \<pattern\>) |  
                    \#(\<pattern\><sup>+</sup> . \<pattern\>)  
\<ellipsis pattern\> -> (\<pattern\><sup>+</sup> \<pattern ellipsis\> \<pattern\><sup>\*</sup>) |  
                        \#(\<pattern\><sup>+</sup> \<pattern ellipsis\> \<pattern\><sup>\*</sup>)  
\<record pattern\> -> ($ \<record type\> \<pattern\><sup>+</sup>) |  
                      (struct \<record type\> \<pattern\><sup>+</sup>) |  
                      (object \<record type\> (\<slot name\> \<pattern\>)<sup>+</sup>)  
\<getter or setter pattern\> -> (get! \<pattern identifier\>) |  
                                (set! \<pattern identifier\>)  
\<field pattern\> -> (= \<operator\> \<pattern\>)  
\<predicate pattern\> -> (? \<predicate\> \<pattern\>)  
\<boolean pattern\> -> (and \<pattern\><sup>\*</sup>) |  
                       (or \<pattern\><sup>\*</sup>) |  
                       (not \<pattern\><sup>+</sup>)  
\<tree pattern\> -> (\<pattern\> \*\*\* \<pattern\>)  
\<quasi-quote pattern\> -> \`\<quasi-quote datum\> |  
                        -> (quasi-quote \<quasi-quote datum\>)  
  
\<pattern ellipsis\> -> ... |  
                        ___ |  
                        =.. <number> |  
                        \*.. <number> <number> |  
\<quasi-quote datum\> -> \<pattern expression\> |  
                         \<identifier\> |  
                         (\<quasi-quote contents\><sup>+</sup>)  
  
\<quasi-quote contents -> ,\<pattern\> |  
                          (unquote \<pattern\>) |  
                          ,@\<pattern\> |  
                          (unquote-splicing \<pattern\>  

