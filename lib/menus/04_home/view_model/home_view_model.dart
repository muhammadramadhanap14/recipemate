import 'package:get/get.dart';

class HomeViewModel extends GetxController {
  final nameUser = ''.obs;

  var dataSessionUtil; // nanti hapus

  HomeViewModel({
    required this.dataSessionUtil,
  });

  @override
  void onInit(){
    super.onInit();

  }

  @override
  void onClose() {
    super.onClose();
  }
}