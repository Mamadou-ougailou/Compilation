#ifndef __TYPES_H__
#define __TYPES_H__

typedef struct{
    char *nom;
    int taille;
    int valeur;
    // int scope //pour la profondeur.
}symbole;

symbole *inserer(const char* nom);

void effacer_ts();

#endif