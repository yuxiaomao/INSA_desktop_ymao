# Parser C et interpreteur ASM
Utilise directement:
```sh
bash run.sh
```
ou après `make` dans `./asmly` et dans `./cly`:
```sh
# genere code asm
./cly/parser test.c
# clean les \0 du code asm
tr '\0' " " < result_clair.txt > result_clair_clean.txt
# run asm
./asmly/interpreteur result_clair_clean.txt
```

Pour générer le Opcode afin d'exécuter sur FPGA, après `make` dans `./asm2oply`:
```sh
./asm2oply/asm2op result_clair_clean.txt > result_op.txt
```

Pour modifier le début de mémoire, il faut changer le macro TOPMEMO dans
`asmly/asmfonctions.h`(line 29) et
`cly/fonctions.h`(line 33):
```c
#define TOPMEMO 1000
```
