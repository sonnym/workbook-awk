# Exercise 5-3. Write a program to generate k distinct random integers between 1
# and n in time proportional to k.

BEGIN {
  distinct_rand(1, 25, 25);
}

function distinct_rand(min, max, count,   pivot, left, right) {
  if (min == max) {
    print max;
    return;
  }

  pivot = randint(max - min + 1) + min - 1;
  print pivot;

  count--;
  left = int(count * ((pivot - min) / (max - min)));
  right = count - left;

  if (left > 0) {
    distinct_rand(min, pivot - 1, left);
  }

  if (right > 0) {
    distinct_rand(pivot + 1, max, right);
  }
}

function randint(n) {
  return int(n * rand()) + 1
}
