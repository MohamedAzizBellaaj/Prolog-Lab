lire(X) :- write('donner un entier '), nl, read(X), nl, write('votre entier est '),write(X),nl,
nl.
calcul_carre(X,Y):- Y is X * X.
ecrire_resultat(X,Y) :- write('le carré de '), write(X), write(' est '),write(Y), nl,nl.
aller :- lire(X), calcul_carre(X,Y), ecrire_resultat(X,Y).