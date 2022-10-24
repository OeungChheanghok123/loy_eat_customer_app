import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat_customer/controller/home_controller.dart';
import 'package:loy_eat_customer/model/remote_data.dart';
import 'package:loy_eat_customer/view/screen_widget.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.9),
        appBar: appBar,
        body: getBody,
      ),
    );
  }

  final appBar = AppBar(
    elevation: 0,
    title: const Text('Home'),
    backgroundColor: Colors.blue.withOpacity(0.8),
  );
  Widget get getBody {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 10),
          buildCardFood,
          buildCategory,
        ],
      ),
    );
  }

  Widget get buildCardFood {
    return InkWell(
      onTap: () => homeController.foodDeliveryButton(),
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

  Widget get buildCategory {
    return Container(
      width: Get.width,
      color: Colors.white,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.fromLTRB(15, 30, 0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleTextWidget('Cuisines', 24),
          const SizedBox(height: 20),
          listCategory(),
        ],
      ),
    );
  }
  Widget listCategory() {
    return Obx(() {
      final status = homeController.cuisinesData.status;
      if (status == RemoteDataStatus.processing) {
        return ScreenWidgets.loading;
      } else if (status == RemoteDataStatus.error) {
        return ScreenWidgets.error;
      } else {
        final report = homeController.cuisinesData.data;
        return SizedBox(
          height: 140,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: report!.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => Get.toNamed('/food_by_category', arguments: {'title': homeController.listCuisines[index]}),
                child: categoryStore(
                  title: homeController.listCuisines[index],
                  image: homeController.listImage[index],
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
      width: 80,
      margin: const EdgeInsets.only(right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              width: 70,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.5),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: Image.asset(image,
                  fit: BoxFit.fill,
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                ),
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