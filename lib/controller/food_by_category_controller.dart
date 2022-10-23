import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat_customer/model/remote_data.dart';

class FoodByCategoryController extends GetxController with GetSingleTickerProviderStateMixin {

  var title = ''.obs;

  final merchantCollection = FirebaseFirestore.instance.collection('merchants');
  final productCollection = FirebaseFirestore.instance.collection('products');

  final _allStoreInCategory = RemoteData<List>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List> get allStoreInCategory => _allStoreInCategory.value;

  final _allStoreCategory = RemoteData<List>(status: RemoteDataStatus.processing, data: null).obs;
  RemoteData<List> get allStoreCategory => _allStoreCategory.value;

  var selectedIndex = 0.obs;

  var listSubMerchantId = [];
  var listSubCategory = ['All'];

  var listAllStore = [];
  var listAllStoreCategory = [];
  var listAllTime = [];
  var listAllImage = [];
  var listAllDeliveryFee = [];

  @override
  void onInit() {
    super.onInit();
    getTitleText();
    getAllSubCategory();
    loadAllMerchant();
    loadMerchantByDetail();
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
          listSubMerchantId.add(tempId);

          final product = productCollection.where('merchant_id', isEqualTo: tempId).snapshots();
          product.listen((result) {
            if (result.docs.isNotEmpty) {
              for (var data in result.docs) {
                var tempProductDetail = data.data()['detail'];
                if (tempProductDetail != '') {
                  listSubCategory.add(tempProductDetail);
                  listSubCategory = listSubCategory.toSet().toList();
                  listSubCategory.sort();
                  _allStoreInCategory.value = RemoteData<List>(status: RemoteDataStatus.success, data: listSubCategory);
                }
              }
            }
          });
        }
        debugPrint('listSubMerchantId: $listSubMerchantId');
        debugPrint('listSubCategory: $listSubCategory');
      }
    });
  }

  void loadAllMerchant() {
    final data = merchantCollection.where('category', isEqualTo: title.value).snapshots();
    data.listen((result) {
      if (result.docs.isNotEmpty) {
        for (var data in result.docs) {
          listAllStore.add(data.data()['merchant_name'] ?? '');
          listAllStoreCategory.add(data.data()['category'] ?? '');
          listAllTime.add(data.data()['time'] ?? '');
          listAllImage.add(data.data()['image'] ?? '');
          listAllDeliveryFee.add(data.data()['delivery_fee'] ?? '');
        }

        _allStoreCategory.value = RemoteData<List>(status: RemoteDataStatus.success, data: listAllStore);
      }
    });
  }
  void loadMerchantByDetail() {
    debugPrint('listSubCategory load merchant: $listSubCategory');
    var tempListID = [];

    for (int index = 0; index < listSubCategory.length ; index++) {
      debugPrint('listSubCategory index: ${listSubCategory[index]}');
      final product = productCollection.where('detail', isEqualTo: listSubCategory[index]).snapshots();
      product.listen((result) {
        if (result.docs.isNotEmpty) {
          for (var data in result.docs) {
            tempListID.add(data.data()['merchant_id'] ?? '');
          }
          var id = [];
          id = tempListID.toSet().toList();
          debugPrint('id: $id');
        }
      });

    }
  }

  // Widget buildBodyDetailByCategory() {
  //   return SingleChildScrollView(
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         titleTextWidget('${listAllStore.length} restaurants', 16),
  //         buildAllRestaurant,
  //       ],
  //     ),
  //   );
  // }
  // Widget get buildAllRestaurant {
  //   return Container(
  //     width: Get.width,
  //     margin: const EdgeInsets.only(top: 10),
  //     padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const SizedBox(height: 10),
  //         listRestaurantItems(),
  //       ],
  //     ),
  //   );
  // }
  // Widget listRestaurantItems() {
  //   return Obx(() {
  //     final status = allStoreCategory.status;
  //     if (status == RemoteDataStatus.processing) {
  //       return ScreenWidgets.loading;
  //     } else if (status == RemoteDataStatus.error) {
  //       return ScreenWidgets.error;
  //     } else {
  //       final report = allStoreCategory.data;
  //       return ListView.builder(
  //         shrinkWrap: true,
  //         physics: const NeverScrollableScrollPhysics(),
  //         scrollDirection: Axis.vertical,
  //         itemCount: report!.length,
  //         itemBuilder: (context, index) {
  //           return restaurantItems(
  //             title: listAllStore[index],
  //             image: listAllImage[index],
  //             category: listAllStoreCategory[index],
  //             time: listAllTime[index],
  //             delivery: listAllDeliveryFee[index],
  //           );
  //         },
  //       );
  //     }
  //   });
  //
  // }
  // Widget restaurantItems({required String title,required String image, required String time, required String category, required String delivery}) {
  //   return Container(
  //     width: Get.width,
  //     height: 260,
  //     margin: const EdgeInsets.only(right: 10, bottom: 15),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Expanded(
  //           child: Container(
  //             alignment: Alignment.bottomLeft,
  //             decoration: BoxDecoration(
  //               color: Colors.blue,
  //               borderRadius: BorderRadius.circular(10),
  //               image: DecorationImage(
  //                 image: AssetImage(image),
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //             child: Container(
  //               width: 65,
  //               height: 30,
  //               margin: const EdgeInsets.only(left: 10, bottom: 10),
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.circular(25),
  //               ),
  //               child: Center(
  //                 child: Text(
  //                   '$time min',
  //                   style: const TextStyle(
  //                     fontSize: 14,
  //                     fontWeight: FontWeight.w600,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.fromLTRB(3, 5, 0, 0),
  //           child: Text(title,
  //             style: const TextStyle(
  //               fontSize: 16,
  //               fontWeight: FontWeight.w600,
  //               overflow: TextOverflow.ellipsis,
  //             ),
  //           ),
  //         ),
  //         Container(
  //           margin: const EdgeInsets.only(left: 3, top: 5),
  //           child: Row(
  //             children: [
  //               Icon(Icons.sell, size: 20, color: Colors.black.withOpacity(0.4)),
  //               Text(' • $category', style: TextStyle(
  //                 color: Colors.black.withOpacity(0.4),
  //                 fontSize: 16,
  //               )),
  //             ],
  //           ),
  //         ),
  //         Container(
  //           margin: const EdgeInsets.only(left: 3, top: 5),
  //           child: Row(
  //             children: [
  //               delivery == '0.00' ? const Icon(Icons.local_shipping, size: 20, color: Colors.blue) : Icon(Icons.local_shipping, size: 20, color: Colors.black.withOpacity(0.4)),
  //               delivery == '0.00' ? const Text(' Free delivery', style: TextStyle(
  //                 color: Colors.blue,
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.w600,
  //               )) : Text(' \$ $delivery', style: TextStyle(
  //                 color: Colors.black.withOpacity(0.4),
  //                 fontSize: 16,
  //               )),
  //             ],
  //           ),
  //         ),
  //         const SizedBox(height: 10),
  //       ],
  //     ),
  //   );
  // }
  //
  // Widget titleTextWidget(String text, double size) {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 10, left: 15),
  //     child: Text(text, style: TextStyle(
  //       fontWeight: FontWeight.w500,
  //       fontSize: size,
  //       color: Colors.black.withOpacity(0.5),
  //     )),
  //   );
  // }
}