import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_watchlist/app/data/models/genre_model.dart';

part 'movie_model.g.dart';

@HiveType(typeId: 0) // Identificador único para este tipo de objeto
class Movie {
  @HiveField(0) // Índice único para cada campo
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String overview;

  @HiveField(3)
  final String posterPath;

  @HiveField(4)
  final double voteAverage;

  // Campos de detalhes (não precisam ser salvos na lista principal)
  // Não vamos anotá-los com @HiveField por enquanto para simplificar.
  final List<Genre>? genres;
  final int? runtime;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
    this.genres,
    this.runtime,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      overview: json['overview'],
      posterPath: json['poster_path'] ?? '',
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      genres: json['genres'] != null
          ? (json['genres'] as List).map((g) => Genre.fromJson(g)).toList()
          : null,
      runtime: json['runtime'],
    );
  }
}
