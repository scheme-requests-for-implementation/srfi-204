## Adding testing for a new implementation

1. Move **match-test.scm** to **./temp** .

2. In Makefile comment out previous definitions of <code>SCM</code> and <code>SCMFLAGS</code> and add new ones for this implementation, adding <code>top_srcdir</code> to search path, and setting any other flags (like <code>--no-compile</code>) needed.

3. Add a <code>cond-expand</code> block to **hello-test** that imports srfi-64, srfi-9 (if necessary), and defines the values **test-name** [<code> "*implementation*-match-test"</code>] and **scheme-version-name** [<code>(string-append "*implementation*-" (version))</code> or <code>"*implementation*-???"</code> if version number isn't available programatically] and then <code>includes</code> **hello-common.scm**.

4. Run tests with <code>make clean</code> then <code>make check</code>, and trouble-shoot any problems that occur.

5. When tests pass for hello, move match-test.scm back to this directory and repeat steps 3 and 4, this time importing the match library defined for this implementation and <code>include</code> **match-common**.
