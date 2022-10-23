import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat_customer/controller/food_detail_controller.dart';
import 'package:loy_eat_customer/model/remote_data.dart';
import 'package:loy_eat_customer/view/screen_widget.dart';

class FoodDetail extends StatelessWidget {
  FoodDetail({Key? key}) : super(key: key);

  final foodDetailController = Get.put(FoodDetailController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar,
        body: getBody,
        backgroundColor: Colors.white,
      ),
    );
  }

  final appBar = AppBar(
    elevation: 0,
    backgroundColor: Colors.white,
    title: const Text('Food delivery', style: TextStyle(color: Colors.black)),
    leading: InkWell(
      onTap: () => Get.offAllNamed('/home'),
      child: const Icon(Icons.arrow_back, color: Colors.blue, size: 32),
    ),
    actions: [
      Container(
        margin: const EdgeInsets.only(right: 10),
        child: const Icon(Icons.shopping_cart, size: 32, color: Colors.blue),
      ),
    ],
  );
  Widget get getBody {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildCategoryFreeDelivery,
          buildCategoryDrink,
          buildCategoryCuisines,
          buildAllRestaurant,
        ],
      ),
    );
  }

  Widget get buildCategoryFreeDelivery {
    return Container(
      width: Get.width,
      color: Colors.white,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleTextWidget('Free delivery', 24),
          const SizedBox(height: 10),
          listCategoryFreeDeliveryItems(),
        ],
      ),
    );
  }
  Widget listCategoryFreeDeliveryItems() {
    return Obx(() {
      final status = foodDetailController.storeFreeDeliveryData.status;
      if (status == RemoteDataStatus.processing) {
        return ScreenWidgets.loading;
      } else if (status == RemoteDataStatus.error) {
        return ScreenWidgets.error;
      } else {
        final report = foodDetailController.storeFreeDeliveryData.data;
        return SizedBox(
          height: 200,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: report!.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Get.toNamed('/merchant_detail', arguments: {
                    'image': foodDetailController.listImageFreeDelivery[index],
                    'merchant_name': foodDetailController.listStoreFreeDelivery[index],
                    'time': foodDetailController.listTimeFreeDelivery[index],
                    'delivery': '0.00'
                  });
                },
                child: categoryStoreFreeDeliveryItems(
                  title: foodDetailController.listStoreFreeDelivery[index],
                  image: foodDetailController.listImageFreeDelivery[index],
                  category: foodDetailController.listStoreCategoryFreeDelivery[index],
                  time: foodDetailController.listTimeFreeDelivery[index],
                ),
              );
            },
          ),
        );}
    });

  }
  Widget categoryStoreFreeDeliveryItems({required String title,required String image,required String time,required String category}) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              width: 250,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.bottomLeft,
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
            child: Text(title,
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
                Icon(Icons.sell, size: 20, color: Colors.black.withOpacity(0.4)),
                Text(' • $category', style: TextStyle(
                  color: Colors.black.withOpacity(0.4),
                  fontSize: 16,
                )),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 3, top: 5),
            child: Row(
              children: const [
                Icon(Icons.local_shipping, size: 20, color: Colors.blue),
                Text(' Free delivery', style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget get buildCategoryDrink {
    return Container(
      width: Get.width,
      color: Colors.white,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleTextWidget('Drinks', 24),
          const SizedBox(height: 10),
          listCategoryDrinkItems(),
        ],
      ),
    );
  }
  Widget listCategoryDrinkItems() {
    return Obx(() {
      final status = foodDetailController.storeDrink.status;
      if (status == RemoteDataStatus.processing) {
        return ScreenWidgets.loading;
      } else if (status == RemoteDataStatus.error) {
        return ScreenWidgets.error;
      } else {
        final report = foodDetailController.storeDrink.data;
        return SizedBox(
          height: 200,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: report!.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Get.toNamed('/merchant_detail', arguments: {
                    'image': foodDetailController.listImageDrink[index],
                    'merchant_name': foodDetailController.listStoreDrink[index],
                    'time': foodDetailController.listTimeDrink[index],
                    'delivery': foodDetailController.listDeliveryFeeDrink[index],
                  });
                },
                child: categoryStoreDrinkItems(
                  title: foodDetailController.listStoreDrink[index],
                  image: foodDetailController.listImageDrink[index],
                  category: foodDetailController.listStoreCategoryDrink[index],
                  time: foodDetailController.listTimeDrink[index],
                  delivery: foodDetailController.listDeliveryFeeDrink[index],
                ),
              );
            },
          ),
        );
      }
    });
  }
  Widget categoryStoreDrinkItems({required String title,required String image,required String time,required String category, required String delivery}) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              width: 250,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.bottomLeft,
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
            child: Text(title,
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
                Icon(Icons.sell, size: 20, color: Colors.black.withOpacity(0.4)),
                Text(' • $category', style: TextStyle(
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
                delivery == '0.00' ? const Icon(Icons.local_shipping, size: 20, color: Colors.blue) : Icon(Icons.local_shipping, size: 20, color: Colors.black.withOpacity(0.4)),
                delivery == '0.00' ? const Text(' Free delivery', style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                )) : Text(' \$ $delivery', style: TextStyle(
                  color: Colors.black.withOpacity(0.4),
                  fontSize: 16,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget get buildCategoryCuisines {
    return Container(
      width: Get.width,
      color: Colors.white,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.fromLTRB(15, 0, 0, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleTextWidget('Cuisines', 24),
          const SizedBox(height: 10),
          listCategory(),
        ],
      ),
    );
  }
  Widget listCategory() {
    return Obx(() {
      final status = foodDetailController.cuisinesData.status;
      if (status == RemoteDataStatus.processing) {
        return ScreenWidgets.loading;
      } else if (status == RemoteDataStatus.error) {
        return ScreenWidgets.error;
      } else {
        final report = foodDetailController.cuisinesData.data;
        return SizedBox(
          height: 90,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: report!.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => Get.toNamed('/food_by_category', arguments: {'title': foodDetailController.listCuisines[index]}),
                child: categoryStore(
                  title: foodDetailController.listCuisines[index],
                  image: foodDetailController.listCuisinesImage[index],
                ),
              );
            },
          ),
        );
      }
    });
  }
  Widget categoryStore({required String image, required String title}) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 1),
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
          opacity: 0.6,
        ),
      ),
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Text(title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget get buildAllRestaurant {
    return Container(
      width: Get.width,
      color: Colors.white,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleTextWidget('All restaurants', 24),
          const SizedBox(height: 10),
          listRestaurantItems(),
        ],
      ),
    );
  }
  Widget listRestaurantItems() {
    return Obx(() {
      final status = foodDetailController.allStore.status;
      if (status == RemoteDataStatus.processing) {
        return ScreenWidgets.loading;
      } else if (status == RemoteDataStatus.error) {
        return ScreenWidgets.error;
      } else {
        final report = foodDetailController.allStore.data;
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: report!.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Get.toNamed('/merchant_detail', arguments: {
                  'image': foodDetailController.listAllImage[index],
                  'merchant_name': foodDetailController.listAllStore[index],
                  'time': foodDetailController.listAllTime[index],
                  'delivery': foodDetailController.listAllDeliveryFee[index],
                });
              },
              child: restaurantItems(
                title: foodDetailController.listAllStore[index],
                image: foodDetailController.listAllImage[index],
                category: foodDetailController.listAllStoreCategory[index],
                time: foodDetailController.listAllTime[index],
                delivery: foodDetailController.listAllDeliveryFee[index],
              ),
            );
          },
        );
      }
    });

  }
  Widget restaurantItems({required String title,required String image, required String time, required String category, required String delivery}) {
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
            child: Text(title,
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
                Icon(Icons.sell, size: 20, color: Colors.black.withOpacity(0.4)),
                Text(' • $category', style: TextStyle(
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
                delivery == '0.00' ? const Icon(Icons.local_shipping, size: 20, color: Colors.blue) : Icon(Icons.local_shipping, size: 20, color: Colors.black.withOpacity(0.4)),
                delivery == '0.00' ? const Text(' Free delivery', style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                )) : Text(' \$ $delivery', style: TextStyle(
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
    return Text(text, style: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: size,
    ));
  }
}