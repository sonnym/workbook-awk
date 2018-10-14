# Exercie 6-4.  Write a disassembler that converts a raw memory dump into
# assembly language

BEGIN {
  system("awk -f programs/disasm.awk data/in/6-4")
}
