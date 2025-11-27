import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_watchlist/app/data/models/movie_model.dart';
import 'package:my_watchlist/app/data/providers/movie_provider.dart';

class FavoritesController extends GetxController {
  final _box = GetStorage();
  final _movieProvider = MovieProvider();

  // Armazena apenas os IDs dos filmes favoritos para ser leve e rápido.
  final RxList<int> favoriteMovieIds = <int>[].obs;
  
  // Lista dos objetos Movie completos, para a tela de favoritos.
  final RxList<Movie> favoriteMovies = <Movie>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Carrega os IDs salvos no dispositivo assim que o controller é iniciado.
    _loadFavorites();
  }

  void _loadFavorites() {
    List<dynamic>? savedIds = _box.read<List<dynamic>>('favorite_ids');
    if (savedIds != null) {
      favoriteMovieIds.value = savedIds.cast<int>().toList();
    }
  }

  // Verifica se um filme é favorito.
  bool isFavorite(int movieId) {
    return favoriteMovieIds.contains(movieId);
  }

  // Ação de adicionar/remover um favorito.
  void toggleFavorite(int movieId) {
    if (isFavorite(movieId)) {
      favoriteMovieIds.remove(movieId);
      // Remove o filme da lista de favoritos
      favoriteMovies.removeWhere((movie) => movie.id == movieId);
    } else {
      favoriteMovieIds.add(movieId);
    }
    // Salva a lista atualizada no dispositivo.
    _box.write('favorite_ids', favoriteMovieIds.toList());
  }

  // Busca os dados completos dos filmes favoritos para exibir na tela.
  Future<void> fetchFavoriteMovies() async {
    try {
      isLoading.value = true;
      favoriteMovies.clear();
      
      // Cria uma lista de chamadas de API para cada ID
      List<Future<Movie>> futures = favoriteMovieIds
          .map((id) => _movieProvider.getMovieDetails(id))
          .toList();
      
      // Executa todas as chamadas em paralelo
      final movies = await Future.wait(futures);
      favoriteMovies.assignAll(movies);

    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível carregar os filmes favoritos.');
    } finally {
      isLoading.value = false;
    }
  }
}