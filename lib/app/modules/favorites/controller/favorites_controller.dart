import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_watchlist/app/data/models/movie_model.dart';
import 'package:my_watchlist/app/data/providers/movie_provider.dart';

class FavoritesController extends GetxController {
  final _box = GetStorage();
  final _movieProvider = MovieProvider();

  final RxList<int> favoriteMovieIds = <int>[].obs;
  
  final RxList<Movie> favoriteMovies = <Movie>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadFavorites();
  }

  void _loadFavorites() {
    List<dynamic>? savedIds = _box.read<List<dynamic>>('favorite_ids');
    if (savedIds != null) {
      favoriteMovieIds.value = savedIds.cast<int>().toList();
    }
  }

  bool isFavorite(int movieId) {
    return favoriteMovieIds.contains(movieId);
  }

  void toggleFavorite(int movieId) {
    if (isFavorite(movieId)) {
      favoriteMovieIds.remove(movieId);
      favoriteMovies.removeWhere((movie) => movie.id == movieId);
    } else {
      favoriteMovieIds.add(movieId);
    }
    _box.write('favorite_ids', favoriteMovieIds.toList());
  }

  Future<void> fetchFavoriteMovies() async {
    try {
      isLoading.value = true;
      favoriteMovies.clear();
      
      List<Future<Movie>> futures = favoriteMovieIds
          .map((id) => _movieProvider.getMovieDetails(id))
          .toList();
      
      final movies = await Future.wait(futures);
      favoriteMovies.assignAll(movies);

    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível carregar os filmes favoritos.');
    } finally {
      isLoading.value = false;
    }
  }
}