import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat_customer/controller/order_controller.dart';
import 'package:loy_eat_customer/model/remote_data.dart';
import 'package:loy_eat_customer/view/screen_widget.dart';

class Order extends StatelessWidget {
  Order({Key? key}) : super(key: key);

  final controller = Get.put(OrderController());

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
      child: const Icon(Icons.arrow_back, color: Colors.blue, size: 32),
    ),
  );

  Widget get getBody {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          paymentMethod,
          merchantDetail,
          deliveryFee,
          otherCoupon,
        ],
      ),
    );
  }

  Widget get getBottonOrder {
    return Obx(() {
      final status = controller.merchantDetailData.status;
      if (status == RemoteDataStatus.processing) {
        return ScreenWidgets.loading;
      } else if (status == RemoteDataStatus.error) {
        return ScreenWidgets.error;
      } else {
        return InkWell(
          onTap: (){},
          child: Container(
            height: 50,
            width: Get.width,
            margin: const EdgeInsets.fromLTRB(20, 15, 20, 30),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(50),
            ),
            alignment: Alignment.center,
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
      final status = controller.merchantDetailData.status;
      if (status == RemoteDataStatus.processing) {
        return ScreenWidgets.loading;
      } else if (status == RemoteDataStatus.error) {
        return ScreenWidgets.error;
      } else {
        final report = controller.merchantDetailData.data;
        return ListView.builder(
          shrinkWrap: true,
          itemCount: report!.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: AssetImage(controller.arrayImageOrder[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(''),
                          Text(controller.arrayNameOrder[index], style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 14,
                          ),),
                          Text('pcs', style: TextStyle(
                            fontSize: 12,
                            color: Colors.black.withOpacity(0.3),
                          ),),
                          const Text(''),
                          Text('x${controller.arrayQtyOrder[index]}', style: const TextStyle(
                            fontSize: 14,
                          ),),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(''),
                        const Text(''),
                        const Text(''),
                        const Text(''),
                        Text('\$${controller.arrayPriceOrder[index]}', style: const TextStyle(fontSize: 14, color: Colors.blue, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
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
              Text('No coupon available', style: TextStyle(
                fontSize: 14,
                color: Colors.black.withOpacity(0.5),
              ),),
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
              Text('No delivery fee coupon available', style: TextStyle(
                fontSize: 14,
                color: Colors.black.withOpacity(0.5),
              ),),
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
              Text('Use promo code', style: TextStyle(
                fontSize: 14,
                color: Colors.black.withOpacity(0.5),
              ),),
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
}