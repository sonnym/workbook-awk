# Exercise 3-14. Add a facility to checkgen so that peices of code can be
# passed through verbatim, for example, to create a BEGIN action to set the
# field separator.

BEGIN { FS = "\t+" }
$1 == "verbatim" {
  printf("%s %s\n", $2, $3)
}
$1 != "verbatim" {
  printf("%s {\n\tprintf(\"line %%d, %s: %%s\\n\",NR,$0) }\n", $1, $2)
}
