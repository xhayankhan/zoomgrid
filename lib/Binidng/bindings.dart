
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:zoomgrid/Controller/EditImageController.dart';

class defaultBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<ImageAndDocumentController>(ImageAndDocumentController());

    // Get.lazyPut(()=>ItemController(),fenix: true);
    // Get.put(customerController());
    // Get.lazyPut(()=>LoginController());
  }

}