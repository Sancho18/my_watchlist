import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:my_watchlist/app/data/models/movie_model.dart';
import 'package:my_watchlist/app/data/providers/movie_provider.dart';

class MovieRepository {
  final MovieProvider _provider = MovieProvider();
  late Box<Movie> _popularMoviesBox;
  late Box<Movie> _topRatedMoviesBox;
  Future<void>? _initFuture;

  MovieRepository() {
    _popularMoviesBox = Hive.box<Movie>('popular_movies');
    _topRatedMoviesBox = Hive.box<Movie>('top_rated_movies');
    log('MovieRepository inicializado e caixas do Hive obtidas.');
  }

  Future<void> ensureInitialized() async {
    await _initFuture;
  }

  Future<List<Movie>> getPopularMovies() async {
    try {
      if (_popularMoviesBox.isNotEmpty) {
        log('Buscando filmes populares do CACHE.');
        return _popularMoviesBox.values.toList();
      }
      log('Buscando filmes populares da API.');
      final moviesFromApi = await _provider.getPopularMovies();
      await _popularMoviesBox.putAll({
        for (var movie in moviesFromApi) movie.id: movie,
      });

      return moviesFromApi;
    } catch (e) {
      if (_popularMoviesBox.isNotEmpty) {
        return _popularMoviesBox.values.toList();
      }
      rethrow;
    }
  }

  Future<List<Movie>> getTopRatedMovies() async {
    try {
      if (_topRatedMoviesBox.isNotEmpty) {
        log('Buscando filmes Top Rated do CACHE.');
        return _topRatedMoviesBox.values.toList();
      }

      log('Buscando filmes Top Rated da API.');
      final moviesFromApi = await _provider.getTopRatedMovies();
      await _topRatedMoviesBox.putAll({
        for (var movie in moviesFromApi) movie.id: movie,
      });
      return moviesFromApi;
    } catch (e) {
      if (_topRatedMoviesBox.isNotEmpty) {
        return _topRatedMoviesBox.values.toList();
      }
      rethrow;
    }
  }

  Future<List<Movie>> refreshTopRatedMovies() async {
    log('Forçando atualização dos filmes Top Rated da API.');
    final moviesFromApi = await _provider.getTopRatedMovies();
    await _topRatedMoviesBox.clear();
    await _topRatedMoviesBox.putAll({
      for (var movie in moviesFromApi) movie.id: movie,
    });
    return moviesFromApi;
  }

  Future<List<Movie>> refreshPopularMovies() async {
    try {
      log('Iniciando atualização dos filmes da API...');

      final moviesFromApi = await _provider.getPopularMovies();
      log('Filmes obtidos da API: ${moviesFromApi.length}');

      await _popularMoviesBox.clear();
      log('Cache limpo com sucesso');

      await _popularMoviesBox.putAll({
        for (var movie in moviesFromApi) movie.id: movie,
      });
      log('Novos filmes salvos no cache');

      return moviesFromApi;
    } catch (e, stackTrace) {
      log('Erro ao atualizar filmes: $e');
      log('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<Movie> getMovieDetails(int movieId) {
    return _provider.getMovieDetails(movieId);
  }

  Future<List<Movie>> searchMovies(String query) {
    return _provider.searchMovies(query);
  }
}
