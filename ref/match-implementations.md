### Andrew Wright's (and some other)pattern matchers:

**publication**
<https://www.iro.umontreal.ca/~feeley/cours/ift6232/doc/pres2/practical-soft-type-system-for-scheme.pdf> pp.116-120 Andrew K. Wright & Robert Cartwright. *ACM Transactions on Programming Languages and Systems.* Vol. 19, No. 1. January 1997. Pages 87-152.

**implementation**
<https://legacy.cs.indiana.edu/scheme-repository/code.match.html>

### s7

**documentation**
<https://ccrma.stanford.edu/software/snd/snd/s7.html#case>

**implementation**
<https://github.com/wdouglass/s7/blob/upstream/case.scm>

### Chibi

**documentation**
<http://synthcode.com/scheme/chibi/lib/chibi/match.html>

**implementation**
<https://github.com/ashinn/chibi-scheme/blob/master/lib/chibi/match.sld>
<https://github.com/ashinn/chibi-scheme/blob/master/lib/chibi/match/match.scm>

### Cyclone

**documentation**
<http://justinethier.github.io/cyclone/docs/api/cyclone/match>

**implementation**
<https://github.com/justinethier/cyclone/blob/master/libs/cyclone/match.sld>

### Guile

**documentation**
<https://www.gnu.org/software/guile/manual/html_node/Pattern-Matching.html>

**implementation**
<http://git.savannah.gnu.org/cgit/guile.git/tree/module/ice-9/match.scm>
<http://git.savannah.gnu.org/cgit/guile.git/tree/module/ice-9/match.upstream.scm>

### LispKit

**implementation**
<https://github.com/objecthub/swift-lispkit/blob/master/Sources/LispKit/Resources/Libraries/lispkit/match.sld>

### Loko

**implementation**
<https://gitlab.com/weinholt/loko/-/blob/master/lib/match.sls>

### Mosh

**documentation**
<http://mosh.monaos.org/files/lib/match-ss.html#Pattern_Match>

**implementation**
<https://github.com/higepon/mosh/blob/master/lib/match.ss>


### Sagittarius

**documentation**
<http://ktakashi.github.io/sagittarius-online-ref/section81.html>

**implementation**
<https://bitbucket.org/ktakashi/sagittarius-scheme/src/master/sitelib/match.scm>

###  NonWCS Pattern Matching

### Armpit Scheme

**documentation/implementation**
<http://armpit.sourceforge.net/v080/aps_080_common_examples.html#Expert>

### Bigloo

**documentation**
<http://www-sop.inria.fr/mimosa/fp/Bigloo/manual-chapter6.html>

**implementation**
<https://github.com/manuel-serrano/bigloo/tree/master/runtime/Match>

### Chez

**documentation**
<https://web.archive.org/web/20180718090106/https://www.cs.indiana.edu/chezscheme/match/>
(I don't know the current status of this re:Chez)

**implementation**
<https://github.com/guenchi/match>

### Chicken

**documentation**
<http://wiki.call-cc.org/eggref/4/matchable>

**documentation**
<http://wiki.call-cc.org/eggref/4/bindings>

### Gambit

**implementation**
<https://github.com/gambit/gambit/blob/master/lib/termite/match.scm>
<https://github.com/gambit/gambit/blob/master/lib/termite/match-support.scm>
<https://github.com/gambit/gambit/blob/master/lib/termite/match-support%23.scm>
<https://github.com/gambit/gambit/blob/master/lib/termite/match%23.scm>

### Gauche

**documentation**
<http://practical-scheme.net/gauche/man/gauche-refe/Pattern-matching.html#Pattern-matching>

**implementation**
<https://sourceforge.net/p/gauche/code/ci/master/tree/libsrc/util/match.scm>

on the surface the syntax is almost identical to WCS, but the implementation is very different.

### Gerbil

**documentation**
<https://cons.io/reference/core-prelude.html#pattern-matching>

**implementation**
<https://github.com/vyzo/gerbil/tree/master/src/bootstrap/gerbil>
(haven't located the individual files)

### Kawa

**documentation**
<https://www.gnu.org/software/kawa/Variables-and-Patterns.html>

**implementation**
<https://gitlab.com/kashell/Kawa/-/blob/master/kawa/lang/AnyPat.java>
<https://gitlab.com/kashell/Kawa/-/blob/master/kawa/lang/BindDecls.java>
<https://gitlab.com/kashell/Kawa/-/blob/master/kawa/lang/EqualPat.java>
<https://gitlab.com/kashell/Kawa/-/blob/master/kawa/lang/ListPat.java>
<https://gitlab.com/kashell/Kawa/-/blob/master/kawa/lang/ListRepeatPat.java>
<https://gitlab.com/kashell/Kawa/-/blob/master/kawa/lang/PairPat.java>
<https://gitlab.com/kashell/Kawa/-/blob/master/kawa/lang/Pattern.java>
<https://gitlab.com/kashell/Kawa/-/blob/master/kawa/lang/PatternScope.java>
<https://gitlab.com/kashell/Kawa/-/blob/master/kawa/lang/VarListPat.java>
(some of these may be related to syntax-rules instead of the pattern matcher)

### Rapid

**documentation**
<http://snow-fort.org/s/rapid-scheme.org/marc/rapid/match/0.1.5/index.html>

**implementation**
<https://akkuscm.org/packages/(rapid%20match)/>
(download)

I thought Loko had a pattern matcher via Akku, now I'm not sure

### Picrin

**implementation**
<https://github.com/picrin-scheme/picrin/tree/master/contrib/50.destructuring-bind>

### Racket

**documentation**
<https://docs.racket-lang.org/reference/match.html?q=match#%28form._%28%28lib._racket%2Fmatch..rkt%29._match%29%29>

**implementation**
<https://github.com/racket/racket/tree/master/racket/collects/racket/match>

### Scheme 9 from Empty Space

**implementation**
<http://t3x.org/s9fes/matcher.scm.html>

### Scheje

**implementation**
<https://github.com/turbopape/scheje/blob/master/src/scheje/unifier.cljc>
 wrapped around
<https://clojure.github.io/core.match/>

### STklos
**documentation**
<https://stklos.net/Doc/html/stklos-ref-6.html#Pattern-Matching>

**implementation**
<https://github.com/egallesio/STklos/tree/master/lib/Match.d>

### RnRS

**definition/standard**
<https://small.r7rs.org/> (this page also has links to all previous standards) pp.23-24 syntax-rules, pp. 14-15 case.
Alex Shinn, John Cowan, Arthur A. Gleckler, et al. 2013 *Revised<sup>7</sup> Report on the Algorithmic Language Scheme.* Retrieved from <https://small.r7rs.org/attachment/r7rs.pdf>.

### Expert System

**publication**
<https://github.com/norvig/paip-lisp/blob/master/docs/chapter5.md> Peter Norvig. 1992 *Paradigms of Artificial intelligence.* (1st Ed.). ELIZA,Dialog with a Machine, Chap. 5. Morgan Kaufmann Publishers, San Francisco, CA.



