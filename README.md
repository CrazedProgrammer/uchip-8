# uchip-8  
Chip-8 assembler written in Urn  
  
## Usage  
`uchip-8.lua <input file> [output file]`  
  
## Syntax  
This assembler uses the same opcodes as on [Cowgod's Chip-8 Technical Reference v1.0](http://devernay.free.fr/hacks/chip8/C8TECH10.HTM).  
The language is case-insensitive.  
Arguments are separated by comma's (`ld v0, 20`).  
  
### Literals
Address literals are written as `$<address>`, for example (`$2E3h`).  
Byte literals are written as `<byte>`, for example `32`.  
You can write values in hex by putting a `h` after it.  
This means `20h` and `32` have the same meaning.  
  
### Labels  
Labels are declared with `<label name>:`.  
You can directly use labels as addresses, for example `jp start`, where `start` is the label name.  
