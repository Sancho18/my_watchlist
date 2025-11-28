import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:my_watchlist/app/data/models/movie_model.dart';

class MovieProvider {
  final Dio _dio = Dio();
  final String _apiKey = 'YOUR_API_KEY';
  final String _baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Movie>> getPopularMovies() async {
    try {
      log('Fazendo requisição para buscar filmes populares');

      final response = await _dio.get(
        '$_baseUrl/movie/popular',
        queryParameters: {'api_key': _apiKey, 'language': 'pt-BR', 'page': 1},
      );

      if (response.statusCode != 200) {
        log('Erro na resposta da API: ${response.statusCode}');
        throw Exception('API retornou status ${response.statusCode}');
      }

      if (!response.data.containsKey('results')) {
        log('Resposta da API não contém a chave results: ${response.data}');
        throw Exception('Formato de resposta inválido');
      }

      final List<dynamic> results = response.data['results'];
      log('Número de resultados da API: ${results.length}');

      List<Movie> movies = results
          .map((movieJson) => Movie.fromJson(movieJson))
          .toList();

      log('Filmes convertidos com sucesso: ${movies.length}');
      return movies;
    } catch (error, stackTrace) {
      log("Erro ao buscar filmes populares: $error");
      log("Stack trace: $stackTrace");

      if (error is DioException) {
        final dioError = error;
        log("Detalhes do erro Dio: ${dioError.message}");
        log("Dados da resposta: ${dioError.response?.data}");
      }

      throw Exception('Falha ao carregar os filmes: $error');
    }
  }

  Future<Movie> getMovieDetails(int movieId) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/movie/$movieId',
        queryParameters: {'api_key': _apiKey, 'language': 'pt-BR'},
      );
      return Movie.fromJson(response.data);
    } catch (error) {
      log("Erro ao buscar detalhes do filme: $error");
      throw Exception('Falha ao carregar os detalhes do filme');
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    if (query.isEmpty) {
      return [];
    }

    try {
      final response = await _dio.get(
        '$_baseUrl/search/movie',
        queryParameters: {
          'api_key': _apiKey,
          'language': 'pt-BR',
          'query': query,
        },
      );

      final List<dynamic> results = response.data['results'];
      List<Movie> movies = results
          .map((movieJson) => Movie.fromJson(movieJson))
          .toList();
      return movies;
    } catch (error) {
      log("Erro ao buscar filmes: $error");
      throw Exception('Falha ao buscar filmes');
    }
  }

  Future<List<Movie>> getTopRatedMovies() async {
    try {
      final response = await _dio.get(
        '$_baseUrl/movie/top_rated',
        queryParameters: {'api_key': _apiKey, 'language': 'pt-BR', 'page': 1},
      );
      final List<dynamic> results = response.data['results'];
      List<Movie> movies = results
          .map((movieJson) => Movie.fromJson(movieJson))
          .toList();
      return movies;
    } catch (error) {
      log("Erro ao buscar filmes Top Rated: $error");
      throw Exception('Falha ao carregar os filmes Top Rated');
    }
  }
}
