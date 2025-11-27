// lib/app/modules/favorites/view/favorites_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_watchlist/app/modules/favorites/controller/favorites_controller.dart';

class FavoritesView extends GetView<FavoritesController> {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Favoritos'),
      ),
      body: FutureBuilder(
        future: controller.fetchFavoriteMovies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return _buildFavoritesList();
            });
          }
          return _buildFavoritesList();
        },
      ),
    );
  }

  Widget _buildFavoritesList() {
    return Obx(() {
      if (controller.isLoading.value && controller.favoriteMovies.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.favoriteMovies.isEmpty) {
        return const Center(
          child: Text('Você ainda não adicionou filmes aos favoritos.'),
        );
      }

      return ListView.builder(
        itemCount: controller.favoriteMovies.length,
        itemBuilder: (context, index) {
          final movie = controller.favoriteMovies[index];
          final imageUrl = 'https://image.tmdb.org/t/p/w500${movie.posterPath}';

          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: Image.network(imageUrl, width: 60, fit: BoxFit.cover),
              title: Text(movie.title),
              subtitle: Text('Nota: ${movie.voteAverage.toStringAsFixed(1)}'),
              onTap: () => Get.toNamed('/details', arguments: movie.id),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: () => controller.toggleFavorite(movie.id),
              ),
            ),
          );
        },
      );
    });
  }
}