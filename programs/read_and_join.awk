BEGIN {
  OFS = sep = "\t"

  file2 = ARGV[2]
  ARGV[2] = ""

  load_file2()
}

{
  if ((ng = getgroup()) > 0) {
    for (i = 0; i < ng; i++) {
      printf("%s\t%s\n", $0, suffix(gp[i]))
    }
  }
}

function load_file2() {
  file2_length = 0
  eofstat = 1

  for (; eofstat > 0; ln = getone(file2)) {
    if (ln != "") {
      file2_contents[file2_length++] = ln
    }
  }

  close(file2)
}

function getgroup() {
  delete gp
  group_length = 0

  for (i = 0; i < length(file2_contents); i++) {
    ln = file2_contents[i]

    if (prefix(ln) == prefix($0)) {
      gp[group_length++] = ln
    }
  }

  return length(gp)
}

function getone(f) {
  if (eofstat <= 0) {
    return 0
  }

  eofstat = getline ln <f

  return ln
}

function prefix(s) {
  return substr(s, 1, index(s, sep) - 1)
}

function suffix(s) {
  return substr(s, index(s, sep) + 1)
}
