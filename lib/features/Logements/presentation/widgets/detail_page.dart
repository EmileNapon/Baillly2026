// detail_page.dart — Page détail Nidali
// Reproduit exactement le mockup nidali_detail_page.html
// Tabs : Aperçu · Média · Localisation · Vérifié · Historique

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/listing.dart';

// ─────────────────────────────────────────────────────────────
//  COULEURS & HELPERS
// ─────────────────────────────────────────────────────────────
const _green  = Color(0xFF1D5C3A);
const _greenL = Color(0xFFEAF5EE);
const _bg     = Color(0xFFF7F5F0);
const _amber  = Color(0xFFF57F17);
const _amberL = Color(0xFFFFF8E1);
const _red    = Color(0xFFC62828);
const _redL   = Color(0xFFFFEBEE);
const _blue   = Color(0xFF0070CC);
const _blueL  = Color(0xFFE3EDF9);
const _border = Color(0xFFECECEC);
const _t1     = Color(0xFF111111);
const _t2     = Color(0xFF4A5568);
const _t3     = Color(0xFF888888);

String _fmt(int n) =>
    n.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => '\u202f');

Color _trustColor(int t) =>
    t >= 85 ? _green : t >= 65 ? _amber : _red;

// ─────────────────────────────────────────────────────────────
//  SCREEN
// ─────────────────────────────────────────────────────────────
class DetailPage extends StatefulWidget {
  final Logement listing;
  const DetailPage({super.key, required this.listing});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  static const _tabLabels = [
    ('Aperçu',       Icons.info_outline_rounded),
    ('Média',        Icons.image_outlined),
    ('Localisation', Icons.location_on_outlined),
    ('Vérifié',      Icons.shield_outlined),
    ('Historique',   Icons.history_rounded),
  ];

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: _tabLabels.length, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = widget.listing;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F0),
      // ── AppBar ─────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: _green,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.maybePop(context),
          child: Center(
            child: Container(
              width: 28, height: 28,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.chevron_left_rounded,
                  color: Colors.white, size: 18),
            ),
          ),
        ),
        title: Text(
          l.name,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.nunitoSans(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: _Badge(
              label: l.visiteTerrain ? 'Terrain vérifié' : 'Non vérifié',
              bg: l.visiteTerrain
                  ? _greenL
                  : _redL.withOpacity(0.85),
              fg: l.visiteTerrain ? _green : _red,
              icon: l.visiteTerrain
                  ? Icons.check_rounded
                  : Icons.close_rounded,
            ),
          ),
        ],
        // ── TabBar ───────────────────────────────────────────
        bottom: TabBar(
          
          controller: _tabs,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorColor: const Color.fromARGB(255, 65, 161, 110),
          indicatorWeight: 2.5,
          labelColor: const Color.fromARGB(255, 99, 100, 99),
          unselectedLabelColor: const Color.fromARGB(255, 198, 198, 198),
          labelStyle: GoogleFonts.nunitoSans(
              fontSize: 11.5, fontWeight: FontWeight.w700),
          unselectedLabelStyle:
              GoogleFonts.nunitoSans(fontSize: 11.5, fontWeight: FontWeight.w500),
          tabs: _tabLabels
              .map((t) => Tab(
                    height: 40,
                    child: Row(
                      children: [
                        Icon(t.$2, size: 12),
                        const SizedBox(width: 4),
                        Text(t.$1),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ),

      // ── TabBarView ─────────────────────────────────────────
      body: TabBarView(
        controller: _tabs,
        children: [
          _TabApercu(l: l),
          _TabMedia(l: l),
          _TabLocalisation(l: l),
          _TabVerifie(l: l),
          _TabHistorique(l: l),
        ],
      ),
    );
  }
}





// ─────────────────────────────────────────────────────────────
//  TAB 1 — APERÇU
// ─────────────────────────────────────────────────────────────
class _TabApercu extends StatelessWidget {
  final Logement l;
  const _TabApercu({required this.l});

  @override
  Widget build(BuildContext context) {
    final total = l.loyer + l.charges + l.carburant +
        l.coutEnergieMois + l.coutEauMois;

    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 32),
      children: [

        // ── Carte principale ─────────────────────────────────
        _Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
                child: l.medias.isNotEmpty
                    ? Image.network(
                        l.medias.first.assetPath,
                        height: 150, width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _ImgPlaceholder(l),
                      )
                    : _ImgPlaceholder(l),
              ),
              Padding(
                padding: const EdgeInsets.all(13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l.name,
                                  style: GoogleFonts.nunitoSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: _t1)),
                              const SizedBox(height: 3),
                              Row(children: [
                                const Icon(Icons.location_on_outlined,
                                    size: 11, color: _t3),
                                const SizedBox(width: 2),
                                Expanded(
                                  child: Text(
                                    '${l.quartier} · ${LogementCategory.label(l.category)} · ${l.surface} m² · ${l.pieces} pièces',
                                    style: GoogleFonts.nunitoSans(
                                        fontSize: 11, color: _t3),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ]),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        _StatutDot(statut: l.statut),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text('${_fmt(l.loyer)} FCFA',
                            style: GoogleFonts.nunitoSans(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: _green)),
                        const SizedBox(width: 5),
                        Text('/mois',
                            style: GoogleFonts.nunitoSans(
                                fontSize: 11, color: _t3)),
                      ],
                    ),
                    Text('Total réel : ${_fmt(total)} FCFA/mois',
                        style: GoogleFonts.nunitoSans(
                            fontSize: 11, color: _t3)),
                    if (l.description.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(l.description,
                          style: GoogleFonts.nunitoSans(
                              fontSize: 12,
                              color: _t2,
                              height: 1.5)),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // ── Statut temps réel ────────────────────────────────
        _StatutTempsReel(l: l),
        const SizedBox(height: 14),

        // ── Score confiance ──────────────────────────────────
        _SecLabel('Score de confiance'),
        const SizedBox(height: 8),
        Row(children: [
          _ScoreBox(icon: Icons.home_rounded, label: 'Logement', score: l.trust),
          const SizedBox(width: 8),
          _ScoreBox(icon: Icons.person_rounded, label: 'Propriétaire',
              score: l.propriScore.round()),
          const SizedBox(width: 8),
          _ScoreBox(icon: Icons.business_rounded, label: 'Zone',
              score: l.scoreZone),
        ]),
        const SizedBox(height: 14),

        // ── Coût total détaillé ──────────────────────────────
        _SecLabel('Coût total détaillé'),
        const SizedBox(height: 8),
        _Card(
          child: Column(
            children: [
              _CostRow('Loyer', l.loyer),
              _CostRow('Charges', l.charges),
              _CostRow('Carburant', l.carburant),
              _CostRow('Électricité (est.)', l.coutEnergieMois),
              _CostRow('Eau (est.)', l.coutEauMois),
              _CostTotal('Total réel', total),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(children: [
          const Icon(Icons.calendar_today_outlined, size: 12, color: _t3),
          const SizedBox(width: 6),
          Text('Disponible dès : ',
              style: GoogleFonts.nunitoSans(fontSize: 12, color: _t2)),
          Text(l.disponibleDes,
              style: GoogleFonts.nunitoSans(
                  fontSize: 12, fontWeight: FontWeight.w700, color: _t1)),
        ]),
        const SizedBox(height: 14),

        // ── Transport ────────────────────────────────────────
        _SecLabel('Coût transport · ${l.lieu}'),
        const SizedBox(height: 8),
        _TransportCard(l: l),
        const SizedBox(height: 14),

        // ── Services eau & élec ──────────────────────────────
        if (l.services != null) ...[
          _SecLabel('Qualité services eau & électricité'),
          const SizedBox(height: 8),
          _ServicesCard(s: l.services!),
          const SizedBox(height: 14),
        ],

        // ── Accessibilité ─────────────────────────────────────
        if (l.accessibilite != null) ...[
          _SecLabel('Accessibilité saison sèche & pluie'),
          const SizedBox(height: 8),
          _AccessibiliteCard(a: l.accessibilite!),
          const SizedBox(height: 14),
        ],

        // ── Colocation ───────────────────────────────────────
        if (l.colocationPossible && l.colocataires.isNotEmpty) ...[
          _SecLabel('Colocation disponible'),
          const SizedBox(height: 8),
          _ColocCard(l: l),
          const SizedBox(height: 14),
        ],

        // ── Commodités ───────────────────────────────────────
        _SecLabel('Commodités'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6, runSpacing: 6,
          children: l.commodites.map((c) => _CommoditePill(c)).toList(),
        ),
        const SizedBox(height: 14),

        // ── Options paiement ─────────────────────────────────
        _SecLabel('Options de paiement'),
        const SizedBox(height: 8),
        ...l.optionsPaiement.map((p) => _PayRow(p: p)),
        const SizedBox(height: 14),

        // ── Démarcheurs ──────────────────────────────────────
        if (l.demarcheurs.isNotEmpty) ...[
          _SecLabel('Démarcheurs disponibles'),
          const SizedBox(height: 8),
          ...l.demarcheurs.map((d) => _DemRow(d: d)),
          const SizedBox(height: 14),
        ],

        // ── CTA ──────────────────────────────────────────────
        _CtaBtn(
          label: 'Demander une visite escortée',
          icon: Icons.shield_outlined,
          bg: _green,
          fg: Colors.white,
          onTap: () {},
        ),
        const SizedBox(height: 9),
        _CtaBtn(
          label: 'Signaler un problème',
          icon: Icons.flag_outlined,
          bg: _redL,
          fg: _red,
          border: _red.withOpacity(0.2),
          onTap: () {},
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  TAB 2 — MÉDIA
// ─────────────────────────────────────────────────────────────
class _TabMedia extends StatelessWidget {
  final Logement l;
  const _TabMedia({required this.l});

  @override
  Widget build(BuildContext context) {
    if (l.medias.isEmpty) {
      return const Center(
          child: Text('Aucun média disponible',
              style: TextStyle(color: _t3)));
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 32),
      children: [
        _SecLabel('${l.medias.length} médias · ${l.name}'),
        const SizedBox(height: 10),
        ...l.medias.map((m) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(13)),
                      child: m.type == 'photo'
                          ? Image.network(
                              m.assetPath,
                              height: 180, width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  _ImgPlaceholder(l),
                            )
                          : Container(
                              height: 120,
                              color: _green.withOpacity(0.1),
                              child: const Center(
                                child: Icon(Icons.play_circle_fill_rounded,
                                    size: 48, color: _green),
                              ),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
                      child: Row(children: [
                        Icon(
                          m.type == 'photo'
                              ? Icons.image_outlined
                              : Icons.videocam_outlined,
                          size: 13, color: _t3,
                        ),
                        const SizedBox(width: 5),
                        Text('${m.label} · ${m.type}',
                            style: GoogleFonts.nunitoSans(
                                fontSize: 12, color: _t2)),
                      ]),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  TAB 3 — LOCALISATION
// ─────────────────────────────────────────────────────────────
class _TabLocalisation extends StatelessWidget {
  final Logement l;
  const _TabLocalisation({required this.l});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 32),
      children: [
        _SecLabel('Localisation · ${l.quartier}'),
        const SizedBox(height: 8),

        // Carte placeholder
        _Card(
          child: Column(
            children: [
              Container(
                height: 180, width: double.infinity,
                decoration: BoxDecoration(
                  color: _greenL,
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(13)),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.map_outlined,
                          size: 40, color: _green),
                      const SizedBox(height: 8),
                      Text(l.quartier,
                          style: GoogleFonts.nunitoSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: _green)),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(13),
                child: Column(children: [
                  _InfoRow(
                    icon: Icons.location_on_outlined,
                    label: 'Quartier',
                    value: l.quartier,
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(
                    icon: Icons.work_outline_rounded,
                    label: 'Zone de travail',
                    value: l.lieu,
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(
                    icon: Icons.directions_car_outlined,
                    label: 'Distance travail',
                    value: '${l.distTravail} km',
                  ),
                ]),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        if (l.accessibilite != null) ...[
          _SecLabel('Accessibilité'),
          const SizedBox(height: 8),
          _AccessibiliteCard(a: l.accessibilite!),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  TAB 4 — VÉRIFIÉ
// ─────────────────────────────────────────────────────────────
class _TabVerifie extends StatelessWidget {
  final Logement l;
  const _TabVerifie({required this.l});

  @override
  Widget build(BuildContext context) {
    final ok = l.securite.where((s) => s.ok).length;
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 32),
      children: [
        _SecLabel(
            'Vérification & sûreté · $ok/${l.securite.length} validés'),
        const SizedBox(height: 8),
        ...l.securite.map((s) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: _CheckRow(check: s),
            )),
        const SizedBox(height: 14),

        // Score confiance
        _SecLabel('Score de confiance'),
        const SizedBox(height: 8),
        Row(children: [
          _ScoreBox(
              icon: Icons.home_rounded,
              label: 'Logement',
              score: l.trust),
          const SizedBox(width: 8),
          _ScoreBox(
              icon: Icons.person_rounded,
              label: 'Propriétaire',
              score: l.propriScore.round()),
          const SizedBox(width: 8),
          _ScoreBox(
              icon: Icons.business_rounded,
              label: 'Zone',
              score: l.scoreZone),
        ]),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  TAB 5 — HISTORIQUE
// ─────────────────────────────────────────────────────────────
class _TabHistorique extends StatelessWidget {
  final Logement l;
  const _TabHistorique({required this.l});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 32),
      children: [
        _SecLabel(
            'Historique · propriétaire score ${l.propriScore.round()}/100'),
        const SizedBox(height: 8),

        _Card(
          child: Column(
            children: l.history
                .asMap()
                .entries
                .map((e) => _HistRow(
                      event: e.value,
                      last: e.key == l.history.length - 1,
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 14),

        // Évolution des loyers
        if (l.loyerHistorique.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: _bg,
              border: Border.all(color: _border),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Évolution des loyers',
                    style: GoogleFonts.nunitoSans(
                        fontSize: 11, color: _t3)),
                const SizedBox(height: 8),
                Row(
                  children: l.loyerHistorique
                      .take(4)
                      .map((h) => Expanded(
                            child: Column(children: [
                              Text('${_fmt(h.montant)} F',
                                  style: GoogleFonts.nunitoSans(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                      color: _green),
                                  textAlign: TextAlign.center),
                              Text(h.periode,
                                  style: GoogleFonts.nunitoSans(
                                      fontSize: 10, color: _t3),
                                  textAlign: TextAlign.center),
                            ]),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  WIDGETS RÉUTILISABLES
// ─────────────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});
  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _border),
        ),
        child: child,
      );
}

class _SecLabel extends StatelessWidget {
  final String text;
  const _SecLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(
        text.toUpperCase(),
        style: GoogleFonts.nunitoSans(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
          color: const Color(0xFF667788),
        ),
      );
}

class _Badge extends StatelessWidget {
  final String label;
  final Color bg, fg;
  final IconData icon;
  const _Badge(
      {required this.label,
      required this.bg,
      required this.fg,
      required this.icon});
  @override
  Widget build(BuildContext context) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
            color: bg, borderRadius: BorderRadius.circular(20)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 10, color: fg),
          const SizedBox(width: 4),
          Text(label,
              style: GoogleFonts.nunitoSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: fg)),
        ]),
      );
}

class _StatutDot extends StatelessWidget {
  final String statut;
  const _StatutDot({required this.statut});
  @override
  Widget build(BuildContext context) {
    final dispo = LogementStatut.isAvailable(statut);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: dispo ? _greenL : _amberL,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 6, height: 6,
          decoration: BoxDecoration(
            color: dispo ? _green : _amber,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          LogementStatut.label(statut),
          style: GoogleFonts.nunitoSans(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: dispo ? _green : _amber,
          ),
        ),
      ]),
    );
  }
}

class _StatutTempsReel extends StatelessWidget {
  final Logement l;
  const _StatutTempsReel({required this.l});
  @override
  Widget build(BuildContext context) {
    final dispo = LogementStatut.isAvailable(l.statut);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
      decoration: BoxDecoration(
        color: dispo ? _greenL : _amberL,
        border: Border.all(
          color: (dispo ? _green : _amber).withOpacity(0.25),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(children: [
        Container(
          width: 10, height: 10,
          decoration: BoxDecoration(
            color: dispo ? _green : _amber,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            LogementStatut.label(l.statut),
            style: GoogleFonts.nunitoSans(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: dispo ? _green : _amber),
          ),
        ),
        Text('Mis à jour ${l.statutMaj}',
            style: GoogleFonts.nunitoSans(
                fontSize: 10.5, color: _t3)),
      ]),
    );
  }
}

class _ScoreBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final int score;
  const _ScoreBox(
      {required this.icon, required this.label, required this.score});
  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _greenL,
            border: Border.all(color: _green.withOpacity(0.15)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Icon(icon, size: 12, color: _green),
                const SizedBox(width: 4),
                Text(label,
                    style: GoogleFonts.nunitoSans(
                        fontSize: 10, color: _green)),
              ]),
              const SizedBox(height: 5),
              Text('$score/100',
                  style: GoogleFonts.nunitoSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: _trustColor(score))),
              const SizedBox(height: 6),
              LinearProgressIndicator(
                value: score / 100,
                backgroundColor: const Color(0xFFE0E0E0),
                valueColor:
                    AlwaysStoppedAnimation(_trustColor(score)),
                minHeight: 4,
                borderRadius: BorderRadius.circular(2),
              ),
            ],
          ),
        ),
      );
}

class _CostRow extends StatelessWidget {
  final String label;
  final int amount;
  const _CostRow(this.label, this.amount);
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFF5F5F5))),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: GoogleFonts.nunitoSans(
                    fontSize: 12, color: _t2)),
            Text('${_fmt(amount)} FCFA',
                style: GoogleFonts.nunitoSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _t1)),
          ],
        ),
      );
}

class _CostTotal extends StatelessWidget {
  final String label;
  final int amount;
  const _CostTotal(this.label, this.amount);
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: _greenL,
          borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(13)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: GoogleFonts.nunitoSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _green)),
            Text('${_fmt(amount)} FCFA',
                style: GoogleFonts.nunitoSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _green)),
          ],
        ),
      );
}

class _TransportCard extends StatelessWidget {
  final Logement l;
  const _TransportCard({required this.l});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: _greenL,
          border: Border.all(color: _green.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Icon(Icons.directions_car_outlined,
                  size: 14, color: _green),
              const SizedBox(width: 6),
              Text('Vers ${l.lieu}',
                  style: GoogleFonts.nunitoSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: _green)),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              _TransportStat(
                icon: Icons.navigation_outlined,
                value: '${l.distTravail} km',
                label: 'Distance',
              ),
              _TransportStat(
                icon: Icons.local_gas_station_outlined,
                value: '${_fmt(l.carburant)} F',
                label: 'Carburant/mois',
              ),
              _TransportStat(
                icon: Icons.access_time_rounded,
                value: '${(l.distTravail / 0.5).round()} min',
                label: 'Trajet estimé',
              ),
            ]),
          ],
        ),
      );
}

class _TransportStat extends StatelessWidget {
  final IconData icon;
  final String value, label;
  const _TransportStat(
      {required this.icon, required this.value, required this.label});
  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(children: [
          Icon(icon, size: 13, color: _green),
          const SizedBox(height: 3),
          Text(value,
              style: GoogleFonts.nunitoSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: _green)),
          Text(label,
              style: GoogleFonts.nunitoSans(
                  fontSize: 10, color: _t3),
              textAlign: TextAlign.center),
        ]),
      );
}

class _ServicesCard extends StatelessWidget {
  final ScoreServices s;
  const _ServicesCard({required this.s});
  @override
  Widget build(BuildContext context) => _Card(
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Column(
            children: [
              Row(children: [
                _ServiceCol(
                  icon: Icons.water_drop_outlined,
                  iconColor: const Color(0xFF378ADD),
                  label: 'Eau ONEA',
                  score: s.eauScore,
                  coupures: s.coupuresEauMois,
                ),
                const SizedBox(width: 12),
                _ServiceCol(
                  icon: Icons.bolt_rounded,
                  iconColor: const Color(0xFFE8A838),
                  label: 'Électricité',
                  score: s.elecScore,
                  coupures: s.coupuresElecMois,
                ),
              ]),
              if (s.commentaire.isNotEmpty) ...[
                const SizedBox(height: 9),
                Text(s.commentaire,
                    style: GoogleFonts.nunitoSans(
                        fontSize: 11, color: _t2)),
              ],
            ],
          ),
        ),
      );
}

class _ServiceCol extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final int score, coupures;
  const _ServiceCol(
      {required this.icon,
      required this.iconColor,
      required this.label,
      required this.score,
      required this.coupures});
  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(icon, size: 12, color: iconColor),
              const SizedBox(width: 4),
              Text(label,
                  style: GoogleFonts.nunitoSans(
                      fontSize: 11, color: _t3)),
            ]),
            const SizedBox(height: 4),
            Text('$score/100',
                style: GoogleFonts.nunitoSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: _trustColor(score))),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: score / 100,
              backgroundColor: const Color(0xFFE0E0E0),
              valueColor:
                  AlwaysStoppedAnimation(_trustColor(score)),
              minHeight: 4,
              borderRadius: BorderRadius.circular(2),
            ),
            const SizedBox(height: 4),
            Text('$coupures coupure${coupures > 1 ? 's' : ''}/mois',
                style: GoogleFonts.nunitoSans(
                    fontSize: 10, color: _t3)),
          ],
        ),
      );
}

class _AccessibiliteCard extends StatelessWidget {
  final ScoreAccessibilite a;
  const _AccessibiliteCard({required this.a});
  @override
  Widget build(BuildContext context) => _Card(
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Saison sèche',
                          style: GoogleFonts.nunitoSans(
                              fontSize: 10, color: _t3)),
                      const SizedBox(height: 4),
                      Text('${a.scoreSec}/100',
                          style: GoogleFonts.nunitoSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: _trustColor(a.scoreSec))),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: a.scoreSec / 100,
                        backgroundColor: const Color(0xFFE0E0E0),
                        valueColor: AlwaysStoppedAnimation(
                            _trustColor(a.scoreSec)),
                        minHeight: 4,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Saison pluies',
                          style: GoogleFonts.nunitoSans(
                              fontSize: 10, color: _t3)),
                      const SizedBox(height: 4),
                      Text('${a.scorePluie}/100',
                          style: GoogleFonts.nunitoSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: _trustColor(a.scorePluie))),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: a.scorePluie / 100,
                        backgroundColor: const Color(0xFFE0E0E0),
                        valueColor: AlwaysStoppedAnimation(
                            _trustColor(a.scorePluie)),
                        minHeight: 4,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ],
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                const Icon(Icons.navigation_outlined,
                    size: 11, color: _t3),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(a.etatRoute,
                      style: GoogleFonts.nunitoSans(
                          fontSize: 11.5, color: _t1)),
                ),
              ]),
              const SizedBox(height: 6),
              Wrap(
                spacing: 5, runSpacing: 5,
                children: a.transportsDisponibles
                    .map((t) => _Pill(t))
                    .toList(),
              ),
            ],
          ),
        ),
      );
}

class _ColocCard extends StatelessWidget {
  final Logement l;
  const _ColocCard({required this.l});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: _blueL,
          border: Border.all(color: _blue.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Icon(Icons.group_outlined, size: 14, color: _blue),
              const SizedBox(width: 7),
              Text(
                'Coloc possible · ${_fmt(l.loyerParColoc)} FCFA/pers',
                style: GoogleFonts.nunitoSans(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: _blue),
              ),
            ]),
            const SizedBox(height: 10),
            ...l.colocataires.map((c) => Padding(
                  padding: const EdgeInsets.only(bottom: 7),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: _border),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(children: [
                      _Avatar(label: c.prenom[0],
                          bg: _blueL, fg: _blue),
                      const SizedBox(width: 10),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c.prenom,
                              style: GoogleFonts.nunitoSans(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: _t1)),
                          Text('${c.profession} · ~${c.ageApprox} ans',
                              style: GoogleFonts.nunitoSans(
                                  fontSize: 11, color: _t3)),
                        ],
                      )),
                      Text(c.disponibilite,
                          style: GoogleFonts.nunitoSans(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: _green)),
                    ]),
                  ),
                )),
          ],
        ),
      );
}

class _CheckRow extends StatelessWidget {
  final SecurityCheck check;
  const _CheckRow({required this.check});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: check.ok
              ? const Color(0xFFEAF5EE).withOpacity(0.6)
              : const Color(0xFFFFEBEE).withOpacity(0.6),
          border: Border.all(
            color: check.ok
                ? _green.withOpacity(0.15)
                : _red.withOpacity(0.15),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(children: [
          Container(
            width: 20, height: 20,
            decoration: BoxDecoration(
              color: check.ok ? _green : _red,
              shape: BoxShape.circle,
            ),
            child: Icon(
              check.ok ? Icons.check_rounded : Icons.close_rounded,
              size: 12, color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              check.label,
              style: GoogleFonts.nunitoSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _t1),
            ),
          ),
        ]),
      );
}

class _HistRow extends StatelessWidget {
  final HistoryEvent event;
  final bool last;
  const _HistRow({required this.event, required this.last});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(14, 9, 14, 9),
        decoration: BoxDecoration(
          border: last
              ? null
              : const Border(
                  bottom: BorderSide(color: Color(0xFFF5F5F5))),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Icon(
            event.ok
                ? Icons.check_circle_rounded
                : Icons.cancel_rounded,
            size: 14,
            color: event.ok ? _green : _red,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.event,
                    style: GoogleFonts.nunitoSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _t1)),
                if (event.detail != null)
                  Text(event.detail!,
                      style: GoogleFonts.nunitoSans(
                          fontSize: 10.5, color: _t3)),
              ],
            ),
          ),
          Text(event.date,
              style: GoogleFonts.nunitoSans(
                  fontSize: 10, color: _t3)),
        ]),
      );
}

class _PayRow extends StatelessWidget {
  final OptionPaiement p;
  const _PayRow({required this.p});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 7),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: _border),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                  color: _greenL,
                  borderRadius: BorderRadius.circular(8)),
              child: Icon(
                p.mode == 'mobile_money'
                    ? Icons.phone_android_rounded
                    : p.mode == 'fractionne'
                        ? Icons.pie_chart_outline_rounded
                        : Icons.calendar_today_outlined,
                size: 16, color: _green,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.label,
                    style: GoogleFonts.nunitoSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: _t1)),
                Text(p.detail,
                    style: GoogleFonts.nunitoSans(
                        fontSize: 11, color: _t3)),
              ],
            )),
            const Icon(Icons.check_circle_rounded,
                size: 14, color: _green),
          ]),
        ),
      );
}

class _DemRow extends StatelessWidget {
  final Demarcheur d;
  const _DemRow({required this.d});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 7),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: _border),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(children: [
            _Avatar(label: d.nom[0]),
            const SizedBox(width: 10),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(d.nom,
                    style: GoogleFonts.nunitoSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: _t1)),
                Row(children: [
                  const Icon(Icons.star_rounded,
                      size: 11, color: Color(0xFFF59E0B)),
                  const SizedBox(width: 3),
                  Text(
                      '${d.note} · ${d.missionsTotal} missions · '
                      '${_fmt(d.tarifVisite.round())} F/visite',
                      style: GoogleFonts.nunitoSans(
                          fontSize: 11, color: _t3)),
                ]),
              ],
            )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (d.disponible)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                        color: _greenL,
                        borderRadius: BorderRadius.circular(20)),
                    child: Text('Dispo',
                        style: GoogleFonts.nunitoSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: _green)),
                  ),
                const SizedBox(height: 5),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                        color: _green,
                        borderRadius: BorderRadius.circular(8)),
                    child: Text('Contacter',
                        style: GoogleFonts.nunitoSans(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                  ),
                ),
              ],
            ),
          ]),
        ),
      );
}

class _CtaBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color bg, fg;
  final Color? border;
  final VoidCallback onTap;
  const _CtaBtn(
      {required this.label,
      required this.icon,
      required this.bg,
      required this.fg,
      this.border,
      required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
            border: border != null ? Border.all(color: border!) : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 15, color: fg),
              const SizedBox(width: 7),
              Text(label,
                  style: GoogleFonts.nunitoSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: fg)),
            ],
          ),
        ),
      );
}

class _CommoditePill extends StatelessWidget {
  final Commodite c;
  const _CommoditePill(this.c);

  static const _palettes = <String, (Color, Color)>{
    'Eau ONEA':            (Color(0xFFE3EDF9), Color(0xFF0070CC)),
    'Électricité SONABEL': (Color(0xFFFFF8E1), Color(0xFFF57F17)),
    'Climatisation':       (_greenL,           _green),
    'Gardien':             (_bg,               Color(0xFF555555)),
    'Parking':             (_bg,               Color(0xFF555555)),
    'Internet fibre':      (Color(0xFFF3E5F5), Color(0xFF7B1FA2)),
    'Cuisine équipée':     (_bg,               Color(0xFF555555)),
  };

  @override
  Widget build(BuildContext context) {
    final pal = _palettes[c.name] ?? (_bg, const Color(0xFF555555));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: pal.$1,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        c.name.replaceAll(' ONEA', '').replaceAll(' SONABEL', ''),
        style: GoogleFonts.nunitoSans(
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            color: pal.$2),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  const _Pill(this.label);
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label,
            style: GoogleFonts.nunitoSans(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF555555))),
      );
}

class _Avatar extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;
  const _Avatar(
      {required this.label,
      this.bg = _greenL,
      this.fg = _green});
  @override
  Widget build(BuildContext context) => Container(
        width: 38, height: 38,
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: Text(label,
            style: GoogleFonts.nunitoSans(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: fg)),
      );
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _InfoRow(
      {required this.icon,
      required this.label,
      required this.value});
  @override
  Widget build(BuildContext context) => Row(children: [
        Icon(icon, size: 13, color: _t3),
        const SizedBox(width: 6),
        Text('$label : ',
            style: GoogleFonts.nunitoSans(
                fontSize: 12, color: _t2)),
        Expanded(
          child: Text(value,
              style: GoogleFonts.nunitoSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: _t1),
              overflow: TextOverflow.ellipsis),
        ),
      ]);
}

class _ImgPlaceholder extends StatelessWidget {
  final Logement l;
  const _ImgPlaceholder(this.l);
  @override
  Widget build(BuildContext context) => Container(
        height: 150, width: double.infinity,
        color: _green,
        child: Center(
          child: Icon(
            l.category == LogementCategory.miniVilla
                ? Icons.villa_rounded
                : l.category == LogementCategory.celibat
                    ? Icons.bed_rounded
                    : Icons.home_rounded,
            size: 48,
            color: Colors.white.withOpacity(0.4),
          ),
        ),
      );
}
