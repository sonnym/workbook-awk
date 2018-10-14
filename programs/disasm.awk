BEGIN {
  split("const get put ld st add sub jpos jz j halt", all_ops)
  for (i in all_ops) {
    ops[sprintf("%.2d", i - 1)] = all_ops[i]
  }

  split("ld st add sub jpos jz j", label_ops_raw)
  for (i in label_ops_raw) {
    label_ops[label_ops_raw[i]] = ""
  }

  # disassembler pass 1
  srcfile = ARGV[1]
  max_label = 0

  while (getline <srcfile > 0) {
    op = get_op($1)

    if (op in label_ops) {
      location = get_argument_location($1)

      if (!(location in locations)) {
        locations[location] = generate_label()
      }
    }
  }
}

# disassembler pass 2
{
  op = get_op($1)
  location = sprintf("%.2d", NR - 1)

  if (location in locations) {
    prefix  = locations[location]
  } else {
    prefix = ""
  }

  if (op in label_ops) {
    argument = locations[get_argument_location($1)]
  } else {
    argument = ""
  }

  printf("%s\t%s\t%s\n", prefix, op, argument)
}

function get_op(str) {
  return ops[substr(str, 1, 2)]
}

function generate_label() {
  return sprintf("$%.3d", max_label++)
}

function get_argument_location(str) {
  return substr(str, 4, 2)
}
