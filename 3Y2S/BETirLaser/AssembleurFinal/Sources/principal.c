#include "gassp72.h"
#include  <stdio.h>
#include "Affichage_Valise.h"
//pour rand
#include <stdlib.h>
#include <time.h>



#define M2TIR 0x00020000
//etant 00002000 qui marche, reste à tester
//signal 4,12 + cos/sin 1,15 = 5,27
//carre 10,54 on prend 32 forte = 10,22
//valeur moy avec ampli 100mv donne environ 1
//code en 10,22 donne 0x00200000
//on prend seuil 8b plus faible donc 0x00020000

//dft
int Calcul_DFT(short* signal, int k);
short int DMA[64];
int Tableau_k[6] = { 17 , 18 ,19 ,20 ,23 ,24};
int Compteur[6] = {0,0,0,0,0,0};

//son
void timer_callback(void);
extern int PeriodeSonMicroSec;
extern int LongueurSon;
extern short Son;
//son
typedef struct {
int position;		// index courant dans le tableau d'echantillons
int taille;		// nombre d'echantillons de l'enregistrement
short int * son;	// adresse de base du tableau d'echantillons en ROM
int resolution;		// pleine echelle du modulateur PWM
int Tech_en_Tck;	// periode d'ech. audio en periodes d'horloge CPU
} type_etat;

type_etat etat;

//dft
void sys_callback(){
int i;
// Démarrage DMA pour 64 points
GPIO_Set(GPIOB, 1);
Start_DMA1(64);
Wait_On_End_Of_DMA1();
Stop_DMA1;
// Traitement pour les 6 signaux; 
for (i=0 ; i<6 ; i++ ) {
	if (Calcul_DFT(DMA, Tableau_k[i])>M2TIR) {
		Compteur[i]++;
	}
	else { 
		Compteur[i]=0;
	}
}
GPIO_Clear(GPIOB, 1);
}


//compteur score
int Score[6] = {0,0,0,0,0,0};
int afficheurJoueur[6] = {0,0,0,0,0,0}; //Determine quel afficheur utilisé par le joueur
int nb_joueurs=1;
int num_capteur=1;

int main(void)
{
////////////////dft
int compt;
int i;
// activation de la PLL qui multiplie la fréquence du quartz par 9
CLOCK_Configure();
// PA2 (ADC voie 2) = entrée analog
GPIO_Configure(GPIOA, 2, INPUT, ANALOG);
// PB1 = sortie pour profilage à l'oscillo
GPIO_Configure(GPIOB, 1, OUTPUT, OUTPUT_PPULL);
// PB14 = sortie pour LED
GPIO_Configure(GPIOC, 12, OUTPUT, OUTPUT_PPULL);

// activation ADC, sampling time 1us
Init_TimingADC_ActiveADC_ff( ADC1, 72 );
Single_Channel_ADC( ADC1, 2 );
// Déclenchement ADC par timer2, periode (72MHz/320kHz)ticks
Init_Conversion_On_Trig_Timer_ff( ADC1, TIM2_CC2, 225 );
// Config DMA pour utilisation du buffer dma_buf (a créér)
Init_ADC1_DMA1( 0, (vu16*)DMA );

// Config Timer, période exprimée en périodes horloge CPU (72 MHz)
Systick_Period_ff( 72000000/200 );
// enregistrement de la fonction de traitement de l'interruption timer
// ici le 3 est la priorité, sys_callback est l'adresse de cette fonction, a créér en C
Systick_Prio_IT( 3, sys_callback );
SysTick_On;
SysTick_Enable_IT;

GPIO_Set(GPIOC, 12);


///////////son

// config port PB1 pour être utilisé en sortie
GPIO_Configure(GPIOB, 1, OUTPUT, OUTPUT_PPULL);

// initialisation du timer 4
// Periode_en_Tck doit fournir la durée entre interruptions,
// exprimée en périodes Tck de l'horloge principale du STM32 (72 MHz)  
	// La fréquence de signal est donc de f (72MHz/2*f)
Timer_1234_Init_ff( TIM4, 72*PeriodeSonMicroSec );// Nombre de Periode du STM32 
// enregistrement de la fonction de traitement de l'interruption timer
// ici le 2 est la priorité, timer_callback est l'adresse de cette fonction, a créér en asm,
// cette fonction doit être conforme à l'AAPCS
	// Appelera Temporisation à chaque periode de TIM4
Active_IT_Debordement_Timer( TIM4, 2, timer_callback );//timer_callback
// lancement du timer
Run_Timer( TIM4 );

	
// config port PB0 pour être utilisé par TIM3-CH3
GPIO_Configure(GPIOB, 0, OUTPUT, ALT_PPULL);
// config TIM3-CH3 en mode PWM
etat.resolution = PWM_Init_ff( TIM3, 3, 72*PeriodeSonMicroSec/4 );
etat.taille = LongueurSon*2 ;
etat.position = etat.taille +1;
etat.son = &Son;



////////////////afficheur
Init_Affichage();
Choix_Capteur(num_capteur);
Prepare_Set_LED(num_capteur);
Mise_A_Jour_Afficheurs_LED();

while	(1){
	for (i=0 ; i<6 ; i++ ) {
		if (Compteur[i] > 3){
			if (afficheurJoueur[i]==0) {// a 1er tir on affiche num joueur
				afficheurJoueur[i]=nb_joueurs;
				nb_joueurs++;
				Prepare_Afficheur(afficheurJoueur[i], i+1);
				Prepare_Set_Point_Unite(afficheurJoueur[i]);
			} else{
				etat.position=0;
				Score[i] +=1;
				Prepare_Afficheur(afficheurJoueur[i], Score[i]);
				if (Score[i]==1){// a 2e tir on affiche score
					Prepare_Clear_Point_Unite(afficheurJoueur[i]);
				}
			//si on ne detecte plus ca revient 0 automatiquement
			}	

			for(compt = 0; compt < 500000; compt ++){
			}//pour que LED affichi longtemps

			// changement du capteur automatique
			num_capteur = (num_capteur + rand())%(4) + 1;
			Choix_Capteur(num_capteur);
			Prepare_Set_LED(num_capteur);
			Mise_A_Jour_Afficheurs_LED();
		}	
	}
}
}
