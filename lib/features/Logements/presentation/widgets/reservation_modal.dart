import 'package:flutter/material.dart';
import '../../data/listing.dart';
import '../../../../shared/theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class ReservationModal extends StatelessWidget {
  final Logement listing;
  const ReservationModal({super.key, required this.listing});

  static const _steps = [
    _Step(icon: Icons.fingerprint_rounded,     label: 'Votre identité vérifiée avant confirmation'),
    _Step(icon: Icons.person_rounded,          label: 'Le propriétaire confirme sous 24h'),
    _Step(icon: Icons.badge_rounded,           label: 'Visite accompagnée par agent certifié ImmoBF'),
    _Step(icon: Icons.how_to_vote_rounded,     label: 'Vous acceptez ou refusez sous 48h'),
    _Step(icon: Icons.account_balance_rounded, label: 'Aucun paiement avant signature notarié'),
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Container(
                  width: 42, height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.successBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.shield_rounded, color: AppColors.successFg, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Visite sécurisée',
                        style: GoogleFonts.nunitoSans(
                            fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                    Text('Protocole sûreté absolue · ImmoBF',
                        style: AppText.caption(size: 12, color: AppColors.textSecond)),
                  ],
                )),
              ]),
              const SizedBox(height: 4),
              Divider(color: AppColors.divider, height: 22),
              ..._steps.asMap().entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: Row(children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.navyLight,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Icon(e.value.icon, size: 17, color: AppColors.navy),
                  ),
                  const SizedBox(width: 11),
                  Expanded(child: RichText(
                    text: TextSpan(children: [
                      TextSpan(text: '${e.key + 1}  ',
                          style: GoogleFonts.nunitoSans(
                              fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.navy)),
                      TextSpan(text: e.value.label,
                          style: GoogleFonts.nunitoSans(
                              fontSize: 12.5, fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary, height: 1.4)),
                    ]),
                  )),
                ]),
              )),
              Divider(color: AppColors.divider, height: 18),
              Row(children: [
                Expanded(child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    decoration: BoxDecoration(
                      color: AppColors.bgPage,
                      borderRadius: BorderRadius.circular(AppDim.radiusLg),
                      border: Border.all(color: AppColors.divider, width: 1),
                    ),
                    child: Text('Annuler', textAlign: TextAlign.center,
                        style: GoogleFonts.nunitoSans(
                            fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textSecond)),
                  ),
                )),
                const SizedBox(width: 10),
                Expanded(flex: 2, child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Demande envoyée ! Confirmation sous 24h.',
                          style: GoogleFonts.nunitoSans(fontSize: 13, fontWeight: FontWeight.w600)),
                      backgroundColor: AppColors.successFg,
                      duration: const Duration(seconds: 4),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.all(16),
                    ));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    decoration: BoxDecoration(
                      color: AppColors.navy,
                      borderRadius: BorderRadius.circular(AppDim.radiusLg),
                    ),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Icon(Icons.check_circle_outline_rounded, size: 16, color: Colors.white),
                      const SizedBox(width: 6),
                      Text('Confirmer la visite', style: AppText.button(size: 13)),
                    ]),
                  ),
                )),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

class _Step {
  final IconData icon;
  final String label;
  const _Step({required this.icon, required this.label});
}
