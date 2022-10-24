import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:loy_eat_customer/controller/merchant_detail_controller.dart';
import 'package:loy_eat_customer/model/remote_data.dart';

class OrderController extends GetxController {
  final merchantController = Get.put(MerchantDetailController());

  final productCollection = FirebaseFirestore.instance.collection('products');

  final _merchantDetailData = RemoteData<List<String>>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List> get merchantDetailData => _merchantDetailData.value;

  var merchantName = '';
  var deliveryFee = '';

  var arrayImageOrder = <String>[];
  var arrayNameOrder = <String>[];
  var arrayQtyOrder = <String>[];
  var arrayPriceOrder = <String>[];

  var subTotalPrice = 0.0.obs;
  var totalPrice = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    merchantName = Get.arguments['merchant_name'];
    deliveryFee = Get.arguments['fee'];

    getItemOrder();
    getPriceOrder();
  }

  void getItemOrder() {
    for (int i = 0 ; i < merchantController.arrayMapOrder.length ; i++) {
      arrayImageOrder.add(merchantController.arrayMapOrder[i]['image']);
      arrayNameOrder.add(merchantController.arrayMapOrder[i]['product_name']);
      arrayQtyOrder.add(merchantController.arrayMapOrder[i]['qty']);
    }
    _merchantDetailData.value = RemoteData<List<String>>(status: RemoteDataStatus.success, data: arrayNameOrder);
  }

  void getPriceOrder() {
    final status = merchantDetailData.status;
    if (status == RemoteDataStatus.success) {
      _merchantDetailData.value = RemoteData<List<String>>(status: RemoteDataStatus.processing, data: null);

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
