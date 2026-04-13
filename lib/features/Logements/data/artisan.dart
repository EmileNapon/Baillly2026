// ============================================================
//  MODÈLE ARTISAN — Nidali / Bailly
// ============================================================

enum MetierType { macon, plombier, electricien, peintre, menuisier }

extension MetierTypeExt on MetierType {
  String get label {
    switch (this) {
      case MetierType.macon:       return 'Maçon';
      case MetierType.plombier:    return 'Plombier';
      case MetierType.electricien: return 'Électricien';
      case MetierType.peintre:     return 'Peintre';
      case MetierType.menuisier:   return 'Menuisier';
    }
  }

  String get emoji {
    switch (this) {
      case MetierType.macon:       return '🧱';
      case MetierType.plombier:    return '🔧';
      case MetierType.electricien: return '⚡';
      case MetierType.peintre:     return '🎨';
      case MetierType.menuisier:   return '🪚';
    }
  }

  // Couleur de fond avatar
  int get bgColor {
    switch (this) {
      case MetierType.macon:       return 0xFFE8EAF6;
      case MetierType.plombier:    return 0xFFE3F2FD;
      case MetierType.electricien: return 0xFFFFFDE7;
      case MetierType.peintre:     return 0xFFFCE4EC;
      case MetierType.menuisier:   return 0xFFFBE9E7;
    }
  }

  // Couleur texte avatar
  int get fgColor {
    switch (this) {
      case MetierType.macon:       return 0xFF3949AB;
      case MetierType.plombier:    return 0xFF0277BD;
      case MetierType.electricien: return 0xFFF9A825;
      case MetierType.peintre:     return 0xFFC62828;
      case MetierType.menuisier:   return 0xFFBF360C;
    }
  }
}

class Artisan {
  final int id;
  final String nom;
  final MetierType metier;
  final List<String> specialites;
  final List<String> zones;
  final int tarif;          // FCFA
  final String unite;       // 'jour' | 'intervention'
  final double note;        // 0-5
  final int missions;
  final bool verified;
  final bool disponible;
  final int experienceAns;
  final int litiges;
  final bool certifie;
  final String telephone;
  final String delaiReponse; // 'Répond en < 2h'

  const Artisan({
    required this.id,
    required this.nom,
    required this.metier,
    required this.specialites,
    required this.zones,
    required this.tarif,
    required this.unite,
    required this.note,
    required this.missions,
    required this.verified,
    required this.disponible,
    required this.experienceAns,
    this.litiges = 0,
    this.certifie = false,
    this.telephone = '',
    this.delaiReponse = 'Répond en < 2h',
  });

  String get tarifFmt {
    final s = tarif.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write('\u202F');
      buf.write(s[i]);
    }
    return '${buf.toString()} F/$unite';
  }
}

// ─────────────────────────────────────────────────────────────
// DONNÉES DE TEST
// ─────────────────────────────────────────────────────────────
final List<Artisan> sampleArtisans = [
  const Artisan(
    id: 0, nom: 'Moussa Kaboré',
    metier: MetierType.macon,
    specialites: ['Fondation', 'Carrelage', 'Enduit'],
    zones: ['Gounghin', 'Pissy'],
    tarif: 15000, unite: 'jour',
    note: 4.8, missions: 112,
    verified: true, disponible: true,
    experienceAns: 8, litiges: 0, certifie: true,
    telephone: '+226 70 12 34 56',
  ),
  const Artisan(
    id: 1, nom: 'Issouf Ouédraogo',
    metier: MetierType.plombier,
    specialites: ['Tuyauterie', 'Sanitaires', 'Fosse'],
    zones: ['Dapoya', 'Tampouy', 'Centre'],
    tarif: 12000, unite: 'intervention',
    note: 4.6, missions: 89,
    verified: true, disponible: true,
    experienceAns: 6, certifie: true,
    telephone: '+226 76 98 76 54',
  ),
  const Artisan(
    id: 2, nom: 'Adama Sawadogo',
    metier: MetierType.electricien,
    specialites: ['Câblage', 'Tableau élec.', 'Solaire'],
    zones: ['Ouaga 2000', 'Gounghin'],
    tarif: 18000, unite: 'jour',
    note: 4.9, missions: 204,
    verified: true, disponible: false,
    experienceAns: 11, certifie: true,
    telephone: '+226 71 55 43 21',
  ),
  const Artisan(
    id: 3, nom: 'Fatima Traoré',
    metier: MetierType.peintre,
    specialites: ['Intérieur', 'Décoration', 'Ravalement'],
    zones: ['Tous quartiers'],
    tarif: 10000, unite: 'jour',
    note: 4.7, missions: 67,
    verified: true, disponible: true,
    experienceAns: 5, certifie: false,
    telephone: '+226 65 33 21 87',
  ),
  const Artisan(
    id: 4, nom: 'Boureima Diallo',
    metier: MetierType.menuisier,
    specialites: ['Portes', 'Fenêtres', 'Meubles bois'],
    zones: ['Pissy', 'Tampouy'],
    tarif: 20000, unite: 'jour',
    note: 4.5, missions: 55,
    verified: true, disponible: true,
    experienceAns: 9, litiges: 1, certifie: true,
    telephone: '+226 70 87 65 43',
  ),
  const Artisan(
    id: 5, nom: 'Seydou Compaoré',
    metier: MetierType.macon,
    specialites: ['Construction', 'Rénovation'],
    zones: ['Dapoya', 'Ouaga 2000'],
    tarif: 14000, unite: 'jour',
    note: 4.3, missions: 78,
    verified: false, disponible: true,
    experienceAns: 4,
    telephone: '+226 76 21 98 54',
  ),
  const Artisan(
    id: 6, nom: 'Ali Zongo',
    metier: MetierType.plombier,
    specialites: ['Urgences', 'Canalisations'],
    zones: ['Pissy', 'Gounghin'],
    tarif: 15000, unite: 'intervention',
    note: 4.4, missions: 44,
    verified: true, disponible: false,
    experienceAns: 3,
    telephone: '+226 66 44 32 10',
  ),
  const Artisan(
    id: 7, nom: 'Rasmata Koné',
    metier: MetierType.electricien,
    specialites: ['Domotique', 'Groupe électrogène'],
    zones: ['Dapoya', 'Centre'],
    tarif: 22000, unite: 'jour',
    note: 4.8, missions: 130,
    verified: true, disponible: true,
    experienceAns: 14, certifie: true,
    telephone: '+226 70 99 88 77',
  ),
];
