import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_watchlist/app/data/models/movie_model.dart';
import 'package:my_watchlist/app/data/providers/movie_provider.dart';

// Um enum para representar os diferentes estados da nossa tela
enum SearchState { initial, loading, success, empty, error }

class SearchController extends GetxController {
  final MovieProvider _movieProvider = MovieProvider();
  final TextEditingController textController = TextEditingController();
  final searchResults = <Movie>[].obs;
  final searchState = SearchState.initial.obs;
  final _searchTerm = ''.obs;

  @override
  void onInit() {
    super.onInit();
    debounce(
      _searchTerm,
      (value) => _searchMovies(value),
      time: const Duration(milliseconds: 800),
    );
  }
  void onSearchChanged(String term) {
    _searchTerm.value = term;
  }
  Future<void> _searchMovies(String query) async {
    if (query.isEmpty) {
      searchState.value = SearchState.initial;
      searchResults.clear();
      return;
    }

    try {
      searchState.value = SearchState.loading;
      final movies = await _movieProvider.searchMovies(query);

      if (movies.isEmpty) {
        searchState.value = SearchState.empty;
      } else {
        searchResults.assignAll(movies);
        searchState.value = SearchState.success;
      }
    } catch (e) {
      searchState.value = SearchState.error;
    }
  }
  
  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}