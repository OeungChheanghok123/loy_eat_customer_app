import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:loy_eat_customer/controller/home_controller.dart';
import 'package:loy_eat_customer/model/remote_data.dart';

class FoodDetailController extends GetxController {
  final homeViewModel = Get.put(HomeController());

  var hasRecentOrder = true.obs;

  var listCuisines = [];
  var listCuisinesImage = [];

  var listAllStore = [];
  var listAllStoreCategory = [];
  var listAllTime = [];
  var listAllImage = [];
  var listAllDeliveryFee = [];
  var listAllDistance = [];
  var listAllAvailable = [];

  var listPopularStoreName = [];
  var listPopularStoreCategory = [];
  var listPopularStoreTime = [];
  var listPopularStoreImage = [];
  var listPopularStoreDeliveryFee = [];
  var listPopularStoreDistance = [];
  var listPopularStoreAvailable = [];

  var listRecentStoreId = [];
  var listRecentStoreName = [];
  var listRecentStoreCategory = [];
  var listRecentStoreTime = [];
  var listRecentStoreImage = [];
  var listRecentStoreDeliveryFee = [];
  var listRecentStoreDistance = [];
  var listRecentStoreAvailable = [];

  var listStoreFreeDelivery = [];
  var listStoreCategoryFreeDelivery = [];
  var listTimeFreeDelivery = [];
  var listImageFreeDelivery = [];
  var listFreeDelivery = [];
  var listDistanceFreeDelivery = [];
  var listAvailableFreeDelivery = [];

  final _cuisines = RemoteData<List>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List> get cuisinesData => _cuisines.value;

  final _allStore = RemoteData<List>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List> get allStore => _allStore.value;

  final _storePopular = RemoteData<List>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List> get storePopular => _storePopular.value;

  final _recentOrder = RemoteData<List>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List> get recentOrder => _recentOrder.value;

  final _storeFreeDelivery = RemoteData<List>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List> get storeFreeDeliveryData => _storeFreeDelivery.value;

  final orderCollection = FirebaseFirestore.instance.collection('orders');
  final merchantCollection = FirebaseFirestore.instance.collection('merchants');
  final categoryCollection = FirebaseFirestore.instance.collection('category');

  @override
  void onInit() {
    super.onInit();
    loadCuisines();
    loadAllMerchant();
    loadMerchantPopular();
    loadRecentOrder();
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
  void loadRecentOrder() {
    final order = orderCollection.where('customer_id', isEqualTo: homeViewModel.customerId.value).snapshots();
    order.listen((result) {
      listRecentStoreId.clear();
      clearListRecentStore();
      if (result.docs.isNotEmpty) {
        for (int i = 0 ; i < result.docs.length ; i++){
          var id = result.docs[i]['merchant_id'];
          listRecentStoreId.add(id);
          if (i + 1 == result.docs.length) {
            listRecentStoreId = listRecentStoreId.toSet().toList();

            for (int x = 0 ; x < listRecentStoreId.length ; x++) {
              var id = listRecentStoreId[x];

              final merchant = merchantCollection.where('merchant_id', isEqualTo: id).snapshots();
              merchant.listen((result) {
                if (result.docs.isNotEmpty) {
                  for (var data in result.docs) {
                    listRecentStoreName.add(data.data()['merchant_name'] ?? '');
                    listRecentStoreCategory.add(data.data()['category'] ?? '');
                    listRecentStoreTime.add(data.data()['time'] ?? '');
                    listRecentStoreImage.add(data.data()['image'] ?? '');
                    listRecentStoreDeliveryFee.add(data.data()['delivery_fee'] ?? '');
                    listRecentStoreDistance.add(data.data()['distance'] ?? '');
                    listRecentStoreAvailable.add(data.data()['is_available'] ?? '');
                  }
                  _recentOrder.value = RemoteData<List>(status: RemoteDataStatus.success, data: listRecentStoreName);
                }
                else {
                  _recentOrder.value = RemoteData<List>(status: RemoteDataStatus.none, data: null);
                }
              });
            }
          }
        }
      }
      else {
        _recentOrder.value = RemoteData<List>(status: RemoteDataStatus.none, data: null);
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

        _storePopular.value = RemoteData<List>(status: RemoteDataStatus.success, data: listPopularStoreName);
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
  void clearListRecentStore() {
    listRecentStoreName.clear();
    listRecentStoreCategory.clear();
    listRecentStoreTime.clear();
    listRecentStoreImage.clear();
    listRecentStoreDeliveryFee.clear();
    listRecentStoreDistance.clear();
    listRecentStoreAvailable.clear();
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