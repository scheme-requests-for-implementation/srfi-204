- check not-working
- try to get all srfi-64 on same test-runner
- try to integrate chez into testing framework
- update srfi:
   - (pat1 ... patN patN+1 ooo \[patN+2 ...])
   - ?nested quasiquotes?
   - specify srfi-206 for exporting patterns
   - clarify tail context (not sure what there is to clarify re:
     call/cc, side-effects, and exceptions, but those are likely
     next issues to come up)
   - add unquote and unquote-splicing to forbidden patvars
   - specify that (match 1 ((and odd? (? odd? odd?)) odd?)) will not work or
     for that matter (match '(1 2 3 4) ((and car (= car car)) car)) \[although this
     second case makes even less sense  since ^    and  ^ would match to '(1 2 3 4)
     and 1, respectively.]
   - figure out how to handle match-letrec/match-letrec* in specification
      - leave as is
      - make optional, refer to use of internal define + match-lambda/match-lambda*
        or named match-let by vast majority of users
   - srfi should give implementors more guidance
- refactor for srfi-206
