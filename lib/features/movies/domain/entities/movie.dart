class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final String releaseDate;
  final String? ageRating;
  final bool isTV;

  const Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    this.isTV = false,
    this.ageRating,
  });

  Movie copyWith({
    String? ageRating,
    bool? isTV,
  }) {
    return Movie(
      id: id,
      title: title,
      overview: overview,
      posterPath: posterPath,
      backdropPath: backdropPath,
      voteAverage: voteAverage,
      releaseDate: releaseDate,
      isTV: isTV ?? this.isTV,
      ageRating: ageRating ?? this.ageRating,
    );
  }
}
