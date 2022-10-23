import 'package:get/get.dart';

class MerchantDetailController extends GetxController {

  var tempListProduct = [];
  var tempListQty = [];
  var qty = 0.obs;
  var listMapProductItem  = [{}];

  var arrayProductName = ['Amazon', 'KFC', 'Burger king', 'Hot Pot'];
  var arrayProductQty = [];

  @override
  void onInit() {
    super.onInit();
    listMapProductItem.clear();
    writeListQty();
  }

  void writeListQty() {
    for (int index = 0 ; index < arrayProductName.length ; index++) {
      arrayProductQty.add('0');
    }
  }
}