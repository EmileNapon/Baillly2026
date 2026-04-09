🧪 TP COMPLET : Construire et tester le modèle Listing en Flutter
🎯 OBJECTIF GLOBAL

Construire un modèle qui représente :

Logement = identité + prix + sécurité + historique + transport
🧩 ÉTAPE 1 — Créer le fichier modèle
📁 Action

Dans ton projet Flutter :

lib/models/listing.dart
🧩 ÉTAPE 2 — Créer SecurityCheck
🎯 Objectif

Représenter une vérification de sécurité

🔧 Code
class SecurityCheck {
  final bool ok;
  final String label;

  const SecurityCheck({
    required this.ok,
    required this.label,
  });
}
🧠 Compréhension
ok → validé ou non
label → description
✅ Test mental

👉 Exemple réel :

Titre foncier validé → true
🧩 ÉTAPE 3 — Créer HistoryEvent
🎯 Objectif

Stocker l’historique du logement

🔧 Code
class HistoryEvent {
  final String date;
  final String event;
  final bool ok;

  const HistoryEvent({
    required this.date,
    required this.event,
    required this.ok,
  });
}
🧠 Compréhension
date → quand
event → quoi
ok → bon ou problème
🧩 ÉTAPE 4 — Créer la classe principale Listing
🎯 Objectif

Représenter un logement complet

🔧 Code
class Listing {
  final int id;
  final String name;
  final String quartier;
  final String category;
  final String statut;

  final double mapX;
  final double mapY;

  final int loyer;
  final int charges;
  final int caution;

  final int surface;
  final int pieces;

  final bool verified;
  final int trust;
  final int litiges;
  final String propriScore;

  final List<SecurityCheck> securite;
  final List<HistoryEvent> history;

  final double distTravail;
  final int carburant;
  final String lieu;
🧠 Compréhension par blocs
🆔 Identité
id, name, quartier
🏠 Type
category, statut
🗺️ Position
mapX, mapY
💰 Finances
loyer, charges, caution
🏗️ Physique
surface, pieces
🔐 Confiance
verified, trust, litiges
📜 Données complexes
securite, history
🚗 Transport
distTravail, carburant
🧩 ÉTAPE 5 — Ajouter le constructeur
🔧 Code
  const Listing({
    required this.id,
    required this.name,
    required this.quartier,
    required this.category,
    required this.statut,
    required this.mapX,
    required this.mapY,
    required this.loyer,
    required this.charges,
    required this.caution,
    required this.surface,
    required this.pieces,
    required this.verified,
    required this.trust,
    required this.litiges,
    required this.propriScore,
    required this.securite,
    required this.history,
    required this.distTravail,
    required this.carburant,
    required this.lieu,
  });
🧩 ÉTAPE 6 — Ajouter les getters (LOGIQUE 🔥)
🎯 Objectif

Faire des calculs automatiques

🔧 Code
  int get totalMensuel => loyer + charges;

  int get totalAvecCarburant => loyer + charges + carburant;

  String get categoryLetter =>
      category == 'Villa'
          ? 'V'
          : category == 'Appartement'
              ? 'A'
              : 'C';
}
🧠 Compréhension

👉 Tu ajoutes de l’intelligence :

coût réel
coût complet
simplification UI
🧩 ÉTAPE 7 — Créer les données de test
🎯 Objectif

Simuler une vraie base de données

🔧 Code
final List<Listing> sampleListings = [
  Listing(
    id: 0,
    name: 'Villa F4',
    quartier: 'Gounghin',
    category: 'Villa',
    statut: 'Disponible',

    mapX: 0.8,
    mapY: 0.5,

    loyer: 250000,
    charges: 30000,
    caution: 500000,

    surface: 180,
    pieces: 6,

    verified: true,
    trust: 96,
    litiges: 0,
    propriScore: 'Excellent',

    securite: [
      SecurityCheck(ok: true, label: 'Titre foncier validé'),
      SecurityCheck(ok: true, label: 'Visite terrain faite'),
    ],

    history: [
      HistoryEvent(date: 'Janv 2026', event: 'Contrat renouvelé', ok: true),
    ],

    distTravail: 5.2,
    carburant: 28000,
    lieu: 'Centre',
  ),
];
🧩 ÉTAPE 8 — Tester dans Flutter
🎯 Objectif

Afficher les données

🔧 Dans un écran
import 'models/listing.dart';
🔧 Affichage simple
ListView.builder(
  itemCount: sampleListings.length,
  itemBuilder: (context, index) {
    final l = sampleListings[index];

    return ListTile(
      title: Text(l.name),
      subtitle: Text(l.quartier),
      trailing: Text("${l.totalAvecCarburant} FCFA"),
    );
  },
)
🧩 ÉTAPE 9 — Tester les calculs
🎯 Objectif

Valider ton modèle

🔧 Ajoute
print(sampleListings[0].totalMensuel);
print(sampleListings[0].totalAvecCarburant);
✅ Résultat attendu

👉 Vérifier :

loyer + charges
carburant
🧩 ÉTAPE 10 — Test logique métier 🔥
🎯 Objectif

Comparer logements

🔧 Exemple
if (l.trust > 90 && l.verified) {
  print("Logement fiable");
}