This behavior is surprising, we should get an error about the fact
that ${@} is not quoted and doesn't contain exactly 1 element

  $ dune build --root bad x
  Entering directory 'bad'
  Error: Rule failed to generate the following targets:
  - x
  - y
  [1]

  $ dune build --root bad x
  File "dune", line 3, characters 26-30:
  Error: Variable ${@} expands to 2 values, however a single value is expected here. Please quote this atom.

The targets should only be interpreted as a single path when quoted

  $ dune build --root good s
  Entering directory 'good'
  Error: Rule failed to generate the following targets:
  - s
  - t
  [1]

  $ dune runtest --root quote-from-context
  Entering directory 'quote-from-context'
    count_args alias runtest
  Number of args: 3

  $ dune runtest --root quotes-multi 2>&1 | grep -v Entering
  lines: foo bar baz
