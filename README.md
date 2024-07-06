# Addon de Menu d'Animations Personnalisées

## Description
Cet addon pour Garry's Mod fournit un menu d'animations personnalisées pour les joueurs, leur permettant d'exécuter diverses animations via une interface graphique. Le menu peut être ouvert en appuyant sur F7 et inclut des animations pour différents personnages et poses. L'addon propose également des effets sonores lors de l'interaction avec le menu.

## Fonctionnalités
- Menu d'animations personnalisable avec diverses animations.
- Effets sonores lors de l'interaction avec le menu.
- Design de menu responsive et scalable.
- Positionnement et redimensionnement dynamiques du menu via des commandes console.

## Installation
- Téléchargez l'addon et extrayez-le dans le répertoire des addons de votre Garry's Mod.

## Utilisation
- Appuyez sur `F7` pour ouvrir le menu d'animations.
- Utilisez les flèches gauche et droite pour naviguer entre les pages d'animations.
- Cliquez sur un bouton d'animation pour exécuter l'animation correspondante.

## Commandes Console
- `set_scale <value>`: Ajuste l'échelle du menu. Remplacez `<value>` par le pourcentage d'échelle désiré (par exemple, `set_scale 90` pour 90% d'échelle).
- `set_pos <x> <y>`: Ajuste la position du menu. Remplacez `<x>` et `<y>` par les pourcentages de position désirés (par exemple, `set_pos 50 50` pour centrer le menu).

## Personnalisation des Animations
Pour personnaliser les animations, éditez le fichier `animations.lua` situé dans le répertoire `lua`. Ajoutez ou modifiez les animations et leurs noms correspondants dans le format suivant :
```lua
animations = {
 { Sequence = "sequence_animation", Weight = 1, Name = "Nom de l'Animation" },
 ...
}
