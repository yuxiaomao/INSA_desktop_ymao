# Système Informatique
**keyword**: Compiler C, Lex, Yacc, ASM, Xilinx ISE, VHDL, FPGA

**Description**: Faire un compilateur C, créer des codes assembleurs. Et puis, faire un système sur FPGA pour éxécuter le code ASM généré.

- `src/` source code v5, principalement codé par moi à partir du v2
  - `src/cly` parseur de C vers ASM
  - `src/asmly` interpréteur de ASM à l'exécution
  - `src/asm2oply` générateur de opcode pour utiliser dans uProcesseur
- `src_rama/` source code de Rama v4
- `uProcesseur/` (pas encore fini, il va y avoir du code VHDL)

**La plus grande Différence entre src et src_rama**:
- Registre & Mémoire
  - J'utilise toujours R0 R1, j'ai choisi d'enregistrer les résultats intermédiaire dans le mémoire.
  - Rama utilise du R0 à Rx, cela économise nettement le nombre de ligne ASM mais limité par le nombre total de registre. Les calculs immenses ne peux peut-être pas réussi.
- Interpréteur ASM
  - J'utilise Lex&Yacc + C
  - Rama utilise C

**Pourquoi 2 src**:
- Moi et Rama, on a développé le code Lex et la base de Yacc ensemble à l'aide de notre encadrant(v1).
- Rama commence à coder en C pour l'affichage, la table de symboles, la définition, l'affectation, les calculs / (v2).
- A partir de sa base nous avons codé séparément les mêmes fonctionnalités mais avec chacun son habitute de codage(rama_v3 et yuxiao_v3).
- Après ça, comme on peut s'inspiré le code de l'autre, on a décidé de séparer un peu la tache: j'ai fait la gestion des fonctions, Rama a fait la gestion pointeur et prépost incrément(rama_v4 et yuxiao_v4).
- On fini par choisir ma version et intégrer les fonctionnalités, c'est ici src(v5).
- Le src_rama est en v4, donc il n'y a pas encore la gestion de fonction.

# Fonctionnalités
- type de variable: int, const int
- Déclaration & Affectation
- Expression E
- If & While boucle
- Pointeur & Malloc
  - Nouveau type: \*int
- Fonction
  - Besoin de changer LOAD et STORE
  - Notion de EBP(base de pile), inspiré du cours Sécu
- Pré/Post incrémentation
  - Nouveau boucle: for(Affectation,E,id++)
