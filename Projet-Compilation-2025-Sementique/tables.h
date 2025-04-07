#include <stdlib.h>
#include <string.h>
#include "symboles.h"

#define TAILLE 251


typedef struct _liste{
    symbole *s;
    struct _liste *suivant;
}liste;

liste *ts[TAILLE];

// hachage par division: hash(s) renvoit un nombre entre 0 et TAILLE-1
unsigned int hash(const char* s) {
    unsigned int res = 0;
    int i;
    for (i = 0; s[i] != 0; i++) {
      res = (res * 256 + s[i]) % TAILLE;
    }
    return res;
  }
  
  symbole *find_in_list(liste *l, const char *nom) {
    while (l != NULL) {
      if (strcmp(l->s->nom, nom) == 0)
        return l->s;
      l = l->suivant;
    }
    return NULL;
  }
  
  symbole *inserer(const char *nom) {
    int i = hash(nom);
    symbole *s = find_in_list(ts[i], nom);
    if (s == NULL) {
      liste* l = malloc(sizeof(liste));
      s = malloc(sizeof(symbole));
      s->nom = strdup(nom);
      s->valeur = 0;
      l->s = s;
      l->suivant = ts[i];
      ts[i] = l;
    }
    return s;
  }
  
  void effacer_liste(liste *l) {
    while (l != NULL) {
      liste *l2 = l->suivant;
      free(l->s->nom);
      free(l->s);
      free(l);
      l = l2;
    }
  }
  
  void effacer_ts() {
    int i;
    for (i = 0; i < TAILLE; i++) {
      effacer_liste(ts[i]);
    }
  }
  