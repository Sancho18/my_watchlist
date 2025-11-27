import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_watchlist/app/modules/favorites/controller/favorites_controller.dart';
import 'package:my_watchlist/app/modules/home/controller/home_controller.dart';
import 'package:my_watchlist/app/modules/home/widgets/popular_carousel.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesController = Get.find<FavoritesController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('MyWatchlist'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Get.toNamed('/search'),
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => Get.toNamed('/favorites'),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.popularMovies.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.popularMovies.isEmpty) {
          return const Center(child: Text('Nenhum filme popular encontrado.'));
        }
        return RefreshIndicator(
          onRefresh: controller.refreshMovies,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PopularCarouselWidget(
                movies: controller.popularMovies,
                favoritesController: favoritesController,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Text(
                  'Melhores Avaliados',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.topRatedMovies.length,
                  itemBuilder: (context, index) {
                    final movie = controller.topRatedMovies[index];
                    final imageUrl =
                        'https://image.tmdb.org/t/p/w500${movie.posterPath}';
                    return Obx(() {
                      final isFav = favoritesController.isFavorite(movie.id);
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          vertical: 6.0,
                          horizontal: 12.0,
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0,
                          ),
                          leading: Image.network(
                            imageUrl,
                            width: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.movie, size: 60);
                            },
                          ),
                          title: Text(
                            movie.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Nota: ${movie.voteAverage.toStringAsFixed(1)}',
                          ),
                          onTap: () =>
                              Get.toNamed('/details', arguments: movie.id),
                          trailing: IconButton(
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? Colors.red : Colors.grey,
                              size: 28,
                            ),
                            onPressed: () {
                              favoritesController.toggleFavorite(movie.id);
                            },
                          ),
                        ),
                      );
                    });
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
