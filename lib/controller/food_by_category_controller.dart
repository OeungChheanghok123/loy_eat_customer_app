import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat_customer/model/remote_data.dart';

class FoodByCategoryController extends GetxController {

  var title = ''.obs;

  final merchantCollection = FirebaseFirestore.instance.collection('merchants');
  final productCollection = FirebaseFirestore.instance.collection('products');

  final _allTitleSubCategory = RemoteData<List>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List> get allTitleSubCategory => _allTitleSubCategory.value;

  final _storeData = RemoteData<List>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List> get storeData => _storeData.value;

  var selectedIndex = 0.obs;

  var listSubCategory = ['All'];

  var listStore = [];
  var listCategory = [];
  var listTime = [];
  var listImage = [];
  var listDeliveryFee = [];

  @override
  void onInit() {
    super.onInit();
    getTitleText();
    getAllSubCategory();
    getAllMerchant();
  }

  void getTitleText() {
    title.value = Get.arguments['title'];
  }
  void getAllSubCategory() {
    final merchant = merchantCollection.where('category', isEqualTo: title.value).snapshots();
    merchant.listen((result) {
      if (result.docs.isNotEmpty) {
        for (var data in result.docs) {
          final tempId = data.data()['merchant_id'];

          final product = productCollection.where('merchant_id', isEqualTo: tempId).snapshots();
          product.listen((result) {
            if (result.docs.isNotEmpty) {
              for (var data in result.docs) {
                var tempProductDetail = data.data()['detail'];
                if (tempProductDetail != '') {
                  listSubCategory.add(tempProductDetail);
                  listSubCategory = listSubCategory.toSet().toList();
                  listSubCategory.sort();
                  _allTitleSubCategory.value = RemoteData<List>(status: RemoteDataStatus.success, data: listSubCategory);
                }
              }
            }
          });
        }
      }
    });
  }
  void getAllMerchant() {
    final data = merchantCollection.where('category', isEqualTo: title.value).snapshots();
    data.listen((result) {
      clearList();
      if (result.docs.isNotEmpty) {
        for (var data in result.docs) {
          listStore.add(data.data()['merchant_name'] ?? '');
          listCategory.add(data.data()['category'] ?? '');
          listTime.add(data.data()['time'] ?? '');
          listImage.add(data.data()['image'] ?? '');
          listDeliveryFee.add(data.data()['delivery_fee'] ?? '');
        }
        _storeData.value = RemoteData<List>(status: RemoteDataStatus.success, data: listStore);
      }
    });
  }
  void getMerchantByDetail() {
    var tempListMerchantId = [];
    var selectedItems = listSubCategory[selectedIndex.value];
    debugPrint('selectedItems: $selectedItems');

    if (selectedItems == 'All') {
      getAllMerchant();
    } else {
      final product = productCollection.where('detail', isEqualTo: selectedItems).snapshots();
      product.listen((result) {
        for (var data in result.docs) {
          tempListMerchantId.add(data['merchant_id']);
        }

        tempListMerchantId = tempListMerchantId.toSet().toList();
        debugPrint('temListMerchantId: $tempListMerchantId');
        clearList();

        for (int i = 0 ; i < tempListMerchantId.length; i++) {
          var id = tempListMerchantId[i];
          final merchant = merchantCollection.where('merchant_id', isEqualTo: id).snapshots();
          merchant.listen((result) {
            for (var data in result.docs) {
              listStore.add(data.data()['merchant_name'] ?? '');
              listCategory.add(data.data()['category'] ?? '');
              listTime.add(data.data()['time'] ?? '');
              listImage.add(data.data()['image'] ?? '');
              listDeliveryFee.add(data.data()['delivery_fee'] ?? '');
            }
            _storeData.value = RemoteData<List>(status: RemoteDataStatus.success, data: listStore);
          });
        }
      });
    }
  }
  void clearList() {
    listStore.clear();
    listCategory.clear();
    listTime.clear();
    listImage.clear();
    listDeliveryFee.clear();
  }
}