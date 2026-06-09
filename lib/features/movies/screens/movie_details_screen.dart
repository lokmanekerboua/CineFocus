import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/movie_model.dart';
import '../providers/movie_provider.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/theme/app_theme.dart';

class MovieDetailsScreen extends ConsumerStatefulWidget {
  final Movie movie;
  const MovieDetailsScreen({super.key, required this.movie});

  @override
  ConsumerState<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends ConsumerState<MovieDetailsScreen> {
  YoutubePlayerController? _controller;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Fix: Using the expected Record argument for the family provider
    final trailerAsync = ref.watch(
      trailerKeyProvider((id: widget.movie.id, isTV: widget.movie.isTV)),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: AppTheme.moodyGradientBackground,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              pinned: true,
              expandedHeight: 450,
              leading: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: 'movie-${widget.movie.id}',
                      child: CachedNetworkImage(
                        imageUrl: "${ApiConstants.backdropBaseUrl}${widget.movie.backdropPath}",
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Container(color: colorScheme.surface),
                      ),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            colorScheme.surface,
                            colorScheme.surface.withOpacity(0.5),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.4, 1.0],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.movie.title,
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: colorScheme.primary.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.star_rounded, color: colorScheme.primary, size: 20),
                              const SizedBox(width: 4),
                              Text(
                                widget.movie.voteAverage.toStringAsFixed(1),
                                style: TextStyle(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (widget.movie.ageRating != null && widget.movie.ageRating!.isNotEmpty) ...[
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: Text(
                              widget.movie.ageRating!,
                              style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                        const SizedBox(width: 12),
                        Text(
                          widget.movie.releaseDate.isNotEmpty 
                            ? widget.movie.releaseDate.split('-').first 
                            : 'N/A',
                          style: const TextStyle(color: Colors.white60, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      "Overview",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.movie.overview,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.white.withOpacity(0.7),
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Trailer",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        if (trailerAsync.hasValue && trailerAsync.value != null)
                          Icon(Icons.play_circle_fill_rounded, color: colorScheme.primary, size: 28),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withOpacity(0.1),
                            blurRadius: 20,
                            spreadRadius: -5,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: trailerAsync.when(
                          data: (key) {
                            if (key == null) {
                              return Container(
                                height: 200,
                                color: Colors.white.withOpacity(0.05),
                                child: const Center(
                                  child: Text("No trailer available", style: TextStyle(color: Colors.white38)),
                                ),
                              );
                            }
                            _controller ??= YoutubePlayerController(
                              initialVideoId: key,
                              flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
                            );
                            return YoutubePlayer(
                              controller: _controller!,
                              progressIndicatorColor: colorScheme.primary,
                            );
                          },
                          loading: () => Container(
                            height: 200,
                            color: Colors.white.withOpacity(0.05),
                            child: Center(child: CircularProgressIndicator(color: colorScheme.primary)),
                          ),
                          error: (_, __) => Container(
                            height: 200,
                            color: Colors.white.withOpacity(0.05),
                            child: const Center(child: Text("Error loading trailer")),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
