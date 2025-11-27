
import 'package:get/get.dart';
import 'package:my_watchlist/app/modules/search/controller/search_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchController>(() => SearchController());
  }
}