import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:loy_eat_customer/model/remote_data.dart';

class MerchantDetailController extends GetxController {

  var selectedIndex = 0.obs;

  var title = ''.obs;
  var time = ''.obs;
  var fee = ''.obs;
  var image = ''.obs;

  late List<Map> listMapProductItem;

  var tempListProduct = [];
  var tempListQty = [];
  var qty = 0.obs;

  var arrayProductImage = [];
  var arrayProductName = [];
  var arrayProductPrice = [];
  var arrayProductQty = [];

  final _merchantDetailData = RemoteData<List>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List> get merchantDetailData => _merchantDetailData.value;

  final _productItemData = RemoteData<List>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List> get productItemData => _productItemData.value;

  final merchantCollection = FirebaseFirestore.instance.collection('merchants');
  final productCollection = FirebaseFirestore.instance.collection('products');


  @override
  void onInit() {
    super.onInit();
    getArgumentMerchant();
    getProductItem();
    listMapProductItem = [{}];
  }

  void getArgumentMerchant() {
    image.value = Get.arguments['image'];
    title.value = Get.arguments['merchant_name'];
    time.value = Get.arguments['time'];
    fee.value = Get.arguments['delivery'];
  }
  void getProductItem() {
    final merchant = merchantCollection.where('merchant_name', isEqualTo: title.value).snapshots();
    merchant.listen((result) {
      if (result.docs.isNotEmpty) {
        for (var data in result.docs) {
          var tempMerchantID = data.data()['merchant_id'];

          final product = productCollection.where('merchant_id', isEqualTo: tempMerchantID).snapshots();
          product.listen((result) {
            if (result.docs.isNotEmpty) {
              for (var data in result.docs) {
                arrayProductImage.add(data.data()['image'] ?? '');
                arrayProductName.add(data.data()['product_name'] ?? '');
                arrayProductPrice.add(data.data()['price'] ?? '');
                arrayProductQty.add('0');
              }
              _productItemData.value = RemoteData<List>(status: RemoteDataStatus.success, data: arrayProductName);
            }
          });
        }

      }
    });
  }
}