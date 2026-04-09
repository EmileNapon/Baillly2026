import 'package:flutter/material.dart';
import '../../data/listing.dart';
import '../widgets/listing_card.dart';
import '../widgets/detail_panel.dart';
import '../../../../shared/theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // ── Sélection détail ──────────────────────────────────────
  Logement? _selected;

  // ── Filtres ───────────────────────────────────────────────
  String _quartier = 'Ouaga 2000'; // Quartier le plus populaire par défaut
  String _category = LogementCategory.celibat; // Célibat par défaut

  // ── Données dérivées ──────────────────────────────────────
  List<Logement> get _filtered => sampleLogements.where((l) {
    if (_quartier.isNotEmpty && l.quartier != _quartier) return false;
    if (_category.isNotEmpty && l.category != _category) return false;
    return true;
  }).toList();



  void _onSelect(Logement l) {
    if (!mounted) return;
    setState(() => _selected = l);
  }

  void _onBack() {
    if (!mounted) return;
    setState(() => _selected = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: _buildAppBar(),
      body: _selected != null ? _buildDetail() : _buildHomeBody()
    );
  }

  // ── AppBar ────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      toolbarHeight: 56,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              color: AppColors.navy,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.home_work_rounded, color: Colors.white, size: 17),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('ImmoBF',
                    style: GoogleFonts.nunitoSans(
                        fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.navy)),
                Text('Logements vérifiés · Ouagadougou',
                    style: AppText.caption(size: 10.5, color: AppColors.textSecond)),
              ],
            ),
          ),
          const Spacer(),
          _CertifiedBadge(),
        ]),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: AppColors.divider),
      ),
    );
  }

  // ── Corps principal ───────────────────────────────────────
  Widget _buildHomeBody() {
    return Column(
      children: [
        // 1. Barre de quartiers horizontale défilante
        QuartierBar(
          selected: _quartier,
          onChanged: (q) => setState(() => _quartier = q),
        ),
        // 2. Barre de catégories
        CategoryBar(
          selected: _category,
          onChanged: (c) => setState(() => _category = c),
        ),
        // 3. Liste de logements
        Expanded(child: _buildListingList()),
      ],
    );
  }

  // ── Détail ────────────────────────────────────────────────
  Widget _buildDetail() {
    return Column(
      children: [
        // Barre horizontale défilante en haut du détail
        const DetailTabBar(),
        Expanded(
          child: Container(
            color: AppColors.white,
            child: DetailPanel(listing: _selected!, onBack: _onBack),
          ),
        ),
      ],
    );
  }

  // ── Liste logements ───────────────────────────────────────
  Widget _buildListingList() {
    final items = _filtered;
    if (items.isEmpty) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.search_off_rounded, size: 44,
              color: AppColors.textMuted.withOpacity(0.35)),
          const SizedBox(height: 12),
          Text('Aucun logement dans ce quartier',
              style: AppText.body(color: AppColors.textMuted)),
          const SizedBox(height: 4),
          Text('Essayez un autre quartier ou une autre catégorie',
              style: AppText.caption(color: AppColors.textMuted)),
        ]),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      itemCount: items.length,
      itemBuilder: (ctx, i) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: ListingCard(
          listing: items[i],
          isActive: _selected?.id == items[i].id,
          onTap: () => _onSelect(items[i]),
        ),
      ),
    );
  }

}

// ── Barre Quartiers ───────────────────────────────────────────────────────────
class QuartierBar extends StatefulWidget {
  final String selected;
  final ValueChanged<String> onChanged;
  const QuartierBar({super.key, required this.selected, required this.onChanged});
  @override
  State<QuartierBar> createState() => _QuartierBarState();
}

class _QuartierBarState extends State<QuartierBar> {
  final _scroll = ScrollController();

  // Quartiers triés : Ouaga 2000 en premier (le plus connu)
  static const _quartiers = [
    'Ouaga 2000', 'Gounghin', 'Pissy', 'Tampouy', 'Dapoya',
    'Cissin', 'Zogona', 'Patte d\'Oie', 'Karpala', 'Bogodogo',
  ];

  @override
  void dispose() { _scroll.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: Column(
        children: [
          SizedBox(
            height: 54,
            child: ListView.builder(
              controller: _scroll,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              itemCount: _quartiers.length,
              itemBuilder: (ctx, i) {
                final q = _quartiers[i];
                final active = widget.selected == q;
                return GestureDetector(
                  onTap: () => widget.onChanged(q),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: active ? AppColors.navy : AppColors.bgPage,
                      borderRadius: BorderRadius.circular(AppDim.radiusPill),
                      border: Border.all(
                        color: active ? AppColors.navy : AppColors.divider,
                        width: 1,
                      ),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      if (i == 0) ...[
                        Icon(Icons.star_rounded,
                            size: 11,
                            color: active ? Colors.amber : AppColors.textMuted),
                        const SizedBox(width: 4),
                      ],
                      Text(q,
                          style: GoogleFonts.nunitoSans(
                              fontSize: 12.5,
                              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                              color: active ? Colors.white : AppColors.textSecond)),
                    ]),
                  ),
                );
              },
            ),
          ),
          Container(height: 1, color: AppColors.divider),
        ],
      ),
    );
  }
}

// ── Barre Catégories ──────────────────────────────────────────────────────────
class CategoryBar extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;
  const CategoryBar({super.key, required this.selected, required this.onChanged});

  static const _cats = [
    _CatItem(LogementCategory.celibat,    'Célibat',     Icons.bed_rounded),
    _CatItem(LogementCategory.miniVilla,  'Mini villa',  Icons.villa_rounded),
    _CatItem(LogementCategory.courUnique, 'Cour unique', Icons.home_rounded),
    _CatItem('magasin',                   'Magasin',     Icons.storefront_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: Column(children: [
        SizedBox(
          height: 52,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            itemCount: _cats.length,
            itemBuilder: (ctx, i) {
              final c = _cats[i];
              final active = selected == c.value;
              return GestureDetector(
                onTap: () => onChanged(c.value),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: active ? AppColors.navyLight : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppDim.radiusPill),
                    border: Border.all(
                      color: active ? AppColors.navy : AppColors.divider,
                      width: active ? 1.5 : 1,
                    ),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(c.icon, size: 13,
                        color: active ? AppColors.navy : AppColors.textMuted),
                    const SizedBox(width: 5),
                    Text(c.label,
                        style: GoogleFonts.nunitoSans(
                            fontSize: 12,
                            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                            color: active ? AppColors.navy : AppColors.textSecond)),
                  ]),
                ),
              );
            },
          ),
        ),
        Container(height: 1, color: AppColors.divider),
      ]),
    );
  }
}

// ── Barre détail horizontale (Aperçu | Média | Localisation | Vérifié | Historique)
class DetailTabBar extends StatefulWidget {
  const DetailTabBar({super.key});
  @override
  State<DetailTabBar> createState() => _DetailTabBarState();
}

class _DetailTabBarState extends State<DetailTabBar> {
  int _activeTab = 0;

  static const _tabs = [
    'Aperçu', 'Média', 'Localisation', 'Vérifié', 'Historique',
  ];

  static const _icons = [
    Icons.info_outline_rounded,
    Icons.photo_library_outlined,
    Icons.location_on_outlined,
    Icons.verified_outlined,
    Icons.history_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: Column(children: [
        SizedBox(
          height: 46,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemCount: _tabs.length,
            itemBuilder: (ctx, i) {
              final active = _activeTab == i;
              return GestureDetector(
                onTap: () => setState(() => _activeTab = i),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: active ? AppColors.navy : Colors.transparent,
                        width: 2.5,
                      ),
                    ),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(_icons[i], size: 14,
                        color: active ? AppColors.navy : AppColors.textMuted),
                    const SizedBox(width: 5),
                    Text(_tabs[i],
                        style: GoogleFonts.nunitoSans(
                            fontSize: 12.5,
                            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                            color: active ? AppColors.navy : AppColors.textSecond)),
                  ]),
                ),
              );
            },
          ),
        ),
        Container(height: 1, color: AppColors.divider),
      ]),
    );
  }
}

// ── Modèles locaux ────────────────────────────────────────────────────────────


class _CatItem {
  final String value;
  final String label;
  final IconData icon;
  const _CatItem(this.value, this.label, this.icon);
}

// ── Badge certifié ────────────────────────────────────────────────────────────
class _CertifiedBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(
      color: AppColors.successBg,
      borderRadius: BorderRadius.circular(AppDim.radiusPill),
      border: Border.all(color: AppColors.successFg.withOpacity(0.3)),
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.verified_rounded, size: 12, color: AppColors.successFg),
      const SizedBox(width: 4),
      Text('Certifié', style: AppText.label(size: 10.5, color: AppColors.successFg)),
    ]),
  );
}
