# Exercise 3-19. Write a command lookup x y that will print fomr a known file
# all multiline records having the item name x with value y.

BEGIN { RS = ""; FS = "\n" }

{
  if (lookup("date", "1/2/87")) {
    print $0
  }
}

function lookup(name, value) {
  for (i = 1; i <= NF; i++) {
    split($i, f, "\t")

    if (f[1] == name && f[2] == value) {
      return 1;
    }
  }

  return 0;
}
