import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/artisan.dart';

// ─────────────────────────────────────────────────────────────
// COULEURS — cohérentes avec Nidali / Bailly
// ─────────────────────────────────────────────────────────────
const _kGreen      = Color(0xFF1D5C3A);
const _kGreenLight = Color(0xFFEAF5EE);
const _kBg         = Color(0xFFF7F5F0);
const _kWhite      = Color(0xFFFFFFFF);
const _kBorder     = Color(0xFFECECEC);
const _kText       = Color(0xFF111111);
const _kTextSub    = Color(0xFF555555);
const _kTextMuted  = Color(0xFF888888);
const _kOrange     = Color(0xFFE65100);
const _kOrangeBg   = Color(0xFFFFF3E0);
const _kWarnBg     = Color(0xFFFFF8E1);
const _kWarnFg     = Color(0xFFF57F17);
const _kStar       = Color(0xFFF9A825);

// ─────────────────────────────────────────────────────────────
// ÉCRAN PRINCIPAL
// ─────────────────────────────────────────────────────────────
class ArtisansScreen extends StatefulWidget {
  const ArtisansScreen({super.key});

  @override
  State<ArtisansScreen> createState() => _ArtisansScreenState();
}

class _ArtisansScreenState extends State<ArtisansScreen> {
  MetierType? _metierFilter;   // null = tous
  _SortOption _sort = _SortOption.note;
  final _searchCtrl = TextEditingController();
  String _searchQ = '';

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() {
      if (!mounted) return;
      setState(() => _searchQ = _searchCtrl.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Artisan> get _filtered {
    var list = sampleArtisans.where((a) {
      if (_metierFilter != null && a.metier != _metierFilter) return false;
      if (_searchQ.isNotEmpty) {
        final q = _searchQ;
        if (!a.nom.toLowerCase().contains(q) &&
            !a.metier.label.toLowerCase().contains(q) &&
            !a.zones.any((z) => z.toLowerCase().contains(q)) &&
            !a.specialites.any((s) => s.toLowerCase().contains(q))) {
          return false;
        }
      }
      return true;
    }).toList();

    list.sort((a, b) {
      switch (_sort) {
        case _SortOption.note:      return b.note.compareTo(a.note);
        case _SortOption.missions:  return b.missions.compareTo(a.missions);
        case _SortOption.tarif:     return a.tarif.compareTo(b.tarif);
        case _SortOption.dispo:     return (b.disponible ? 1 : 0) - (a.disponible ? 1 : 0);
        case _SortOption.verified:  return (b.verified ? 1 : 0) - (a.verified ? 1 : 0);
      }
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final items = _filtered;
    return Scaffold(
      backgroundColor: _kBg,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // ── Barre de recherche ─────────────────────────
          _SearchBar(controller: _searchCtrl),
          // ── Filtres métiers ─────────────────────────────
          _MetierFilterBar(
            selected: _metierFilter,
            onChanged: (m) => setState(() => _metierFilter = m),
          ),
          // ── Tri ─────────────────────────────────────────
          _SortBar(
            selected: _sort,
            onChanged: (s) => setState(() => _sort = s),
          ),
          // ── Liste ───────────────────────────────────────
          Expanded(
            child: items.isEmpty
                ? _EmptyState(metier: _metierFilter?.label)
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
                    itemCount: items.length + 1,
                    itemBuilder: (ctx, i) {
                      if (i == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            '${items.length} artisan${items.length > 1 ? 's' : ''} trouvé${items.length > 1 ? 's' : ''}',
                            style: _ts(11, color: _kTextMuted, w: FontWeight.w500),
                          ),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _ArtisanCard(artisan: items[i - 1]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _kGreen,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(Icons.build_rounded, color: Colors.white, size: 17),
          ),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Artisans', style: _ts(15, color: Colors.white, w: FontWeight.w700)),
            Text('Professionnels vérifiés · Ouagadougou',
                style: _ts(10, color: Colors.white.withOpacity(0.65))),
          ]),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.verified_rounded, size: 11, color: Colors.white),
              const SizedBox(width: 4),
              Text('Certifié', style: _ts(10, color: Colors.white, w: FontWeight.w600)),
            ]),
          ),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// BARRE DE RECHERCHE
// ─────────────────────────────────────────────────────────────
class _SearchBar extends StatefulWidget {
  final TextEditingController controller;
  const _SearchBar({required this.controller});

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final _focus = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() => _focused = _focus.hasFocus));
  }

  @override
  void dispose() { _focus.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _kWhite,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 40,
        decoration: BoxDecoration(
          color: _focused ? _kWhite : const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _focused ? _kGreen : Colors.transparent,
            width: 1.5,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(children: [
          Icon(Icons.search_rounded, size: 17,
              color: _focused ? _kGreen : _kTextMuted),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: _focus,
              style: _ts(13.5, color: _kText),
              decoration: InputDecoration(
                hintText: 'Nom, métier, quartier…',
                hintStyle: _ts(13.5, color: _kTextMuted),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (widget.controller.text.isNotEmpty)
            GestureDetector(
              onTap: () => widget.controller.clear(),
              child: const Icon(Icons.close_rounded, size: 16, color: _kTextMuted),
            ),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// FILTRE MÉTIERS
// ─────────────────────────────────────────────────────────────
class _MetierFilterBar extends StatelessWidget {
  final MetierType? selected;
  final ValueChanged<MetierType?> onChanged;

  const _MetierFilterBar({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _kWhite,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: Row(
          children: [
            _chip(null, '🔍 Tous'),
            ...MetierType.values.map((m) => _chip(m, '${m.emoji} ${m.label}')),
          ],
        ),
      ),
    );
  }

  Widget _chip(MetierType? m, String label) {
    final active = selected == m;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => onChanged(m),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
          decoration: BoxDecoration(
            color: active ? _kGreen : _kBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: active ? _kGreen : const Color(0xFFE0E0E0),
              width: active ? 1.5 : 1,
            ),
          ),
          child: Text(label,
              style: _ts(12, color: active ? _kWhite : _kTextSub,
                  w: FontWeight.w600)),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// TRI
// ─────────────────────────────────────────────────────────────
enum _SortOption { note, missions, tarif, dispo, verified }

extension _SortOptionExt on _SortOption {
  String get label {
    switch (this) {
      case _SortOption.note:     return 'Mieux notés';
      case _SortOption.missions: return '+ de missions';
      case _SortOption.tarif:    return 'Tarif bas';
      case _SortOption.dispo:    return 'Disponibles';
      case _SortOption.verified: return 'Vérifiés';
    }
  }
}

class _SortBar extends StatelessWidget {
  final _SortOption selected;
  final ValueChanged<_SortOption> onChanged;

  const _SortBar({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _kWhite,
      child: Column(children: [
        const Divider(height: 1, color: Color(0xFFEEEEEE)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(12, 7, 12, 9),
          child: Row(
            children: _SortOption.values.map((s) {
              final active = selected == s;
              return Padding(
                padding: const EdgeInsets.only(right: 7),
                child: GestureDetector(
                  onTap: () => onChanged(s),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: active ? _kGreenLight : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: active ? _kGreen : const Color(0xFFE0E0E0),
                        width: active ? 1.5 : 1,
                      ),
                    ),
                    child: Text(s.label,
                        style: _ts(11, color: active ? _kGreen : _kTextMuted,
                            w: FontWeight.w600)),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const Divider(height: 1, color: Color(0xFFEEEEEE)),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// CARTE ARTISAN
// ─────────────────────────────────────────────────────────────
class _ArtisanCard extends StatelessWidget {
  final Artisan artisan;
  const _ArtisanCard({required this.artisan});

  @override
  Widget build(BuildContext context) {
    final a = artisan;
    return Container(
      decoration: BoxDecoration(
        color: _kWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kBorder, width: 1),
        boxShadow: const [
          BoxShadow(color: Color(0x08000000), blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showDetail(context, a),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // ── En-tête ────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(13),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar métier
                  Container(
                    width: 50, height: 50,
                    decoration: BoxDecoration(
                      color: Color(a.metier.bgColor),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(a.metier.emoji, style: const TextStyle(fontSize: 22)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Infos
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(a.nom,
                            style: _ts(14.5, w: FontWeight.w700),
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 2),
                        Row(children: [
                          Icon(Icons.work_outline_rounded,
                              size: 11, color: Color(a.metier.fgColor)),
                          const SizedBox(width: 4),
                          Text('${a.metier.label} · ${a.experienceAns} ans d\'exp.',
                              style: _ts(11.5, color: Color(a.metier.fgColor),
                                  w: FontWeight.w600)),
                        ]),
                        const SizedBox(height: 2),
                        Row(children: [
                          const Icon(Icons.location_on_rounded,
                              size: 11, color: _kTextMuted),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(a.zones.join(', '),
                                style: _ts(11, color: _kTextMuted),
                                maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                        ]),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Tarif + dispo + note
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text(a.tarifFmt, style: _ts(13, color: _kGreen, w: FontWeight.w700)),
                    const SizedBox(height: 4),
                    _DispoBadge(disponible: a.disponible),
                    const SizedBox(height: 4),
                    _StarRow(note: a.note),
                  ]),
                ],
              ),
            ),

            // ── Séparateur ─────────────────────────────────
            const Divider(height: 1, indent: 13, endIndent: 13,
                color: Color(0xFFF2F2F2)),

            // ── Corps ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(13, 10, 13, 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tags
                  Wrap(spacing: 5, runSpacing: 5, children: [
                    if (a.verified)
                      _Tag(label: 'Vérifié', icon: Icons.check_circle_rounded,
                          bg: _kGreenLight, fg: _kGreen)
                    else
                      _Tag(label: 'Non vérifié',
                          icon: Icons.warning_amber_rounded,
                          bg: _kWarnBg, fg: _kWarnFg),
                    if (a.certifie)
                      const _Tag(label: 'Certifié', bg: Color(0xFFE8F5E9),
                          fg: Color(0xFF2E7D32)),
                    if (a.litiges > 0)
                      _Tag(label: '⚠ ${a.litiges} litige',
                          bg: _kWarnBg, fg: _kWarnFg),
                    ...a.specialites.map((s) =>
                        _Tag(label: s, bg: const Color(0xFFF0F0F0), fg: _kTextSub)),
                  ]),
                  const SizedBox(height: 10),

                  // Stats
                  Row(children: [
                    _Stat(icon: Icons.star_border_rounded,
                        value: '${a.missions} missions'),
                    const SizedBox(width: 14),
                    _Stat(icon: Icons.access_time_rounded,
                        value: a.delaiReponse),
                    const SizedBox(width: 14),
                    _Stat(icon: Icons.handshake_outlined,
                        value: 'Zéro litige'),
                  ]),
                  const SizedBox(height: 12),

                  // Boutons
                  Row(children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _showDetail(context, a),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: _kBorder),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: Text('Voir profil',
                            style: _ts(12.5, color: _kText, w: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _contact(context, a),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _kGreen,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: Text('Contacter',
                            style: _ts(12.5, color: Colors.white,
                                w: FontWeight.w700)),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  void _contact(BuildContext ctx, Artisan a) {
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
      content: Text('Demande envoyée à ${a.nom} · Réponse sous 2h',
          style: _ts(13, color: Colors.white, w: FontWeight.w600)),
      backgroundColor: _kGreen,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      duration: const Duration(seconds: 3),
    ));
  }

  void _showDetail(BuildContext ctx, Artisan a) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ArtisanDetailSheet(artisan: a),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// FICHE DÉTAIL (BottomSheet)
// ─────────────────────────────────────────────────────────────
class _ArtisanDetailSheet extends StatelessWidget {
  final Artisan artisan;
  const _ArtisanDetailSheet({required this.artisan});

  @override
  Widget build(BuildContext context) {
    final a = artisan;
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (ctx, scroll) => Container(
        decoration: const BoxDecoration(
          color: _kWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: Column(children: [
          // Poignée
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFDDDDDD),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: scroll,
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Profil ──────────────────────────────
                  Row(children: [
                    Container(
                      width: 64, height: 64,
                      decoration: BoxDecoration(
                        color: Color(a.metier.bgColor),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Center(child: Text(a.metier.emoji,
                          style: const TextStyle(fontSize: 30))),
                    ),
                    const SizedBox(width: 14),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(a.nom, style: _ts(18, w: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Text('${a.metier.label} · ${a.experienceAns} ans',
                            style: _ts(13, color: _kTextSub)),
                        const SizedBox(height: 4),
                        _StarRow(note: a.note, showCount: true,
                            count: a.missions),
                      ],
                    )),
                    _DispoBadge(disponible: a.disponible, large: true),
                  ]),
                  const SizedBox(height: 18),

                  // ── Tarif ───────────────────────────────
                  _DetailSection('Tarif', child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: _kGreenLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _kGreen.withOpacity(0.2)),
                    ),
                    child: Row(children: [
                      const Icon(Icons.payments_outlined, color: _kGreen, size: 20),
                      const SizedBox(width: 10),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(a.tarifFmt,
                            style: _ts(17, color: _kGreen, w: FontWeight.w800)),
                        Text('Paiement mobile money ou espèces',
                            style: _ts(11.5, color: _kGreen.withOpacity(0.7))),
                      ]),
                    ]),
                  )),
                  const SizedBox(height: 16),

                  // ── Zones ──────────────────────────────
                  _DetailSection('Zones d\'intervention', child: Wrap(
                    spacing: 7, runSpacing: 7,
                    children: a.zones.map((z) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.location_on_rounded,
                            size: 11, color: _kTextMuted),
                        const SizedBox(width: 4),
                        Text(z, style: _ts(12, color: _kTextSub,
                            w: FontWeight.w500)),
                      ]),
                    )).toList(),
                  )),
                  const SizedBox(height: 16),

                  // ── Spécialités ─────────────────────────
                  _DetailSection('Spécialités', child: Wrap(
                    spacing: 7, runSpacing: 7,
                    children: a.specialites.map((s) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: Color(a.metier.bgColor),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Color(a.metier.fgColor).withOpacity(0.2)),
                      ),
                      child: Text(s, style: _ts(12,
                          color: Color(a.metier.fgColor), w: FontWeight.w600)),
                    )).toList(),
                  )),
                  const SizedBox(height: 16),

                  // ── Fiabilité ───────────────────────────
                  _DetailSection('Fiabilité & confiance', child: Column(
                    children: [
                      _ScoreRow('Missions réalisées', a.missions, 200),
                      const SizedBox(height: 8),
                      _ScoreRow('Note clients', (a.note * 20).round(), 100),
                      const SizedBox(height: 8),
                      _ScoreRow('Expérience', (a.experienceAns * 7).clamp(0, 100), 100),
                    ],
                  )),
                  const SizedBox(height: 16),

                  // ── Badges ──────────────────────────────
                  _DetailSection('Statut & badges', child: Wrap(
                    spacing: 8, runSpacing: 8,
                    children: [
                      if (a.verified)
                        _Tag(label: '✓ Identité vérifiée',
                            bg: _kGreenLight, fg: _kGreen)
                      else
                        const _Tag(label: 'Non vérifié',
                            bg: _kWarnBg, fg: _kWarnFg),
                      if (a.certifie)
                        const _Tag(label: '🏅 Certifié Nidali',
                            bg: Color(0xFFE8F5E9), fg: Color(0xFF2E7D32)),
                      if (a.litiges == 0)
                        const _Tag(label: '✓ Zéro litige',
                            bg: _kGreenLight, fg: _kGreen)
                      else
                        _Tag(label: '⚠ ${a.litiges} litige(s)',
                            bg: _kWarnBg, fg: _kWarnFg),
                      const _Tag(label: 'Répond en < 2h',
                          bg: Color(0xFFE3F2FD), fg: Color(0xFF0277BD)),
                    ],
                  )),
                  const SizedBox(height: 24),

                  // ── CTA ─────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                          content: Text(
                            'Demande envoyée à ${a.nom}',
                            style: _ts(13, color: Colors.white,
                                w: FontWeight.w600),
                          ),
                          backgroundColor: _kGreen,
                          behavior: SnackBarBehavior.floating,
                          margin: const EdgeInsets.all(14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ));
                      },
                      icon: const Icon(Icons.send_rounded, size: 16),
                      label: Text('Envoyer une demande',
                          style: _ts(14, color: Colors.white,
                              w: FontWeight.w700)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _kGreen,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// COMPOSANTS RÉUTILISABLES
// ─────────────────────────────────────────────────────────────
class _DispoBadge extends StatelessWidget {
  final bool disponible;
  final bool large;
  const _DispoBadge({required this.disponible, this.large = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: large ? 10 : 8, vertical: large ? 5 : 3),
      decoration: BoxDecoration(
        color: disponible ? _kGreenLight : _kOrangeBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        disponible ? '● Disponible' : '● Occupé',
        style: _ts(large ? 11 : 10, w: FontWeight.w600,
            color: disponible ? _kGreen : _kOrange),
      ),
    );
  }
}

class _StarRow extends StatelessWidget {
  final double note;
  final bool showCount;
  final int count;
  const _StarRow({required this.note, this.showCount = false, this.count = 0});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      ...List.generate(5, (i) => Icon(
        i < note.floor() ? Icons.star_rounded : Icons.star_border_rounded,
        size: 12, color: _kStar,
      )),
      const SizedBox(width: 3),
      Text(note.toStringAsFixed(1),
          style: _ts(11, w: FontWeight.w700, color: _kText)),
      if (showCount) ...[
        const SizedBox(width: 3),
        Text('($count)', style: _ts(11, color: _kTextMuted)),
      ],
    ]);
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color bg;
  final Color fg;
  const _Tag({required this.label, this.icon, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
          color: bg, borderRadius: BorderRadius.circular(10)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (icon != null) ...[
          Icon(icon, size: 10, color: fg),
          const SizedBox(width: 3),
        ],
        Text(label, style: _ts(10.5, color: fg, w: FontWeight.w600)),
      ]),
    );
  }
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final String value;
  const _Stat({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 12, color: _kTextMuted),
      const SizedBox(width: 4),
      Text(value, style: _ts(11, color: _kTextSub)),
    ]);
  }
}

class _DetailSection extends StatelessWidget {
  final String title;
  final Widget child;
  const _DetailSection(this.title, {required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title.toUpperCase(),
          style: _ts(10, color: _kTextMuted, w: FontWeight.w700,
              spacing: 0.7)),
      const SizedBox(height: 8),
      child,
    ]);
  }
}

class _ScoreRow extends StatelessWidget {
  final String label;
  final int value;
  final int max;
  const _ScoreRow(this.label, this.value, this.max);

  @override
  Widget build(BuildContext context) {
    final ratio = (value / max).clamp(0.0, 1.0);
    final color = ratio >= 0.8 ? _kGreen
        : ratio >= 0.5 ? _kWarnFg
        : Colors.red.shade700;
    return Row(children: [
      SizedBox(width: 130,
          child: Text(label, style: _ts(12, color: _kTextSub))),
      Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: ratio,
            backgroundColor: const Color(0xFFF0F0F0),
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 5,
          ),
        ),
      ),
      const SizedBox(width: 8),
      Text('$value', style: _ts(11.5, color: color, w: FontWeight.w700)),
    ]);
  }
}

class _EmptyState extends StatelessWidget {
  final String? metier;
  const _EmptyState({this.metier});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.search_off_rounded, size: 48,
            color: _kTextMuted.withOpacity(0.4)),
        const SizedBox(height: 12),
        Text(
          metier != null
              ? 'Aucun $metier disponible'
              : 'Aucun artisan trouvé',
          style: _ts(14, color: _kTextMuted),
        ),
        const SizedBox(height: 4),
        Text('Essayez un autre filtre',
            style: _ts(12, color: _kTextMuted.withOpacity(0.7))),
      ]),
    );
  }
}

// Helper typographie
TextStyle _ts(double size, {
  Color color = _kText,
  FontWeight w = FontWeight.w400,
  double? spacing,
}) =>
    GoogleFonts.nunitoSans(
      fontSize: size,
      fontWeight: w,
      color: color,
      letterSpacing: spacing,
    );
