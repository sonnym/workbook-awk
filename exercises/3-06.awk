# Exercise 3-6. Make a version of the histogram code that divides the input
# into a specified number of buckets, adjusting the ranges according to the
# data given.

BEGIN {
  buckets = 5
  min_value = 0
  max_value = 0
}

               { values[NR] = $0 }
$1 < min_value { min_value = $1 }
$1 > max_value { max_value = $1 }

END {
  range = (max_value - min_value) / buckets
  negative_ranges = -1 * int(min_value / range)

  for (k in values)
    frequencies[int(values[k] / range)]++

  for (i = 0; i < buckets; i++)
    printf(" %4d - %4d: %2d %s\n",
           min_value + (range * i),
           min_value + (range * (i + 1)),
           frequencies[i - negative_ranges],
           rep(frequencies[i - negative_ranges], "*"))
}

function rep(n, s, t) {
  while (n-- > 0)
      t = t s
  return t
}
