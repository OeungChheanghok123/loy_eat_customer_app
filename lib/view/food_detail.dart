import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat_customer/controller/food_detail_controller.dart';
import 'package:loy_eat_customer/model/remote_data.dart';
import 'package:loy_eat_customer/view/screen_widget.dart';

class FoodDetail extends StatelessWidget {
  FoodDetail({Key? key}) : super(key: key);

  final controller = Get.put(FoodDetailController());

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
      child: const Icon(Icons.arrow_back_ios_outlined, color: Colors.black, size: 32),
    ),
    actions: [
      InkWell(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.only(right: 15, left: 15),
          child: const Icon(Icons.shopping_cart, size: 32, color: Colors.black),
        ),
      ),
    ],
  );
  Widget get getBody {
    return Column(
      children: [
        buildTextFieldSearch,
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildCategoryCuisines,
                buildAllRestaurant,
                buildRecentOrder,
                buildPopular,
                buildCategoryFreeDelivery,
                buildCategoryDrink,
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget get buildTextFieldSearch {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: TextField(
        autocorrect: false,
        autofocus: false,
        style: const TextStyle(
          fontSize: 14,
        ),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, size: 32),
          hintText: 'Search for stores and items',
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.black.withOpacity(0.4),
          ),
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding: const EdgeInsets.only(top: 15),
        ),
      ),
    );
  }

  Widget get buildCategoryCuisines {
    return Container(
      width: Get.width,
      color: Colors.white,
      margin: const EdgeInsets.only(top: 5),
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(margin: const EdgeInsets.only(left: 10), child: titleTextWidget('Cuisines', 24)),
          const SizedBox(height: 10),
          listCategory(),
        ],
      ),
    );
  }
  Widget listCategory() {
    return Obx(() {
      final status = controller.cuisinesData.status;
      if (status == RemoteDataStatus.processing) {
        return ScreenWidgets.loading;
      } else if (status == RemoteDataStatus.error) {
        return ScreenWidgets.error;
      } else {
        final report = controller.cuisinesData.data;
          return GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(report!.length, (index) {
            return InkWell(
              onTap: () => Get.toNamed('/food_by_category', arguments: {'title': controller.listCuisines[index]}),
              child: categoryStore(
                title: controller.listCuisines[index],
                image: controller.listCuisinesImage[index],
              ),
            );
          }),
        );
      }
    });
  }
  Widget categoryStore({required String image, required String title}) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 95,
            height: 95,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.5),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Image.asset(image,
                fit: BoxFit.fill,
                height: 60,
                width: 60,
                alignment: Alignment.center,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
              child: Text(title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
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
      final status = controller.allStore.status;
      if (status == RemoteDataStatus.processing) {
        return ScreenWidgets.loading;
      } else if (status == RemoteDataStatus.error) {
        return ScreenWidgets.error;
      } else {
        final report = controller.allStore.data;
        return SizedBox(
          height: 250,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: report!.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Get.toNamed('/merchant_detail', arguments: {
                    'image': controller.listAllImage[index],
                    'merchant_name': controller.listAllStore[index],
                    'time': controller.listAllTime[index],
                    'delivery': controller.listAllDeliveryFee[index],
                    'distance': controller.listAllDistance[index],
                  });
                },
                child: restaurantItems(
                  title: controller.listAllStore[index],
                  image: controller.listAllImage[index],
                  category: controller.listAllStoreCategory[index],
                  time: controller.listAllTime[index],
                  delivery: controller.listAllDeliveryFee[index],
                  available: controller.listAllAvailable[index],
                ),
              );
            },
          ),
        );
      }
    });

  }

  Widget get buildRecentOrder {
    return Container(
      width: Get.width,
      color: Colors.white,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleTextWidget('Recent order', 24),
          const SizedBox(height: 10),
          listRecentRestaurant(),
        ],
      ),
    );
  }
  Widget listRecentRestaurant() {
    return Obx(() {
      final status = controller.allStore.status;
      if (status == RemoteDataStatus.processing) {
        return ScreenWidgets.loading;
      } else if (status == RemoteDataStatus.error) {
        return ScreenWidgets.error;
      } else {
        final report = controller.allStore.data;
        return SizedBox(
          height: 250,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: report!.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Get.toNamed('/merchant_detail', arguments: {
                    'image': controller.listAllImage[index],
                    'merchant_name': controller.listAllStore[index],
                    'time': controller.listAllTime[index],
                    'delivery': controller.listAllDeliveryFee[index],
                    'distance': controller.listAllDistance[index],
                  });
                },
                child: restaurantItems(
                  title: controller.listAllStore[index],
                  image: controller.listAllImage[index],
                  category: controller.listAllStoreCategory[index],
                  time: controller.listAllTime[index],
                  delivery: controller.listAllDeliveryFee[index],
                  available: controller.listAllAvailable[index],
                ),
              );
            },
          ),
        );
      }
    });

  }

  Widget get buildPopular {
    return Container(
      width: Get.width,
      color: Colors.white,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleTextWidget('Popular', 24),
          const SizedBox(height: 10),
          listRestaurantItems(),
        ],
      ),
    );
  }
  Widget listPopularRestaurant() {
    return Obx(() {
      final status = controller.allStore.status;
      if (status == RemoteDataStatus.processing) {
        return ScreenWidgets.loading;
      } else if (status == RemoteDataStatus.error) {
        return ScreenWidgets.error;
      } else {
        final report = controller.allStore.data;
        return SizedBox(
          height: 250,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: report!.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Get.toNamed('/merchant_detail', arguments: {
                    'image': controller.listAllImage[index],
                    'merchant_name': controller.listAllStore[index],
                    'time': controller.listAllTime[index],
                    'delivery': controller.listAllDeliveryFee[index],
                    'distance': controller.listAllDistance[index],
                  });
                },
                child: restaurantItems(
                  title: controller.listAllStore[index],
                  image: controller.listAllImage[index],
                  category: controller.listAllStoreCategory[index],
                  time: controller.listAllTime[index],
                  delivery: controller.listAllDeliveryFee[index],
                  available: controller.listAllAvailable[index],
                ),
              );
            },
          ),
        );
      }
    });

  }

  Widget get buildCategoryFreeDelivery {
    return Container(
      width: Get.width,
      color: Colors.white,
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
      final status = controller.storeFreeDeliveryData.status;
      if (status == RemoteDataStatus.processing) {
        return ScreenWidgets.loading;
      } else if (status == RemoteDataStatus.error) {
        return ScreenWidgets.error;
      } else {
        final report = controller.storeFreeDeliveryData.data;
        return SizedBox(
          height: 250,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: report!.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Get.toNamed('/merchant_detail', arguments: {
                    'image': controller.listImageFreeDelivery[index],
                    'merchant_name': controller.listStoreFreeDelivery[index],
                    'time': controller.listTimeFreeDelivery[index],
                    'delivery': '0.00',
                    'distance': controller.listDistanceFreeDelivery[index],
                  });
                },
                child: restaurantItems(
                  title: controller.listStoreFreeDelivery[index],
                  image: controller.listImageFreeDelivery[index],
                  category: controller.listStoreCategoryFreeDelivery[index],
                  time: controller.listTimeFreeDelivery[index],
                  delivery: controller.listFreeDelivery[index],
                  available: controller.listAvailableFreeDelivery[index],
                ),
              );
            },
          ),
        );}
    });

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
      final status = controller.storeDrink.status;
      if (status == RemoteDataStatus.processing) {
        return ScreenWidgets.loading;
      } else if (status == RemoteDataStatus.error) {
        return ScreenWidgets.error;
      } else {
        final report = controller.storeDrink.data;
          return SizedBox(
            height: 250,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: report!.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Get.toNamed('/merchant_detail', arguments: {
                      'image': controller.listImageDrink[index],
                      'merchant_name': controller.listStoreDrink[index],
                      'time': controller.listTimeDrink[index],
                      'delivery': controller.listDeliveryFeeDrink[index],
                      'distance': controller.listDistanceDrink[index],
                    });
                  },
                  child: restaurantItems(
                    title: controller.listStoreDrink[index],
                    image: controller.listImageDrink[index],
                    category: controller.listStoreCategoryDrink[index],
                    time: controller.listTimeDrink[index],
                    delivery: controller.listDeliveryFeeDrink[index],
                    available: controller.listAvailableDrink[index],
                  ),
                );
              },
            ),
        );
      }
    });
  }

  Widget restaurantItems({required String title,required String image, required String time, required String category, required String delivery, required bool available}) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
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
                    height: 25,
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
                Positioned(
                  top: 5,
                  right: 10,
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Center(
                      child: Icon(Icons.favorite_outline_outlined, size: 16),
                    ),
                  ),
                ),
                available ? const SizedBox() : Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: InkWell(
                    onTap: (){},
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text('The shop now is closed.',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          available
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                  size: 20,
                                  color: Colors.black.withOpacity(0.4)),
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
                  ],
                )
              : InkWell(
                  onTap: () {},
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                    size: 20,
                                    color: Colors.black.withOpacity(0.4)),
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
                    ],
                  ),
                ),
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