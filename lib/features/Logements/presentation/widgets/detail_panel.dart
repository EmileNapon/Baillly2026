import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/listing.dart';
import '../../../../shared/theme/app_theme.dart';
import 'listing_card.dart' show fmtFCFA;
import 'media_gallery.dart';
import 'reservation_modal.dart';

// ============================================================
//  DETAIL PANEL — 12 fonctionnalités ImmoBF
// ============================================================
class DetailPanel extends StatelessWidget {
  final Logement listing;
  final VoidCallback? onBack;
  const DetailPanel({super.key, required this.listing, this.onBack});

  @override
  Widget build(BuildContext context) {
    final l = listing;
    return Column(
      children: [
        _Header(listing: l, onBack: onBack),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ── Statut temps réel (besoin 12) ──────────
                _StatutTempsReel(listing: l),
                const SizedBox(height: 16),

                // ── Description ────────────────────────────
                if (l.description.isNotEmpty) ...[
                  Text(l.description,
                      style: AppText.body(size: 13.5, color: AppColors.textSecond)),
                  const SizedBox(height: 18),
                ],

                // ── Score confiance global (besoin 5) ──────
                _SectionLabel('Score de confiance'),
                const SizedBox(height: 10),
                _ScoreConfianceRow(listing: l),
                const SizedBox(height: 18),

                // ── Médias par pièce (besoin 2) ────────────
                if (l.medias.isNotEmpty) ...[
                  _SectionLabel('Visite virtuelle · ${l.medias.length} médias'),
                  const SizedBox(height: 10),
                  MediaGallery(mediasByPiece: l.mediasByPiece),
                  const SizedBox(height: 18),
                ],

                // ── Coût total détaillé (besoin 3) ─────────
                _SectionLabel('Coût total détaillé'),
                const SizedBox(height: 10),
                _CoutTotalDetaille(listing: l),
                const SizedBox(height: 10),
                _InfoRow(
                  icon: Icons.calendar_today_rounded,
                  label: 'Disponible dès',
                  value: l.disponibleDes,
                ),
                const SizedBox(height: 18),

                // ── Recommandation lieu travail (besoin 4) ──
                _SectionLabel('Coût transport · ${l.lieu}'),
                const SizedBox(height: 10),
                _TransportCard(listing: l),
                const SizedBox(height: 18),

                // ── Qualité eau / électricité (besoin 10) ──
                if (l.services != null) ...[
                  _SectionLabel('Qualité services eau & électricité'),
                  const SizedBox(height: 10),
                  _ServicesCard(services: l.services!),
                  const SizedBox(height: 18),
                ],

                // ── Accessibilité (besoin 11) ───────────────
                if (l.accessibilite != null) ...[
                  _SectionLabel('Accessibilité saison sèche & pluie'),
                  const SizedBox(height: 10),
                  _AccessibiliteCard(acc: l.accessibilite!),
                  const SizedBox(height: 18),
                ],

                // ── Colocation (besoin 9) ──────────────────
                if (l.colocationPossible) ...[
                  _SectionLabel('Colocation disponible'),
                  const SizedBox(height: 10),
                  _ColocationCard(listing: l),
                  const SizedBox(height: 18),
                ],

                // ── Sûreté absolue (besoin 1) ───────────────
                _SectionLabel('Vérification & sûreté · '
                    '${l.securite.where((s) => s.ok).length}/${l.securite.length} validés'),
                const SizedBox(height: 10),
                _SecurityList(listing: l),
                const SizedBox(height: 18),

                // ── Commodités ─────────────────────────────
                if (l.commodites.isNotEmpty) ...[
                  _SectionLabel('Commodités'),
                  const SizedBox(height: 8),
                  _CommoditeChips(commodites: l.commodites),
                  const SizedBox(height: 18),
                ],

                // ── Historique complet (besoin 6) ──────────
                _SectionLabel('Historique · propriétaire score ${l.propriScore.toStringAsFixed(0)}/100'),
                const SizedBox(height: 10),
                _HistoryList(listing: l),
                const SizedBox(height: 10),
                if (l.loyerHistorique.isNotEmpty) ...[
                  _LoyerHistoriqueWidget(historique: l.loyerHistorique),
                  const SizedBox(height: 18),
                ] else
                  const SizedBox(height: 18),

                // ── Paiement flexible (besoin 7) ───────────
                if (l.optionsPaiement.isNotEmpty) ...[
                  _SectionLabel('Options de paiement'),
                  const SizedBox(height: 10),
                  _PaiementOptions(options: l.optionsPaiement),
                  const SizedBox(height: 18),
                ],

                // ── Démarcheurs (besoin 8) ──────────────────
                if (l.demarcheurs.isNotEmpty) ...[
                  _SectionLabel('Démarcheurs disponibles'),
                  const SizedBox(height: 10),
                  _DemarcheursWidget(demarcheurs: l.demarcheurs),
                  const SizedBox(height: 22),
                ],

                // ── CTA ────────────────────────────────────
                _CtaRow(listing: l),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Header ──────────────────────────────────────────────────
class _Header extends StatelessWidget {
  final Logement listing;
  final VoidCallback? onBack;
  const _Header({required this.listing, this.onBack});

  @override
  Widget build(BuildContext context) {
    final l = listing;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(bottom: BorderSide(color: AppColors.divider, width: 1)),
      ),
      child: Row(children: [
        if (onBack != null)
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 32, height: 32,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: AppColors.navyLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  size: 15, color: AppColors.navy),
            ),
          ),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l.name,
                style: AppText.heading(size: 14, weight: FontWeight.w800),
                maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 3),
            Text('${l.quartier} · ${l.categoryLabel} · ${l.surface} m² · ${l.pieces} pièce(s)',
                style: AppText.caption(size: 11.5, color: AppColors.textSecond)),
          ]),
        ),
        const SizedBox(width: 8),
        _VerifiedChip(listing: l),
      ]),
    );
  }
}

class _VerifiedChip extends StatelessWidget {
  final Logement listing;
  const _VerifiedChip({required this.listing});

  @override
  Widget build(BuildContext context) {
    final ok = listing.verified && listing.verifiePropr && listing.visiteTerrain;
    final partial = listing.verified || listing.verifiePropr;
    final color = ok ? AppColors.successFg : (partial ? AppColors.warnFg : AppColors.dangerFg);
    final bg    = ok ? AppColors.successBg : (partial ? AppColors.warnBg  : AppColors.dangerBg);
    final label = ok ? 'Terrain vérifié' : (partial ? 'Partiel' : 'Non vérifié');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppDim.radiusPill),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(ok ? Icons.verified_rounded : Icons.warning_amber_rounded,
            size: 12, color: color),
        const SizedBox(width: 4),
        Text(label, style: GoogleFonts.nunitoSans(
            fontSize: 10.5, fontWeight: FontWeight.w700, color: color)),
      ]),
    );
  }
}

// ── Section label ────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(text.toUpperCase(),
      style: GoogleFonts.nunitoSans(
        fontSize: 10, fontWeight: FontWeight.w800,
        letterSpacing: 0.7, color: AppColors.textSecond,
      ));
}

// ── Statut temps réel (besoin 12) ────────────────────────────
class _StatutTempsReel extends StatelessWidget {
  final Logement listing;
  const _StatutTempsReel({required this.listing});

  @override
  Widget build(BuildContext context) {
    final l = listing;
    Color dotColor;
    Color bg;
    switch (l.statut) {
      case 'disponible':   dotColor = AppColors.successFg; bg = AppColors.successBg; break;
      case 'reserve':      dotColor = const Color(0xFF0070CC); bg = const Color(0xFFE3EDF9); break;
      case 'occupe':       dotColor = AppColors.dangerFg;  bg = AppColors.dangerBg;  break;
      case 'maintenance':  dotColor = AppColors.warnFg;    bg = AppColors.warnBg;    break;
      default:             dotColor = AppColors.textMuted; bg = AppColors.bgPage;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppDim.radiusMd),
        border: Border.all(color: dotColor.withOpacity(0.3), width: 1),
      ),
      child: Row(children: [
        // Dot pulsant simulé
        Container(
          width: 10, height: 10,
          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(l.statutLabel,
              style: GoogleFonts.nunitoSans(
                  fontSize: 13, fontWeight: FontWeight.w700, color: dotColor)),
        ),
        Text('Mis à jour ${l.statutMaj}',
            style: AppText.caption(size: 10.5, color: AppColors.textMuted)),
      ]),
    );
  }
}

// ── Score confiance (besoin 5) ────────────────────────────────
class _ScoreConfianceRow extends StatelessWidget {
  final Logement listing;
  const _ScoreConfianceRow({required this.listing});

  @override
  Widget build(BuildContext context) {
    final l = listing;
    return Row(children: [
      Expanded(child: _ScoreCard('Logement',    l.trust,               Icons.home_rounded)),
      const SizedBox(width: 8),
      Expanded(child: _ScoreCard('Propriétaire', l.propriScore.round(), Icons.person_rounded)),
      const SizedBox(width: 8),
      Expanded(child: _ScoreCard('Zone',         l.scoreZone,           Icons.location_city_rounded)),
    ]);
  }
}

class _ScoreCard extends StatelessWidget {
  final String label;
  final int score;
  final IconData icon;
  const _ScoreCard(this.label, this.score, this.icon);

  @override
  Widget build(BuildContext context) {
    final color = AppColors.trustColor(score);
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(AppDim.radiusMd),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(label, style: AppText.caption(size: 10.5, color: color)),
        ]),
        const SizedBox(height: 6),
        Text('$score/100', style: GoogleFonts.nunitoSans(
            fontSize: 18, fontWeight: FontWeight.w800, color: color)),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: score / 100,
            backgroundColor: color.withOpacity(0.15),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 4,
          ),
        ),
      ]),
    );
  }
}

// ── Coût total détaillé (besoin 3) ────────────────────────────
class _CoutTotalDetaille extends StatelessWidget {
  final Logement listing;
  const _CoutTotalDetaille({required this.listing});

  @override
  Widget build(BuildContext context) {
    final l = listing;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDim.radiusLg),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Column(children: [
        _coutLigne('Loyer',       fmtFCFA(l.loyer),               false),
        _coutLigne('Charges',     fmtFCFA(l.charges),             false),
        _coutLigne('Carburant',   fmtFCFA(l.carburant),           false),
        if (l.coutEnergieMois > 0)
          _coutLigne('Électricité (est.)', fmtFCFA(l.coutEnergieMois), false),
        if (l.coutEauMois > 0)
          _coutLigne('Eau (est.)', fmtFCFA(l.coutEauMois), false),
        _coutLigne('TOTAL RÉEL',  fmtFCFA(l.totalComplet),        true),
      ]),
    );
  }

  Widget _coutLigne(String label, String val, bool isTotal) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: isTotal ? AppColors.navyLight : Colors.transparent,
        border: const Border(top: BorderSide(color: AppColors.divider, width: 0.5)),
      ),
      child: Row(children: [
        Expanded(child: Text(label,
            style: GoogleFonts.nunitoSans(
              fontSize: isTotal ? 12.5 : 12,
              fontWeight: isTotal ? FontWeight.w800 : FontWeight.w500,
              color: isTotal ? AppColors.navy : AppColors.textSecond,
            ))),
        Text(val, style: GoogleFonts.nunitoSans(
          fontSize: isTotal ? 13.5 : 12.5,
          fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
          color: isTotal ? AppColors.navy : AppColors.textPrimary,
        )),
      ]),
    );
  }
}

// ── Transport / localisation (besoin 4) ──────────────────────
class _TransportCard extends StatelessWidget {
  final Logement listing;
  const _TransportCard({required this.listing});

  @override
  Widget build(BuildContext context) {
    final l = listing;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.navyLight,
        borderRadius: BorderRadius.circular(AppDim.radiusLg),
        border: Border.all(color: AppColors.navy.withOpacity(0.2), width: 1),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.directions_car_outlined, size: 15, color: AppColors.navy),
          const SizedBox(width: 6),
          Text('Vers ${l.lieu}',
              style: GoogleFonts.nunitoSans(
                  fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.navy)),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          _transportStat(Icons.straighten_rounded, '${l.distTravail} km', 'Distance'),
          const SizedBox(width: 12),
          _transportStat(Icons.local_gas_station_rounded, fmtFCFA(l.carburant), 'Carburant/mois'),
          const SizedBox(width: 12),
          _transportStat(Icons.timer_outlined,
              '${(l.distTravail / 30 * 60).round()} min', 'Trajet estimé'),
        ]),
      ]),
    );
  }

  Widget _transportStat(IconData icon, String val, String label) {
    return Expanded(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, size: 14, color: AppColors.navy.withOpacity(0.7)),
        const SizedBox(height: 4),
        Text(val, style: GoogleFonts.nunitoSans(
            fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.navy)),
        Text(label, style: AppText.caption(size: 10, color: AppColors.textSecond)),
      ]),
    );
  }
}

// ── Score services eau/élec (besoin 10) ──────────────────────
class _ServicesCard extends StatelessWidget {
  final ScoreServices services;
  const _ServicesCard({required this.services});

  @override
  Widget build(BuildContext context) {
    final s = services;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDim.radiusLg),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: _serviceScore('Eau ONEA', s.eauScore,
              Icons.water_drop_rounded, '${s.coupuresEauMois} coupures/mois')),
          const SizedBox(width: 12),
          Expanded(child: _serviceScore('Électricité', s.elecScore,
              Icons.bolt_rounded, '${s.coupuresElecMois} coupures/mois')),
        ]),
        if (s.commentaire.isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(s.commentaire,
              style: AppText.caption(size: 11.5, color: AppColors.textSecond)),
        ],
      ]),
    );
  }

  Widget _serviceScore(String label, int score, IconData icon, String sub) {
    final color = AppColors.trustColor(score);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        Text(label, style: AppText.caption(size: 11, color: AppColors.textSecond)),
      ]),
      const SizedBox(height: 4),
      Text('$score/100', style: GoogleFonts.nunitoSans(
          fontSize: 16, fontWeight: FontWeight.w800, color: color)),
      const SizedBox(height: 3),
      ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(
          value: score / 100,
          backgroundColor: color.withOpacity(0.15),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 4,
        ),
      ),
      const SizedBox(height: 3),
      Text(sub, style: AppText.caption(size: 10, color: AppColors.textMuted)),
    ]);
  }
}

// ── Accessibilité (besoin 11) ─────────────────────────────────
class _AccessibiliteCard extends StatelessWidget {
  final ScoreAccessibilite acc;
  const _AccessibiliteCard({required this.acc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDim.radiusLg),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: _accScore('Saison sèche', acc.scoreSec,  Icons.wb_sunny_rounded,   '☀️')),
          const SizedBox(width: 12),
          Expanded(child: _accScore('Saison pluie', acc.scorePluie, Icons.water_rounded, '🌧️')),
        ]),
        const SizedBox(height: 12),
        _infoChip(Icons.alt_route, acc.etatRoute),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6, runSpacing: 5,
          children: acc.transportsDisponibles.map((t) => _transportPill(t)).toList(),
        ),
        if (acc.commentaire.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(acc.commentaire,
              style: AppText.caption(size: 11.5, color: AppColors.textSecond)),
        ],
      ]),
    );
  }

  Widget _accScore(String label, int score, IconData icon, String emoji) {
    final color = AppColors.trustColor(score);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('$emoji  $label',
          style: AppText.caption(size: 11, color: AppColors.textSecond)),
      const SizedBox(height: 4),
      Text('$score/100', style: GoogleFonts.nunitoSans(
          fontSize: 16, fontWeight: FontWeight.w800, color: color)),
      const SizedBox(height: 3),
      ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(
          value: score / 100,
          backgroundColor: color.withOpacity(0.15),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 4,
        ),
      ),
    ]);
  }

  Widget _infoChip(IconData icon, String text) => Row(children: [
    Icon(icon, size: 12, color: AppColors.textSecond),
    const SizedBox(width: 5),
    Expanded(child: Text(text,
        style: AppText.caption(size: 11.5, color: AppColors.textPrimary))),
  ]);

  Widget _transportPill(String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: AppColors.bgPage,
      borderRadius: BorderRadius.circular(AppDim.radiusPill),
      border: Border.all(color: AppColors.divider, width: 1),
    ),
    child: Text(label, style: AppText.caption(size: 11, color: AppColors.textSecond)),
  );
}

// ── Colocation (besoin 9) ─────────────────────────────────────
class _ColocationCard extends StatelessWidget {
  final Logement listing;
  const _ColocationCard({required this.listing});

  @override
  Widget build(BuildContext context) {
    final l = listing;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7FF),
        borderRadius: BorderRadius.circular(AppDim.radiusLg),
        border: Border.all(color: const Color(0xFF0070CC).withOpacity(0.2), width: 1),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.people_rounded, size: 15, color: Color(0xFF0070CC)),
          const SizedBox(width: 7),
          Text('Colocation possible · ${fmtFCFA(l.loyerParColoc)}/personne',
              style: GoogleFonts.nunitoSans(
                  fontSize: 12.5, fontWeight: FontWeight.w700,
                  color: const Color(0xFF0070CC))),
        ]),
        if (l.colocataires.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text('Candidats potentiels',
              style: AppText.caption(size: 11, color: AppColors.textSecond)),
          const SizedBox(height: 8),
          ...l.colocataires.map((c) => Padding(
            padding: const EdgeInsets.only(bottom: 7),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppDim.radiusMd),
                border: Border.all(color: AppColors.divider, width: 1),
              ),
              child: Row(children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.navyLight,
                  child: Text(c.prenom[0],
                      style: GoogleFonts.nunitoSans(
                          fontSize: 13, fontWeight: FontWeight.w800,
                          color: AppColors.navy)),
                ),
                const SizedBox(width: 10),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(c.prenom, style: AppText.label(size: 12.5, color: AppColors.textPrimary)),
                  Text('${c.profession} · ~${c.ageApprox} ans',
                      style: AppText.caption(size: 11, color: AppColors.textSecond)),
                ])),
                Text(c.disponibilite,
                    style: AppText.caption(size: 10.5, color: AppColors.successFg)),
              ]),
            ),
          )),
        ],
      ]),
    );
  }
}

// ── Security list (besoin 1) ─────────────────────────────────
class _SecurityList extends StatelessWidget {
  final Logement listing;
  const _SecurityList({required this.listing});

  @override
  Widget build(BuildContext context) => Column(
    children: listing.securite.map((s) => Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: (s.ok ? AppColors.successBg : AppColors.dangerBg).withOpacity(0.55),
          borderRadius: BorderRadius.circular(AppDim.radiusMd),
          border: Border.all(
            color: s.ok ? AppColors.successFg.withOpacity(0.18)
                : AppColors.dangerFg.withOpacity(0.18),
            width: 1,
          ),
        ),
        child: Row(children: [
          Container(
            width: 22, height: 22,
            decoration: BoxDecoration(
              color: s.ok ? AppColors.successFg : AppColors.dangerFg,
              shape: BoxShape.circle,
            ),
            child: Icon(s.ok ? Icons.check_rounded : Icons.close_rounded,
                size: 13, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(s.label, style: GoogleFonts.nunitoSans(
              fontSize: 13, fontWeight: FontWeight.w600,
              color: AppColors.textPrimary, height: 1.4))),
        ]),
      ),
    )).toList(),
  );
}

// ── Commodités ───────────────────────────────────────────────
class _CommoditeChips extends StatelessWidget {
  final List<Commodite> commodites;
  const _CommoditeChips({required this.commodites});

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 7, runSpacing: 7,
    children: commodites.map((c) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.infoBg,
        borderRadius: BorderRadius.circular(AppDim.radiusPill),
        border: Border.all(color: AppColors.navy.withOpacity(0.15), width: 1),
      ),
      child: Text(c.name, style: GoogleFonts.nunitoSans(
          fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.navy)),
    )).toList(),
  );
}

// ── History (besoin 6) ────────────────────────────────────────
class _HistoryList extends StatelessWidget {
  final Logement listing;
  const _HistoryList({required this.listing});

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppDim.radiusLg),
      border: Border.all(color: AppColors.divider, width: 1),
    ),
    child: Column(
      children: listing.history.asMap().entries.map((e) {
        final h = e.value;
        final isLast = e.key == listing.history.length - 1;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            border: isLast ? null
                : const Border(bottom: BorderSide(color: AppColors.divider, width: 1)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Icon(h.ok ? Icons.check_circle_rounded : Icons.error_outline_rounded,
                  size: 14, color: h.ok ? AppColors.successFg : AppColors.dangerFg),
              const SizedBox(width: 8),
              Expanded(child: Text(h.event, style: GoogleFonts.nunitoSans(
                  fontSize: 12.5, fontWeight: FontWeight.w600,
                  color: h.ok ? AppColors.textPrimary : AppColors.dangerFg))),
              Text(h.date, style: AppText.caption(size: 10.5, color: AppColors.textMuted)),
            ]),
            if (h.detail != null) ...[
              const SizedBox(height: 3),
              Padding(
                padding: const EdgeInsets.only(left: 22),
                child: Text(h.detail!,
                    style: AppText.caption(size: 11, color: AppColors.textSecond)),
              ),
            ],
          ]),
        );
      }).toList(),
    ),
  );
}

// ── Historique loyers (besoin 6) ─────────────────────────────
class _LoyerHistoriqueWidget extends StatelessWidget {
  final List<LoyerHistorique> historique;
  const _LoyerHistoriqueWidget({required this.historique});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgPage,
        borderRadius: BorderRadius.circular(AppDim.radiusMd),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Évolution des loyers',
            style: AppText.caption(size: 11, color: AppColors.textSecond)),
        const SizedBox(height: 8),
        Row(
          children: historique.map((h) => Expanded(
            child: Column(children: [
              Text(fmtFCFA(h.montant), style: GoogleFonts.nunitoSans(
                  fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.navy)),
              const SizedBox(height: 2),
              Text(h.periode, style: AppText.caption(size: 10, color: AppColors.textMuted)),
            ]),
          )).toList(),
        ),
      ]),
    );
  }
}

// ── Paiement flexible (besoin 7) ─────────────────────────────
class _PaiementOptions extends StatelessWidget {
  final List<OptionPaiement> options;
  const _PaiementOptions({required this.options});

  IconData _icon(String mode) {
    switch (mode) {
      case 'mobile_money': return Icons.phone_android_rounded;
      case 'fractionne':   return Icons.splitscreen_rounded;
      default:             return Icons.calendar_month_rounded;
    }
  }

  @override
  Widget build(BuildContext context) => Column(
    children: options.map((o) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDim.radiusMd),
          border: Border.all(color: AppColors.divider, width: 1),
        ),
        child: Row(children: [
          Container(
            width: 34, height: 34,
            decoration: BoxDecoration(
              color: AppColors.navyLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(_icon(o.mode), size: 17, color: AppColors.navy),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(o.label, style: AppText.label(size: 13, color: AppColors.textPrimary)),
            const SizedBox(height: 2),
            Text(o.detail, style: AppText.caption(size: 11.5, color: AppColors.textSecond)),
          ])),
          const Icon(Icons.check_circle_rounded, size: 16, color: AppColors.successFg),
        ]),
      ),
    )).toList(),
  );
}

// ── Démarcheurs (besoin 8) ────────────────────────────────────
class _DemarcheursWidget extends StatelessWidget {
  final List<Demarcheur> demarcheurs;
  const _DemarcheursWidget({required this.demarcheurs});

  @override
  Widget build(BuildContext context) => Column(
    children: demarcheurs.map((d) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDim.radiusLg),
          border: Border.all(color: AppColors.divider, width: 1),
        ),
        child: Row(children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.navyLight,
            child: Text(d.nom.substring(0, 1), style: GoogleFonts.nunitoSans(
                fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.navy)),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(d.nom, style: AppText.label(size: 13, color: AppColors.textPrimary)),
            const SizedBox(height: 2),
            Row(children: [
              const Icon(Icons.star_rounded, size: 12, color: Color(0xFFF59E0B)),
              const SizedBox(width: 3),
              Text('${d.note}  ·  ${d.missionsTotal} missions',
                  style: AppText.caption(size: 11, color: AppColors.textSecond)),
            ]),
            const SizedBox(height: 2),
            Text('Visite : ${fmtFCFA(d.tarifVisite.round())}',
                style: AppText.caption(size: 11, color: AppColors.textSecond)),
          ])),
          Column(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: d.disponible ? AppColors.successBg : AppColors.dangerBg,
                borderRadius: BorderRadius.circular(AppDim.radiusPill),
              ),
              child: Text(d.disponible ? 'Dispo' : 'Indispo',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 10, fontWeight: FontWeight.w700,
                    color: d.disponible ? AppColors.successFg : AppColors.dangerFg,
                  )),
            ),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Demande envoyée à ${d.nom}',
                    style: GoogleFonts.nunitoSans(
                        fontSize: 13, fontWeight: FontWeight.w600)),
                backgroundColor: AppColors.navy,
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                duration: const Duration(seconds: 3),
              )),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.navy,
                  borderRadius: BorderRadius.circular(AppDim.radiusMd),
                ),
                child: Text('Contacter',
                    style: GoogleFonts.nunitoSans(
                        fontSize: 10.5, fontWeight: FontWeight.w700,
                        color: Colors.white)),
              ),
            ),
          ]),
        ]),
      ),
    )).toList(),
  );
}

// ── Info row ─────────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Row(children: [
    Icon(icon, size: 13, color: AppColors.textSecond),
    const SizedBox(width: 6),
    Text('$label : ',
        style: AppText.caption(size: 12.5, color: AppColors.textSecond)),
    Text(value, style: AppText.label(size: 12.5, color: AppColors.textPrimary)),
  ]);
}

// ── CTA ──────────────────────────────────────────────────────
class _CtaRow extends StatelessWidget {
  final Logement listing;
  const _CtaRow({required this.listing});

  @override
  Widget build(BuildContext context) {
    if (!listing.isAvailable) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.bgPage,
          borderRadius: BorderRadius.circular(AppDim.radiusLg),
          border: Border.all(color: AppColors.divider, width: 1),
        ),
        child: Text(
          '${listing.statutLabel} · Dispo dès ${listing.disponibleDes}',
          textAlign: TextAlign.center,
          style: GoogleFonts.nunitoSans(
              fontSize: 13, fontWeight: FontWeight.w600,
              color: AppColors.textSecond),
        ),
      );
    }
    return Column(children: [
      GestureDetector(
        onTap: () => showDialog(
          context: context,
          barrierDismissible: true,
          builder: (_) => ReservationModal(listing: listing),
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.navy,
            borderRadius: BorderRadius.circular(AppDim.radiusLg),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.shield_rounded, size: 16, color: Colors.white),
            const SizedBox(width: 8),
            Text('Demander une visite escortée', style: AppText.button(size: 14)),
          ]),
        ),
      ),
      const SizedBox(height: 10),
      GestureDetector(
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Signalé. Notre équipe vérifie sous 48h.',
              style: GoogleFonts.nunitoSans(
                  fontSize: 13, fontWeight: FontWeight.w600)),
          backgroundColor: AppColors.navy,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 3),
        )),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            color: AppColors.dangerBg,
            borderRadius: BorderRadius.circular(AppDim.radiusLg),
            border: Border.all(color: AppColors.dangerFg.withOpacity(0.25), width: 1),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.flag_outlined, size: 15, color: AppColors.dangerFg),
            const SizedBox(width: 7),
            Text('Signaler un problème',
                style: GoogleFonts.nunitoSans(
                    fontSize: 13, fontWeight: FontWeight.w700,
                    color: AppColors.dangerFg)),
          ]),
        ),
      ),
    ]);
  }
}
