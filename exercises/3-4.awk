# Exercise 3-4. Write a program that reads a list of item and quantity pairs
# and for each item on the list accumulates the total quantity; at the end it
# prints the items and total quantities, sorted alphabetically by item.

{ accumulator[$1] += $2 }

END { 
  for (key in accumulator) {
    printf("%s %d\n", key, accumulator[key]) | "sort"
  }
}
