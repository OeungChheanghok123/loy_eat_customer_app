import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat_customer/controller/home_controller.dart';
import 'package:loy_eat_customer/model/remote_data.dart';
import 'package:loy_eat_customer/view/screen_widget.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final controller = Get.put(HomeViewModel());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.9),
        appBar: getAppBar,
        body: getBody,
        drawer: getDrawer,
      ),
    );
  }

  final getAppBar = AppBar(
    elevation: 0,
    title: const Text('Home'),
    backgroundColor: Colors.blue.withOpacity(0.8),
    actions: [
      InkWell(
        onTap: () {},
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: const Icon(Icons.favorite_outline_outlined),
        ),
      ),
    ],
  );
  Widget get getBody {
    return Obx(() {
      final status = controller.recentOrder.status;
      if (status == RemoteDataStatus.processing) {
        return ScreenWidgets.loading;
      } else if (status == RemoteDataStatus.error) {
        return ScreenWidgets.error;
      } else if (status == RemoteDataStatus.none) {
        controller.hasRecentOrder.value = false;
        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              buildCardFood,
              buildCategory(controller.hasRecentOrder.value),
            ],
          ),
        );
      } else {
        controller.hasRecentOrder.value = true;
        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              buildCardFood,
              buildCategory(controller.hasRecentOrder.value),
            ],
          ),
        );
      }
    });
  }

  Widget get getDrawer {
    return Drawer(
      child: controller.isLogin.value ? drawerLogInItems : drawerItems,
    );
  }
  Widget get drawerLogInItems {
    return ListView(
      children: [
        drawerLoginHeader,
        ListTile(
          leading: const Icon(Icons.favorite_outline_outlined),
          title: const Text('Favourites'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.person_outline),
          title: const Text('Profile'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.location_on_outlined),
          title: const Text('Addresses'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Settings'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.help_outline),
          title: const Text('Help center'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.person_add_alt_1_outlined),
          title: const Text('Invite friends'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Log out'),
          onTap: () {},
        ),
      ],
    );
  }
  Widget get drawerLoginHeader {
    return const UserAccountsDrawerHeader(
      accountName: Text('Chheanghok', style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),),
      accountEmail: Text('098496050', style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.blue,
        child: FlutterLogo(size: 42.0),
      ),
    );
  }
  Widget get drawerItems {
    return ListView(
      children: [
        drawerHeader,
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Settings'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.help_outline),
          title: const Text('Help center'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.person_add_alt_1_outlined),
          title: const Text('Invite friends'),
          onTap: () {},
        ),
      ],
    );
  }
  Widget get drawerHeader {
    return UserAccountsDrawerHeader(
      accountName: const Text(''),
      accountEmail: InkWell(
        onTap: () {
          debugPrint('Sign up / Log in');
        },
        child: Container(
          width: Get.width,
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: const Text('Sign up / Log in', style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),),
        ),
      ),
      currentAccountPicture: const CircleAvatar(
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget get buildCardFood {
    return InkWell(
      onTap: () => controller.foodDeliveryButton(),
      child: Container(
        width: Get.width,
        height: 150,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            foodDelivery,
            imageLogo,
          ],
        ),
      ),
    );
  }
  Widget get foodDelivery {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleTextWidget('Food delivery', 32),
            bodyTextWidget('Order food you love'),
          ],
        ),
      ),
    );
  }
  Widget get imageLogo {
    return Column(
      children: [
        Expanded(
          child: Container(
            color: Colors.white,
            height: 100,
            margin: const EdgeInsets.only(right: 10),
          ),
        ),
        Container(
          width: 130,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Image.asset('assets/image/food_delivery.jpg', fit: BoxFit.cover),
        ),
      ],
    );
  }

  Widget buildCategory (bool recentStore) {
    return Container(
      width: Get.width,
      color: Colors.white,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.fromLTRB(15, 20, 0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          recentStore ? buildRecentOrder : const SizedBox(),
          titleTextWidget('Cuisines', 24),
          const SizedBox(height: 20),
          listCategory,
        ],
      ),
    );
  }

  Widget get buildRecentOrder {
    return Container(
      width: Get.width,
      color: Colors.white,
      margin: const EdgeInsets.only(top: 0),
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleTextWidget('Recent order', 24),
          const SizedBox(height: 10),
          listRecentRestaurant,
        ],
      ),
    );
  }
  Widget get listRecentRestaurant {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: controller.listRecentStoreName.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Get.toNamed('/merchant_detail', arguments: {
                'image': controller.listRecentStoreImage[index],
                'merchant_name': controller.listRecentStoreName[index],
                'time': controller.listRecentStoreTime[index],
                'delivery': controller.listRecentStoreDeliveryFee[index],
                'distance': controller.listRecentStoreDistance[index],
              });
            },
            child: restaurantItems(
              title: controller.listRecentStoreName[index],
              image: controller.listRecentStoreImage[index],
              category: controller.listRecentStoreCategory[index],
              time: controller.listRecentStoreTime[index],
              delivery: controller.listRecentStoreDeliveryFee[index],
              available: controller.listRecentStoreAvailable[index],
            ),
          );
        },
      ),
    );
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

  Widget get listCategory {
    return Obx(() {
      final status = controller.cuisinesData.status;
      if (status == RemoteDataStatus.processing) {
        return ScreenWidgets.loading;
      } else if (status == RemoteDataStatus.error) {
        return ScreenWidgets.error;
      } else {
        final report = controller.cuisinesData.data;
        return SizedBox(
          height: 150,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: report!.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => Get.toNamed('/food_by_category', arguments: {'title': controller.listCuisines[index]}),
                child: categoryStore(
                  title: controller.listCuisines[index],
                  image: controller.listImage[index],
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
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

  Widget titleTextWidget(String text, double size) {
    return Text(text, style: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: size,
    ));
  }
  Widget bodyTextWidget(String text) {
    return Text(text, style: const TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 16,
    ));
  }
}