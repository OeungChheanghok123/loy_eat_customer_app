import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat_customer/controller/merchant_detail_controller.dart';
import 'package:loy_eat_customer/controller/order_controller.dart';
import 'package:loy_eat_customer/model/remote_data.dart';
import 'package:loy_eat_customer/view/screen_widget.dart';

class Order extends StatelessWidget {
  Order({Key? key}) : super(key: key);

  final controller = Get.put(OrderController());
  final merchantController = Get.put(MerchantDetailController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.9),
        appBar: appBar,
        body: getBody,
        bottomSheet: getBottonOrder,
      ),
    );
  }

  final appBar = AppBar(
    elevation: 0,
    backgroundColor: Colors.white,
    title: const Text('Submit Order', style: TextStyle(color: Colors.black)),
    leading: InkWell(
      onTap: () => Get.back(),
      child: const Icon(Icons.arrow_back_ios_outlined, color: Colors.blue, size: 32),
    ),
  );

  Widget get getBody {
    return Obx(() {
      final status = merchantController.productItemData.status;
      if (status == RemoteDataStatus.processing) {
        return ScreenWidgets.loading;
      } else if (status == RemoteDataStatus.error) {
        return ScreenWidgets.error;
      } else {
        return controller.arrayNameIsEmpty.value
            ? const Center(child: Text('No order here.', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)))
            : SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    paymentMethod,
                    merchantDetail,
                    deliveryFee,
                    otherCoupon,
                    const SizedBox(height: 100),
                  ],
                ),
        ) ;
      }
    });
  }

  Widget get getBottonOrder {
    return Obx(() {
      final status = controller.merchantDetailData.status;
      if (status == RemoteDataStatus.processing) {
          return ScreenWidgets.loading;
      } else if (status == RemoteDataStatus.error) {
          return ScreenWidgets.error;
      } else {
          return controller.arrayNameIsEmpty.value ? const SizedBox() : Container(
            height: 50,
            width: Get.width,
            margin: const EdgeInsets.fromLTRB(20, 15, 20, 30),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(50),
            ),
            alignment: Alignment.center,
            child: InkWell(
              onTap: (){
                controller.orderNow();
              },
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 20),
                  const Text('Total:', style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),),
                  Text('  \$ ${controller.totalPrice.value.toStringAsFixed(2)}', style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),),
                  const Spacer(),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Text('Order Now', style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),),
                  ),
                ],
              ),
            ),
          );
      }
    });
  }

  Widget get paymentMethod {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(15),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text('Payment method',
            style: TextStyle(fontSize: 14),
          ),
          Text('Cash On Delivery',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget get merchantDetail {
    return Container(
      width: Get.width,
      color: Colors.white,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          merchantName(controller.merchantName),
          underLine(),
          orderItem(),
          underLine(),
          subTotal(),
        ],
      ),
    );
  }

  Widget merchantName(String name) {
    return Row(
      children: [
        const Icon(Icons.storefront),
        Text('  $name', style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: Colors.black,
        ),),
      ],
    );
  }
  Widget underLine() {
    return Container(
      width: Get.width,
      height: 2,
      color: Colors.black.withOpacity(0.1),
      margin: const EdgeInsets.symmetric(vertical: 10),
    );
  }
  Widget orderItem() {
    return Obx(() {
      final status = merchantController.productItemData.status;
      if (status == RemoteDataStatus.processing) {
        return ScreenWidgets.loading;
      } else if (status == RemoteDataStatus.error) {
        return ScreenWidgets.error;
      } else {
        final report = merchantController.productItemData.data;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: report!.length,
            itemBuilder: (context, index) {
              return merchantController.arrayProductQty[index] == '0' ? const SizedBox() : bodyItems(
                index: index,
                image: merchantController.arrayProductImage[index],
                name: merchantController.arrayProductName[index],
                price: (double.parse(merchantController.arrayProductPrice[index]) * double.parse(merchantController.arrayProductQty[index])).toStringAsFixed(2),
              );
            },
          ),
        );
      }
    });
  }
  Widget subTotal() {
    return Obx(() {
      final status = controller.merchantDetailData.status;
      if (status == RemoteDataStatus.processing) {
        return ScreenWidgets.loading;
      } else if (status == RemoteDataStatus.error) {
        return ScreenWidgets.error;
      } else {
        return Container(
          margin: const EdgeInsets.only(top: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Subtotal', style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),),
              Text('\$${controller.subTotalPrice.value.toStringAsFixed(2)}', style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),),
            ],
          ),
        );
      }
    });
  }

  Widget bodyItems({required index, required String image, required String name, required String price}) {
    return Container(
      width: Get.width,
      height: 100,
      margin: const EdgeInsets.only(bottom: 0),
      child: Stack(
        children: [
          Row(
            children: [
              // image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  image: DecorationImage(
                    image: AssetImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // detail
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 15, left: 15, bottom: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'pcs',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.3),
                        ),
                      ),
                      const SizedBox(height: 15),
                      merchantController.arrayProductQty[index].toString() != "0"
                          ? buttonIncreaseAndDecrease((merchantController.arrayProductQty[index]).toString(), index)
                          : buttonAdd(index),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Positioned (
            right: 0,
            bottom: 13,
            child: Text(
              '\$ $price',
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget get deliveryFee {
    return Container(
      padding: const EdgeInsets.all(15),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Delivery Fee', style: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),),
          Text('\$${controller.deliveryFee}', style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.black.withOpacity(0.5),
          ),),
        ],
      ),
    );
  }
  Widget get otherCoupon {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(15),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Coupon', style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),),
              buildTextField('No coupon available'),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Delivery fee coupon', style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),),
              buildTextField('No coupon available'),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Promo code', style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),),
              buildTextField('Use promo code'),
            ],
          ),
          const SizedBox(height: 5),
          underLine(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Discount', style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),),
              Text('-\$0.00', style: TextStyle(
                fontSize: 14,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),),
            ],
          ),
        ],
      ),
    );
  }
  Widget buildTextField(String text) {
    return SizedBox(
      height: 30,
      width: 180,
      child: TextField(
        autocorrect: false,
        style: const TextStyle(
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: text,
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.black.withOpacity(0.4),
          ),
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding: const EdgeInsets.only(bottom: 15, left: 10),
        ),
      ),
    );
  }

  Widget buttonIncreaseAndDecrease(String qty, int index) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            merchantController.selectedIndex.value = index;
            merchantController.decreaseQty();
            controller.getItemOrder();
            controller.getPriceOrder();
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(100),
            ),
            child: const Icon(Icons.remove, color: Colors.white, size: 16),
          ),
        ),
        Text(
          '   $qty   ',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        InkWell(
          onTap: () {
            merchantController.selectedIndex.value = index;
            merchantController.increaseQty();
            controller.getItemOrder();
            controller.getPriceOrder();
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(100),
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 16),
          ),
        ),
      ],
    );
  }
  Widget buttonAdd(int index) {
    return InkWell(
      onTap: () {
        merchantController.selectedIndex.value = index;
        merchantController.updateQty();
      },
      child: Container(
        width: 55,
        height: 25,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(25),
        ),
        child: const Center(
          child: Text(
            '  Add + ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}