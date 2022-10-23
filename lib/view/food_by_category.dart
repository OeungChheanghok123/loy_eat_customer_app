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
      title: Text(controller.title.value, style: const TextStyle(color: Colors.black)),
      leading: InkWell(
        onTap: () => Get.offAllNamed('/home'),
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
      ],
    );
  }

  Widget get titleSubCategory {
    return Obx(() {
      final status = controller.allStoreInCategory.status;
      if (status == RemoteDataStatus.processing) {
        return ScreenWidgets.loading;
      } else if (status == RemoteDataStatus.error) {
        return ScreenWidgets.error;
      } else {
        final report = controller.allStoreInCategory.data;
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
                      },
                      child: titleItems(controller.listSubCategory[index], index),
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
            color: index == controller.selectedIndex.value ? Colors.red : Colors.transparent,
            width: 3,
          ),
        ),
      ),
      child: Text(text, style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      )),
    ));
  }
}