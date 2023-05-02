% Travail fait par Mohamed Aziz Bellaaj, Louay Badri et Talel Ayed

%* Exercice 1

%! 1. Déclarez les relations rocher(X,Y) et arbre(X,Y) qui retourneront vrai si la case (X,Y) est encombrée par un rocher (respectivement par un arbre). 
:- dynamic case/2.
:- dynamic arbre/2.
:- dynamic rocher/2.

%! 2. Déclarez la relation vache(X, Y, Race, Etat) qui retourne vrai lorsqu’une vache de race Race est sur la case (X,Y). L'Etat de la vache est vivante ou zombie. Les races possibles sont brune, simmental, alpine_herens.
race(brune).
race(simmental).
race(alpine_herens).

etat(vivante).
etat(zombie).

%! Declare dynamic relation vache
:- dynamic vache/4.
vache(X, Y, Race, Etat):- 
    case(X, Y),
    race(Race), 
    etat(Etat).
vache(X, Y):- vache(X, Y, _, _).

%! 3. Déclarez  la  relation  dimitri(X,  Y)  qui  donne  la  position  de Dimitri.
:- dynamic dimitri/2.

%! 4. Définissez les faits largeur(X) et hauteur(Y) qui donnent la largeur et la longueur du plateau de jeu (choisissez des valeurs).  
largeur(8).
hauteur(8).

%! 5. Définissez les faits nombre_rochers(N), nombre_arbres(N), nombre_vaches(Race, N) qui donnent le nombre de rochers, d’arbres et de vaches de chaque race sur le plateau de jeu (choisissez des valeurs).
nombre_rochers(3).
nombre_arbres(2).
nombre_vaches(brune, 3).
nombre_vaches(simmental, 4).
nombre_vaches(alpine_herens, 4).

%* Exercice 2

%! 1. Écrivez  la  règle  occupe(X,Y)  qui  est  vrai  si  et  seulement si  la  case  (X,Y)  est  occupée  par un arbre, un rocher, une vache ou Dimitri.
occupe(X, Y) :- arbre(X, Y); rocher(X, Y); vache(X, Y); dimitri(X, Y).

%! 2. Écrivez la règle libre(X,Y) qui retourne dans X et Y les coordonnées d’une case libre, c’est-à-dire n’ayant ni rocher, ni arbre, ni vache, ni Dimitri.  
%? la logique est de chercher une place random qui n est pas occupe

libre(X,Y) :-
    largeur(L),
    hauteur(H),
    repeat,
    X is random(L),
    Y is random(H),
    (not(occupe(X, Y))),!.

%! 3. Écrivez les règles placer_rochers(N), placer_arbres(N), placer_vaches(Race, N) qui placent N rochers, arbres ou vaches sur le plateau de jeu.  
  
%? Condition d'arret d'insertion d'arbre 

placer_arbres(0).

%? L'insertion de N arbres 

placer_arbres(N) :-
    N>0,
    libre(X, Y),
    assert(arbre(X, Y)),
    N1 is N-1 ,
    placer_arbres(N1).

%? Condition d'arret d'insertion d'rocher 

placer_rochers(0).

%? L'insertion de N rocher

placer_rochers(N) :-
    N>0,
    libre(X, Y),
    assert(rocher(X, Y)),
    N1 is N-1 ,
    placer_rochers(N1).

%? Condition d'arret d'insertion de vache
placer_vaches(_, 0).

%? L'insertion de N vaches

placer_vaches(R, N) :-
    N>0,
    libre(X, Y),
    assert(vache(X, Y, R, vivante)),
    N1 is N-1 ,
    placer_vaches(R, N1).

%? L'insertion de Dimitri

placer_dimitri :-
    libre(X, Y),
    assert(dimitri(X, Y)).


%! 4. Écrivez  la  règle  vaches(L)  qui  retourne  dans  L  la  liste  des  positions  occupées  par  des vaches. Indications : Pensez à utiliser bagof ou findall. 

%? Exemple de resultat de L [[1, 2], [4, 5], [3, 4]]

vaches(L) :-
    findall([X, Y], vache(X, Y, _, _), L).


%! 5.  Écrivez la règle creer_zombie qui sélectionne aléatoirement une vache et la transforme en zombie. 
%? nth0 prend 3 parametres nth0(X, L, R) et retourne X est l'indice ,L est la liste , R est la result qui est l'element de la Liste L d'indice X

creer_zombie :-
    vaches(L),
    length(L, Len), X is random(Len),
    nth0(X, L, Val), nth0(0, Val, X1),
    nth0(1, Val, Y1),
    vache(X1, Y1, Race, vivante),
    assert(vache(X1, Y1, Race, zombie)),
    retract(vache(X1, Y1, Race, vivante)).

%* Exercice 3

%! 1. Écrivez  la  règle  question(R)  qui  demande  au  joueur  dans  quelle  direction  déplacer Dimitri, et retourne le résultat sous forme d'atome (reste, nord, sud, est, ouest) dans R. reste indique de ne pas bouger. 

  question(R):-
    write('Move Dimitry:'),
    nl,
    read(R).

%! 2. Écrivez  la  règle  zombification  qui  transforme  en  zombies  les  vaches  autour  (nord,  sud, est, ouest) de toute position (X,Y) occupée par une vache zombie. En effet, celle-ci mord ses voisines... 

%? Here we zombify the cow being in the (X - 1, Y) position.

  zombification(X, Y):-
    X1 is X - 1,
    vache(X1, Y, Race, vivante),
    assert(vache(X1, Y, Race, zombie)),
    retract(vache(X1, Y, _, vivante)).

%? Here we zombify the cow being in the (X + 1, Y) position.

  zombification(X, Y):-
    X1 is X + 1,
    vache(X1, Y, Race, vivante),
    assert(vache(X1, Y, Race, zombie)),
    retract(vache(X1, Y, _, vivante)).

%? Here we zombify the cow being in the (X, Y - 1) position.

  zombification(X, Y):-
    Y1 is Y - 1,
    vache(X, Y1, Race, vivante),
    assert(vache(X, Y1, Race, zombie)),
    retract(vache(X, Y1, _,  vivante)).

%? Here we zombify the cow being in the (X, Y + 1) position.

  zombification(X, Y):-
    Y1 is Y + 1,
    vache(X, Y1, Race, vivante),
    assert(vache(X, Y1, Race, zombie)),
    retract(vache(X, Y1, _, vivante)).

  zombification(_, _).

%? If the cow is alive, we do the backtracking so we don't have to zombify it.

  zombifiable(_, _, _,vivante).

%? If the cow is a zombie we call zombification on it and turn every neighboring cow into a zombie!

  zombifiable(X, Y, _, zombie):-
    zombification(X, Y).

%? If there are no cows nothing happens.

zombification([]).

%? If there are cows, we execute this rule. If the cow is alive nothing happens. Else if it is a zombie, it will turn every other cow surrounding it to a zombie cow! We repeat it this process for each cow present in the game.

  zombification(L):-
    L \== [],
    [Val | K] = L,
    nth0(0, Val, X1),
    nth0(1, Val, Y1),
    vache(X1, Y1, Race, State),
    zombifiable(X1, Y1, Race, State),
    zombification(K).

%? If we call zombification, We will call zombification on every cow.

  zombification:-
    vaches(L),
    zombification(L).

%! 3. Écrivez la règle deplacement_vache(X, Y, Direction) qui déplace la vache située en (X, Y) dans la direction Direction (reste, nord, sud, est, ouest). Attention, il ne faut pas sortir du plateau de jeu ni arriver sur une case occupée. Si c’est le cas, il n’y a pas de mouvement. 

  deplacement_vache(_, _, reste).

  deplacement_vache(X, Y, est):-
    X1 is X + 1,
    largeur(L),
    X1 < L,
    not(occupe(X1, Y)),
    vache(X, Y, Race, Etat),
    assert(vache(X1, Y, Race, Etat)),
    retract(vache(X, Y, _, _)).

  deplacement_vache(X, Y, ouest):-
    X1 is X - 1,
    X1 >= 0 ,
    not(occupe(X1, Y)),
    vache(X, Y, Race, Etat),
    assert(vache(X1, Y, Race, Etat)),
    retract(vache(X, Y, _, _)).

  deplacement_vache(X, Y, nord):-
    Y1 is Y - 1,
    Y1 >= 0 ,
    not(occupe(X, Y1)),
    vache(X, Y, Race, Etat),
    assert(vache(X, Y1, Race, Etat)),
    retract(vache(X, Y, _, _)).

  deplacement_vache(X, Y, sud):-
    Y1 is Y  +  1,
    hauteur(H),
    Y1 < H ,
    not(occupe(X, Y1)),
    vache(X, Y, Race, Etat),
    assert(vache(X, Y1, Race, Etat)),
    retract(vache(X,  Y, _, _)).

  deplacement_vaches(R):-
    vache(X, Y, _, _),
    deplacement_vache(X, Y, R).

    deplacement_vaches(_).

%! 4.  Écrivez la règle deplacement_joueur(Direction) qui déplace Dimitri. Respectez les mêmes contraintes que pour la question précédente. 

  deplacement_joueur(reste).

  deplacement_joueur(est):-
    dimitri(X, Y),
    X1 is X + 1,
    largeur(L),
    X1 < L,
    not(occupe(X1, Y)),
    assert(dimitri(X1, Y)),
    retract(dimitri(X, Y)).

  deplacement_joueur(ouest):-
    dimitri(X, Y),
    X1 is X - 1,
    X1 >= 0,
    not(occupe(X1, Y)),
    assert(dimitri(X1, Y)),
    retract(dimitri(X, Y)).

  deplacement_joueur(nord):-
    dimitri(X, Y),
    Y1 is Y - 1,
    Y1 >= 0,
    not(occupe(X, Y1)),
    assert(dimitri(X, Y1)),
    retract(dimitri(X, Y)).

  deplacement_joueur(sud):-
    dimitri(X, Y),
    Y1 is Y + 1,
    hauteur(H),
    Y1 < H,
    not(occupe(X, Y1)),
    assert(dimitri(X, Y1)),
    retract(dimitri(X, Y)).

%! 5.  Écrivez la règle verification qui retourne vrai si Dimitri n’est pas à côté d’une vache zombie. Il peut ainsi continuer son chemin  sans se faire mordre et devenir lui-même un zombie.

  verification:-
    dimitri(X, Y),
    X1 is X + 1,
    not(vache(X1, Y, _, zombie)),
    X2 is X - 1, 
    not(vache(X2, Y, _,zombie)),
    Y1 is Y - 1, 
    not(vache(X, Y1, _,zombie)),
    Y2 is Y + 1, 
    not(vache(X, Y2, _,zombie)).

% Le reste est le code prédéfini du jeu

initialisation :-
    nombre_rochers(NR),
    placer_rochers(NR),
    nombre_arbres(NA),
    placer_arbres(NA),
    nombre_vaches(brune, NVB),
    placer_vaches(brune, NVB),
    nombre_vaches(simmental, NVS),
    placer_vaches(simmental, NVS),
    nombre_vaches(alpine_herens, NVH),
    placer_vaches(alpine_herens, NVH),
    placer_dimitri,
    creer_zombie,
    creer_zombie,
    !.
  
  affichage(L, _) :-
  largeur(L),
  nl.

affichage(L, H) :-
  rocher(L, H),
  print('R'),
  L_ is L + 1,
  affichage(L_, H).

affichage(L, H) :-
  arbre(L, H),
  print('T'),
  L_ is L + 1,
  affichage(L_, H).

affichage(L, H) :-
  dimitri(L, H),
  print('D'),
  L_ is L + 1,
  affichage(L_, H).

affichage(L, H) :-
  vache(L, H, brune, vivante),
  print('B'),
  L_ is L + 1,
  affichage(L_, H).
affichage(L, H) :-
  vache(L, H, brune, zombie),
  print('b'),
  L_ is L + 1,
  affichage(L_, H).

affichage(L, H) :-
  vache(L, H, simmental, vivante),
  print('S'),
  L_ is L + 1,
  affichage(L_, H).
affichage(L, H) :-
  vache(L, H, simmental, zombie),
  print('s'),
  L_ is L + 1,
  affichage(L_, H).

affichage(L, H) :-
  vache(L, H, alpine_herens, vivante),
  print('H'),
  L_ is L + 1,
  affichage(L_, H).
affichage(L, H) :-
  vache(L, H, alpine_herens, zombie),
  print('h'),
  L_ is L + 1,
  affichage(L_, H).

affichage(L, H) :-
  \+ occupe(L, H),
  print('.'),
  L_ is L + 1,
  affichage(L_, H).

affichage(H) :-
  hauteur(H).

affichage(H) :-
  hauteur(HMax),
  H < HMax,
  affichage(0, H),
  H_ is H + 1,
  affichage(H_).

affichage :-
  affichage(0),!.

jouer :-
  initialisation,
  tour(0, _).

tour_(_, _) :-
  \+ verification,
  write('Dimitri s\'est fait mordre'),!.
tour_(N, _) :-
  verification,
  M is N + 1,
  tour(M, _).

tour(N, R) :-
  affichage,
  question(R),
  deplacement_joueur(R),
  deplacement_vaches(R),
  zombification,
  tour_(N, R).