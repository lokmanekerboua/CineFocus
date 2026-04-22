import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/movie_model.dart';
import '../providers/movie_provider.dart';
import '../../../core/constants/api_constants.dart';

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
    final trailerAsync = ref.watch(trailerKeyProvider(widget.movie.id));

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'movie-${widget.movie.id}',
                child: CachedNetworkImage(
                  imageUrl: "${ApiConstants.backdropBaseUrl}${widget.movie.backdropPath}",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.movie.title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text("${widget.movie.voteAverage} | ${widget.movie.releaseDate}"),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text("Overview", style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(widget.movie.overview, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70)),
                  const SizedBox(height: 32),
                  Text("Trailer", style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  trailerAsync.when(
                    data: (key) {
                      if (key == null) return const Text("No trailer available");
                      _controller ??= YoutubePlayerController(
                        initialVideoId: key,
                        flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
                      );
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: YoutubePlayer(controller: _controller!),
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (_, __) => const Text("Error loading trailer"),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}