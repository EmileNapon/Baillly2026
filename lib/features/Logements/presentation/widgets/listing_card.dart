import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/listing.dart';
import '../../../../shared/theme/app_theme.dart';

// Formatage FCFA partagé
String fmtFCFA(int n) {
  final s = n.toString();
  final buf = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write('\u202F');
    buf.write(s[i]);
  }
  return '${buf.toString()} FCFA';
}

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
    final firstPhoto = l.photos.isNotEmpty ? l.photos.first.assetPath : null;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDim.radiusLg),
          border: Border.all(
            color: isActive ? AppColors.navy : AppColors.divider,
            width: isActive ? 1.5 : AppDim.borderW,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isActive ? 0.07 : 0.04),
              blurRadius: isActive ? 12 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Photo principale ──────────────────────────
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppDim.radiusLg)),
                  child: SizedBox(
                    height: 118,
                    width: double.infinity,
                    child: firstPhoto != null
                        ? CachedNetworkImage(
                            imageUrl: firstPhoto,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(
                                color: AppColors.bgPage,
                                child: const Center(
                                    child: SizedBox(
                                        width: 20, height: 20,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2)))),
                            errorWidget: (_, __, ___) => Container(
                                color: AppColors.bgPage,
                                child: Center(
                                    child: Icon(
                                        Icons.image_not_supported_rounded,
                                        color: AppColors.textMuted,
                                        size: 28))),
                          )
                        : Container(
                            color: AppColors.navyLight,
                            child: Center(
                                child: Icon(_catIcon(l.category),
                                    size: 36,
                                    color: AppColors.navy.withOpacity(0.35))),
                          ),
                  ),
                ),
                // Badge statut temps réel (besoin 12)
                Positioned(
                  top: 8, left: 8,
                  child: _StatutBadge(statut: l.statut, label: l.statutLabel),
                ),
                // Compteur médias
                if (l.medias.isNotEmpty)
                  Positioned(
                    bottom: 8, right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.60),
                        borderRadius: BorderRadius.circular(AppDim.radiusPill),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.photo_library_rounded,
                            size: 11, color: Colors.white),
                        const SizedBox(width: 4),
                        Text('${l.medias.length}',
                            style: GoogleFonts.nunitoSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                      ]),
                    ),
                  ),
              ],
            ),

            // ── Contenu ───────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(13, 11, 13, 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nom + badge vérifié
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l.name,
                                style: AppText.heading(
                                    size: 13.5, weight: FontWeight.w700),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 2),
                            Row(children: [
                              Icon(Icons.location_on_rounded,
                                  size: 11, color: AppColors.textMuted),
                              const SizedBox(width: 2),
                              Text(l.quartier,
                                  style: AppText.caption(
                                      size: 11, color: AppColors.textSecond)),
                            ]),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      _VerifiedBadge(verified: l.verified),
                    ],
                  ),
                  const SizedBox(height: 9),

                  // Prix
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(fmtFCFA(l.loyer), style: AppText.price(size: 15)),
                      const SizedBox(width: 4),
                      Text('/mois',
                          style: AppText.caption(
                              size: 11, color: AppColors.textMuted)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Coût total (besoin 3) — ligne secondaire
                  Text(
                    'Total réel : ${fmtFCFA(l.totalComplet)}/mois',
                    style: AppText.caption(size: 11, color: AppColors.textSecond),
                  ),
                  const SizedBox(height: 9),

                  // Pills
                  Wrap(
                    spacing: 5, runSpacing: 5,
                    children: [
                      _Pill(l.categoryLabel),
                      _Pill('${l.surface} m²'),
                      _TrustScore(l.trust),
                    ],
                  ),

                  // Commodités (3 max)
                  if (l.commodites.isNotEmpty) ...[
                    const SizedBox(height: 7),
                    Wrap(
                      spacing: 4, runSpacing: 4,
                      children: l.commodites.take(3).map((c) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.infoBg,
                          borderRadius:
                              BorderRadius.circular(AppDim.radiusPill),
                        ),
                        child: Text(c.name,
                            style: GoogleFonts.nunitoSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.navy)),
                      )).toList(),
                    ),
                  ],

                  // Colocation dispo (besoin 9)
                  if (l.colocationPossible) ...[
                    const SizedBox(height: 7),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3EDF9),
                        borderRadius:
                            BorderRadius.circular(AppDim.radiusPill),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.people_rounded,
                            size: 11, color: Color(0xFF0070CC)),
                        const SizedBox(width: 4),
                        Text(
                          'Coloc · ${fmtFCFA(l.loyerParColoc)}/pers',
                          style: GoogleFonts.nunitoSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0070CC)),
                        ),
                      ]),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _catIcon(String cat) {
    switch (cat) {
      case 'mini_villa':  return Icons.villa_rounded;
      case 'cour_unique': return Icons.home_rounded;
      default:            return Icons.bed_rounded;
    }
  }
}

// ── Badge statut temps réel (besoin 12) ─────────────────────
class _StatutBadge extends StatelessWidget {
  final String statut;
  final String label;
  const _StatutBadge({required this.statut, required this.label});

  @override
  Widget build(BuildContext context) {
    Color dot;
    Color bg;
    switch (statut) {
      case 'disponible':  dot = AppColors.successFg; bg = AppColors.successBg; break;
      case 'reserve':     dot = const Color(0xFF0070CC); bg = const Color(0xFFE3EDF9); break;
      case 'occupe':      dot = AppColors.dangerFg; bg = AppColors.dangerBg; break;
      default:            dot = AppColors.warnFg; bg = AppColors.warnBg;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: bg.withOpacity(0.92),
        borderRadius: BorderRadius.circular(AppDim.radiusPill),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
            width: 6, height: 6,
            decoration: BoxDecoration(color: dot, shape: BoxShape.circle)),
        const SizedBox(width: 5),
        Text(label,
            style: GoogleFonts.nunitoSans(
                fontSize: 10, fontWeight: FontWeight.w700, color: dot)),
      ]),
    );
  }
}

// ── Verified badge ───────────────────────────────────────────
class _VerifiedBadge extends StatelessWidget {
  final bool verified;
  const _VerifiedBadge({required this.verified});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: verified ? AppColors.successBg : AppColors.warnBg,
        borderRadius: BorderRadius.circular(AppDim.radiusPill),
        border: Border.all(
          color: verified
              ? AppColors.successFg.withOpacity(0.25)
              : AppColors.warnFg.withOpacity(0.25),
          width: 1,
        ),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(
            verified
                ? Icons.check_circle_rounded
                : Icons.warning_amber_rounded,
            size: 10.5,
            color: verified ? AppColors.successFg : AppColors.warnFg),
        const SizedBox(width: 3),
        Text(verified ? 'Vérifié' : 'Partiel',
            style: GoogleFonts.nunitoSans(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: verified ? AppColors.successFg : AppColors.warnFg)),
      ]),
    );
  }
}

// ── Pill ────────────────────────────────────────────────────
class _Pill extends StatelessWidget {
  final String label;
  const _Pill(this.label);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: AppColors.bgPage,
      borderRadius: BorderRadius.circular(AppDim.radiusPill),
      border: Border.all(color: AppColors.divider, width: 1),
    ),
    child: Text(label,
        style: GoogleFonts.nunitoSans(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecond)),
  );
}

// ── Trust score ─────────────────────────────────────────────
class _TrustScore extends StatelessWidget {
  final int score;
  const _TrustScore(this.score);

  @override
  Widget build(BuildContext context) {
    final c = AppColors.trustColor(score);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: c.withOpacity(0.10),
        borderRadius: BorderRadius.circular(AppDim.radiusPill),
      ),
      child: Text('Score $score/100',
          style: GoogleFonts.nunitoSans(
              fontSize: 10, fontWeight: FontWeight.w700, color: c)),
    );
  }
}
