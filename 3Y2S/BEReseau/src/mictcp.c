#include <mictcp.h>
#include <api/mictcp_core.h>

#include <unistd.h>


/*

MAO Yuxiao
DEBAILLEUX Margaux
3MIC E

Nous avons changé notre algorithme pour la reprise de perte partielle : au lieu d'utiliser un tableau, on utilise une variable qui indique depuis combien de temps il n'y a pas eu de pertes
Nous avons implémenté la reprise de pertes partielle dynamique
Nous avons implémenté la fermeture de connexion
  
*/

int setting = 1;
mic_tcp_sock sock_local;
mic_tcp_sock_addr sock_addr_distant;
unsigned int prochain_nseq = 0;


int seuil_perte;   //1 perte sur n est autorisé
int decalage_perte ; //la distance entre derniere perte et l'info actuelle

// variables pour calculer rtt
 int t_debut;
 int t_fin;



int mic_tcp_socket(start_mode sm) 
// Permet de créer un socket entre l’application et MIC-TCP
// Retourne le descripteur du socket ou bien -1 en cas d'erreur
{
    printf("[MIC-TCP] Appel de la fonction: ");  printf(__FUNCTION__); printf("\n");
    initialize_components(sm); // Appel obligatoire
    if (sm == CLIENT){
      seuil_perte = 10;
    }else{
      seuil_perte = 5;
    }
    sock_local.fd = 0;
    sock_local.state = CLOSED;
    set_loss_rate(100);
    return sock_local.fd;
}

int mic_tcp_bind(int socket, mic_tcp_sock_addr addr)
// Permet d’attribuer une adresse à un socket. Retourne 0 si succès, et -1 en cas d’échec
{
    printf("[MIC-TCP] Appel de la fonction: ");  printf(__FUNCTION__); printf("\n");
    memcpy((char *)&(sock_local.addr),(char *) &addr, sizeof(sock_local.addr));
    return 0;
}

int mic_tcp_accept(int socket, mic_tcp_sock_addr* addr)
// Met l’application en état d'acceptation d’une requête de connexion entrante
// Retourne 0 si succès, -1 si erreur
{
    printf("[MIC-TCP] Appel de la fonction: ");  printf(__FUNCTION__); printf("\n");


    int nb_essais = 0;
    int erreur = 0;


    sock_addr_distant.port = addr->port;
    sock_addr_distant.ip_addr = addr->ip_addr;
    sock_addr_distant.ip_addr_size = addr->ip_addr_size;


    while (sock_local.state != SYN_RECEIVED){}

    //envoi syn-ack
    mic_tcp_pdu syn_ack;
    syn_ack.hd.source_port = sock_local.addr.port;
    syn_ack.hd.dest_port = sock_addr_distant.port;
    syn_ack.hd.syn = 1; 
    syn_ack.hd.ack = 1;
    syn_ack.hd.seq_num = seuil_perte;
    syn_ack.payload.data=malloc(sizeof(char));
    syn_ack.payload.size = 0;
	
    while (sock_local.state != ESTABLISHED && nb_essais < 100){
      t_debut = get_now_time_usec();
      IP_send(syn_ack,sock_addr_distant) ;
      nb_essais++;
      usleep(1000);
    }

    if (nb_essais == 100){
      erreur = -1;
    }

    return erreur;
}

int mic_tcp_connect(int socket, mic_tcp_sock_addr addr)
// Permet de réclamer l’établissement d’une connexion
// Retourne 0 si la connexion est établie, et -1 en cas d’échec
{   
    
    printf("[MIC-TCP] Appel de la fonction: ");  printf(__FUNCTION__); printf("\n");
    sock_addr_distant.port = addr.port;
    sock_addr_distant.ip_addr = addr.ip_addr;
    sock_addr_distant.ip_addr_size = addr.ip_addr_size;


    int nb_essais = 0;
    int echec = 0;

    mic_tcp_pdu pdu;
    pdu.hd.source_port = sock_local.addr.port;
    pdu.hd.dest_port = sock_addr_distant.port;
    pdu.hd.syn = 1; 
    pdu.hd.seq_num = seuil_perte;    // on envoie l'info sur le seuil de pertes autorisé dans le champ seq_num
    pdu.payload.data=malloc(sizeof(char));
    pdu.payload.size = 0;

    mic_tcp_payload  payload;
    payload.data = malloc (15);
    payload.size = 15;

    //envoi syn
    int ack_recu = 0;
    int taille_recu = -1;
    mic_tcp_header header_recu;
    while (!ack_recu && nb_essais < 100){
      t_debut = get_now_time_usec();
      IP_send(pdu,sock_addr_distant);
      nb_essais++;
      sock_local.state = SYN_SENT;
      taille_recu = IP_recv (&payload, &sock_addr_distant, 1000);
      if (taille_recu!=-1){
	header_recu=get_header(payload.data);
	if (header_recu.ack == 1 && header_recu.syn==1 ){
	  ack_recu = 1;
	  t_fin = get_now_time_usec();
	  set_RTT(t_fin - t_debut);
	  seuil_perte = header_recu.seq_num;
	  decalage_perte = seuil_perte +1;
	  printf ("[MIC-TCP] Seuil perte : %d\n", seuil_perte);
	  printf("[MIC-TCP] RTT : %d\n", t_fin - t_debut);
	}
      }
    }

    if (nb_essais == 100){
      echec = -1;
    }else{
      //envoi ack
      pdu.hd.syn = 0; 
      pdu.hd.ack = 1; 
      int taille_envoi = -1;
      taille_envoi = IP_send(pdu,sock_addr_distant) ;

      free(pdu.payload.data);
      sock_local.state = ESTABLISHED;
    }
    
    return echec;
}

int mic_tcp_send (int mic_sock, char* mesg, int mesg_size)
// Permet de réclamer l’envoi d’une donnée applicative
// Retourne la taille des données envoyées, et -1 en cas d'erreur
{


    mic_tcp_pdu pdu;
    int taille_envoi;
    int taille_recu = -1;
    int ack_recu = 0;
    mic_tcp_payload  ppayload;
    mic_tcp_header header_recu;

    int i;
    int somme = 0;

    printf("[MIC-TCP] Appel de la fonction: "); printf(__FUNCTION__); printf("\n");

    ppayload.data = malloc (15);
    ppayload.size = 15;
    pdu.hd.source_port = sock_local.addr.port;
    pdu.hd.dest_port = sock_addr_distant.port;
    pdu.hd.seq_num = prochain_nseq;
    pdu.hd.fin = 0;
    pdu.payload.size = mesg_size;
    pdu.payload.data = mesg;
    prochain_nseq = (prochain_nseq+1)%seuil_perte;        // ici on choisit de mettre le numéro du prochain message attendu
    

    taille_envoi = IP_send(pdu,sock_addr_distant) ;    
    taille_recu = IP_recv (&ppayload, &sock_addr_distant, 1000);
    if (taille_recu!=-1){
      header_recu=get_header(ppayload.data);
      if (header_recu.ack == 1 && header_recu.ack_num == prochain_nseq){
	ack_recu = 1;
      }
    }
    
    if (ack_recu){
      decalage_perte ++;
    }else{
      if (decalage_perte < seuil_perte){
	while (!ack_recu){
	  printf("[MIC-TCP] Renvoi du PDU\n");
	  taille_envoi = IP_send(pdu,sock_addr_distant) ;
	  taille_recu = IP_recv (&ppayload, &sock_addr_distant, 1000);
	  if (taille_recu!=-1){
	    header_recu=get_header(ppayload.data);
	    if (header_recu.ack == 1 && header_recu.ack_num == prochain_nseq){
	      ack_recu = 1;
	    }
	  }
	}
	decalage_perte ++;
      }else{
	decalage_perte = 1;
      }
    }

    return taille_envoi; 
}


int mic_tcp_recv (int socket, char* mesg, int max_mesg_size)
// Permet à l’application réceptrice de réclamer la récupération d’une donnée 
// stockée dans les buffers de réception du socket
// Retourne le nombre d’octets lu ou bien -1 en cas d’erreur
// NB : cette fonction fait appel à la fonction app_buffer_get() 

{
    mic_tcp_payload payload_recu;
    int taille;
    printf("[MIC-TCP] Appel de la fonction: "); printf(__FUNCTION__); printf("\n");
    payload_recu.size = max_mesg_size;
    payload_recu.data = mesg;
    taille = app_buffer_get(payload_recu);
    return taille;
}

int mic_tcp_close (int socket)
// Permet de réclamer la destruction d’un socket. 
// Engendre la fermeture de la connexion suivant le modèle de TCP. 
// Retourne 0 si tout se passe bien et -1 en cas d'erreur

{
    printf("[MIC-TCP] Appel de la fonction: "); printf(__FUNCTION__); printf("\n"); 

    mic_tcp_pdu pdu;
    pdu.hd.source_port = sock_local.addr.port;
    pdu.hd.dest_port = sock_addr_distant.port;
    pdu.payload.data=malloc(sizeof(char));
    pdu.payload.size = 0;

    mic_tcp_payload  payload;
    payload.data = malloc (15);
    payload.size = 15;

    if (sock_local.state == ESTABLISHED){
      printf("[MIC-TCP] Fin de connexion client\n");
      //cote client
      pdu.hd.fin = 1;
      sock_local.state = FIN_WAIT;
      //envoi fin
      int ack_recu = 0;
      int taille_recu = -1;
      mic_tcp_header header_recu;
      while (!ack_recu){
	IP_send(pdu,sock_addr_distant);
	taille_recu = IP_recv (&payload, &sock_addr_distant, 1000);
	if (taille_recu!=-1){
	  header_recu=get_header(payload.data);
	  if (header_recu.ack == 1 && header_recu.fin==1 ){
	    ack_recu = 1;
	    sock_local.state = TIME_WAIT;
	  }
	}
      }

      //envoi ack
      pdu.hd.fin = 0; 
      pdu.hd.ack = 1; 
      int taille_envoi = -1;
      taille_envoi = IP_send(pdu,sock_addr_distant) ;
      free(pdu.payload.data);

      usleep(1000); 
      sock_local.state = CLOSED;

    }else{
      //cote serveur
      //sock_local.state == CLOSE_WAIT
      printf("[MIC-TCP] Fin de connexion serveur\n");
      pdu.hd.fin = 1;
      pdu.hd.ack = 1;
      sock_local.state = LAST_ACK;
      int nb_essais = 0;
      while (sock_local.state != CLOSED && nb_essais < 100){
	IP_send(pdu,sock_addr_distant) ;
	nb_essais++;
	usleep(1000);
      }
    }



    return 0;
}

void process_received_PDU(mic_tcp_pdu pdu)
// Gère le traitement d’un PDU MIC-TCP reçu (mise à jour des numéros de séquence
// et d'acquittement, etc.) puis insère les données utiles du PDU dans le buffer 
// de réception du socket. Cette fonction utilise la fonction app_buffer_add().   
{

  printf("[MIC-TCP] Appel de la fonction: "); printf(__FUNCTION__); printf("\n");

  if (sock_local.state == CLOSED){
    
    mic_tcp_header header_recu;
    header_recu=pdu.hd;
    if (header_recu.syn == 1){
      sock_local.state = SYN_RECEIVED;
      if (header_recu.seq_num > seuil_perte){
	seuil_perte = header_recu.seq_num;
      }
      printf ("[MIC-TCP] Seuil perte : %d\n", seuil_perte);
    }
 
  }else{

    if (sock_local.state == SYN_RECEIVED){
      mic_tcp_header header_recu;
      mic_tcp_pdu pdu_ack;
      header_recu=pdu.hd;
      if (header_recu.ack == 1 ||  pdu.payload.size != 0){   // si le ack a été recu ou si le ack a été perdu et le client a déjà envoyé des données (donc connexion établie)
	t_fin = get_now_time_usec();
	set_RTT(t_fin - t_debut);
	printf("[MIC-TCP] RTT : %d\n", t_fin - t_debut);
	if (pdu.payload.size != 0){
	  app_buffer_set(pdu.payload);
	  prochain_nseq = (prochain_nseq+1)%seuil_perte;
	  pdu_ack.hd.source_port = sock_local.addr.port;
	  pdu_ack.hd.dest_port = sock_addr_distant.port;
	  pdu_ack.hd.ack_num = prochain_nseq;
	  pdu_ack.hd.ack = 1; 
	  pdu_ack.payload.data=malloc(sizeof(char));
	  pdu_ack.payload.size = 0;
	  IP_send(pdu_ack,sock_addr_distant);
	  free(pdu_ack.payload.data);
	}
	sock_local.state = ESTABLISHED;
      }

    }else{
      if(sock_local.state == LAST_ACK){
	printf("[MIC-TCP] LAST_ACK\n");
	if (pdu.hd.ack ==1){
	  sock_local.state = CLOSED;
	  printf("[MIC-TCP] CLOSED \n");
	}
      }else{

	if (pdu.hd.fin == 0){
	  mic_tcp_pdu pdu_ack;

	  if (pdu.hd.seq_num == prochain_nseq){
	    app_buffer_set(pdu.payload);
	    prochain_nseq = (prochain_nseq+1)%seuil_perte;
	  }else{
	    if (pdu.hd.seq_num == (prochain_nseq+1)%seuil_perte ){
	      app_buffer_set(pdu.payload);
	      prochain_nseq = (prochain_nseq+2)%seuil_perte;
	    }
	  }

	  pdu_ack.hd.source_port = sock_local.addr.port;
	  pdu_ack.hd.dest_port = sock_addr_distant.port;
	  pdu_ack.hd.ack_num = prochain_nseq;
	  pdu_ack.hd.ack = 1; 
	  pdu_ack.payload.data=malloc(sizeof(char));
	  pdu_ack.payload.size = 0;
	  IP_send(pdu_ack,sock_addr_distant);
	  free(pdu_ack.payload.data);

	}else{
	  sock_local.state = CLOSE_WAIT;
	  printf("[MIC-TCP] CLOSE_WAIT\n");
	}

      }
    }
  }
}
