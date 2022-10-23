import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat_customer/controller/food_by_category_controller.dart';
import 'package:loy_eat_customer/model/remote_data.dart';
import 'package:loy_eat_customer/view/screen_widget.dart';

class FoodByCategory extends StatelessWidget {
  FoodByCategory({Key? key}) : super(key: key);

  final controller = Get.put(FoodByCategoryController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar,
        body: getBody,
      ),
    );
  }

  PreferredSizeWidget get appBar {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white60,
      title: Text(controller.title.value,
          style: const TextStyle(color: Colors.black)),
      leading: InkWell(
        onTap: () => Get.back(),
        child: const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Icon(Icons.arrow_back_ios, color: Colors.black, size: 32),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 10),
          child: const Icon(Icons.shopping_cart, size: 32, color: Colors.black),
        ),
      ],
    );
  }

  Widget get getBody {
    return Column(
      children: [
        titleSubCategory,
        buildAllRestaurant,
      ],
    );
  }

  Widget get titleSubCategory {
    return Obx(() {
      final status = controller.allTitleSubCategory.status;
      if (status == RemoteDataStatus.processing) {
        return ScreenWidgets.loading;
      } else if (status == RemoteDataStatus.error) {
        return ScreenWidgets.error;
      } else {
        final report = controller.allTitleSubCategory.data;
        return SizedBox(
          width: Get.width,
          height: 40,
          child: Row(
            children: [
              const SizedBox(width: 10),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: report!.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      splashColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        controller.selectedIndex.value = index;
                        controller.getMerchantByDetail();
                      },
                      child:
                          titleItems(controller.listSubCategory[index], index),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }
    });
  }

  Widget titleItems(String text, int index) {
    return Obx(() => Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: index == controller.selectedIndex.value
                    ? Colors.blue
                    : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Text(text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              )),
        ));
  }

  Widget get buildAllRestaurant {
    return Expanded(
      child: Container(
        width: Get.width,
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
        child: listRestaurantItems(),
      ),
    );
  }

  Widget listRestaurantItems() {
    return Obx(() {
      final status = controller.storeData.status;
      if (status == RemoteDataStatus.processing) {
        return ScreenWidgets.loading;
      } else if (status == RemoteDataStatus.error) {
        return ScreenWidgets.error;
      } else {
        final report = controller.storeData.data;
        return ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: report!.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Get.toNamed('/merchant_detail', arguments: {
                  'image': controller.listImage[index],
                  'merchant_name': controller.listStore[index],
                  'time': controller.listTime[index],
                  'delivery': controller.listDeliveryFee[index],
                });
              },
              child: restaurantItems(
                title: controller.listStore[index],
                image: controller.listImage[index],
                category: controller.listCategory[index],
                time: controller.listTime[index],
                delivery: controller.listDeliveryFee[index],
              ),
            );
          },
        );
      }
    });
  }

  Widget restaurantItems(
      {required String title,
      required String image,
      required String time,
      required String category,
      required String delivery}) {
    return Container(
      width: Get.width,
      height: 260,
      margin: const EdgeInsets.only(right: 10, bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomLeft,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                width: 65,
                height: 30,
                margin: const EdgeInsets.only(left: 10, bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    '$time min',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(3, 5, 0, 0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 3, top: 5),
            child: Row(
              children: [
                Icon(Icons.sell,
                    size: 20, color: Colors.black.withOpacity(0.4)),
                Text(' • $category',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.4),
                      fontSize: 16,
                    )),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 3, top: 5),
            child: Row(
              children: [
                delivery == '0.00'
                    ? const Icon(Icons.local_shipping,
                        size: 20, color: Colors.blue)
                    : Icon(Icons.local_shipping,
                        size: 20, color: Colors.black.withOpacity(0.4)),
                delivery == '0.00'
                    ? const Text(' Free delivery',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ))
                    : Text(' \$ $delivery',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.4),
                          fontSize: 16,
                        )),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget titleTextWidget(String text, double size) {
    return Text(text,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: size,
        ));
  }
}
