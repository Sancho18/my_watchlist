import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:my_watchlist/app/modules/details/bindings/details_binding.dart';
import 'package:my_watchlist/app/modules/details/view/details_view.dart';
import 'package:my_watchlist/app/modules/favorites/bindings/favorites_binding.dart';
import 'package:my_watchlist/app/modules/favorites/view/favorites_view.dart';
import 'package:my_watchlist/app/modules/home/bindings/home_binding.dart';
import 'package:my_watchlist/app/modules/home/view/home_view.dart';
import 'package:my_watchlist/app/modules/search/bindings/search_binding.dart';
import 'package:my_watchlist/app/modules/search/view/search_view.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: '/home',
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: '/details',
      page: () => const DetailsView(),
      binding: DetailsBinding(),
    ),
    GetPage(
      name: '/favorites',
      page: () => const FavoritesView(),
      binding: FavoritesBinding(),
    ),
    GetPage(
      name: '/search',
      page: () => const SearchView(),
      binding: SearchBinding(),
    ),
  ];
}
