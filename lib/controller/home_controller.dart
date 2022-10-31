import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat_customer/controller/cache_helper.dart';
import 'package:loy_eat_customer/model/remote_data.dart';

class HomeController extends GetxController {
  var isLogin = false.obs;
  var customerId = ''.obs;
  var customerPhone = ''.obs;
  var customerName = ''.obs;
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
  final customerCollection = FirebaseFirestore.instance.collection('customers');

  final cacheHelper = CacheHelper();

  @override
  void onInit() {
    super.onInit();
    getCustomerDetail();
    loadCuisines();
  }

  void getCustomerDetail() async {
    customerPhone.value = await cacheHelper.readCache();

    if (customerPhone.value != '') {
      debugPrint('customerPhone.value = ${customerPhone.value}');
      isLogin.value = true;
      final customer = customerCollection.where('tel', isEqualTo: customerPhone.value).snapshots();
      customer.listen((result) {
        for (var data in result.docs) {
          customerId.value = data.data()['customer_id'] ?? '';
          customerName.value = data.data()['customer_name'] ?? '';

          if (customerId.value != '') {
            loadRecentOrder();
          }
          else {
            debugPrint('customerName.value = ${customerPhone.value}');
          }
        }
      });
    }
    else {
      isLogin.value = false;
      debugPrint('customerPhone.value = ${customerPhone.value}');
      _recentOrder.value = RemoteData<List>(status: RemoteDataStatus.none, data: null);
    }
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

  Future<void> signOut() async {
   await  FirebaseAuth.instance.signOut();
   cacheHelper.removeCache();
  }
}