# Plan de développement de l'addon MiniAHScanner

## Objectif
Créer un addon World of Warcraft qui scanne l'hôtel des ventes (HV) pour enregistrer les prix et les afficher dans les infobulles, avec une interface légère et configurable.

## Étapes de développement

### 1. Initialisation du projet
- Définir la structure de base de l'addon (fichiers TOC, Lua, XML, etc.)
- Préparer les variables globales et l'environnement WoW API

### 2. Scan de l'hôtel des ventes
- Implémenter le scan des objets à l'HV (ventes d'achat et d'enchères)
- Stocker les prix récupérés dans une base de données locale
- Respecter la limite de 15 minutes pour éviter la déconnexion

### 3. Affichage dans les infobulles
- Ajouter l'affichage du prix dans l'infobulle des objets
- S'assurer que l'affichage soit léger et non-intrusif

### 4. Interface graphique (UI)
- Créer une fenêtre d'options avec fond noir
- Ajouter les options :
  - Activer/désactiver le scan automatique à l'ouverture de l'HV
  - Choisir le temps et le type de scan (achat/enchères)

### 5. Icône minimap
- Ajouter une icône (pièce d'or) sur la minimap
- Permettre d'ouvrir l'UI via cette icône

### 6. Optimisations et tests
- Optimiser les accès mémoire et la légèreté de l'addon
- Tester toutes les fonctionnalités en jeu
- Corriger les bugs éventuels

