Right now I'm on the feature/new-chibi-match branch. The feature/renamed-fields branch is at a standstill because the code won't run. I may open feature/letrec-star, feature/quasiquote-patterns and feature/var branches later but I am not there yet and I do want to update all the documentation and refactor for srfi-206 (if it is in a stable state), along with checking the implementations in not-working  once  more to see if the changes we've made recently have made any difference, then either integrating or deleting them. Aside from the things I mentioned I also have an outstanding issue on the testing suite where the output of the implementations that use srfi-64 varies from highly verbose to "80 tests completed" and I wanted to get them all using the same runner so that wasn't an issue. There may be some other stuff I was wanting to do with testing but I didn't put in an issue on it.

- check not-working
- try to get all srfi-64 on same test-runner
- try to integrate chez into testing framework
- update srfi:
   - (pat1 ... patN patN+1 ooo \[patN+2 ...])
   - ?something about nested quasiquotes?
   - specify srfi-206 for exporting patterns
   - clarify tail context (not sure what there is to clarify re:
     call/cc, side-effects, and exceptions, but those will be Marc's
     next questions \[if they aren't already]
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