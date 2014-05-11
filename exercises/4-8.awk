# Exercise 4-8. Modify join so it can join on any field or fields of the input
# files, and output any selected subset of fields in any order.

BEGIN {
  system("awk -f programs/join_on_and_project.awk data/countries_with_headers data/capitals_with_headers Country Area,Capital")
}
