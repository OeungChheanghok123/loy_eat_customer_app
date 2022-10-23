import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:loy_eat_customer/model/remote_data.dart';

class HomeController extends GetxController {

  var listCuisines = [];
  var listImage = [];

  final categoryCollection = FirebaseFirestore.instance.collection('category');

  final _cuisines = RemoteData<List>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List> get cuisinesData => _cuisines.value;

  @override
  void onInit() {
    super.onInit();
    loadCuisines();
  }

  void foodDeliveryButton() {
    Get.toNamed('/food_detail');
  }

  void loadCuisines() {
    final data = categoryCollection.snapshots();
    data.listen((result) {
      if (result.docs.isNotEmpty) {
        for (var data in result.docs) {
          listCuisines.add(data.data()['category_type'] ?? '');
          listImage.add(data.data()['image'] ?? '');
        }

        _cuisines.value = RemoteData<List>(status: RemoteDataStatus.success, data: listCuisines);
      }
    });
  }
}