# Contexte du Projet - Tracker Force & Course

## Vue d'ensemble
Application mobile Flutter pour suivre un programme d'entraînement de force (calisthenics) et de course à pied personnel.

## Programme d'entraînement

### Cycle de 4 jours
1. **Jour 1 : TIRAGE (Pull)**
   - Pull-ups : 2 sets jusqu'à l'échec
   - Chin-ups : 1 set jusqu'à l'échec
   - Méthodologie : Set 1 normal, Set 2 avec drop sets (négatives)

2. **Jour 2 : POUSSÉE (Push)**
   - ALTERNANCE entre :
     - Dips : 2 sets jusqu'à l'échec
     - Pike Push-ups : 2 sets jusqu'à l'échec
   - Méthodologie : Set 1 normal, Set 2 avec drop sets (négatives)

3. **Jour 3 : JAMBES (Legs)**
   - ALTERNANCE entre :
     - Squats : 2 sets jusqu'à l'échec
     - Deadlifts : 2 sets jusqu'à l'échec
   - Méthodologie : Set 1 normal, Set 2 avec drop sets (négatives)

4. **Jour 4 : COURSE (Repos actif)**
   - Programme "Couch to 5K" progressif
   - 4 phases de progression

### Programme de Course (Couch to 5K)

**Semaines 1-2**
- Course : 1 minute
- Marche : 2 minutes
- Répéter : 8 cycles (24 minutes total)

**Semaines 3-4**
- Course : 2 minutes
- Marche : 2 minutes
- Répéter : 6 cycles (24 minutes total)

**Semaines 5-6**
- Course : 5 minutes
- Marche : 2 minutes
- Répéter : 3 cycles (21 minutes total)

**Semaines 7-8**
- Course : 8 minutes
- Marche : 1 minute
- Répéter : 3 cycles (27 minutes total)

## Fonctionnalités requises

### 1. Enregistrement des entraînements de force

#### Structure de données pour un workout
```
{
  id: timestamp,
  date: "YYYY-MM-DD",
  type: "pull" | "push" | "legs",
  
  // Pour type "pull"
  pullups1: int,
  pullups2: int,
  pullups2Negatives: int,
  pullups2NegativesFinal: int,
  chinups: int,
  chinupsNegatives: int,
  
  // Pour type "push"
  dipsOrPike: "dips" | "pike",
  dips1: int,
  dips2: int,
  dips2Negatives: int,
  dips2NegativesFinal: int,
  pike1: int,
  pike2: int,
  pike2Negatives: int,
  pike2NegativesFinal: int,
  
  // Pour type "legs"
  squatOrDeadlift: "squat" | "deadlift",
  squat1: int,
  squat2: int,
  squat2Negatives: int,
  deadlift1: int,
  deadlift2: int,
  deadlift2Negatives: int,
  
  notes: string
}
```

### 2. Enregistrement des courses

#### Structure de données pour une course
```
{
  id: timestamp,
  date: "YYYY-MM-DD",
  week: 1 | 3 | 5 | 7, // Semaine du programme
  runMinutes: int,
  walkMinutes: int,
  cycles: int,
  totalTime: int,
  feeling: "excellent" | "good" | "hard" | "veryhard",
  notes: string
}
```

### 3. Suivi du poids quotidien

#### Structure de données pour le poids
```
{
  id: timestamp,
  date: "YYYY-MM-DD",
  weightLbs: double,
  notes: string (optionnel)
}
```

### 4. Historique
- Liste chronologique de tous les entraînements de force
- Liste chronologique de toutes les courses
- Liste chronologique des pesées
- Affichage clair des détails de chaque séance
- Filtrage par type d'entraînement/activité

### 5. Statistiques

#### Statistiques de force
- Total d'entraînements effectués
- Record personnel (max reps Set 1) pour :
  - Pull-ups
  - Dips
  - Pike Push-ups
  - Squats
  - Deadlifts
- Progression des 5 dernières séances de Pull-ups
- Progression des 5 dernières séances de Push (Dips/Pike)

#### Statistiques de course
- Total de courses effectuées
- Temps moyen par course
- Progression par semaine du programme

#### Statistiques de poids
- Poids actuel vs poids initial
- Changement total (gain/perte en lbs)
- Moyenne hebdomadaire/mensuelle
- Graphique de tendance avec moyenne mobile
- Progression sur 7, 30, 90 jours

### 6. Persistance des données
- Sauvegarde locale avec Hive (NoSQL, type-safe)
- Type adapters générés pour Workout, Run, et Weight
- Données conservées entre les sessions
- Export/Import optionnel (bonus)

## Interface utilisateur

### Écrans principaux
1. **Écran d'enregistrement d'entraînement Force**
2. **Écran d'enregistrement de Course**
3. **Écran d'enregistrement de Poids**
4. **Écran Historique**
5. **Écran Statistiques**

### Navigation
- Bottom navigation bar ou drawer
- Tabs pour faciliter la navigation
- Boutons d'action flottants pour ajouter rapidement

### Design

#### Couleurs suggérées
- **Pull (Tirage)** : Bleu (#2563eb)
- **Push (Poussée)** : Rouge/Orange (#dc2626)
- **Legs (Jambes)** : Vert (#16a34a)
- **Course** : Violet/Mauve (#9333ea)
- **Poids** : Amber/Jaune (#f59e0b)
- **Comparaison** : Dégradé multicolore

#### Composants
- Cards pour afficher les entraînements
- Forms bien structurés avec validation
- Graphiques simples pour les progressions
- Badges/Chips pour les catégories
- Boutons Material Design
- AppBar avec titre et actions

## Détails techniques

### Packages Flutter recommandés
```yaml
dependencies:
  flutter:
    sdk: flutter

  # State management
  provider: ^6.1.1

  # Persistance (Hive)
  hive: ^2.2.3
  hive_flutter: ^1.1.0

  # UI
  intl: ^0.18.1  # Pour les dates
  fl_chart: ^0.66.0  # Pour les graphiques

dev_dependencies:
  # Code generation pour Hive
  hive_generator: ^2.0.1
  build_runner: ^2.4.6
```

### Structure de fichiers suggérée
```
lib/
├── main.dart
├── models/
│   ├── workout.dart
│   ├── run.dart
│   └── weight.dart
├── providers/
│   ├── workout_provider.dart
│   ├── run_provider.dart
│   └── weight_provider.dart
├── screens/
│   ├── home_screen.dart
│   ├── workout_form_screen.dart
│   ├── run_form_screen.dart
│   ├── weight_form_screen.dart

│   ├── history_screen.dart
│   └── stats_screen.dart
├── widgets/
│   ├── workout_card.dart
│   ├── run_card.dart
│   ├── weight_card.dart
│   ├── weight_chart.dart
│   └── stat_card.dart
└── services/
    └── hive_service.dart
```

## Logique métier importante

### Validation des formulaires
- Tous les champs numériques doivent être >= 0
- La date ne peut pas être dans le futur
- Au moins un exercice doit avoir des valeurs renseignées

### Calculs automatiques
- Pour les courses, calculer automatiquement le temps total si possible : 
  `totalTime = (runMinutes + walkMinutes) × cycles`

### Affichage conditionnel
- Ne montrer que les champs pertinents selon le type d'exercice
- Dips/Pike : radio button pour choisir
- Squat/Deadlift : radio button pour choisir

## User Experience

### Feedback utilisateur
- Message de confirmation après sauvegarde
- Animation de transition entre les écrans
- Indicateurs de chargement si nécessaire
- Messages d'erreur clairs

### Facilité d'utilisation
- Valeurs par défaut intelligentes (date du jour)
- Auto-focus sur le premier champ
- Keyboard type approprié (number pour les champs numériques)
- Boutons bien espacés et facilement cliquables

## Priorisation des fonctionnalités

### MVP (Minimum Viable Product)
1. ✅ Formulaire workout force (3 types)
2. ✅ Formulaire course
3. ✅ Formulaire poids quotidien
4. ✅ Sauvegarde locale avec Hive
5. ✅ Historique basique
6. ✅ Statistiques de base
7. ✅ Graphique de tendance de poids

### Version 2 (Améliorations)
1. Graphiques de progression avancés
2. Export/Import des données
3. Rappels/Notifications pour les entraînements
4. Thème sombre
5. Objectifs personnalisés
6. Partage de progression

## Notes importantes

### Philosophie du programme
- **Intensité maximale** : Chaque set va jusqu'à l'échec
- **Récupération** : Essentielle, d'où le jour 4 de course légère
- **Progression** : Suivre l'évolution des reps au fil du temps
- **Alternance** : Dips/Pike et Squat/Deadlift pour varier les stimuli

### Terminology
- **Set** : Une série d'exercices
- **Reps** : Répétitions
- **Négatives** : Phase excentrique lente (descente)
- **Drop set** : Technique d'intensification après l'échec
- **Échec** : Incapacité de faire une répétition supplémentaire avec bonne forme

## Messages d'encouragement suggérés
- Après sauvegarde workout : "Excellent travail ! 💪"
- Après sauvegarde course : "Tu progresses ! 🏃"
- Après sauvegarde poids : "Poids enregistré ! 📊"
- Nouveau record : "NOUVEAU RECORD ! 🎉"
- 7 jours de suite : "Semaine complétée ! 🔥"
- Perte de poids : "Continue comme ça ! 📉"

## Considérations futures
- Mode multi-langues (FR/EN)
- Synchronisation cloud
- Partage de progression sur réseaux sociaux
- Conseils d'entraînement basés sur les données
- Détection automatique des records