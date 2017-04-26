# Architecture Materielle
**keyword**: Xilinx ISE, VHDL, FPGA

[Sujet TD1: td_compteur.pdf](http://homepages.laas.fr/bmorgan/td_compteur.pdf)

[Sujet TD2: FIFO.docx](http://homepages.laas.fr/bmorgan/FIFO.docx)

# Notes Personnelles
## TD1 Compteur 8 bits
- Pour simulation:
  - [à gauche, onglet: simulation]
  - behavioral check syntax
  - simulate behaviohal model
- Pour mettre sur carte FPGA:
  - [cpt8.vhd] -> add source [c8.ucf]
  - [en bas à gauche, implementation], double click dans le sens suivant:
  - Synthesize
  - Implement Design
  - Generate Programming File
  - Configure trager device[une nouvelle fenêtre ouvre]
  - [ise impact] la nouvelle fenêtre
  - [à gauche en haut] Boundary scan
  - Add [cpt8.bit] Xilint (Configuration de I/O)
  - [à gauche en bas] Program
  - Device 1 -> OK
- Le config donné par le prof[c8.ucf] est:
  - Din: switch
  - Dout: LED
  - CLK: center
  - RST: up
  - SENS: left
  - EN: right
  - LOAD: down
- Pour compter dans notre cas, appuyer RST, (sens), appuyer*N centre
- Ca sert à:
  - IP, pointeur instuction.
  - LOAD->JMP

## TD2 FIFO
- Définition d'un file comme en ada
```VHDL
type fifo_file is array (integer range 3 downto 0) of STD_LOGIC_VECTOR(3 downto 0)
signal f : fifo_file
f(1) <= x"0"
```
et on peut faire
```VHDL
signal head : STD_LOGIC_VECTOR(1 downto 0);
tete <= tete + 1;
```
comme le type n'est pas integer mais STD_LOGIC_VECTOR, on peut avoir overflow quand on atteint la valeur max+1, et on revient automatiquement à 0 comme modulo.
Donc sert bien de ce mécanisme, car modulo est coûteux.
- conv_integer(), lib stdlogic unsigned, convertir std_logic en entier

## Configuration
- New Project:
  - Evaluation Development Board: None Specified
  - Product Category: All
  - Family: Spartan6
  - Device: XC6SLX16
  - Package: CSG324
  - Speed: -3
  - Synthesis Tool: XST (VHDL/Verilog)
  - Simulator: ISim (VHDL/Verilog)
  - Preferred Language: VHDL
  - Property Specification in Project File: Store all values
  - Manual Compile Order: No
  - VHDL Source Analysis Standard: VHDL-93
  - Enable Message Filtering: No
