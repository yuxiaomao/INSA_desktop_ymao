# Système Informatique
**keyword**: Compiler C, Lex, Yacc, ASM, Xilinx ISE, VHDL, FPGA

**Description**: Faire un compilateur C, créer des codes assembleurs. Et puis, faire un système sur FPGA pour éxécuter le code ASM généré.

- `src/` source code v5, principalement codé par moi à partir du v2
  - `src/cly` parseur de C vers ASM
  - `src/asmly` interpréteur de ASM à l'exécution
  - `src/asm2oply` générateur de opcode pour utiliser dans uProcesseur
- `src_rama/` source code de Rama v4
- `uProcesseur/`
  - `uProcesseur/components` et `uProcesseur/cores`  [package de M. Benoit Morgan](http://homepages.laas.fr/bmorgan/soc.tgz), contenant mémoire ROM (32bits), RAM (16bits), vga
  - `uProcesseur/` main module `fpga.vhd`, simulation `fpgatest.vhd`, implementation `fpga.ucf`

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
## C code
- type de variable
  - int, const int
- Déclaration & Affectation
- Expression E
  - int, id
  - ADD, MUL, SUB, DIV
  - EQU, INF, INFE, SUP, SUPE
- If & While boucle
- Pointeur & Malloc
  - type: \*int
  - valeur: &a
- Fonction
  - Notion de EBP(base de pile), inspiré du cours Sécu
  - possible appel récursif
  - possible return valeur
- Pré/Post incrémentation
  - valeur: i++
  - boucle: for(Affectation,E,id++)

### ASM & OP code
| Opération | Code | OP | | | | Description|
| --- | --- | --- | --- | --- | --- | --- |
| Addition | 0x01 | ADD | Ri | Rj | Rk | [Ri] ← [Rj] + [Rk] |
| Multiplication | 0x02 | MUL | Ri | Rj | Rk | [Ri] ← [Rj] * [Rk] |
| Soustraction | 0x03 | SUB | Ri | Rj | Rk | [Ri] ← [Rj] - [Rk] |
| Division | 0x04 | DIV | Ri | Rj | Rk | [Ri] ← [Rj] / [Rk] |
| Copie | 0x05 | COP | Ri | Rj | | [Ri] ← [Rj] |
| Affectation | 0x06 | AFC | Ri | j_h | j_l | [Ri] ← j (16bits, j_h & j_l) |
| Chargement | 0x07 | LOAD | Rbp | j | Ri | @[[Rbp]+j] ← [Ri] |
| Sauvegarde | 0x08 | STORE | Ri | Rbp | j | [Ri] → @[[Rbp]+j] |
| Egalité | 0x09 | EQU | Ri | Rj | Rk | [Ri] ← 1 si [Rj]=[Rk], 0 sinon |
| Inferieur | 0xA | INF | Ri | Rj | Rk | [Ri] ← 1 si [Rj]<[Rk], 0 sinon |
| Inferieur égal | 0xB | INFE | Ri | Rj | Rk | [Ri] ← 1 si [Rj]<=[Rk], 0 sinon |
| Supérieur | 0xC | SUP | Ri | Rj | Rk | [Ri] ← 1 si [Rj]>[Rk], 0 sinon |
| Supérieur égal | 0xD | SUPE | Ri | Rj | Rk | [Ri] ← 1 si [Rj]>=[Rk], 0 sinon |
| Saut | 0xE | JMP | @i_h | @i_l | | Saut à l’adresse @i (16bits) |
| Saut conditionnel | 0xF | JMPC | @i_h | @i_l | Ri | Saut à l’adr @i (16bits) si Ri = 0 |
| Saut Registre | 0x10 | JMPR | Ri | | | Saut à l’adresse @[Ri] |


## VHDL code
### Overview
- Conception d’un microprocesseur de type RISC avec pipe-line
- Input: `init32.hex`
  - Compatible avec les codes générés par Compilateur C
- Mémoire: `init16.hex`
  - Si on veux initialisé le contenu du RAM
- Fréquences de fonctionnement: `92MHz` (requis 100 MHz, n'est pas satisfait à l'état actuelle du projet)
- Config projet  
  - Family: Spartan6
  - Device: XC6SLX16
  - Package: CSG324
  - Speed: -3
  - Synthesis Tool: XST (VHDL/Verilog)
  - Simulator: ISim (VHDL/Verilog)
  - Preferred Language: VHDL
  - VHDL Source Analysis Standard: VHDL-93

### Plan du chemin des données

| Instructions | Banc de registres(r) | UAL | Mémoires des données |Banc de registres(w) |
| --- | --- | --- | --- | --- |
| Pointeur d'instruction `ip`| |Logic Controller `lcual`| Logic Controller `lcmem` | Logic Controller `lc` |
| ROM 32 bits `bram32`| Registres `regs/read` | UAL `ual` | RAM `bram16` + VGA `vga_top`| Registres `regs/write` |
| Décodeur `decode`| Multiplexer `mux` | Multiplexer `muxual` | | Multiplexer `muxdata` |

\* `pipeline` Le passage entre les différents niveau de pipeline. synchrone, probager les valeurs OP, A, B, C à la sortie à chaque rising_edge(CLK), reset asynchrone avec signal NOP.

\*\* `ctlalea` Control aléa de donnée est mis en place pour gestion d'un write suivi d'un read sur le même registre; control aléa de branchement est pour gestion des jump.

### Explcation des unités
- IP
  - synchrone rising_edge(CLK)
  - pointeur d'instruction est un compteur, il pointe sur la prochaine ligne qu'on veut exécuté
  - Lors d'un aléa de donnée est détecter, IP arrête de compter pour laisser finir l'instruction écrire critique
- ROM
  - synchrone rising_edge(CLK)
  - contient les instructions que l'on veut exécuter
- Décode
  - combinatoire
  - Décodeur prend 32 bits à l'entrée et les séparent, selon OP, dans signaux A, B et C de 16 bits
- Registres
  - synchrone failling_edge(CLK)
    - pour garandir chaque pipeline se fait dans 1 CLK période
  - 32 registres de 16 bits synchrone
  - l'écriture et la lecture simultané est possible, considéré comme d'abord fait l'écriture
- UAL
  - combinatoire
  - permet de faire ADD, MUL, SUB, (DIV non implémenté)
- RAM
  - synchrone rising_edge(CLK)
  - plage 0x0000 - 0x3FFFF
- VGA
  - synchrone rising_edge(CLK)
  - plage 0x4000 - 0x7FFF
- LC logic controller
  - combinatoire
  - Il s'agit de détecter la présence d'une action write (registres ou mémoires), ou de repéré le calcul arithmétique voulu (ual)
- Multiplexer
  - combinatoire
  - Ceci s'agit de la choix entre signal passé par module (par exemple UAL), ou la valeur probagé depuis le pipeline précédent

### Amélioration
- Fréquence de fonctionnement
  - trouvé la chemin critique du code, essayer d'améliorer la fréquence de fonctionnement
- VGA
  - à l'état actuelle, l'affichage à l'écran VGA ne fonctionne pas, il n'y a aucun signal à la sortie
- Détection Aléa
  - Manque de séparation de cas READ x r 0 / READ x r r / READ x 0 r, c-à-d la lecture se fait sur quelle registre
  - L'écriture est la lecture simultané est possible, donc on peut encore réduire le temps d'attente lors de la détection d'un aléa de donnée
- Les instructions non traité: EQU, INF, INFE, SUP, SUPE
  - Aélioration possible: dans UAL faire Rj-Rk, affecter dans Ri selon la règle suivant
    - EQU = Z
    - INF = N
    - INFE = N or Z
    - SUP = not(N or Z)
    - SUPE = not(N)
- L'accès mémoire avec connecteur de bus non traité
  - Normalement il faut un module au milieu (`cores/conbus1x4.v`) pour multiplexer l'accès mémoire, selon les différents adresse, on peut accéder à RAM, Core Vidéo vga, Périphériques et Timers. Mais pour l'instant on a brancher directement les sigaux de adresse, data in, data out, we à module RAM etc.
