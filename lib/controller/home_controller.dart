import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat_customer/model/remote_data.dart';

class HomeViewModel extends GetxController {
  var isLogin = false.obs;
  var customerId = '1'.obs;
  var hasRecentOrder = true.obs;

  var listCuisines = [];
  var listImage = [];

  var listRecentStoreId = [];
  var listRecentStoreName = [];
  var listRecentStoreCategory = [];
  var listRecentStoreTime = [];
  var listRecentStoreImage = [];
  var listRecentStoreDeliveryFee = [];
  var listRecentStoreDistance = [];
  var listRecentStoreAvailable = [];

  final categoryCollection = FirebaseFirestore.instance.collection('category');

  final _cuisines = RemoteData<List>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List> get cuisinesData => _cuisines.value;

  final _recentOrder = RemoteData<List>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List> get recentOrder => _recentOrder.value;

  final merchantCollection = FirebaseFirestore.instance.collection('merchants');
  final orderCollection = FirebaseFirestore.instance.collection('orders');

  @override
  void onInit() {
    super.onInit();
    loadCuisines();
    loadRecentOrder();
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
  void loadRecentOrder() {
    final order = orderCollection.where('customer_id', isEqualTo: customerId.value).snapshots();
    order.listen((result) {
      listRecentStoreId.clear();
      clearListStore();
      if (result.docs.isNotEmpty) {
        for (int i = 0 ; i < result.docs.length ; i++){
          var id = result.docs[i]['merchant_id'];
          listRecentStoreId.add(id);
          if (i + 1 == result.docs.length) {
            listRecentStoreId = listRecentStoreId.toSet().toList();
            debugPrint('listRecentStoreId = $listRecentStoreId');

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

  void clearListStore() {
    listRecentStoreName.clear();
    listRecentStoreCategory.clear();
    listRecentStoreTime.clear();
    listRecentStoreImage.clear();
    listRecentStoreDeliveryFee.clear();
    listRecentStoreDistance.clear();
    listRecentStoreAvailable.clear();
  }
}