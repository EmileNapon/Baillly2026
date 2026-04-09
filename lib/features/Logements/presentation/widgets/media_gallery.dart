import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import '../../data/listing.dart';
import '../../../../shared/theme/app_theme.dart';

// ================================================================
//  GALERIE MÉDIAS PAR PIÈCE
// ================================================================
class MediaGallery extends StatefulWidget {
  final Map<String, List<PieceMedia>> mediasByPiece;
  const MediaGallery({super.key, required this.mediasByPiece});

  @override
  State<MediaGallery> createState() => _MediaGalleryState();
}

class _MediaGalleryState extends State<MediaGallery> {
  late String _activePiece;

  // Ordre canonique des pièces
  static const _order = ['Cour', 'Salon', 'Chambre', 'Douche', 'Cuisine'];

  List<String> get _pieces {
    final keys = widget.mediasByPiece.keys.toList();
    keys.sort((a, b) {
      final ia = _order.indexOf(a);
      final ib = _order.indexOf(b);
      if (ia == -1 && ib == -1) return a.compareTo(b);
      if (ia == -1) return 1;
      if (ib == -1) return -1;
      return ia.compareTo(ib);
    });
    return keys;
  }

  @override
  void initState() {
    super.initState();
    _activePiece = _pieces.isNotEmpty ? _pieces.first : '';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mediasByPiece.isEmpty) return const SizedBox.shrink();
    final pieces = _pieces;
    final items  = widget.mediasByPiece[_activePiece] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Onglets pièces ──────────────────────────────────
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            itemCount: pieces.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (ctx, i) {
              final p = pieces[i];
              final active = p == _activePiece;
              return GestureDetector(
                onTap: () => setState(() => _activePiece = p),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                  decoration: BoxDecoration(
                    color: active ? AppColors.navy : AppColors.white,
                    borderRadius: BorderRadius.circular(AppDim.radiusPill),
                    border: Border.all(
                      color: active ? AppColors.navy : AppColors.divider,
                      width: AppDim.borderW,
                    ),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_pieceIcon(p), size: 13,
                            color: active ? Colors.white : AppColors.textSecond),
                        const SizedBox(width: 5),
                        Text(p,
                            style: GoogleFonts.nunitoSans(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: active ? Colors.white : AppColors.textSecond,
                            )),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        // ── Grille médias ────────────────────────────────────
        if (items.isEmpty)
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.bgPage,
              borderRadius: BorderRadius.circular(AppDim.radiusLg),
            ),
            child: Center(child: Text('Aucun média', style: AppText.caption())),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 4 / 3,
            ),
            itemCount: items.length,
            itemBuilder: (ctx, i) => _MediaTile(media: items[i]),
          ),
      ],
    );
  }

  IconData _pieceIcon(String label) {
    switch (label) {
      case 'Cour':    return Icons.yard_rounded;
      case 'Salon':   return Icons.weekend_rounded;
      case 'Chambre': return Icons.bed_rounded;
      case 'Douche':  return Icons.shower_rounded;
      case 'Cuisine': return Icons.kitchen_rounded;
      default:        return Icons.image_rounded;
    }
  }
}

// ── Tuile individuelle ──────────────────────────────────────
class _MediaTile extends StatelessWidget {
  final PieceMedia media;
  const _MediaTile({required this.media});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openFullscreen(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDim.radiusMd),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Miniature
            media.type == 'video'
                ? _VideoThumbnail(url: media.assetPath)
                : CachedNetworkImage(
                    imageUrl: media.assetPath,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: AppColors.bgPage),
                    errorWidget: (_, __, ___) => Container(
                      color: AppColors.bgPage,
                      child: const Icon(Icons.broken_image_rounded,
                          color: AppColors.textMuted),
                    ),
                  ),
            // Badge type
            Positioned(
              bottom: 8, right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.62),
                  borderRadius: BorderRadius.circular(AppDim.radiusPill),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      media.type == 'video'
                          ? Icons.play_circle_rounded
                          : Icons.photo_rounded,
                      size: 12, color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      media.type == 'video' ? 'Vidéo' : 'Photo',
                      style: GoogleFonts.nunitoSans(
                        fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openFullscreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => _FullscreenViewer(media: media),
    ));
  }
}

// ── Thumbnail vidéo ─────────────────────────────────────────
class _VideoThumbnail extends StatelessWidget {
  final String url;
  const _VideoThumbnail({required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1A1A2E),
      child: Center(
        child: Icon(Icons.play_circle_outline_rounded,
            size: 44, color: Colors.white.withOpacity(0.85)),
      ),
    );
  }
}

// ── Visionneur plein écran ──────────────────────────────────
class _FullscreenViewer extends StatefulWidget {
  final PieceMedia media;
  const _FullscreenViewer({required this.media});

  @override
  State<_FullscreenViewer> createState() => _FullscreenViewerState();
}

class _FullscreenViewerState extends State<_FullscreenViewer> {
  VideoPlayerController? _ctrl;
  bool _initialized = false;
  bool _playing = false;

  @override
  void initState() {
    super.initState();
    if (widget.media.type == 'video') _initVideo();
  }

  Future<void> _initVideo() async {
    _ctrl = VideoPlayerController.networkUrl(Uri.parse(widget.media.assetPath));
    await _ctrl!.initialize();
    if (mounted) setState(() => _initialized = true);
  }

  @override
  void dispose() {
    _ctrl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          '${widget.media.label} · ${widget.media.type == "video" ? "Vidéo" : "Photo"}',
          style: GoogleFonts.nunitoSans(
            fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white,
          ),
        ),
      ),
      body: widget.media.type == 'video' ? _videoBody() : _photoBody(),
    );
  }

  Widget _photoBody() {
    return InteractiveViewer(
      child: Center(
        child: CachedNetworkImage(
          imageUrl: widget.media.assetPath,
          fit: BoxFit.contain,
          placeholder: (_, __) => const Center(
              child: CircularProgressIndicator(color: Colors.white)),
          errorWidget: (_, __, ___) => const Icon(Icons.broken_image_rounded,
              color: Colors.white54, size: 64),
        ),
      ),
    );
  }

  Widget _videoBody() {
    if (!_initialized || _ctrl == null) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AspectRatio(
          aspectRatio: _ctrl!.value.aspectRatio,
          child: VideoPlayer(_ctrl!),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                _playing ? Icons.pause_circle_rounded : Icons.play_circle_rounded,
                size: 56, color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _playing ? _ctrl!.pause() : _ctrl!.play();
                  _playing = !_playing;
                });
              },
            ),
          ],
        ),
        VideoProgressIndicator(_ctrl!, allowScrubbing: true,
            colors: const VideoProgressColors(
              playedColor: AppColors.navy,
              bufferedColor: Colors.white24,
              backgroundColor: Colors.white12,
            )),
      ],
    );
  }
}
