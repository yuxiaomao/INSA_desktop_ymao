## Questionnement concernant la bram16 [Projet SI]
Rama DESPLATS, Yuxiao MAO, Benoit MORGAN

### 1 Rama DESPLATS
Monsieur Morgan,

Aujourd'hui en TP, nous avons rencontré un comportement nous ayant amenés
à nous poser des questions.

En effet, dans votre code de la bram16, on trouve : assign adr =
a[adr_width-1:1];
Cependant, en tronquant le dernier bit, si on donne à "a" la valeur "0000"
et "0001", la valeur retournée par adr sera "000".

Du coup, lorsque l'utilisateur veut LOAD l'@0 et l'@1, il aura la même
valeur. Ce qui ne correspond pas réellement au comportement attendu.

Auriez-vous des informations complémentaires par rapport à notre façon
d'aborder le problème ?
Faut-il nous même réaliser le décalage de "a" pour avoir la bonne valeur
de "adr" ?

### 2 Benoît MORGAN
Bonjour,

Concernant les modules mémoires, le choix a été de simplifier au maximum
l'interprétation des adresses utilisées par le logiciel du SoC. Les modules
bram16 et bram32 sont des mémoires qui stockent respectivement des mots de 2 et
4 octets. Un design possible est d'adresser chaque mot de ces mémoires par
unité d'adresse. Plus concrètement pour les bram{16,32} nous aurions la
traduction suivante :

```
bram16 :      bram32 :
@    Data     @    Data
0 -> mot16 0  0 -> mot32 0
1 -> mot16 1  1 -> mot32 1
2 -> mot16 2  2 -> mot32 2
[..]
```

Une utilisation naïve de cette technique d'adressage poserait le problème
suivant. Une adresse manipulée par le processeur a deux sémantiques différent en
fonction de son usage : Si elle représente un adresse de donnée une unité permet
d'adresser deux octets et dans le cas où elle représente un pointeur de
fonction, une unité permet d'adresser 4 octets. On a donc une représentation de
la mémorie qui diverge. Pour tout mettre à plat, nous avons choisi d'imposer
l'adressage à l'octet au niveau des blocs mémoires pour obtenir l'adressage
suivant :

```
bram16:       bram32 :
@    Data     @    Data
0 -> mot16 0  0 -> mot32 0
2 -> mot16 1  4 -> mot32 1
4 -> mot16 2  8 -> mot32 2
```

On décale en effet de 1 à droite l'adresse en entrée dans le bram16 et de 2 a
droite dans le bram32.

Ainsi dans la globalité du système une unité d'adresse représente uniformément
un octet. Cela permet aussi de simplifier l'interprétation des simulations.
un LOAD R1, 0x4 verra 0x4 en entrée du bram16.

J'ai joint en pièce jointe une trace d'exécution de l'implémentation de
référence du SoC.

### 3 Rama DESPLATS
Monsieur Morgan,

J'ai bien reçu votre réponse de la dernière fois et n'ai pas manqué de la transmettre au reste du groupe.
Cela nous a beaucoup aidé, je vous remercie.

Voulant implémenter le VGA à notre FPGA, j'ai rencontré des erreurs. En effet, il y a des incohérences entre le fichier component "vga_top.vhd" et le fichier core "vga_top.v".

Premièrement, les noms des signaux ne sont pas les mêmes (respectivement mem_do et mem_dw) mais jusque là pas trop de soucis, j'avais juste à changer les noms.
Par contre, dans le component vga_blu est un out std_logic_vector(2 downto 0) et dans le core c'est output [1:0] vga_blu.
Du coup, ISE nous sort l'erreur : "Expression has 3 elements ; expected 2" comme dans la capture d'écran jointe à ce courriel.

Est-ce encore quelque chose que nous manquons ou faut-il procéder différemment ?

Faut-il écrire les adresses respectivement à partir de 0x4000 (comme pour les bram{16,32}) ou doit on les écrire "en dur"?

Je vous remercie d’avance du temps que vous prendrez à répondre à ce courriel et je reste à votre entière disposition pour répondre à d’éventuelles questions.

### 4 Yuxiao MAO
Bonjour,

Vous trouvez dans ce lien les codes que nous avons écris:

[1]https://github.com/ramadesplats/C-to-ASM/tree/master/ASM-Processor

1. Après avoir travaillé sur notre code, nous n'avons toujours pas réussi
à afficher les "hello world" sur vga, il n'y a aucun signal détecté par
l'écran. Pourriez-vous regarder notre code et nous dire comment le faire
marcher?

2. En plus,  la fréquences de fonctionnement maximale (donnée dans
synthèse) de notre code est actuellement à 92 MHz après avoir fini la
gestion d'aléa, on aimerait bien savoir comment trouver la chemin critique
pour améliorer la fréquence.

### 5 Benoit MORGAN
Bonjour,

Je ne sais plus trop ce qu'on avait dit et fait ensemble en TP la dernière fois.
J'ai regardé votre fpga.ucf. Il inique bien que VGA_vga_clk oit être à 25MHz.
Aussi CLK doit être à 100 MHz. Il faut maintenant générer l'horloge VGA à partir
de l'horloge système en utilisant deux diviseurs d'horloge sucessifs qui
diviseront par deux l'horloge en entrée à chaque fois, donc par 4 au total :

```
signal vga0 : STD_LOGIC;
signa VGA_vga_clk : STD_LOGIC;

begin

  div0 : process (clk) begin
    if rising_edge(clk) then
      if rst == '0' then
        vga0 <= '0';
      else
        vga0 <= vga0 + '1';
      end if;
    end if;
  end process;

  div1 : process (vga0) begin
    if rising_edge(vga0) then
      if rst == '0' then
        VGA_vga_clk <= '0';
      else
        VGA_vga_clk <= VGA_vga_clk + '1';
      end if;
    end if;
  end process;
```

Votre problème venait du fait que vous n'aviez pas la bonne horloge pour le VGA
core. Il n'y en avait pas du tout à la vue du fpga.ucf. Notre fpga digilent
dispose que d'une seule horloge utilisateur à 100Mhz qu'il faut partager entre
les éléments du FPGA. D'ou la nécessité d'un diviseur.

Pour votre 2ième problème, en effet il faut amléiorer la performance de votre
circuit pour qu'il supporte 100Mhz sinon vous aurez à faire face aux problèmes
liés à l'overclocking...

Pour trouver où se situent les éventuelles améliorations de performance à
effectuer, il faut lire le rapport de synthèse de votre circuit. Voici le miens
:

```
Timing Summary:
---------------
Speed Grade: -3

   Minimum period: 9.068ns (Maximum Frequency: 110.277MHz)
   Minimum input arrival time before clock: 8.428ns
   Maximum output required time after clock: 5.498ns
   Maximum combinational path delay: No path found

Timing Details:
---------------
All values displayed in nanoseconds (ns)

=========================================================================
Timing constraint: Default period analysis for Clock 'sys_clk'
  Clock period: 9.068ns (frequency: 110.277MHz)
  Total number of paths / destination ports: 67478 / 1323
-------------------------------------------------------------------------
Delay:               9.068ns (Levels of Logic = 6)
  Source:            d16/p_ex_mem/op_out_5 (FF)
  Destination:       sys_ctl/led_7 (FF)
  Source Clock:      sys_clk rising
  Destination Clock: sys_clk rising

  Data Path: d16/p_ex_mem/op_out_5 to sys_ctl/led_7
                                Gate     Net
    Cell:in->out      fanout   Delay   Delay  Logical Name (Net Name)
    ----------------------------------------  ------------
     FDRE:C->Q             4   0.447   0.788  d16/p_ex_mem/op_out_5 (d16/p_ex_mem/op_out_5)
     LUT2:I0->O            1   0.203   0.580  d16/Mmux_data_a17_SW0 (N50)
     LUT6:I5->O           88   0.205   1.799  d16/Mmux_data_a17 (d16/Mmux_data_a17)
     LUT3:I2->O           26   0.205   1.207  d16/Mmux_data_a61 (data_a<14>)
     LUT6:I5->O            2   0.205   0.981  data_bus/Mmux_s2_a101 (sys_ctl_a<3>)
     LUT6:I0->O            5   0.203   0.715  sys_ctl/a[13]_GND_23_o_equal_3_o<13>11 (sys_ctl/a[13]_GND_23_o_equal_3_o<13>11)
     LUT6:I5->O           16   0.205   1.004  sys_ctl/_n0099_inv1 (sys_ctl/_n0099_inv)
     FDRE:CE                   0.322          sys_ctl/led_0
    ----------------------------------------
    Total                      9.068ns (1.995ns logic, 7.073ns route)
                                       (22.0% logic, 78.0% route)

=========================================================================
Timing constraint: Default period analysis for Clock 'vga_clk0'
  Clock period: 1.913ns (frequency: 522.821MHz)
  Total number of paths / destination ports: 1 / 1
-------------------------------------------------------------------------
Delay:               1.913ns (Levels of Logic = 1)
  Source:            vga_clk (FF)
  Destination:       vga_clk (FF)
  Source Clock:      vga_clk0 rising
  Destination Clock: vga_clk0 rising

  Data Path: vga_clk to vga_clk
                                Gate     Net
    Cell:in->out      fanout   Delay   Delay  Logical Name (Net Name)
    ----------------------------------------  ------------
     FD:C->Q               1   0.447   0.579  vga_clk (vga_clk)
     INV:I->O              1   0.206   0.579  Mcount_vga_clk_xor<0>11_INV_0 (Result1)
     FD                      0.102          vga_clk
    ----------------------------------------
    Total                      1.913ns (0.755ns logic, 1.158ns route)
                                       (39.5% logic, 60.5% route)

=========================================================================
Timing constraint: Default period analysis for Clock 'vga_clk'
  Clock period: 5.556ns (frequency: 179.983MHz)
  Total number of paths / destination ports: 1905 / 140
-------------------------------------------------------------------------
Delay:               5.556ns (Levels of Logic = 3)
  Source:            vga/video/hc_3 (FF)
  Destination:       vga/video/cy_4 (FF)
  Source Clock:      vga_clk rising
  Destination Clock: vga_clk rising

  Data Path: vga/video/hc_3 to vga/video/cy_4
                                Gate     Net
    Cell:in->out      fanout   Delay   Delay  Logical Name (Net Name)
    ----------------------------------------  ------------
     FDR:C->Q              3   0.447   0.995  vga/video/hc_3 (vga/video/hc_3)
     LUT5:I0->O            1   0.203   0.827  vga/video/GND_3_o_hc[9]_AND_2_o_SW0 (N
     LUT6:I2->O           31   0.203   1.642  vga/video/GND_3_o_hc[9]_AND_2_o (vga/video/GND_3_o_hc[9]_AND_2_o)
     LUT6:I0->O            5   0.203   0.714  vga/video/_n0184_inv1 (vga/video/_n0184_inv)
     FDRE:CE                   0.322          vga/video/cy_0
    ----------------------------------------
    Total                      5.556ns (1.378ns logic, 4.178ns route)
                                       (24.8% logic, 75.2% route)

=========================================================================
Timing constraint: Default OFFSET IN BEFORE for Clock 'sys_clk'
  Total number of paths / destination ports: 868 / 744
-------------------------------------------------------------------------
Offset:              8.428ns (Levels of Logic = 4)
  Source:            sys_rst (PAD)
  Destination:       d16/reg_ip/cpt_13 (FF)
  Destination Clock: sys_clk rising

  Data Path: sys_rst to d16/reg_ip/cpt_13
                                Gate     Net
    Cell:in->out      fanout   Delay   Delay  Logical Name (Net Name)
    ----------------------------------------  ------------
     IBUF:I->O           452   1.222   2.313  sys_rst_IBUF (sys_rst_IBUF)
     LUT5:I2->O            1   0.205   0.808  d16/jmp/Mmux_mem_addr18_SW0 (N86)
     LUT6:I3->O           33   0.205   1.534  d16/jmp/Mmux_mem_addr18 (d16/jh_load)
     LUT3:I0->O           60   0.205   1.613  d16/aleas/len1 (d16/ah_en)
     FDRE:CE                   0.322          d16/reg_ip/cpt_2
    ----------------------------------------
    Total                      8.428ns (2.159ns logic, 6.269ns route)
                                       (25.6% logic, 74.4% route)

=========================================================================
Timing constraint: Default OFFSET IN BEFORE for Clock 'vga_clk'
  Total number of paths / destination ports: 57 / 57
-------------------------------------------------------------------------
Offset:              5.305ns (Levels of Logic = 2)
  Source:            sys_rst (PAD)
  Destination:       vga/video/py_3 (FF)
  Destination Clock: vga_clk rising

  Data Path: sys_rst to vga/video/py_3
                                Gate     Net
    Cell:in->out      fanout   Delay   Delay  Logical Name (Net Name)
    ----------------------------------------  ------------
     IBUF:I->O           452   1.222   2.085  sys_rst_IBUF (sys_rst_IBUF)
     LUT3:I2->O           37   0.205   1.362  vga/video/Mcount_cy_val1 (vga/video/Mcount_cy_val)
     FDRE:R                    0.430          vga/video/cy_0
    ----------------------------------------
    Total                      5.305ns (1.857ns logic, 3.448ns route)
                                       (35.0% logic, 65.0% route)

=========================================================================
Timing constraint: Default OFFSET OUT AFTER for Clock 'vga_clk'
  Total number of paths / destination ports: 22 / 10
-------------------------------------------------------------------------
Offset:              5.498ns (Levels of Logic = 3)
  Source:            vga/video/vc_7 (FF)
  Destination:       vga_vsync (PAD)
  Source Clock:      vga_clk rising

  Data Path: vga/video/vc_7 to vga_vsync
                                Gate     Net
    Cell:in->out      fanout   Delay   Delay  Logical Name (Net Name)
    ----------------------------------------  ------------
     FDRE:C->Q             4   0.447   0.912  vga/video/vc_7 (vga/video/vc_7)
     LUT4:I1->O            1   0.205   0.580  vga/vga_vsync1_SW0 (N20)
     LUT6:I5->O            1   0.205   0.579  vga/vga_vsync1 (vga_vsync_OBUF)
     OBUF:I->O                 2.571          vga_vsync_OBUF (vga_vsync)
    ----------------------------------------
    Total                      5.498ns (3.428ns logic, 2.070ns route)
                                       (62.3% logic, 37.7% route)

=========================================================================
Timing constraint: Default OFFSET OUT AFTER for Clock 'sys_clk'
  Total number of paths / destination ports: 8 / 8
-------------------------------------------------------------------------
Offset:              3.597ns (Levels of Logic = 1)
  Source:            sys_ctl/led_7_1 (FF)
  Destination:       led<7> (PAD)
  Source Clock:      sys_clk rising

  Data Path: sys_ctl/led_7_1 to led<7>
                                Gate     Net
    Cell:in->out      fanout   Delay   Delay  Logical Name (Net Name)
    ----------------------------------------  ------------
     FDRE:C->Q             1   0.447   0.579  sys_ctl/led_7_1 (sys_ctl/led_7_1)
     OBUF:I->O                 2.571          led_7_OBUF (led<7>)
    ----------------------------------------
    Total                      3.597ns (3.018ns logic, 0.579ns route)
                                       (83.9% logic, 16.1% route)

=========================================================================
```

Vous trouverez dans ces tableaux le chemin le plus contraignant en terme de
porte traversées entre la sortie d'une bascule et l'entrée de la bascule
terminant ce chemin. Plus les operations logiques rencontrées sur le chemin le
plus contraignant sont simples, plus la période nécessaire pour une
stabilisation des sorties par rapport aux entrées de ce chemin sera faible, donc
la fréquence grande.

Vous aurez surement des soucis au niveau de l'alu par exemple. Si vous faites
des décalages à la place des multiplications et divs. Sachez que vous ne
pourrez pas tenir 100Mhz si vous permettez le décalage de 0 à 8, vous devrez
déscendre à 0 à 4 il me semble. Ainsi le multiplexeur nécessaire pour ce
décalage est moins important du plus rapide

Envoyez moi votre fin de rapport de synthèse (la même que la mienne) si vous ne
trouvez pas.

Pour résumer :

- Générez votre clock VGA avec les deux diviseurs de clock système
- AUgmentez la performance de votre circuit pour tenir 100hz sinon le VGA core
  ne pourra pas fonctionner
- Autre solution. Vous pouvez diviser la clock par deux pour votre système puis
  par 4 pour le VGA. mais votre processeur sera 2 fois plus lent qu'il ne
  pourrait être !
