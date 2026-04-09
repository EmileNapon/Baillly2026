// Import du package principal Flutter (UI Material Design)
import 'package:flutter/material.dart';

// Import de ton app (non utilisé ici mais prêt pour extension)




// Taille standard des icônes
const double iconSize = 24;

// Point d'entrée de l'application
void main() {
  runApp(LinkedInApp()); // Lance l'application
}

// ─────────────────────────────────────────────────────────────
// APPLICATION PRINCIPALE
// ─────────────────────────────────────────────────────────────
class LinkedInApp extends StatelessWidget {
  const LinkedInApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LinkedIn UI', // Nom de l'app
      debugShowCheckedModeBanner: false, // Enlever le bandeau debug

      // Thème global
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF3F2EF),
      ),
      // Page d'accueil
      home:const HomePage(),
    );
  }
}


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

     body: Column(
      children: [
            
            Expanded(
              child: Container(
                
              ),
            ),
          ],
     ),
   //    bottomNavigationBar: BuildBottomBar(),
    );
  
  }
}





/*


// ─────────────────────────────────────────────────────────────
// PAGE PRINCIPALE (STATEFUL → car il y a des interactions)
// ─────────────────────────────────────────────────────────────
class LinkedInHomePage extends StatefulWidget {
  const LinkedInHomePage({super.key});

  @override
  State<LinkedInHomePage> createState() => _LinkedInHomePageState();
}

class _LinkedInHomePageState extends State<LinkedInHomePage> {

  // Index de l’onglet sélectionné (0 = Accueil)
  int _selectedTab = 0;



  // Etat du champ recherche (focus ou non)
  bool _searchFocused = false;

  // Couleurs d'avatar (changent dynamiquement)
  final _avatarColors = const Color(0xFFB24020);
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // Couleur de fond globale
      backgroundColor: const Color(0xFFF3F2EF),
 
      body: SafeArea(
        child: Column(
          children: [

            // Affiche AppBar seulement sur Accueil
            if (_selectedTab == 0) _buildAppBar(),

            // Contenu principal
            Expanded(child: _buildContent()),
          ],
        ),
      ),

      // Barre de navigation en bas
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // APPBAR PERSONNALISÉE (style LinkedIn)
  // ─────────────────────────────────────────────────────────────
  Widget _buildAppBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        children: [
          Row(
            children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: _avatarColors,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFE0DDD8),
                          width: 2,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'EN',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    // Petit point de statut
                  
              const SizedBox(width:4),

              // ─── INFOS UTILISATEUR ───
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Bonjour, Emile',
                        style: TextStyle(fontSize: 11, color: Color(0xFF666666))),
                    SizedBox(height: 1),
                    Text('Emile Napon',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF191919))),
                  ],
                ),
              ),

              // ─── BOUTONS ACTIONS ───
              Row(
                children: [
                  _IconBtn(
                    icon: Icons.notifications_none,
                    onTap:  () {},
                  ),
                   const SizedBox(width:20),
                  _IconBtn(
                    icon: Icons.settings_outlined,
                    highlight: true,
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ─── BARRE DE RECHERCHE ───
          GestureDetector(
            onTap: () => setState(() => _searchFocused = true),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: _searchFocused ? Colors.white : const Color(0xFFEEF0F1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: _searchFocused ? const Color(0xFF0A66C2) : Colors.transparent,
                  width: 1.5,
                ),
              ),

              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

              child: Row(
                children: const [
                  Icon(Icons.search, size: 16),
                  SizedBox(width: 8),
                  Text('Rechercher'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // BARRE DE NAVIGATION BASSE
  // ─────────────────────────────────────────────────────────────
  Widget _buildBottomBar() {
    final tabs = [
      _TabData(icon: Icons.home_outlined, label: 'Accueil'),
      _TabData(icon: Icons.home_work_outlined, label: 'Logements'),
      _TabData(icon: Icons.work_outline, label: 'Artisans'),
      _TabData(icon: Icons.person_outline, label: 'Profil'),
    ];

    return Container(
      color: Colors.white,

      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final i = entry.key;
          final tab = entry.value;
          final isActive = _selectedTab == i;

          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = i),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(tab.icon, color: isActive ? Colors.black : Colors.grey),
                  Text(tab.label),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // CONTENU PRINCIPAL (change selon onglet)
  // ─────────────────────────────────────────────────────────────
  Widget _buildContent() {
    switch (_selectedTab) {

      case 0:
        return _buildLinkedInFeed();

      case 1:
        // Intégration module Logements
        return const HomeScreen();

      default:
        return _buildPlaceholder(_selectedTab);
    }
  }

  // Fake feed (squelettes)
  Widget _buildLinkedInFeed() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        _SkeletonCard(lines: 3),
        SizedBox(height: 10),
        _SkeletonCard(lines: 2),
      ],
    );
  }

  // Placeholder écran vide
  Widget _buildPlaceholder(int tab) {
    return const Center(
      child: Text("Bientôt disponible a"),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// WIDGETS RÉUTILISABLES
// ─────────────────────────────────────────────────────────────

// Bouton icône avec badge
class _IconBtn extends StatelessWidget {
  final IconData icon;
  final int badge;
  final bool highlight;
  final VoidCallback onTap;

  const _IconBtn({
    required this.icon,
    required this.onTap,
    this.badge = 0,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Icon(icon),
        if (badge > 0)
          Positioned(
            right: 0,
            child: Text('$badge'),
          ),
      ],
    );
  }
}



// Carte skeleton (chargement)
class _SkeletonCard extends StatelessWidget {
  final int lines;

  const _SkeletonCard({required this.lines});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      color: Colors.grey[300],
    );
  }
}

// Structure des tabs
class _TabData {
  final IconData icon;
  final String label;
  _TabData({required this.icon, required this.label});
}

*/