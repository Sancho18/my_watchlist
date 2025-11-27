import 'dart:developer';

import 'package:get/get.dart';
import 'package:my_watchlist/app/data/models/movie_model.dart';
import 'package:my_watchlist/app/data/repositories/movie_repository.dart';

class HomeController extends GetxController {
  final MovieRepository _repository;
  final RxBool isLoading = false.obs;
  final RxList<Movie> popularMovies = <Movie>[].obs;
  final RxList<Movie> topRatedMovies = <Movie>[].obs;

  HomeController(this._repository);

  @override
  void onInit() {
    super.onInit();
    fetchPopularMovies();
    fetchTopRatedMovies();
  }

  void fetchPopularMovies() async {
    if (isLoading.value) {
      log('Já existe uma busca em andamento, ignorando chamada');
      return;
    }

    isLoading.value = true;

    try {
      log('Iniciando busca de filmes populares');
      isLoading.value = true;
      log('Aguardando inicialização do repository...');
      await _repository.ensureInitialized();
      log('Repository inicializado com sucesso');
      log('Tentando buscar da API primeiro...');
      try {
        final moviesFromApi = await _repository.refreshPopularMovies();
        if (moviesFromApi.isNotEmpty) {
          log('Filmes obtidos com sucesso da API: ${moviesFromApi.length}');
          popularMovies.assignAll(moviesFromApi);
          isLoading.value = false;
          return;
        }
      } catch (apiError) {
        log('Erro ao buscar da API, tentando cache: $apiError');
      }
      var movies = await _repository.getPopularMovies();
      log('Filmes recuperados do cache: ${movies.length}');

      if (movies.isEmpty) {
        log('Nenhum filme encontrado em nenhuma fonte');
        Get.snackbar(
          'Atenção',
          'Não foi possível carregar os filmes. Tente novamente.',
          duration: const Duration(seconds: 3),
        );
      } else {
        popularMovies.assignAll(movies);
        log('Filmes carregados com sucesso: ${movies.length} filmes');
      }
    } catch (e, stackTrace) {
      log('Erro ao carregar filmes: $e');
      log('Stack trace: $stackTrace');
      Get.snackbar(
        'Erro',
        'Não foi possível carregar os filmes. Tente novamente.',
        duration: const Duration(seconds: 3),
      );
    } finally {
      log('Finalizando fetchPopularMovies, setando loading para false');
      isLoading.value = false;
    }
  }

  void fetchTopRatedMovies() async {
    try {
      var movies = await _repository.getTopRatedMovies();
      topRatedMovies.assignAll(movies);
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Não foi possível carregar os filmes mais avaliados.',
      );
    }
  }

  Future<void> refreshMovies() async {
    try {
      final popularFuture = _repository.refreshPopularMovies();
      final topRatedFuture = _repository.refreshTopRatedMovies();

      final results = await Future.wait([popularFuture, topRatedFuture]);

      popularMovies.assignAll(results[0]);
      topRatedMovies.assignAll(results[1]);
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível atualizar os filmes.');
    }
  }
}
