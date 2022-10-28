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
  var listDistanceFreeDelivery = [];
  var listAvailableFreeDelivery = [];

  var listPopularStoreName = [];
  var listPopularStoreCategory = [];
  var listPopularStoreTime = [];
  var listPopularStoreImage = [];
  var listPopularStoreDeliveryFee = [];
  var listPopularStoreDistance = [];
  var listPopularStoreAvailable = [];

  var listAllStore = [];
  var listAllStoreCategory = [];
  var listAllTime = [];
  var listAllImage = [];
  var listAllDeliveryFee = [];
  var listAllDistance = [];
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
    loadCuisines();
    loadAllMerchant();
    loadMerchantPopular();
    loadMerchantFreeDelivery();
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
      clearAllStore();

      if (result.docs.isNotEmpty) {
        for (var data in result.docs) {
          listAllStore.add(data.data()['merchant_name'] ?? '');
          listAllStoreCategory.add(data.data()['category'] ?? '');
          listAllTime.add(data.data()['time'] ?? '');
          listAllImage.add(data.data()['image'] ?? '');
          listAllDeliveryFee.add(data.data()['delivery_fee'] ?? '');
          listAllDistance.add(data.data()['distance'] ?? '');
          listAllAvailable.add(data.data()['is_available'] ?? '');
        }

        _allStore.value = RemoteData<List>(status: RemoteDataStatus.success, data: listAllStore);
      }
    });
  }
  void loadMerchantPopular() {
    final data = merchantCollection.orderBy('merchant_id', descending: true).limit(10).snapshots();
    data.listen((result) {
      if (result.docs.isNotEmpty) {
        clearDrink();
        for (var data in result.docs) {
          listPopularStoreName.add(data.data()['merchant_name'] ?? '');
          listPopularStoreCategory.add(data.data()['category'] ?? '');
          listPopularStoreTime.add(data.data()['time'] ?? '');
          listPopularStoreImage.add(data.data()['image'] ?? '');
          listPopularStoreDeliveryFee.add(data.data()['delivery_fee'] ?? '');
          listPopularStoreDistance.add(data.data()['distance'] ?? '');
          listPopularStoreAvailable.add(data.data()['is_available'] ?? '');
        }

        _storeDrink.value = RemoteData<List>(status: RemoteDataStatus.success, data: listPopularStoreName);
      }
    });
  }
  void loadMerchantFreeDelivery() {
    final data = merchantCollection.where('delivery_fee', isEqualTo: '0.00').snapshots();
    data.listen((result) {
      if (result.docs.isNotEmpty) {
        clearFreeDelivery();
        for (var data in result.docs) {
          listStoreFreeDelivery.add(data.data()['merchant_name'] ?? '');
          listStoreCategoryFreeDelivery.add(data.data()['category'] ?? '');
          listTimeFreeDelivery.add(data.data()['time'] ?? '');
          listImageFreeDelivery.add(data.data()['image'] ?? '');
          listFreeDelivery.add(data.data()['delivery_fee'] ?? '');
          listDistanceFreeDelivery.add(data.data()['distance'] ?? '');
          listAvailableFreeDelivery.add(data.data()['is_available'] ?? '');
        }

        _storeFreeDelivery.value = RemoteData<List>(status: RemoteDataStatus.success, data: listStoreFreeDelivery);
      }
    });
  }

  void clearAllStore() {
    listAllStore.clear();
    listAllStoreCategory.clear();
    listAllTime.clear();
    listAllImage.clear();
    listAllDeliveryFee.clear();
    listAllDistance.clear();
    listAllAvailable.clear();
  }
  void clearFreeDelivery() {
    listStoreFreeDelivery.clear();
    listStoreCategoryFreeDelivery.clear();
    listTimeFreeDelivery.clear();
    listImageFreeDelivery.clear();
    listFreeDelivery.clear();
    listDistanceFreeDelivery.clear();
    listAvailableFreeDelivery.clear();
  }
  void clearDrink() {
    listPopularStoreName.clear();
    listPopularStoreCategory.clear();
    listPopularStoreTime.clear();
    listPopularStoreImage.clear();
    listPopularStoreDeliveryFee.clear();
    listPopularStoreDistance.clear();
    listPopularStoreAvailable.clear();
  }
}