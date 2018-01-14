# Exercise 6-2.  Augment the interpreter to print a trace of the instructions as
# they are executed.

BEGIN {
  system("awk -f programs/asm_with_tracer.awk data/in/assembly_program data/assembly_data")
}
