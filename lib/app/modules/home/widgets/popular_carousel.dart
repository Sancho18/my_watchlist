import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_watchlist/app/data/models/movie_model.dart';
import 'package:my_watchlist/app/modules/favorites/controller/favorites_controller.dart';

class PopularCarouselWidget extends StatefulWidget {
  final List<Movie> movies;
  final FavoritesController favoritesController;

  const PopularCarouselWidget({
    super.key,
    required this.movies,
    required this.favoritesController,
  });

  @override
  State<PopularCarouselWidget> createState() => _PopularCarouselWidgetState();
}

class _PopularCarouselWidgetState extends State<PopularCarouselWidget> {
  late PageController _pageController;
  Timer? _autoScrollTimer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.7,
      initialPage: _currentPage,
    );
    _startAutoScroll();
  }

  @override
  void dispose() {
    _stopAutoScroll();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _stopAutoScroll();
    
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (widget.movies.isEmpty) return;

      _currentPage = _pageController.page!.round();
      _currentPage++;

      if (_currentPage >= widget.movies.length) {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.width * 0.8,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollStartNotification && notification.dragDetails != null) {
            _stopAutoScroll();
          } else if (notification is ScrollEndNotification) {
            _startAutoScroll();
          }
          return true;
        },
        child: PageView.builder(
          controller: _pageController,
          itemCount: widget.movies.length,
          itemBuilder: (context, index) {
            final movie = widget.movies[index];
            final imageUrl = 'https://image.tmdb.org/t/p/w500${movie.posterPath}';
            
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
              child: GestureDetector(
                onTap: () async {
                  _stopAutoScroll();
                  await Get.toNamed('/details', arguments: movie.id);
                  _startAutoScroll();
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(child: Icon(Icons.movie, size: 100)),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.black, Colors.transparent],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16.0,
                        left: 16.0,
                        right: 16.0,
                        child: Text(
                          movie.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            shadows: [Shadow(blurRadius: 10.0, color: Colors.black)],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8.0,
                        right: 8.0,
                        child: Obx(() {
                          // 9. Acesse o controller através de 'widget.'
                          final isFav = widget.favoritesController.isFavorite(movie.id);
                          return IconButton(
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? Colors.red : Colors.white70,
                              size: 30.0,
                              shadows: const [Shadow(blurRadius: 10.0, color: Colors.black)],
                            ),
                            onPressed: () => widget.favoritesController.toggleFavorite(movie.id),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}