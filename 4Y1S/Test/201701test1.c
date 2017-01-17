#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define MAXN 100

int main(){
    /* var */
    FILE *pfin;
    FILE *pfout;
    int nbtest;
    int N;
    int X[MAXN];
    /* math var */
    float math_sum=0.0000f;
    double math_avg=0.000f;
    double V=0.0f;
    float S[MAXN];
    /* loop and error var */
    int i;
    int j;
    int err;

    /*open file*/
    pfin=fopen("./input.txt","r");
    if(pfin==0){printf("Err pfin.\n");}

    pfout=fopen("./output","w");
    if(pfout==0){printf("Err pfout.\n");}

    err=fscanf(pfin,"%d",&nbtest);
    printf("Total test: %d.\n",nbtest);
    if(err==EOF){printf("Err fscanf.\n");}

    /*Main loop*/
    for(i=0;i<nbtest;i++){
        fprintf(pfout,"#%d:",i+1);

        fscanf(pfin,"%d",&N);
        //printf("Nbdata:%d\n",N);
        if(N>MAXN){printf("Nbdata must < %d.\n",MAXN);exit(1);}

        /*Analyse input*/
        for(j=0;j<N;j++){
            fscanf(pfin,"%d",&X[j]);
        }

        /*Math calcul*/
        math_sum=0.0f;
        for(j=0;j<N;j++){
            math_sum+=X[j];
        }
        math_avg=math_sum/(float)N;
        //printf("Avg %lf.\n",math_avg);

        math_sum=0.0f;
        for(j=0;j<N;j++){
            math_sum+=powf(((float)X[j]-math_avg),2.0f);
        }
        V=math_sum/(float)N;
        //printf("Var %lf.\n",V);

        /*Output*/
        for(j=0;j<N;j++){
            if(V==0){
                S[j]=50.0f;
            }else{
                S[j]=50.0f+10.0f*((float)X[j]-math_avg)/powf(V,0.5f);
            }
            //printf("S[%d] %lf.\n",j,S[j]);
            fprintf(pfout," %lf",S[j]);
        }
        fprintf(pfout,"\n");
    }

    printf("Test end.\n");

    return 0;
}
