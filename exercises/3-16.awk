# Exercise 3-16. Because awk variables are not declared, a misspelled name will
# not be detected. Write a program to identify names that are only used once.
# To make it truly useful, you will have to handle function declarations and
# variables used in functions.

# clean up line
/"/  { gsub(/"([^"]|\\")*"/, "", $0) }
/\// { gsub(/\/([^\/]|\\\/)+\//, "", $0) }
/#/  { sub(/#.*/, "", $0) }

# tokenize line
{
  split($0, line, /[ \t]+|\[|\]|\(|\)|,|{|}/)

  for (i in line)
    if (line[i] == "")
      delete line[i]
}

# capture function definitions
$0 ~ /^function/ {
  note_usage(line[2], NR, functions)
  delete line[2]
}

# capture identifier usage
{
  for (i in line)
    if (valid_identifier(line[i]) && !is_built_in(line[i]))
      if (is_fn_invocation(line[i], $0))
        note_usage(line[i], NR, functions)
      else
        note_usage(line[i], NR, identifiers)
}

END {
  warn(functions, "file %s, line %2d: function %s declared but never used\n")
  warn(identifiers, "file %s, line %2d: identifier %s used only once\n")
}

function valid_identifier(token) {
  return token ~ /^[a-zA-Z_]+[a-zA-Z0-9_]*$/
}

function is_built_in(token) {
  return token ~ /(close|system|atan2|sin|cos|rand|srand|match|sub|gsub)/ ||
         token ~ /(NR|ARGC|ARGV|FNR|RSTART|RLENGTH|SUBSEP|BEGIN|END)/ ||
         token ~ /(for|in|do|delete|function|return)/
}

function is_fn_invocation(token, line) {
  return line ~ token "\\(.*\\)"
}

function note_usage(identifier, line, arr) {
  if (identifier in arr)
    arr[identifier] = -1
  else
    arr[identifier] = line
}

function warn(arr, message) {
  for (i in arr)
    if (arr[i] != -1)
      printf(message, FILENAME, arr[i], i) | "sort"
}
