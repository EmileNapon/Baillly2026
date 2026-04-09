// ============================================================
//  MODÈLES — ImmoBF / Bailly  — 12 fonctionnalités
// ============================================================

// ── Commodité ────────────────────────────────────────────────
class Commodite {
  final int id;
  final String name;
  const Commodite({required this.id, required this.name});
}

// ── Médias par pièce ─────────────────────────────────────────
class PieceMedia {
  final String type;      // 'photo' | 'video' | '360'
  final String label;     // 'Cour', 'Salon', 'Chambre', 'Douche', 'Cuisine'
  final String assetPath;
  const PieceMedia({required this.type, required this.label, required this.assetPath});
}

// ── Security check (besoin 1) ─────────────────────────────────
class SecurityCheck {
  final bool ok;
  final String label;
  const SecurityCheck({required this.ok, required this.label});
}

// ── Historique complet (besoin 6) ────────────────────────────
class HistoryEvent {
  final String date;
  final String event;
  final bool ok;
  final String? detail; // optionnel : prix précédent, nom occupant, etc.
  const HistoryEvent({required this.date, required this.event, required this.ok, this.detail});
}

// ── Historique des loyers (besoin 6) ─────────────────────────
class LoyerHistorique {
  final String periode;
  final int montant;
  const LoyerHistorique({required this.periode, required this.montant});
}

// ── Score qualité eau / électricité (besoin 10) ───────────────
class ScoreServices {
  final int eauScore;         // 0-100
  final int elecScore;        // 0-100
  final int coupuresEauMois;  // nombre moyen/mois
  final int coupuresElecMois;
  final String commentaire;
  const ScoreServices({
    required this.eauScore, required this.elecScore,
    required this.coupuresEauMois, required this.coupuresElecMois,
    this.commentaire = '',
  });
}

// ── Score accessibilité (besoin 11) ──────────────────────────
class ScoreAccessibilite {
  final int scoreSec;    // saison sèche 0-100
  final int scorePluie;  // saison pluie 0-100
  final String etatRoute;
  final List<String> transportsDisponibles;
  final String commentaire;
  const ScoreAccessibilite({
    required this.scoreSec, required this.scorePluie,
    required this.etatRoute, required this.transportsDisponibles,
    this.commentaire = '',
  });
}

// ── Paiement flexible (besoin 7) ─────────────────────────────
class OptionPaiement {
  final String mode;       // 'mensuel' | 'fractionne' | 'mobile_money'
  final String label;
  final String detail;
  const OptionPaiement({required this.mode, required this.label, required this.detail});
}

// ── Démarcheur (besoin 8) ─────────────────────────────────────
class Demarcheur {
  final int id;
  final String nom;
  final String photo;
  final double note;       // 0-5
  final int missionsTotal;
  final bool disponible;
  final String telephone;
  final double tarifVisite; // FCFA
  const Demarcheur({
    required this.id, required this.nom, required this.photo,
    required this.note, required this.missionsTotal,
    required this.disponible, required this.telephone,
    required this.tarifVisite,
  });
}

// ── Colocation (besoin 9) ─────────────────────────────────────
class ColocatairePotentiel {
  final int id;
  final String prenom;
  final String profession;
  final int ageApprox;
  final String disponibilite;
  const ColocatairePotentiel({
    required this.id, required this.prenom, required this.profession,
    required this.ageApprox, required this.disponibilite,
  });
}

// ── Catégories & statuts ─────────────────────────────────────
class LogementCategory {
  static const courUnique = 'cour_unique';
  static const celibat    = 'celibat';
  static const miniVilla  = 'mini_villa';

  static String label(String v) {
    switch (v) {
      case courUnique: return 'Cour unique';
      case celibat:    return 'Célibat';
      case miniVilla:  return 'Mini villa';
      default:         return v;
    }
  }

  static String letter(String v) {
    switch (v) {
      case courUnique: return 'C';
      case celibat:    return 'L';
      case miniVilla:  return 'V';
      default:         return '?';
    }
  }
}

class LogementStatut {
  static const construction = 'construction';
  static const maintenance  = 'maintenance';
  static const disponible   = 'disponible';
  static const occupe       = 'occupe';
  static const suspendu     = 'suspendu';
  static const reserve      = 'reserve';    // besoin 12 — statut en temps réel

  static String label(String v) {
    switch (v) {
      case construction: return 'En construction';
      case maintenance:  return 'En maintenance';
      case disponible:   return 'Disponible';
      case occupe:       return 'Occupé';
      case suspendu:     return 'Suspendu';
      case reserve:      return 'Réservé';
      default:           return v;
    }
  }

  static bool isAvailable(String v) => v == disponible;
}

// ── Modèle principal Logement ─────────────────────────────────
class Logement {
  final int id;
  final String name;
  final String description;

  // Localisation
  final String quartier;
  final double mapX;
  final double mapY;
  final String lieu;          // zone de travail de référence

  // Catégorie & statut temps réel (besoin 12)
  final String category;
  final String statut;
  final String statutMaj;    // "il y a 2 min" / horodatage

  // Financier
  final int loyer;
  final int charges;
  final int caution;

  // Coût total détaillé (besoin 3)
  final int coutEnergieMois;   // électricité estimée
  final int coutEauMois;       // eau estimée
  final double distTravail;
  final int carburant;

  // Caractéristiques
  final int surface;
  final int pieces;
  final String disponibleDes;

  // Confiance (besoin 5)
  final bool verified;
  final bool verifiePropr;
  final bool visiteTerrain;    // visite physique effectuée
  final int trust;             // score global 0-100
  final double propriScore;    // score propriétaire 0-100
  final int scoreZone;         // score de la zone 0-100
  final int litiges;

  // Colocation (besoin 9)
  final bool colocationPossible;
  final int loyerParColoc;     // loyer si 2 colocataires
  final List<ColocatairePotentiel> colocataires;

  // Score services (besoin 10)
  final ScoreServices? services;

  // Score accessibilité (besoin 11)
  final ScoreAccessibilite? accessibilite;

  // Paiement (besoin 7)
  final List<OptionPaiement> optionsPaiement;

  // Démarcheurs disponibles (besoin 8)
  final List<Demarcheur> demarcheurs;

  // Historique des loyers (besoin 6)
  final List<LoyerHistorique> loyerHistorique;

  // Relations
  final List<Commodite> commodites;
  final List<PieceMedia> medias;
  final List<SecurityCheck> securite;
  final List<HistoryEvent> history;

  const Logement({
    required this.id,
    required this.name,
    this.description = '',
    required this.quartier,
    required this.mapX,
    required this.mapY,
    required this.lieu,
    required this.category,
    required this.statut,
    this.statutMaj = 'Mis à jour à l\'instant',
    required this.loyer,
    required this.charges,
    required this.caution,
    this.coutEnergieMois = 0,
    this.coutEauMois = 0,
    required this.distTravail,
    required this.carburant,
    required this.surface,
    required this.pieces,
    required this.disponibleDes,
    required this.verified,
    this.verifiePropr = false,
    this.visiteTerrain = false,
    required this.trust,
    required this.propriScore,
    this.scoreZone = 0,
    this.litiges = 0,
    this.colocationPossible = false,
    this.loyerParColoc = 0,
    this.colocataires = const [],
    this.services,
    this.accessibilite,
    this.optionsPaiement = const [],
    this.demarcheurs = const [],
    this.loyerHistorique = const [],
    this.commodites = const [],
    this.medias = const [],
    required this.securite,
    required this.history,
  });

  // Coût total (besoin 3)
  int get totalMensuel       => loyer + charges;
  int get totalComplet       => loyer + charges + carburant + coutEnergieMois + coutEauMois;
  int get totalAvecCarburant => loyer + charges + carburant;

  String get categoryLabel  => LogementCategory.label(category);
  String get categoryLetter => LogementCategory.letter(category);
  String get statutLabel    => LogementStatut.label(statut);
  bool   get isAvailable    => LogementStatut.isAvailable(statut);

  Map<String, List<PieceMedia>> get mediasByPiece {
    final map = <String, List<PieceMedia>>{};
    for (final m in medias) {
      map.putIfAbsent(m.label, () => []).add(m);
    }
    return map;
  }

  List<PieceMedia> get photos => medias.where((m) => m.type == 'photo').toList();
  List<PieceMedia> get videos => medias.where((m) => m.type == 'video').toList();
}

// ============================================================
//  DONNÉES DE TEST
// ============================================================

final _demarcheursDisponibles = [
  const Demarcheur(id: 1, nom: 'Moussa Traoré', photo: '', note: 4.8,
      missionsTotal: 127, disponible: true, telephone: '+226 70 12 34 56', tarifVisite: 5000),
  const Demarcheur(id: 2, nom: 'Aïssata Koné', photo: '', note: 4.6,
      missionsTotal: 89, disponible: true, telephone: '+226 76 98 76 54', tarifVisite: 4000),
];

final _paiementsStandard = [
  const OptionPaiement(mode: 'mensuel', label: 'Mensuel classique', detail: 'Virement ou espèces en début de mois'),
  const OptionPaiement(mode: 'mobile_money', label: 'Mobile Money', detail: 'Orange Money · Moov Money · Coris'),
  const OptionPaiement(mode: 'fractionne', label: 'Fractionné x2', detail: '2 versements de 50% — 1er et 15 du mois'),
];

final List<Logement> sampleLogements = [

  // ── 0 · Mini Villa Gounghin ──────────────────────────────
  Logement(
    id: 0,
    name: 'Mini Villa F4 — Rue 14.52',
    description: 'Belle mini villa avec cour arborée, cuisine équipée et salon spacieux. Quartier calme, gardien à demeure.',
    quartier: 'Gounghin', mapX: 0.80, mapY: 0.57, lieu: 'Plateau Central',
    category: LogementCategory.miniVilla,
    statut: LogementStatut.disponible,
    statutMaj: 'il y a 3 min',
    loyer: 250000, charges: 30000, caution: 500000,
    coutEnergieMois: 18000, coutEauMois: 8000,
    distTravail: 5.2, carburant: 28000,
    surface: 180, pieces: 6,
    disponibleDes: '01/04/2026',
    verified: true, verifiePropr: true, visiteTerrain: true,
    trust: 96, propriScore: 95, scoreZone: 88, litiges: 0,
    colocationPossible: true, loyerParColoc: 130000,
    colocataires: [
      const ColocatairePotentiel(id: 1, prenom: 'Karim', profession: 'Enseignant', ageApprox: 28, disponibilite: 'Dès le 01/04'),
    ],
    services: const ScoreServices(
      eauScore: 85, elecScore: 78,
      coupuresEauMois: 2, coupuresElecMois: 3,
      commentaire: 'Eau ONEA stable · SONABEL quelques délestages en soirée',
    ),
    accessibilite: const ScoreAccessibilite(
      scoreSec: 92, scorePluie: 74,
      etatRoute: 'Bitumée jusqu\'au portail',
      transportsDisponibles: ['Taxi', 'Moto-taxi', 'Sotraco ligne 4'],
      commentaire: 'Accessible toute l\'année. Quelques flaques en saison des pluies.',
    ),
    optionsPaiement: _paiementsStandard,
    demarcheurs: _demarcheursDisponibles,
    loyerHistorique: const [
      LoyerHistorique(periode: '2024', montant: 230000),
      LoyerHistorique(periode: '2023', montant: 210000),
      LoyerHistorique(periode: '2022', montant: 200000),
    ],
    commodites: const [
      Commodite(id: 1, name: 'Eau ONEA'), Commodite(id: 2, name: 'Électricité SONABEL'),
      Commodite(id: 3, name: 'Climatisation'), Commodite(id: 4, name: 'Gardien'),
      Commodite(id: 5, name: 'Parking'),
    ],
    medias: const [
      PieceMedia(type: 'photo', label: 'Cour',    assetPath: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800'),
      PieceMedia(type: 'video', label: 'Cour',    assetPath: 'https://www.w3schools.com/html/mov_bbb.mp4'),
      PieceMedia(type: 'photo', label: 'Salon',   assetPath: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=800'),
      PieceMedia(type: 'video', label: 'Salon',   assetPath: 'https://www.w3schools.com/html/mov_bbb.mp4'),
      PieceMedia(type: 'photo', label: 'Chambre', assetPath: 'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=800'),
      PieceMedia(type: 'video', label: 'Chambre', assetPath: 'https://www.w3schools.com/html/mov_bbb.mp4'),
      PieceMedia(type: 'photo', label: 'Douche',  assetPath: 'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?w=800'),
      PieceMedia(type: 'video', label: 'Douche',  assetPath: 'https://www.w3schools.com/html/mov_bbb.mp4'),
      PieceMedia(type: 'photo', label: 'Cuisine', assetPath: 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=800'),
      PieceMedia(type: 'video', label: 'Cuisine', assetPath: 'https://www.w3schools.com/html/mov_bbb.mp4'),
    ],
    securite: const [
      SecurityCheck(ok: true,  label: 'Titre foncier authentifié notaire'),
      SecurityCheck(ok: true,  label: 'Visite terrain effectuée mars 2026'),
      SecurityCheck(ok: true,  label: 'Charges eau/élec vérifiées 3 mois'),
      SecurityCheck(ok: true,  label: 'Zéro litige historique'),
      SecurityCheck(ok: true,  label: 'Propriétaire identifié CNIB validé'),
    ],
    history: const [
      HistoryEvent(date: 'Janv 2026', event: 'Contrat renouvellé',              ok: true,  detail: '250 000 FCFA/mois'),
      HistoryEvent(date: 'Oct 2025',  event: 'Réparation toit prise en charge', ok: true),
      HistoryEvent(date: 'Juil 2025', event: 'Quittance délivrée à temps',      ok: true),
      HistoryEvent(date: 'Jan 2024',  event: 'Augmentation loyer +20 000 FCFA', ok: true,  detail: '230 000 → 250 000'),
    ],
  ),

  // ── 1 · Cour Unique Pissy ───────────────────────────────
  Logement(
    id: 1,
    name: 'Cour Unique F3 — Cité An-Tiim',
    description: 'Cour unique propre et bien entretenue à Pissy. Compteur électrique individualisé, citerne d\'eau.',
    quartier: 'Pissy', mapX: 0.17, mapY: 0.63, lieu: 'Zone du Bois',
    category: LogementCategory.courUnique,
    statut: LogementStatut.disponible,
    statutMaj: 'il y a 1h',
    loyer: 95000, charges: 15000, caution: 190000,
    coutEnergieMois: 8000, coutEauMois: 4000,
    distTravail: 8.7, carburant: 46000,
    surface: 75, pieces: 4,
    disponibleDes: '15/04/2026',
    verified: true, verifiePropr: true, visiteTerrain: true,
    trust: 88, propriScore: 82, scoreZone: 72, litiges: 0,
    colocationPossible: false, loyerParColoc: 0,
    services: const ScoreServices(
      eauScore: 70, elecScore: 65,
      coupuresEauMois: 4, coupuresElecMois: 5,
      commentaire: 'Coupures fréquentes en saison sèche. Citerne de 1000L disponible.',
    ),
    accessibilite: const ScoreAccessibilite(
      scoreSec: 80, scorePluie: 55,
      etatRoute: 'Latérite — praticable mais difficile en pluie',
      transportsDisponibles: ['Moto-taxi', 'Taxi'],
      commentaire: 'Voie non bitumée. Prévoir véhicule ou moto en saison des pluies.',
    ),
    optionsPaiement: _paiementsStandard,
    demarcheurs: _demarcheursDisponibles,
    loyerHistorique: const [
      LoyerHistorique(periode: '2024', montant: 90000),
      LoyerHistorique(periode: '2023', montant: 85000),
    ],
    commodites: const [
      Commodite(id: 1, name: 'Eau ONEA'), Commodite(id: 2, name: 'Électricité SONABEL'),
    ],
    medias: const [
      PieceMedia(type: 'photo', label: 'Cour',    assetPath: 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=800'),
      PieceMedia(type: 'video', label: 'Cour',    assetPath: 'https://www.w3schools.com/html/mov_bbb.mp4'),
      PieceMedia(type: 'photo', label: 'Salon',   assetPath: 'https://images.unsplash.com/photo-1493809842364-78817add7ffb?w=800'),
      PieceMedia(type: 'photo', label: 'Chambre', assetPath: 'https://images.unsplash.com/photo-1586105251261-72a756497a11?w=800'),
      PieceMedia(type: 'video', label: 'Chambre', assetPath: 'https://www.w3schools.com/html/mov_bbb.mp4'),
      PieceMedia(type: 'photo', label: 'Douche',  assetPath: 'https://images.unsplash.com/photo-1560185127-6ed189bf02f4?w=800'),
      PieceMedia(type: 'photo', label: 'Cuisine', assetPath: 'https://images.unsplash.com/photo-1595515106969-1ce29566ff1c?w=800'),
    ],
    securite: const [
      SecurityCheck(ok: true,  label: 'Titre foncier authentifié notaire'),
      SecurityCheck(ok: true,  label: 'Visite terrain effectuée fév 2026'),
      SecurityCheck(ok: true,  label: 'Charges eau/élec vérifiées'),
      SecurityCheck(ok: true,  label: 'Zéro litige historique'),
      SecurityCheck(ok: false, label: 'Photo intérieure à mettre à jour'),
    ],
    history: const [
      HistoryEvent(date: 'Fév 2026',  event: 'Repeint avant entrée',               ok: true),
      HistoryEvent(date: 'Nov 2025',  event: 'Compteur électricité individualisé',  ok: true),
      HistoryEvent(date: 'Août 2025', event: 'Litige bruit résolu',                 ok: false, detail: 'Médiation propriétaire'),
    ],
  ),

  // ── 2 · Célibat Tampouy ─────────────────────────────────
  Logement(
    id: 2,
    name: 'Célibat meublé — Secteur 27',
    description: 'Chambre célibat au secteur 27 de Tampouy. Bien meublé mais titre foncier en cours.',
    quartier: 'Tampouy', mapX: 0.22, mapY: 0.20, lieu: 'Zone du Bois',
    category: LogementCategory.celibat,
    statut: LogementStatut.disponible,
    statutMaj: 'il y a 20 min',
    loyer: 45000, charges: 8000, caution: 90000,
    coutEnergieMois: 5000, coutEauMois: 2000,
    distTravail: 12.1, carburant: 64000,
    surface: 28, pieces: 1,
    disponibleDes: '01/04/2026',
    verified: false, verifiePropr: false, visiteTerrain: false,
    trust: 62, propriScore: 55, scoreZone: 60, litiges: 1,
    colocationPossible: false, loyerParColoc: 0,
    services: const ScoreServices(
      eauScore: 55, elecScore: 50,
      coupuresEauMois: 6, coupuresElecMois: 7,
      commentaire: 'Instabilité fréquente. Recommande groupe électrogène.',
    ),
    accessibilite: const ScoreAccessibilite(
      scoreSec: 70, scorePluie: 40,
      etatRoute: 'Piste — impraticable par fortes pluies',
      transportsDisponibles: ['Moto-taxi'],
      commentaire: 'Zone enclavée. Seule la moto-taxi dessert régulièrement.',
    ),
    optionsPaiement: [
      const OptionPaiement(mode: 'mensuel', label: 'Mensuel classique', detail: 'Espèces uniquement'),
      const OptionPaiement(mode: 'mobile_money', label: 'Mobile Money', detail: 'Orange Money · Moov Money'),
    ],
    demarcheurs: [_demarcheursDisponibles[0]],
    loyerHistorique: const [
      LoyerHistorique(periode: '2024', montant: 40000),
      LoyerHistorique(periode: '2023', montant: 38000),
    ],
    commodites: const [Commodite(id: 2, name: 'Électricité SONABEL')],
    medias: const [
      PieceMedia(type: 'photo', label: 'Cour',    assetPath: 'https://images.unsplash.com/photo-1568605114967-8130f3a36994?w=800'),
      PieceMedia(type: 'photo', label: 'Chambre', assetPath: 'https://images.unsplash.com/photo-1540518614846-7eded433c457?w=800'),
      PieceMedia(type: 'video', label: 'Chambre', assetPath: 'https://www.w3schools.com/html/mov_bbb.mp4'),
      PieceMedia(type: 'photo', label: 'Douche',  assetPath: 'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?w=800'),
    ],
    securite: const [
      SecurityCheck(ok: true,  label: 'Propriétaire identifié CNIB validé'),
      SecurityCheck(ok: false, label: 'Titre foncier non encore transmis'),
      SecurityCheck(ok: false, label: 'Visite terrain à planifier'),
      SecurityCheck(ok: true,  label: 'Charges estimées, non vérifiées'),
      SecurityCheck(ok: false, label: '1 litige locatif précédent déclaré'),
    ],
    history: const [
      HistoryEvent(date: 'Déc 2025', event: 'Litige sur caution non restituée', ok: false, detail: 'En cours de résolution'),
      HistoryEvent(date: 'Sep 2025', event: 'Retard réparation plomberie',      ok: false),
      HistoryEvent(date: 'Mai 2025', event: 'Occupation paisible',              ok: true),
    ],
  ),

  // ── 3 · Mini Villa Dapoya (occupé) ──────────────────────
  Logement(
    id: 3,
    name: 'Mini Villa F5 — Blvd Moogo Naaba',
    description: 'Mini villa haut standing à Dapoya. Tout confort, propriétaire sérieux depuis 1998.',
    quartier: 'Dapoya', mapX: 0.75, mapY: 0.18, lieu: 'Centre Ville',
    category: LogementCategory.miniVilla,
    statut: LogementStatut.occupe,
    statutMaj: 'il y a 2h',
    loyer: 380000, charges: 45000, caution: 760000,
    coutEnergieMois: 35000, coutEauMois: 12000,
    distTravail: 3.1, carburant: 16000,
    surface: 230, pieces: 8,
    disponibleDes: '01/07/2026',
    verified: true, verifiePropr: true, visiteTerrain: true,
    trust: 99, propriScore: 99, scoreZone: 95, litiges: 0,
    colocationPossible: false, loyerParColoc: 0,
    services: const ScoreServices(
      eauScore: 96, elecScore: 92,
      coupuresEauMois: 0, coupuresElecMois: 1,
      commentaire: 'Excellente stabilité. Groupe électrogène en secours. Château d\'eau privé.',
    ),
    accessibilite: const ScoreAccessibilite(
      scoreSec: 98, scorePluie: 95,
      etatRoute: 'Bitumée · Boulevard principal',
      transportsDisponibles: ['Taxi', 'Moto-taxi', 'Sotraco ligne 2', 'Transport personnel'],
      commentaire: 'Accessibilité maximale. Boulevard bitumé toute l\'année.',
    ),
    optionsPaiement: _paiementsStandard,
    demarcheurs: _demarcheursDisponibles,
    loyerHistorique: const [
      LoyerHistorique(periode: '2024', montant: 360000),
      LoyerHistorique(periode: '2023', montant: 340000),
      LoyerHistorique(periode: '2022', montant: 320000),
    ],
    commodites: const [
      Commodite(id: 1, name: 'Eau ONEA'), Commodite(id: 2, name: 'Électricité SONABEL'),
      Commodite(id: 3, name: 'Climatisation'), Commodite(id: 4, name: 'Gardien'),
      Commodite(id: 5, name: 'Parking'), Commodite(id: 6, name: 'Cuisine équipée'),
      Commodite(id: 7, name: 'Internet fibre'),
    ],
    medias: const [
      PieceMedia(type: 'photo', label: 'Cour',    assetPath: 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=800'),
      PieceMedia(type: 'video', label: 'Cour',    assetPath: 'https://www.w3schools.com/html/mov_bbb.mp4'),
      PieceMedia(type: 'photo', label: 'Salon',   assetPath: 'https://images.unsplash.com/photo-1567767292278-a4f21aa2d36e?w=800'),
      PieceMedia(type: 'video', label: 'Salon',   assetPath: 'https://www.w3schools.com/html/mov_bbb.mp4'),
      PieceMedia(type: 'photo', label: 'Chambre', assetPath: 'https://images.unsplash.com/photo-1616594039964-ae9021a400a0?w=800'),
      PieceMedia(type: 'video', label: 'Chambre', assetPath: 'https://www.w3schools.com/html/mov_bbb.mp4'),
      PieceMedia(type: 'photo', label: 'Douche',  assetPath: 'https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?w=800'),
      PieceMedia(type: 'video', label: 'Douche',  assetPath: 'https://www.w3schools.com/html/mov_bbb.mp4'),
      PieceMedia(type: 'photo', label: 'Cuisine', assetPath: 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=800'),
      PieceMedia(type: 'video', label: 'Cuisine', assetPath: 'https://www.w3schools.com/html/mov_bbb.mp4'),
    ],
    securite: const [
      SecurityCheck(ok: true, label: 'Titre foncier authentifié notaire'),
      SecurityCheck(ok: true, label: 'Visite terrain mars 2026'),
      SecurityCheck(ok: true, label: 'Audit technique bâtiment'),
      SecurityCheck(ok: true, label: 'Zéro litige — propriétaire depuis 1998'),
      SecurityCheck(ok: true, label: 'CNIB + passeport + registre commerce validés'),
    ],
    history: const [
      HistoryEvent(date: 'Mars 2026', event: 'Occupé — dispo juil 2026',      ok: true),
      HistoryEvent(date: 'Jan 2026',  event: 'Remise en état complète',        ok: true),
      HistoryEvent(date: 'Oct 2025',  event: 'Locataire précédent : avis 5/5', ok: true),
    ],
  ),

  // ── 4 · Cour Unique Ouaga 2000 ───────────────────────────
  Logement(
    id: 4,
    name: 'Cour Unique F4 — Ouaga 2000 Résidence',
    description: 'Cour unique moderne dans la résidence Ouaga 2000. Gardiennage 24h, espace vert privatif.',
    quartier: 'Ouaga 2000', mapX: 0.50, mapY: 0.88, lieu: 'Plateau Central',
    category: LogementCategory.courUnique,
    statut: LogementStatut.disponible,
    statutMaj: 'il y a 5 min',
    loyer: 190000, charges: 25000, caution: 380000,
    coutEnergieMois: 15000, coutEauMois: 7000,
    distTravail: 6.8, carburant: 36000,
    surface: 110, pieces: 5,
    disponibleDes: '01/05/2026',
    verified: true, verifiePropr: true, visiteTerrain: true,
    trust: 93, propriScore: 90, scoreZone: 91, litiges: 0,
    colocationPossible: true, loyerParColoc: 105000,
    colocataires: [
      const ColocatairePotentiel(id: 2, prenom: 'Fatima', profession: 'Commerçante', ageApprox: 32, disponibilite: 'Dès le 01/05'),
      const ColocatairePotentiel(id: 3, prenom: 'Ibrahim', profession: 'Étudiant', ageApprox: 24, disponibilite: 'Flexible'),
    ],
    services: const ScoreServices(
      eauScore: 90, elecScore: 86,
      coupuresEauMois: 1, coupuresElecMois: 2,
      commentaire: 'Très bonne stabilité. Château d\'eau commun géré par la résidence.',
    ),
    accessibilite: const ScoreAccessibilite(
      scoreSec: 95, scorePluie: 88,
      etatRoute: 'Bitumée · Résidence sécurisée',
      transportsDisponibles: ['Taxi', 'Moto-taxi', 'Sotraco ligne 5'],
      commentaire: 'Excellente accessibilité. Route bitumée et résidence clôturée.',
    ),
    optionsPaiement: _paiementsStandard,
    demarcheurs: _demarcheursDisponibles,
    loyerHistorique: const [
      LoyerHistorique(periode: '2024', montant: 175000),
      LoyerHistorique(periode: '2023', montant: 160000),
    ],
    commodites: const [
      Commodite(id: 1, name: 'Eau ONEA'), Commodite(id: 2, name: 'Électricité SONABEL'),
      Commodite(id: 4, name: 'Gardien'), Commodite(id: 5, name: 'Parking'),
    ],
    medias: const [
      PieceMedia(type: 'photo', label: 'Cour',    assetPath: 'https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=800'),
      PieceMedia(type: 'video', label: 'Cour',    assetPath: 'https://www.w3schools.com/html/mov_bbb.mp4'),
      PieceMedia(type: 'photo', label: 'Salon',   assetPath: 'https://images.unsplash.com/photo-1505691938895-1758d7feb511?w=800'),
      PieceMedia(type: 'video', label: 'Salon',   assetPath: 'https://www.w3schools.com/html/mov_bbb.mp4'),
      PieceMedia(type: 'photo', label: 'Chambre', assetPath: 'https://images.unsplash.com/photo-1484154218962-a197022b5858?w=800'),
      PieceMedia(type: 'photo', label: 'Douche',  assetPath: 'https://images.unsplash.com/photo-1600566753151-384129cf4d3a?w=800'),
      PieceMedia(type: 'video', label: 'Douche',  assetPath: 'https://www.w3schools.com/html/mov_bbb.mp4'),
      PieceMedia(type: 'photo', label: 'Cuisine', assetPath: 'https://images.unsplash.com/photo-1565538810643-b5bdb714032a?w=800'),
      PieceMedia(type: 'video', label: 'Cuisine', assetPath: 'https://www.w3schools.com/html/mov_bbb.mp4'),
    ],
    securite: const [
      SecurityCheck(ok: true, label: 'Titre foncier authentifié notaire'),
      SecurityCheck(ok: true, label: 'Visite terrain fév 2026'),
      SecurityCheck(ok: true, label: 'Charges copropriété vérifiées'),
      SecurityCheck(ok: true, label: 'Zéro litige historique'),
      SecurityCheck(ok: true, label: 'Gardiennage 24h sécurisé'),
    ],
    history: const [
      HistoryEvent(date: 'Fév 2026',  event: 'Climatisation remplacée',                  ok: true),
      HistoryEvent(date: 'Nov 2025',  event: 'Quittances à jour',                         ok: true),
      HistoryEvent(date: 'Août 2025', event: 'Assemblée copropriété — décisions prises',  ok: true),
    ],
  ),
];
