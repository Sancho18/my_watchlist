import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';
import 'package:my_watchlist/app/modules/favorites/controller/favorites_controller.dart';
import 'package:my_watchlist/app/modules/search/controller/search_controller.dart';

class SearchView extends GetView<SearchController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    // Pegamos o controller de favoritos para usar nos resultados da busca
    final favoritesController = Get.find<FavoritesController>();

    return Scaffold(
      appBar: AppBar(
        // Usamos a propriedade 'title' para o campo de busca
        title: TextField(
          controller: controller.textController,
          autofocus: true, // Já abre o teclado automaticamente
          onChanged: controller.onSearchChanged,
          decoration: InputDecoration(
            hintText: 'Buscar filmes...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.black),
          ),
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: Obx(() {
        // Um switch para construir a UI de acordo com o estado atual
        return switch (controller.searchState.value) {
          SearchState.initial => const Center(
            child: Text('Digite para buscar um filme'),
          ),
          SearchState.loading => const Center(
            child: CircularProgressIndicator(),
          ),
          SearchState.empty => const Center(
            child: Text('Nenhum filme encontrado.'),
          ),
          SearchState.error => const Center(
            child: Text('Ocorreu um erro ao buscar.'),
          ),
          SearchState.success => ListView.builder(
            itemCount: controller.searchResults.length,
            itemBuilder: (context, index) {
              final movie = controller.searchResults[index];
              return Obx(() {
                final isFav = favoritesController.isFavorite(movie.id);
                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 6.0,
                    horizontal: 12.0,
                  ),
                  child: ListTile(
                    title: Text(movie.title),
                    subtitle: Text(
                      'Nota: ${movie.voteAverage.toStringAsFixed(1)}',
                    ),
                    leading: movie.posterPath.isNotEmpty
                        ? Image.network(
                            'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                            width: 60,
                            fit: BoxFit.cover,
                          )
                        : const SizedBox(width: 60, child: Icon(Icons.movie)),
                    onTap: () => Get.toNamed('/details', arguments: movie.id),
                    trailing: IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.red : null,
                      ),
                      onPressed: () =>
                          favoritesController.toggleFavorite(movie.id),
                    ),
                  ),
                );
              });
            },
          ),
        };
      }),
    );
  }
}
