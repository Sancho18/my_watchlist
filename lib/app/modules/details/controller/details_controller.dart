import 'dart:developer';

import 'package:get/get.dart';
import 'package:my_watchlist/app/data/models/movie_model.dart';
import 'package:my_watchlist/app/data/providers/movie_provider.dart';

class DetailsController extends GetxController {
  final MovieProvider _movieProvider = MovieProvider();
  
  final Rx<Movie?> movie = Rx<Movie?>(null);
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    final int movieId = Get.arguments;
    fetchMovieDetails(movieId);
  }

  void fetchMovieDetails(int movieId) async {
    try {
      isLoading.value = true;
      movie.value = await _movieProvider.getMovieDetails(movieId);
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível carregar os detalhes do filme.');
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}