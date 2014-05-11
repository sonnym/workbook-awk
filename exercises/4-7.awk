# Exercise 4-7. Implement a version of join that reads one file entirely into
# memory, then does the join. Which is simpler?

BEGIN {
  system("awk -f programs/read_and_join.awk data/unsorted_countries data/unsorted_capitals")
}
