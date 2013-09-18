# Exercise 3-5. Scale the rows of stars so they don't overflow the line length
# when there's a lot of data.

BEGIN {
  max_width = 60
}

{ x[int($1/10)]++ }

END {
  for (key in x)
    longest = x[key] > longest ? x[key] : longest

  for (i = 0; i < 10; i++)
    printf(" %2d - %2d: %3d %s\n", 10*i, 10*i+9, x[i], rep(scale(x[i], longest), "*"))

  printf("100:      %3d %s\n", x[10], rep(scale(x[i], longest), "*"))
}

function scale(val, longest) {
  return val * (max_width / longest)
}

function rep(n, s, t) {
  while (n-- > 0)
      t = t s
  return t
}
