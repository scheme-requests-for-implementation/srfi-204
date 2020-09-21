<!-- - check not-working **fixed** -->
- try to get all srfi-64 on same test-runner
<!-- - Gerbil and Cyclone record methods -->
 <!-- - try to integrate chez into testing framework **fixed** -->
- update srfi:
   <!-- - (pat1 ... patN patN+1 ooo \[patN+2 ...]) **fixed** -->
   <!-- - ?nested quasiquotes? **nothing to be done** -->
   <!-- - specify srfi-206 for exporting patterns **re-fixed** -->
   <!-- - clarify tail context **fixed** (not sure what there is to clarify re: -->
   <!-- call/cc, side-effects **fixed** , and exceptions **fixed**, but those are likely -->
   <!-- next issues to come up) -->
   <!-- - add unquote and unquote-splicing to forbidden patvars **fixed** -->
   <!-- - specify that (match 1 ((and odd? (? odd? odd?)) odd?)) will not work or -->
   <!-- for that matter (match '(1 2 3 4) ((and car (= car car)) car)) \[although this -->
   <!-- second case makes even less sense  since ^    and  ^ would match to '(1 2 3 4) -->
   <!-- and 1, respectively.] **fixed** added info and examples about patvars in -->
   <!-- fields and predicates. -->
   - figure out how to handle match-letrec/match-letrec\* in specification
      - leave as is
      - make optional, refer to use of internal define + match-lambda/match-lambda*
        or named match-let by vast majority of users
   <!-- - srfi should give implementors more guidance **fixed** -->
   <!-- - find and show example of match with failure -does this figure into call/cc (escape continuations,etc?)? **fixed** -->
   <!-- - flesh out: -->
   <!-- - or patterns **fixed** -->
   <!-- - not patterns **fixed** -->
   <!-- - ellipses **fixed** -->
- refactor for srfi-206
<!-- - make srfi-test.scm in srfi/test containing all example code. -->
<!-- - run #f branches of srfi-test using (util match) and record-less implementation -->
  <!-- - test skip isn't enough to stop erroneous conditions from giving an error. -->
    <!-- Commented all errors out until tests ran. Convert to test-read-eval-string form. -->
<!-- - close out threads move to maybe, answered, or no-answer, depending on how handled -->
   <!-- - milestone handle files that start with 1 -->
   <!-- - milestone handle files that start with 2 -->
   <!-- - milestone handle files that start with 3 -->
   <!-- - milestone handle files that start with 4 -->
   <!-- - milestone handle files that start with 5 -->
   <!-- - milestone handle files that start with 6 -->
   <!-- - milestone handle files that start with 7 -->
   <!-- - milestone handle files that start with 8 -->
   <!-- - milestone handle files that start with 9 -->
