# Exercise 3-15. Rewrite compat to indentify keywords, etc., with regular
# expressions instead of the function asplit. Compare the two versions on
# complexity and speed.

# for i in $(seq 1 1000); do; awk -f exercises/3-15.awk data/in/3-15; done
# Before: 1.28s user 1.54s system 90% cpu 3.112 total
# After:  1.45s user 2.34s system 90% cpu 4.178 total

{ line = $0 }

/"/  { gsub(/"([^"]|\\")*"/, "", line) }
/\// { gsub(/\/([^\/]|\\\/)+\//, "", line) }
/#/  { sub(/#.*/, "", line) }

{
  n = split(line, x, "[^A-Za-z0-9_]+")

  for (i = 1; i <= n; i++) {
    if (x[i] ~ /(close|system|atan2|sin|cos|rand|srand|match|sub|gsub)/)
      warn(x[i] " is now a built-in function")
    if (x[i] ~ /(ARGC|ARGV|FNR|RSTART|RLENGTH|SUBSEP)/)
      warn(x[i] " is now a built-in variable")
    if (x[i] ~ /(do|delete|function|return)/)
      warn(x[i] " is now a keyword")
  }
}

function warn(s) {
  sub(/^[ \t]+/, "")
  printf("file %s, line %d: %s\n\t%s\n", FILENAME, FNR, s, $0)
}
