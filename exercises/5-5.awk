# With some grammars, there is an unacceptably high probability the the
# sentence-generation program will go into a derivation that just keeps getting
# longer. Add a mechanism to limit the length of a derivation.

BEGIN {
  PATH_LIMIT = 5

  read_grammar()
  calculate_path_lengths()

  for (n = 0; n < 10; n++) {
    gen("Sentence", PATH_LIMIT)
    print ""
  }
}

function read_grammar() {
  while (getline < "data/in/grammar" > 0) {
    if ($2 == "->") {
      i = ++lhs[$1]

      rhs_counts[$1, i] = NF - 2

      for (j = 3; j <= NF; j++) {
        rhs_list[$1, i, j - 2] = $j
      }
    } else {
      print "illegal production"
    }
  }
}

function calculate_path_lengths() {
  for (sym in lhs) {
    path_lengths[sym] = calculate_path_length(sym)
  }
}

function calculate_path_length(sym,   i, j, cyclic, max_len, branch_len) {
  cyclic = 0
  max_len = 0

  for (i = 1; i <= lhs[sym]; i++) {
    for (j = 1; j <= rhs_counts[sym, i]; j++) {
      rhs = rhs_list[sym, i, j]

      if (sym == rhs) {
        cyclic = 1

      } else if (rhs in lhs) {
        branch_len = calculate_path_length(rhs) + 1

        if (branch_len > max_len) {
          max_len = branch_len
        }
      } else {
        max_len = 2
        path_lengths[rhs] = 1
      }
    }
  }

  if (cyclic) {
    return -1
  } else {
    return max_len
  }
}

function gen(sym, path_limit,  i, j) {
  if (sym in lhs) {
    i = pick_production(sym, path_limit)

    for (j = 1; j <= rhs_counts[sym, i]; j++) {
      gen(rhs_list[sym, i, j], path_limit - 1)
    }
  } else {
    printf("%s ", sym)
  }
}

function pick_production(sym, path_limit) {
  split("", valid_paths);

  for (i = 1; i <= lhs[sym]; i++) {
    rhs_count = rhs_counts[sym, i]

    if (rhs_count == 0) {
      valid_paths[length(valid_paths) + 1] = i
    }

    for (j = 1; j <= rhs_count; j++) {
      rhs = rhs_list[sym, i, j]
      len = path_lengths[rhs]

      if (len > -1 && len < path_limit - 1) {
        valid_paths[length(valid_paths) + 1] = i
        j = rhs_count + 1;
      }
    }
  }

  return valid_paths[randint(length(valid_paths))]
}

function randint(n) {
  return int(n * rand()) + 1
}
