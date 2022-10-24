import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:loy_eat_customer/model/remote_data.dart';

class FoodDetailController extends GetxController {

  var tempList = [];
  var tempImage = [];
  var listCuisines = [];
  var listCuisinesImage = [];

  var listStoreFreeDelivery = [];
  var listStoreCategoryFreeDelivery = [];
  var listTimeFreeDelivery = [];
  var listImageFreeDelivery = [];
  var listFreeDelivery = [];
  var listAvailableFreeDelivery = [];

  var listStoreDrink = [];
  var listStoreCategoryDrink = [];
  var listTimeDrink = [];
  var listImageDrink = [];
  var listDeliveryFeeDrink = [];
  var listAvailableDrink = [];

  var listAllStore = [];
  var listAllStoreCategory = [];
  var listAllTime = [];
  var listAllImage = [];
  var listAllDeliveryFee = [];
  var listAllAvailable = [];

  final _storeFreeDelivery = RemoteData<List>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List> get storeFreeDeliveryData => _storeFreeDelivery.value;

  final _storeDrink = RemoteData<List>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List> get storeDrink => _storeDrink.value;

  final _cuisines = RemoteData<List>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List> get cuisinesData => _cuisines.value;

  final _allStore = RemoteData<List>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List> get allStore => _allStore.value;

  final merchantCollection = FirebaseFirestore.instance.collection('merchants');
  final categoryCollection = FirebaseFirestore.instance.collection('category');

  @override
  void onInit() {
    super.onInit();
    loadMerchantFreeDelivery();
    loadMerchantDrink();
    loadCuisines();
    loadAllMerchant();
  }

  void loadMerchantFreeDelivery() {
    final data = merchantCollection.where('delivery_fee', isEqualTo: '0.00').snapshots();
    data.listen((result) {
      if (result.docs.isNotEmpty) {
        for (var data in result.docs) {
          listStoreFreeDelivery.add(data.data()['merchant_name'] ?? '');
          listStoreCategoryFreeDelivery.add(data.data()['category'] ?? '');
          listTimeFreeDelivery.add(data.data()['time'] ?? '');
          listImageFreeDelivery.add(data.data()['image'] ?? '');
          listFreeDelivery.add(data.data()['delivery_fee'] ?? '');
          listAvailableFreeDelivery.add(data.data()['is_available'] ?? '');
        }

        _storeFreeDelivery.value = RemoteData<List>(status: RemoteDataStatus.success, data: listStoreFreeDelivery);
      }
    });
  }
  void loadMerchantDrink() {
    final data = merchantCollection.where('category', isEqualTo: 'Beverages').snapshots();
    data.listen((result) {
      if (result.docs.isNotEmpty) {
        for (var data in result.docs) {
          listStoreDrink.add(data.data()['merchant_name'] ?? '');
          listStoreCategoryDrink.add(data.data()['category'] ?? '');
          listTimeDrink.add(data.data()['time'] ?? '');
          listImageDrink.add(data.data()['image'] ?? '');
          listDeliveryFeeDrink.add(data.data()['delivery_fee'] ?? '');
          listAvailableDrink.add(data.data()['is_available'] ?? '');
        }

        _storeDrink.value = RemoteData<List>(status: RemoteDataStatus.success, data: listStoreDrink);
      }
    });
  }
  void loadCuisines() {
    final data = categoryCollection.snapshots();
    data.listen((result) {
      if (result.docs.isNotEmpty) {
        for (var data in result.docs) {
          listCuisines.add(data.data()['category_type'] ?? '');
          listCuisinesImage.add(data.data()['image'] ?? '');
        }

        _cuisines.value = RemoteData<List>(status: RemoteDataStatus.success, data: listCuisines);
      }
    });
  }
  void loadAllMerchant() {
    final data = merchantCollection.orderBy('merchant_id').snapshots();
    data.listen((result) {
      if (result.docs.isNotEmpty) {
        for (var data in result.docs) {
          listAllStore.add(data.data()['merchant_name'] ?? '');
          listAllStoreCategory.add(data.data()['category'] ?? '');
          listAllTime.add(data.data()['time'] ?? '');
          listAllImage.add(data.data()['image'] ?? '');
          listAllDeliveryFee.add(data.data()['delivery_fee'] ?? '');
          listAllAvailable.add(data.data()['is_available'] ?? '');
        }

        _allStore.value = RemoteData<List>(status: RemoteDataStatus.success, data: listAllStore);
      }
    });
  }
}