# Exercise 4-3. The table formatter assumes that all numbers have the same
# number of digits after the decimal point. Modify it to work properly if this
# assumption is not true

BEGIN {
  FS = "\t"
  blanks = sprintf("%100s", " ")
  number = "^[+-]?([0-9]+[.]?[0-9]*|[.][0-9]+)$"
}

{
  row[NR] = $0

  for (i = 1; i <= NF; i++) {
    if ($i ~ number) {
      nwid[i] = max(nwid[i], length($i))
      nfmt[i] = max(nfmt[i], index($i, "."))
    }

    wid[i] = max(wid[i], length($i))
  }
}

END {
  for (r = 1; r <= NR; r++) {
    n = split(row[r], d)

    for (i = 1; i <=n; i++) {
      sep = (i < n) ? "	" : "\n"

      if (d[i] ~ number) {
        printf("%" wid[i] "s%s", numjust(i, d[i]), sep)
      } else {
        printf("%-" wid[i] "s%s", d[i], sep)
      }
    }
  }
}

function max(x, y) { return (x > y) ? x : y }

function numjust(n, s) {
  if (index(s, ".") == 0) {
    offset = nwid[n] - nfmt[n] + 1
  } else {
    offset = (nwid[n] - length(s)) - (nfmt[n] - index(s, "."))
  }

  return s substr(blanks, 1, int((wid[n] - nwid[n]) / 2) + offset)
}
