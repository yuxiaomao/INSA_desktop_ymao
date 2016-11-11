#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <netinet/in.h>
#include <netdb.h>

/*Ce qui marche: UDP/TCP, -n, -l
  Bug connu: aucun..
  Rmq: 1. On est allé vérifier le fonctionnement de vrai tsock
          le TCP puit ferme directement après avoir reçu les messages de sources
          donc on a fait la meme chose
       2. On a déjà géré les variables de -n et -l dans v1, donc ça simplifie notre travail

*/

void construire_message(char * message, char motif, int lg)
{
  int i;
  for(i=0;i<lg;i++){
     message[i] = motif;
  }
  message[lg] = '\0';
 }


void afficher_message (char * message, int lg)
{
  int i;
  printf("message construit : ");
  for (i=0;i<lg;i++)
    {
      printf("%c", message[i]);
    }
  printf("\n");
}

void afficher_terminal (int source, int numero, int lg, char* message)
{
  if (source)
  {
    printf("SOURCE : Envoi ");
  }
  else
    {
      printf("PUITS : Reception ");
    }
  printf("n°%d  (%d)  [",numero,lg);
  if (numero<10)
    {
      printf("----%d",numero);
    }
  else 
    {
      if (numero<100)
	{
	  printf("---%d", numero);
	}
      else 
	{
	  if (numero<1000)
	    {
	      printf("--%d",numero);
	    }
	  else 
	    {
	      if (numero<10000)
		{
		  printf("-%d",numero);
		}
	      else
		{
		  printf("%d",numero);
		}
	    }
	}
    }
  printf("%s]\n",message);
  
}
  


int main (int argc, char **argv)
{
	int c;
	extern char *optarg;
	extern int optind;
	int nb_message = -1; /* Nb de messages ˆ envoyer ou ˆ recevoir, par défaut: 10 en émission, infini en réception */
	int source = -1 ; /* 0=puits, 1=source */
	int port;
	char * host;
	int socket_local;
	struct sockaddr_in adresse_recepteur;
	struct hostent * hp;
	int numero_message = 1;
	char * message;
	int lg_mess = -1;
	int lg_adr_in;
	int lg_lue = 1;
	int mode_udp = 0;
	struct sockaddr_in adresse_client;
	int lg_addresse_client = sizeof(adresse_client);
	int sock_dedie;
	
	while ((c = getopt(argc, argv, "upsn:l:")) != -1) {
		switch (c) {		
		case 'p':
				if (source == 1) {
					printf("usage: cmd [-p|-s][-n ##]\n");
					exit(1);}
				source = 0;
				break;
		case 's':
				if (source == 0) {
					printf("usage: cmd [-p|-s][-n ##]\n");
					exit(1);}
				source = 1;
				break;
		case 'n':
				nb_message = atoi(optarg);
				break;
				
	        case 'u':
		                mode_udp = 1;
				break;

	        case 'l':
		                lg_mess = atoi(optarg);
				break;

		default:
				printf("usage: cmd [-p|-s][-n ##][-l ##]\n");
				break;
		}
	}
	if (source == -1) {
		printf("usage: cmd [-p|-s][-n ##]\n");
		exit(1);
		};
	if (source == 1) 
	  printf("on est dans le source\n");
	else 
	  printf("on est dans le puits\n");
      
	if (nb_message != -1) {
	  if (source == 1)
	    printf("nb de tampons ˆ envoyer: %d\n", nb_message);
	  else 
	    printf("nb de tampons ˆ recevoir: %d\n", nb_message);
	}
	else {
	  if (source == 1) {
	    nb_message = 10;
	    printf("nb de tampons ˆ envoyer= 10 par défaut\n");
       }
	  else 
	    printf("nb de tampons ˆ envoyer= infini\n");
	}

	if (lg_mess != -1) {
	  if (source == 1)
	    printf("lg des messages ˆ envoyer: %d\n", lg_mess);
	  else 
	    printf("lg des messages ˆ recevoir: %d\n", lg_mess);
	}
	else {
	  if (source == 1) {
	    lg_mess = 30;
	    printf("lg des messages ˆ envoyer= 30 par défaut\n");
       }
	  else 
	    {
	      lg_mess = 30;
	      printf("lg des messages ˆ envoyer= 30 par défaut\n");
	    }
	}


	if (mode_udp == 1)
	  printf ("on est en mode udp\n");
	else
	  printf ("on est en mode tcp\n");

	port = atoi(argv[argc-1]);



	if (mode_udp)
	    socket_local=socket(AF_INET,SOCK_DGRAM,0);
	else
	  socket_local=socket(AF_INET,SOCK_STREAM,0);
	    if (socket_local==-1)
	      {
		printf("erreur création socket\n");
		exit(1);
	      }



	if (source)
	  {
	    host = argv[argc-2];
	    memset (&adresse_recepteur,0,sizeof(adresse_recepteur));
	    adresse_recepteur.sin_family = AF_INET;
	    adresse_recepteur.sin_port = port;
	    if ( (hp=gethostbyname(host)) == NULL)
	      {
		printf("erreur gethostbyname\n");
		exit(1);
	      }
	    memcpy((&adresse_recepteur.sin_addr.s_addr), hp->h_addr, hp->h_length);
	  }

	else

	  {
	    memset (&adresse_recepteur,0,sizeof(adresse_recepteur));
	    adresse_recepteur.sin_family = AF_INET;
	    adresse_recepteur.sin_port = port;
	    adresse_recepteur.sin_addr.s_addr = INADDR_ANY;
	    if ( bind(socket_local,(struct sockaddr *) &adresse_recepteur, sizeof(adresse_recepteur)) == -1)
	      {
		printf("échec du bind\n");
		exit(1);
	      }
	  }



	if (mode_udp == 0)
	  {
	    if(source)
	      {
		if (connect(socket_local, (struct sockaddr *) &adresse_recepteur, sizeof(adresse_recepteur)) == -1)
		  {
		    printf("échec de la connexion\n");
		    exit(1);
		  }


		printf ("SOURCE : lg_mesg_emis=%d, port=%d, nb_envois=%d, TP=tcp, dest=%s\n", lg_mess, port, nb_message, host);
		message = malloc ((lg_mess+1)*sizeof(char));

		for (numero_message=1; numero_message<=nb_message; numero_message++)
		{
		  construire_message(message, (numero_message%26)+96, lg_mess);
		  afficher_terminal(source, numero_message, lg_mess, message);
		  if (write(socket_local, message, lg_mess) == -1)
		    { 
		      printf("echec write n°%d",numero_message);
		    }
		}

	      }
	    else
	      {
		if (listen(socket_local, 2) == -1)
		  {
		    printf("échec de listen\n");
		    exit(1);
		    } 
		if (( sock_dedie = accept (socket_local,(struct sockaddr *) &adresse_client, &lg_addresse_client)) == -1)
		  {
		    perror("échec de accept\n");
		    exit(1);
		  }

	      printf("PUITS : lg_mesg_lus=%d, port=%d, nb_receptions=infini, TP=udp\n", lg_mess, port);

	      while(((nb_message==-1) || (numero_message<=nb_message)) && (lg_lue != 0 ))
		{	
		  message = malloc ((lg_mess+1)*sizeof(char));
		  if (( lg_lue = read(sock_dedie, message, lg_mess)) < 0)
		  {
		    printf("échec du read\n");
		    exit(1);
		  }
		  if (lg_lue != 0)
		    {
		      afficher_terminal(source, numero_message, lg_lue, message);
		      numero_message++;
		    }

		}
		
	      }
	    
	  }


	if (mode_udp)
	{
	  if (source)
	    {
	      message = malloc ((lg_mess+1)*sizeof(char));
	      printf ("SOURCE : lg_mesg_emis=%d, port=%d, nb_envois=%d, TP=udp, dest=%s\n", lg_mess, port, nb_message, host);
	      for (numero_message=1; numero_message<=nb_message; numero_message++)
		{
		  construire_message(message, (numero_message%26)+96, lg_mess);
		  afficher_terminal(source, numero_message, lg_mess, message);
		  if (sendto(socket_local, message, lg_mess,0,(struct sockaddr *)&adresse_recepteur, sizeof(adresse_recepteur)) == -1)
		    { 
		      printf("echec sendto n°%d",numero_message);
		    }
		}

	    }
	  else
	    {
	      message = malloc ((lg_mess+1)*sizeof(char));
	      printf("PUITS : lg_mesg_lus=%d, port=%d, nb_receptions=infini, TP=udp\n", lg_mess, port);
	      lg_adr_in = sizeof(adresse_recepteur);
	      while((nb_message==-1) || (numero_message<=nb_message))
		{	
		  lg_lue = recvfrom(socket_local, message, lg_mess, 0,(struct sockaddr *)&adresse_recepteur, &lg_adr_in);
		  afficher_terminal(source, numero_message, lg_lue, message);
		  numero_message++;
		}
	    
	    }
	}

	return 0;
	
 }



