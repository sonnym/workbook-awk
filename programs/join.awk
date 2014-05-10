BEGIN {
  OFS = sep = "\t"
  file2 = ARGV[2]
  ARGV[2] = ""
  eofstat = 1

  if ((ng = getgroup()) <= 0) {
    exit
  }
}

{
  while (prefix($0) < prefix(gp[1])) {
    if ((ng = getgroup()) <= 0) {
      exit
    }
  }

  if (prefix($0) == prefix(gp[1])) {
    for (i = 1; i <= ng; i++) {
      printf("%s\t%s\n", $0, suffix(gp[i]))
    }
  }
}

function getgroup() {
  if (getone(file2, gp, 1) <= 0) {
    return 0
  }

  for (ng = 2; getone(file2, gp, ng) > 0; ng++) {
    if (prefix(gp[ng]) != prefix(gp[1])) {
      unget(gp[ng])
      return ng - 1
    }
  }

  return ng - 1
}

function getone(f, gp, n) {
  if (eofstat <= 0) {
    return 0
  }

  if (ungot) {
    gp[n] = ungotline
    ungot = 0
    return 1
  }

  return eofstat = (getline gp[n] <f)
}

function unget(s) {
  ungotline = s
  ungot = 1
}

function prefix(s) {
  return substr(s, 1, index(s, sep) - 1)
}

function suffix(s) {
  return substr(s, index(s, sep) + 1)
}
