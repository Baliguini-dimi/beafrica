# BéAfrica 🌍
> Découvrez le cœur de l'Afrique.

Application mobile Android dédiée à la valorisation de la République Centrafricaine — sa culture, son histoire, son peuple, son économie.

## Développeur
**Dimitri Nelson BALIGUINI DEMBA (Dem's)**  
Master 1 Big Data & IA — IUA Abidjan

## Stack technique
Flutter · Dart · Firebase · Riverpod · Groq API · OpenWeatherMap · ExchangeRate-API

## Installation

```bash
# Cloner le projet
git clone https://github.com/[TON_USERNAME]/beafrica.git
cd beafrica

# Copier le fichier d'environnement
cp .env.example .env
# Remplir les clés API dans .env

# Installer les dépendances
flutter pub get

# Lancer l'app
flutter run
```

## Configuration Firebase
Voir la documentation dans `/docs/firebase_setup.md` (Sprint 2)

## ⚠️ Note TECNO CLA5
Les appareils Transsion (TECNO, Infinix, itel) ont une gestion agressive de la batterie qui peut tuer les services background. Ce comportement est au niveau OS et non corrigeable côté code Flutter.

## Modules v1
- Accueil Dashboard
- Médias & Actualités (RSS)
- Histoire & Patrimoine
- Culture & Artisanat
- Astuces & Conseils pratiques
- Mini Marketplace
- Communauté Diaspora (Forum)
- Chatbot IA — Kôdô
- Météo RCA
- Convertisseur Devises Afrique
- Dictionnaire Sango (basique)