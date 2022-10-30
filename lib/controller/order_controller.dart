import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loy_eat_customer/controller/home_controller.dart';
import 'package:loy_eat_customer/controller/merchant_detail_controller.dart';
import 'package:loy_eat_customer/model/remote_data.dart';

class OrderController extends GetxController {

  final merchantController = Get.put(MerchantDetailController());

  final productCollection = FirebaseFirestore.instance.collection('products');
  final orderCollection = FirebaseFirestore.instance.collection('orders');
  final deliverCollection = FirebaseFirestore.instance.collection('delivers');
  final orderDetailCollection = FirebaseFirestore.instance.collection('orders_detail');

  final _merchantDetailData = RemoteData<List<String>>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List> get merchantDetailData => _merchantDetailData.value;

  final homeController = Get.put(HomeController());

  var merchantId = '';
  var merchantName = '';
  var deliveryTime = '';
  var deliveryFee = '';
  var distance = '';

  var arrayNameIsEmpty = false.obs;

  var arrayImageOrder = <String>[];
  var arrayIdOrder = <String>[];
  var arrayNameOrder = <String>[];
  var arrayQtyOrder = <String>[];
  var arrayPriceOrder = <String>[];

  var subTotalPrice = 0.0.obs;
  var totalPrice = 0.0.obs;

  var customerId = '';
  var customerName = '';

  String? today;
  String? time;
  String? orderId;
  String? orderDate;

  @override
  void onInit() {
    super.onInit();
    customerId = homeController.customerId.value;
    customerName = homeController.customerName.value;

    debugPrint('customerId = $customerId');
    debugPrint('customerName = $customerName');

    merchantId = Get.arguments['merchant_id'];
    merchantName = Get.arguments['merchant_name'];
    deliveryFee = Get.arguments['fee'];
    deliveryTime = Get.arguments['time'];
    distance = Get.arguments['distance'];

    getItemOrder();
    getPriceOrder();
    getLastOrderID();
  }

  void getItemOrder() {
    arrayImageOrder.clear();
    arrayNameOrder.clear();
    arrayQtyOrder.clear();
    for (int i = 0 ; i < merchantController.arrayMapOrder.length ; i++) {
      arrayImageOrder.add(merchantController.arrayMapOrder[i]['image']);
      arrayNameOrder.add(merchantController.arrayMapOrder[i]['product_name']);
      arrayQtyOrder.add(merchantController.arrayMapOrder[i]['qty']);
    }
    _merchantDetailData.value = RemoteData<List<String>>(status: RemoteDataStatus.success, data: arrayNameOrder);
  }
  void getPriceOrder() {
    arrayPriceOrder.clear();
    subTotalPrice.value = 0.0;

    final status = merchantDetailData.status;
    if (status == RemoteDataStatus.success) {
      _merchantDetailData.value = RemoteData<List<String>>(status: RemoteDataStatus.processing, data: null);

      if (arrayNameOrder.isEmpty) {
        arrayNameIsEmpty.value = true;
        merchantController.canOrder.value = false;
        debugPrint('arrayNameIsEmpty.value: ${arrayNameIsEmpty.value}');
        _merchantDetailData.value = RemoteData<List<String>>(status: RemoteDataStatus.success, data: null);
      }
      else {
        for (int i = 0 ; i < arrayNameOrder.length ; i++) {
          String name = arrayNameOrder[i];

          final product = productCollection.where('product_name', isEqualTo: name).snapshots();
          product.listen((result) {
            if (result.docs.isNotEmpty) {
              for (var data in result.docs) {
                var tempPrice = data.data()['price'];
                var tempQty = arrayQtyOrder[i];

                double total = double.parse(tempPrice) * int.parse(tempQty);
                arrayPriceOrder.add(total.toStringAsFixed(2));

                if (i + 1 == arrayNameOrder.length) {

                  for (int i = 0 ; i < arrayPriceOrder.length ; i++) {
                    double tempTotal = double.parse(arrayPriceOrder[i]);
                    subTotalPrice.value = subTotalPrice.value + tempTotal;
                  }

                  if (i + 1 == arrayPriceOrder.length) {
                    totalPrice.value = subTotalPrice.value + double.parse(deliveryFee);

                    _merchantDetailData.value = RemoteData<List<String>>(status: RemoteDataStatus.success, data: arrayNameOrder);
                  }
                }
              }
            }
          });
        }
      }
    }
  }

  getCurrentDate() {
    var getCurrentDate = DateTime.now();
    var formatDate = DateFormat('dd-MMM-yy');
    var formatTime = DateFormat('kk:mm a');
    var formatOrder = DateFormat('yyMMdd');
    today = formatDate.format(getCurrentDate);
    time = formatTime.format(getCurrentDate);
    orderDate = formatOrder.format(getCurrentDate);
  }
  getLastOrderID() async {
    getCurrentDate();

    final order = await orderCollection.where('date', isEqualTo: today).get();
    if (order.docs.isNotEmpty) {
      var list = [];
      for (var data in order.docs) {
        final lastID = data['order_id'];
        var newID = int.parse(lastID) + 1;
        list.add(newID);
        var maxId = list.reduce((value, element) => value > element ? value : element);
        orderId = maxId.toString();
      }
    }
    else {
      orderId = '${orderDate}001';
    }

  }

  void orderNow() async {
    await orderCollection.add({
      'customer_id': customerId,
      'customer_name': customerName,
      'date': today.toString(),
      'driver_id': '',
      'is_new': true,
      'merchant_id': merchantId,
      'merchant_name': merchantName,
      'order_id': orderId.toString(),
      'time': time.toString(),
      'total_discount': '0.00',
      'status': 'Pending',
    }).then((value) => debugPrint('order added'));
    await deliverCollection.add({
      'bonus': '0.00',
      'customer_rating': '5.0',
      'date': today.toString(),
      'delivery_fee': deliveryFee,
      'distance': distance,
      'driver_id': '',
      'merchant_rating': '5.0',
      'order_id': orderId.toString(),
      'period': deliveryTime,
      'process': '',
      'step_1': false,
      'step_2': false,
      'step_3': false,
      'step_4': false,
      'tip': '0.00',
    }).then((value) => debugPrint('deliver added'));
    await orderDetailCollection.add({
      'order_id': orderId.toString(),
      'items': merchantController.arrayMapOrder,
      'sub_amount': subTotalPrice.toStringAsFixed(2),
    }).then((value) => debugPrint('order detail added'));

    Get.offAllNamed('/home');
  }
}