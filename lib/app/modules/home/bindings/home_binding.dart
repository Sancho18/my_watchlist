import 'dart:developer';

import 'package:get/get.dart';
import 'package:my_watchlist/app/data/repositories/movie_repository.dart';
import 'package:my_watchlist/app/modules/home/controller/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    try {
      // 1. Registra o repository de forma síncrona
      final repository = MovieRepository();
      Get.put<MovieRepository>(
        repository,
        permanent: true,
      );
      log('MovieRepository registrado com sucesso');

      // 2. Registra o controller
      final controller = HomeController(repository);
      Get.put<HomeController>(
        controller,
        permanent: true,
      );
      log('HomeController registrado com sucesso');
    } catch (e) {
      log('Erro ao registrar dependências: $e');
    }
  }
}