// lib/app/modules/favorites/view/favorites_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_watchlist/app/modules/favorites/controller/favorites_controller.dart';

class FavoritesView extends GetView<FavoritesController> {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    // O GetView já nos dá acesso ao 'controller'
    // (FavoritesController, neste caso)
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Favoritos'),
      ),
      // Usamos o FutureBuilder para chamar a função que busca os filmes
      // na primeira vez que a tela é construída
      body: FutureBuilder(
        future: controller.fetchFavoriteMovies(),
        builder: (context, snapshot) {
          // Enquanto os dados estão sendo buscados
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Podemos usar o Obx para mostrar um loading mais inteligente
            return Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              // Se terminou de carregar mas a lista está vazia
              return _buildFavoritesList();
            });
          }
          // Se a busca inicial terminou (com ou sem erro),
          // deixamos o Obx gerenciar a UI
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
              // TUDO: Não está excluindo, verificar...
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