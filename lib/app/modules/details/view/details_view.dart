import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_watchlist/app/modules/details/controller/details_controller.dart';
import 'package:my_watchlist/app/modules/favorites/controller/favorites_controller.dart';

class DetailsView extends GetView<DetailsController> {
  const DetailsView({super.key});

   @override
  Widget build(BuildContext context) {
    final favoritesController = Get.find<FavoritesController>();

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.movie.value?.title ?? 'Detalhes')),
        actions: [
          Obx(() {
            if (controller.movie.value == null) {
              return const SizedBox.shrink();
            }
            final isFav = favoritesController.isFavorite(controller.movie.value!.id);
            return IconButton(
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? Colors.red : null,
              ),
              onPressed: () {
                favoritesController.toggleFavorite(controller.movie.value!.id);
              },
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.movie.value == null) {
          return const Center(child: Text('Filme não encontrado.'));
        }

        final movie = controller.movie.value!;
        final imageUrl = 'https://image.tmdb.org/t/p/w500${movie.posterPath}';
        final genres = movie.genres?.map((g) => g.name).join(', ') ?? 'N/A';
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  imageUrl,
                  height: 300,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.movie, size: 150),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                movie.title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 5),
                  Text(
                    '${movie.voteAverage.toStringAsFixed(1)}/10',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(width: 20),
                  const Icon(Icons.timer_outlined, size: 20),
                  const SizedBox(width: 5),
                  Text(
                    '${movie.runtime ?? '?'} min',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Gêneros: $genres',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 20),
              Text('Sinopse', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 5),
              Text(
                movie.overview.isNotEmpty
                    ? movie.overview
                    : 'Sinopse não disponível.',
                textAlign: TextAlign.justify,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        );
      }),
    );
  }
}
