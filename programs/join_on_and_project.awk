BEGIN {
  OFS = sep = "\t"

  process_args()

  load_file2()
}

FNR == 1 { split($0, attributes, sep) }
FNR != 1 { join() }

function process_args() {
  file2 = ARGV[2]
  join_on = ARGV[3]

  split(ARGV[4], projection, ",")

  ARGV[2] = ARGV[3] = ARGV[4] = ""
}

function load_file2() {
  split("", file2_attributes)

  file2_length = 0
  eofstat = 1

  for (; eofstat > 0; ln = getone(file2)) {
    if (ln != "") {
      if (length(file2_attributes) == 0) {
        split(ln, file2_attributes, sep)
      } else {
        file2_contents[file2_length++] = ln
      }
    }
  }

  close(file2)
}

function getone(f) {
  if (eofstat <= 0) {
    return 0
  }

  eofstat = getline ln <f

  return ln
}

function join() {
  associate(attributes, $0, left_associated)

  if ((ng = getgroup()) > 0) {
    for (i = 0; i < ng; i++) {
      associate(file2_attributes, group[i], right_associated)
      project(left_associated, right_associated)
    }
  }
}

function getgroup() {
  delete group
  group_length = 0

  for (l = 0; l < length(file2_contents); l++) {
    ln = file2_contents[l]

    if (on(ln)) {
      group[group_length++] = ln
    }
  }

  return length(group)
}

function on(ln) {
  associate(file2_attributes, ln, right_associated)

  return left_associated[join_on] == right_associated[join_on]
}

function associate(attr, line, associated) {
  split(line, split_line, sep)

  for (a = 0; a < length(attr); a++) {
    associated[attr[a]] = split_line[a]
  }
}

function project(left, right) {
  combine(left, right, combined)

  for (p = 1; p <= length(projection); p++) {
    attr = projection[p]
    printf("%s", combined[attr])

    if (p == length(projection)) {
      printf("\n")
    } else {
      printf("\t")
    }
  }
}

function combine(left, right, out) {
  copy(left, out)
  copy(right, out)
}

function copy(from, to) {
  for (k in from) {
    if (length(k) > 0) {
      to[k] = from[k]
    }
  }
}
