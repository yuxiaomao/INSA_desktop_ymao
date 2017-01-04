#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>

typedef void *(*fct_ptr_t)(void *);

static pthread_mutex_t mutex_ressources = PTHREAD_MUTEX_INITIALIZER;
static unsigned int nb_ressources = 4;
static pthread_cond_t cond_ressources_libere = PTHREAD_COND_INITIALIZER;


void f_thread(unsigned int *ressources_necessaires)
{
    pthread_t current_thread = pthread_self();

    /* Attente des ressources */
    pthread_mutex_lock(&mutex_ressources);
    while (nb_ressources < *ressources_necessaires) {
        printf("*** Thread[%lu] ***\nJe veux %u ressources",
           current_thread,
           *ressources_necessaires);
        printf(" mais il y a %u ressources\n\n", nb_ressources);
        /*pthread_mutex_unlock(&mutex_ressources);*/
        /*pthread_mutex_lock(&mutex_ressources);*/
        pthread_cond_wait(&cond_ressources_libere, &mutex_ressources);
    }

    /* Prise des ressources */
    printf("*** Thread[%lu] ***\nJe prends %u ressources",
           current_thread,
           *ressources_necessaires);
    nb_ressources -= *ressources_necessaires;
    printf(" donc il reste %u ressources\n\n", nb_ressources);
    pthread_mutex_unlock(&mutex_ressources);

    sleep(3);

    /* Libération */
    pthread_mutex_lock(&mutex_ressources);
    printf("*** Thread[%lu] ***\nJe libère %u ressources",
           current_thread,
           *ressources_necessaires);
    nb_ressources += *ressources_necessaires;
    printf(" donc il reste %u ressources\n\n", nb_ressources);
    pthread_cond_broadcast(&cond_ressources_libere);


    pthread_mutex_unlock(&mutex_ressources);
}

int main(int argc, char** argcv)
{
    pthread_t thread1, thread2, thread3;
    unsigned int r1 = 3, r2 = 2, r3 = 1;
    pthread_create(&thread1, NULL, (fct_ptr_t)f_thread, &r1);
    pthread_create(&thread2, NULL, (fct_ptr_t)f_thread, &r2);
    pthread_create(&thread3, NULL, (fct_ptr_t)f_thread, &r3);

    pthread_exit(NULL);

    return EXIT_SUCCESS;
}
