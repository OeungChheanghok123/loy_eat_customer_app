import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat_customer/controller/home_controller.dart';
import 'package:loy_eat_customer/model/remote_data.dart';

class MerchantDetailController extends GetxController {
  var selectedIndex = 0.obs;

  var merchantId = ''.obs;
  var title = ''.obs;
  var time = ''.obs;
  var fee = ''.obs;
  var distance = ''.obs;
  var image = ''.obs;

  var qty = 0.obs;

  var arrayProductId = [];
  var arrayProductName = [];
  var arrayProductImage = [];
  var arrayProductPrice = [];
  var arrayProductQty = [];
  var arrayProductStatus = [];

  var canOrder = false.obs;

  var arrayMapOrder = [{}];

  final _merchantDetailData = RemoteData<List>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List> get merchantDetailData => _merchantDetailData.value;

  final _productItemData = RemoteData<List>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List> get productItemData => _productItemData.value;

  final _arrayMapOrderData = RemoteData<List>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List> get arrayMapOrderData => _arrayMapOrderData.value;

  final merchantCollection = FirebaseFirestore.instance.collection('merchants');
  final productCollection = FirebaseFirestore.instance.collection('products');

  final homeController = Get.put(HomeController());

  @override
  void onInit() {
    super.onInit();
    arrayMapOrder.clear();
    getArgumentMerchant();
    getProductItem();
  }

  void getArgumentMerchant() {
    image.value = Get.arguments['image'];
    title.value = Get.arguments['merchant_name'];
    time.value = Get.arguments['time'];
    distance.value = Get.arguments['distance'];
    fee.value = Get.arguments['delivery'];
  }

  void getProductItem() {
    final merchant = merchantCollection.where('merchant_name', isEqualTo: title.value).snapshots();
    merchant.listen((result) {
      if (result.docs.isNotEmpty) {
        for (var data in result.docs) {
          var tempMerchantID = data.data()['merchant_id'];
          merchantId.value = tempMerchantID;
          final product = productCollection.where('merchant_id', isEqualTo: tempMerchantID).snapshots();
          product.listen((result) {
            clearProductItem();
            _productItemData.value = RemoteData<List>(status: RemoteDataStatus.processing, data: null);

            if (result.docs.isNotEmpty) {
              for (var data in result.docs) {
                arrayProductImage.add(data.data()['image'] ?? '');
                arrayProductId.add(data.data()['product_id'] ?? '');
                arrayProductName.add(data.data()['product_name'] ?? '');
                arrayProductPrice.add(data.data()['price'] ?? '');
                arrayProductQty.add('0');
                arrayProductStatus.add(data.data()['status'] ?? '');
              }
              _productItemData.value = RemoteData<List>(status: RemoteDataStatus.success, data: arrayProductName);
            }
          });
        }
      }
    });
  }

  void goToPageOrder() {
    if (homeController.isLogin.value == true) {
      Get.toNamed('/order', arguments: {'merchant_id': merchantId.value, 'merchant_name': title.value, 'fee': fee.value, 'time': time.value, 'distance': distance.value});
    }
    else {
      Get.toNamed('/login');
    }
  }

  void updateQty() {
    _productItemData.value = RemoteData<List>(status: RemoteDataStatus.processing, data: arrayProductName);

    qty.value = 1;

    arrayProductQty[selectedIndex.value] = qty.value.toString();

    canOrder.value = true;

    arrayMapOrder.add({'image': arrayProductImage[selectedIndex.value], 'product_id': arrayProductId[selectedIndex.value], 'product_name': arrayProductName[selectedIndex.value], 'qty': arrayProductQty[selectedIndex.value], 'price': arrayProductPrice[selectedIndex.value]});
    debugPrint('arrayMapOrder = $arrayMapOrder');

    _productItemData.value = RemoteData<List>(status: RemoteDataStatus.success, data: arrayProductName);
  }

  void increaseQty() {
    _productItemData.value = RemoteData<List>(status: RemoteDataStatus.processing, data: arrayProductName);

    qty.value = int.parse(arrayProductQty[selectedIndex.value]);
    arrayProductQty[selectedIndex.value] = (qty + 1).toString();

    int index = arrayMapOrder.indexWhere((item) => item['product_name'] == arrayProductName[selectedIndex.value]);

    arrayMapOrder[index]['qty'] = arrayProductQty[selectedIndex.value];
    debugPrint('arrayMapOrder = $arrayMapOrder');

    _productItemData.value = RemoteData<List>(status: RemoteDataStatus.success, data: arrayProductName);
  }

  void decreaseQty() {
    _productItemData.value = RemoteData<List>(status: RemoteDataStatus.processing, data: arrayProductName);

    qty.value = int.parse(arrayProductQty[selectedIndex.value]);
    arrayProductQty[selectedIndex.value] = (qty - 1).toString();

    int index = arrayMapOrder.indexWhere((item) => item['product_name'] == arrayProductName[selectedIndex.value]);

    arrayMapOrder[index]['qty'] = arrayProductQty[selectedIndex.value];
    debugPrint('arrayMapOrder = $arrayMapOrder');

    if (arrayMapOrder[index]['qty'] == '0') {
      arrayMapOrder.removeAt(index);
    }

    for (int i = 0; i < arrayProductQty.length; i++) {
      if (arrayProductQty[i] == '0') {
        canOrder.value = false;
      } else {
        canOrder.value = true;
        break;
      }
    }

    _productItemData.value = RemoteData<List>(status: RemoteDataStatus.success, data: arrayProductName);
  }

  void clearProductItem() {
    arrayProductId.clear();
    arrayProductImage.clear();
    arrayProductName.clear();
    arrayProductPrice.clear();
    arrayProductQty.clear();
    arrayProductStatus.clear();
  }
}