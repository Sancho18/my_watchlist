import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_watchlist/app/core/utils/routs.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Inicializa GetStorage
    await GetStorage.init();
    log('GetStorage inicializado com sucesso');
    
    // Inicializa Hive e registra adaptadores
    await Hive.initFlutter();
    log('Hive inicializado com sucesso');
    
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(MovieAdapter());
      log('MovieAdapter registrado com sucesso');
    }

    log('Abrindo caixas do Hive...');
    await Hive.openBox<Movie>('popular_movies');
    await Hive.openBox<Movie>('top_rated_movies');
    log('Caixas do Hive abertas com sucesso.');
    
    // Registra controllers globais
    Get.put(FavoritesController(), permanent: true);
    log('FavoritesController registrado com sucesso');
    
    runApp(const MyApp());
  } catch (e, stackTrace) {
    log('Erro durante a inicialização do app: $e');
    log('Stack trace: $stackTrace');
    rethrow;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'My Watchlist',
      initialBinding: HomeBinding(),
      initialRoute: '/home',
      getPages: AppPages.routes,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
