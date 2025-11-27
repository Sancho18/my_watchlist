import 'package:get/get.dart';
import 'package:my_watchlist/app/modules/details/controller/details_controller.dart';

class DetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailsController>(() => DetailsController());
  }
}