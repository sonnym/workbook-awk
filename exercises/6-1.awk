# Exercise 6-1.  Modify asm to print the listing of memeory and program show
# above.

BEGIN {
  srcfile = ARGV[1]
  ARGV[1] = "" # remaining files are data
  tempfile = "asm.temp"

  n = split("const get put ld st add sub jpos jz j halt", x)
  for (i = 1; i <=n; i++) { # create table of op codes
    op[x[i]] = i - 1
  }

  # ASSEMBLER PASS 1
  FS = "[ \t]+"

  while (getline <srcfile > 0) {
    sub(/#.*/, "")         # strip comments
    symtab[$1] = nextmem   # remember label location
    r_symtab[nextmem] = $1 # reverse lookup of label location

    if ($2 != "") {      # save op, addr if present
      print $2 "\t" $3 >tempfile
      nextmem++
    }
  }
  close(tempfile)

  # ASSEMBLER PASS 2
  nextmem = 0
  while (getline <tempfile > 0) {
    loc = $2

    if (loc !~ /^[0-9]*$/) { # if symbolic address
      loc = symtab[loc]      # replace by numeric value
    }

    word = 1000 * op[$1] + loc
    printf("%2d:\t%05d\t%s\t%s\t%s\n", nextmem, word, r_symtab[nextmem], $1, $2)

    nextmem++
  }
}
