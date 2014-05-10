# Exercise 4-6. This version of join does not check for errors or whether the
# files are sorted. Remedy these defects. How much bigger is the program?

BEGIN {
  system("awk -f programs/sort_and_join.awk data/unsorted_countries data/unsorted_capitals")
}
