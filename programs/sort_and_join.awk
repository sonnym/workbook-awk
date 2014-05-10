BEGIN {
  OFS = sep = "\t"
  file2 = ARGV[2]
  ARGV[2] = ""
  eofstat = 1
}

{
  if ((ng = getgroup()) > 0) {
    for (i = 0; i < ng; i++) {
      if (gp[i] != "") {
        printf("%s\t%s\n", $0, suffix(gp[i]))
      }
    }
  }
}

function getgroup() {
  delete gp
  group_length = 0

  for (; eofstat > 0; ln = getone(file2)) {
    if (prefix(ln) == prefix($0)) {
      gp[group_length++] = ln
    }
  }

  ln = ""
  eofstat = 1
  close(file2)

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
