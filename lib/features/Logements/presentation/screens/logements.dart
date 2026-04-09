// logements.dart — Écran principal Nidali
// Reprend exactement le rendu du mockup :
//   • AppBar vert #1D5C3A avec logo + badge "Certifié"
//   • Barre de filtres quartier (chips défilants)
//   • Barre catégories (Tous / Célibat / Mini villa / Cour unique)
//   • Fond #F7F5F0
//   • ListingCard (logements.dart inchangé)

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/listing.dart';

// ── Données de test (identiques au mockup HTML) ──────────────
final List<Logement> _kLogements = sampleLogements; // liste définie dans listing.dart

const List<String> _kQuartiers = [
  'Tous',
  'Ouaga 2000',
  'Gounghin',
  'Pissy',
  'Tampouy',
  'Dapoya',
  'Cissin',
  'Zogona',
];

const List<_CatItem> _kCats = [
  _CatItem('tous',        'Tous'),
  _CatItem('celibat',     'Célibat'),
  _CatItem('mini_villa',  'Mini villa'),
  _CatItem('cour_unique', 'Cour unique'),
];

class _CatItem {
  final String value;
  final String label;
  const _CatItem(this.value, this.label);
}

// ── Écran ─────────────────────────────────────────────────────
class LogementsScreen extends StatefulWidget {
  const LogementsScreen({super.key});

  @override
  State<LogementsScreen> createState() => _LogementsScreenState();
}

class _LogementsScreenState extends State<LogementsScreen> {
  String _selQuartier = 'Tous';
  String _selCat      = 'tous';

  List<Logement> get _filtered => _kLogements.where((l) {
        if (_selQuartier != 'Tous' && l.quartier != _selQuartier) return false;
        if (_selCat != 'tous'      && l.category  != _selCat)     return false;
        return true;
      }).toList();

  @override
  Widget build(BuildContext context) {
    final items = _filtered;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F0),
      // ── AppBar ──────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D5C3A),
        elevation: 0,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Logo box
              Container(
                width: 30, height: 30,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.home_rounded, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 10),
              // Titre + sous-titre
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nidali',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.2,
                    ),
                  ),
                  Text(
                    'Logements vérifiés · Ouagadougou',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 10,
                      color: Colors.white.withOpacity(0.65),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Badge Certifié
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check, color: Colors.white, size: 10),
                    const SizedBox(width: 4),
                    Text(
                      'Certifié',
                      style: GoogleFonts.nunitoSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Filtres ─────────────────────────────────────────
          Container(
            color: Colors.white,
            child: Column(
              children: [
                // Chips quartier
                SizedBox(
                  height: 42,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemCount: _kQuartiers.length,
                    itemBuilder: (_, i) {
                      final q = _kQuartiers[i];
                      final active = _selQuartier == q;
                      return GestureDetector(
                        onTap: () => setState(() => _selQuartier = q),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
                          decoration: BoxDecoration(
                            color: active ? const Color(0xFF1D5C3A) : const Color(0xFFF7F5F0),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: active ? const Color(0xFF1D5C3A) : const Color(0xFFE0E0E0),
                            ),
                          ),
                          child: Text(
                            q == 'Ouaga 2000' ? '★ $q' : q,
                            style: GoogleFonts.nunitoSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: active ? Colors.white : const Color(0xFF555555),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Chips catégorie
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 14, right: 14, bottom: 10),
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemCount: _kCats.length,
                    itemBuilder: (_, i) {
                      final c = _kCats[i];
                      final active = _selCat == c.value;
                      return GestureDetector(
                        onTap: () => setState(() => _selCat = c.value),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: active ? const Color(0xFFEAF5EE) : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: active ? const Color(0xFF1D5C3A) : const Color(0xFFE0E0E0),
                              width: active ? 1.5 : 1,
                            ),
                          ),
                          child: Text(
                            c.label,
                            style: GoogleFonts.nunitoSans(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              color: active ? const Color(0xFF1D5C3A) : const Color(0xFF666666),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(height: 1, color: Color(0xFFEEEEEE)),
              ],
            ),
          ),

          // ── Compteur ────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 2),
            child: Text(
              '${items.length} logement${items.length > 1 ? 's' : ''} '
              'trouvé${items.length > 1 ? 's' : ''}',
              style: GoogleFonts.nunitoSans(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF888888),
              ),
            ),
          ),

          // ── Liste ────────────────────────────────────────────
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.search_off_rounded,
                            size: 40, color: Color(0xFFCCCCCC)),
                        const SizedBox(height: 10),
                        Text(
                          'Aucun logement dans cette sélection',
                          style: GoogleFonts.nunitoSans(
                              fontSize: 13, color: const Color(0xFFAAAAAA)),
                        ),
                        Text(
                          'Essayez un autre quartier',
                          style: GoogleFonts.nunitoSans(
                              fontSize: 11, color: const Color(0xFFCCCCCC)),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemCount: items.length,
                    itemBuilder: (_, i) => ListingCard(
                      listing: items[i],
                      isActive: false,
                      onTap: () {
                        // TODO: navigation vers le détail
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  LISTING CARD (reprise de logements.dart, inchangée)
// ══════════════════════════════════════════════════════════════

class ListingCard extends StatelessWidget {
  final Logement listing;
  final bool isActive;
  final VoidCallback onTap;

  const ListingCard({
    super.key,
    required this.listing,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l = listing;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? const Color(0xFF1D5C3A) : const Color(0xFFECECEC),
            width: isActive ? 1.8 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image ──────────────────────────────────────
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              child: Stack(
                children: [
                  l.medias.isNotEmpty
                      ? Image.network(
                          l.medias.first.assetPath,
                          height: 140,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _imgPlaceholder(l),
                        )
                      : _imgPlaceholder(l),
                  Positioned(
                      top: 10, left: 10,
                      child: _StatutBadge(statut: l.statut)),
                  Positioned(
                      top: 10, right: 10,
                      child: _TrustBadge(trust: l.trust)),
                ],
              ),
            ),

            // ── Corps ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(13, 11, 13, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nom + Prix
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          l.name,
                          style: GoogleFonts.nunitoSans(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF111111),
                            height: 1.3,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${_fmt(l.loyer)} F',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF1D5C3A),
                            ),
                          ),
                          Text(
                            '+${_fmt(l.charges)} charges',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 10,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 7),

                  // Tags
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      _Tag(
                        label: LogementCategory.label(l.category),
                        bg: const Color(0xFFF0F0F0),
                        fg: const Color(0xFF555555),
                      ),
                      if (l.colocationPossible)
                        _Tag(
                          label: 'Coloc possible',
                          bg: const Color(0xFFEDE7F6),
                          fg: const Color(0xFF4527A0),
                        ),
                      if (l.litiges > 0)
                        _Tag(
                          label: '⚠ ${l.litiges} litige',
                          bg: const Color(0xFFFFF8E1),
                          fg: const Color(0xFFF57F17),
                        ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  const Divider(height: 1, color: Color(0xFFF0F0F0)),
                  const SizedBox(height: 8),

                  // Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _Stat(icon: Icons.crop_square_rounded, label: '${l.surface} m²'),
                      _Stat(icon: Icons.bed_rounded, label: '${l.pieces} pièces'),
                      _Stat(icon: Icons.location_on_outlined, label: '${l.distTravail} km'),
                      _Stat(
                        icon: Icons.star_rounded,
                        label: '${l.trust}/100',
                        color: l.trust >= 85
                            ? const Color(0xFF1D5C3A)
                            : l.trust >= 65
                                ? const Color(0xFFF57F17)
                                : const Color(0xFFC62828),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  const Divider(height: 1, color: Color(0xFFF0F0F0)),
                  const SizedBox(height: 8),

                  // Commodités + vérifié
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: l.commodites
                              .take(4)
                              .map((c) => _ComDot(name: c.name))
                              .toList(),
                        ),
                      ),
                      if (l.verified)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.verified_rounded,
                                size: 13, color: Color(0xFF1D5C3A)),
                            const SizedBox(width: 3),
                            Text(
                              'Vérifié',
                              style: GoogleFonts.nunitoSans(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1D5C3A),
                              ),
                            ),
                          ],
                        )
                      else
                        Text(
                          'Non vérifié',
                          style: GoogleFonts.nunitoSans(
                            fontSize: 10.5,
                            color: Colors.orange[700],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imgPlaceholder(Logement l) => Container(
        height: 140,
        width: double.infinity,
        color: const Color(0xFFE8F5E9),
        child: Center(
          child: Icon(
            l.category == LogementCategory.miniVilla
                ? Icons.villa_rounded
                : l.category == LogementCategory.celibat
                    ? Icons.bed_rounded
                    : Icons.home_rounded,
            size: 40,
            color: const Color(0xFF5DCAA5),
          ),
        ),
      );

  String _fmt(int n) => n
      .toString()
      .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => '\u202f');
}

// ── Widgets internes ──────────────────────────────────────────

class _StatutBadge extends StatelessWidget {
  final String statut;
  const _StatutBadge({required this.statut});
  @override
  Widget build(BuildContext context) {
    final dispo = LogementStatut.isAvailable(statut);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: dispo ? Colors.white : Colors.orange[50],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6, height: 6,
            decoration: BoxDecoration(
              color: dispo ? const Color(0xFF1D5C3A) : Colors.orange,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            dispo ? 'Disponible' : 'Occupé',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: dispo ? const Color(0xFF1D5C3A) : Colors.orange[800],
            ),
          ),
        ],
      ),
    );
  }
}

class _TrustBadge extends StatelessWidget {
  final int trust;
  const _TrustBadge({required this.trust});
  @override
  Widget build(BuildContext context) {
    final color = trust >= 85
        ? const Color(0xFF1D5C3A)
        : trust >= 65
            ? const Color(0xFFF57F17)
            : const Color(0xFFC62828);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, size: 11, color: color),
          const SizedBox(width: 2),
          Text(
            '$trust',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: color),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color bg, fg;
  const _Tag({required this.label, required this.bg, required this.fg});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            color: fg,
          ),
        ),
      );
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  const _Stat({required this.icon, required this.label, this.color});
  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color ?? Colors.grey[600]),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color ?? Colors.grey[600],
              fontWeight: color != null ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ],
      );
}

class _ComDot extends StatelessWidget {
  final String name;
  const _ComDot({required this.name});

  static const _colors = {
    'Eau ONEA':            Color(0xFF378ADD),
    'Électricité SONABEL': Color(0xFFE8A838),
    'Climatisation':       Color(0xFF5DCAA5),
    'Gardien':             Color(0xFF8D6E63),
    'Parking':             Color(0xFF888888),
    'Internet fibre':      Color(0xFF7B1FA2),
  };

  @override
  Widget build(BuildContext context) {
    final color = _colors[name] ?? const Color(0xFFAAAAAA);
    final short = name
        .replaceAll(' ONEA', '')
        .replaceAll(' SONABEL', '');
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6, height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 3),
        Text(short,
            style: const TextStyle(fontSize: 10, color: Color(0xFF666666))),
      ],
    );
  }
}