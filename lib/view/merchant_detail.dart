import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat_customer/controller/merchant_detail_controller.dart';

class MerchantDetail extends StatefulWidget {
  const MerchantDetail({Key? key}) : super(key: key);

  @override
  State<MerchantDetail> createState() => _MerchantDetailState();
}

class _MerchantDetailState extends State<MerchantDetail> {
  final controller = Get.put(MerchantDetailController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: null,
        backgroundColor: Colors.white,
        body: getBody,
      ),
    );
  }

  Widget get getBody {
    return Column(
      children: [
        merchantImage,
        bodyMerchantItem,
      ],
    );
  }

  Widget get merchantImage {
    return Stack(
      children: [
        Container(
          width: Get.width,
          height: 200,
          color: Colors.blue,
        ),
        Positioned(
          top: 10,
          left: 10,
          child: InkWell(
            onTap: () => Get.back(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Icon(Icons.arrow_back_ios_sharp, color: Colors.black),
            ),
          ),
        ),
        Positioned(
          bottom: 5,
          right: 0,
          left: 0,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            width: Get.width,
            height: 120,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 70,
                      height: 70,
                      margin: const EdgeInsets.only(right: 15, top: 10),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Container()),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 15, left: 15),
                          child: Text('Amazon City Mall', style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5, left: 15),
                          child: Row(
                            children: const [
                              Icon(Icons.star, size: 16, color: Colors.red),
                              Text(' 4.9', style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5, left: 15),
                          child: Row(
                            children: const [
                              Icon(Icons.location_on, size: 16, color: Colors.red),
                              Text(' 1.6km , 15min | \$0.50 Delivery fee', style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget get bodyMerchantItem {
     return Expanded(
       child: Container(
         padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
         child: ListView.builder(
           shrinkWrap: true,
           itemCount: controller.arrayProductName.length,
           itemBuilder: (context, index) {
             return bodyItems(index);
           },
         ),
       ),
     );
  }

  Widget bodyItems(int index) {
    return Container(
      width: Get.width,
      height: 100,
      margin: const EdgeInsets.only(bottom: 15),
      child: Stack(
        children: [
          Row(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 15, bottom: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(controller.arrayProductName[index], style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        )),
                        const SizedBox(height: 3),
                        Text('0 Sold', style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                        )),
                      ],
                    ),
                    const Text('\$ 4.60', style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    )),
                  ],
                ),
              ),
            ],
          ),
          Positioned (
            right: 5,
            bottom: 2,
            child: controller.tempListProduct.contains(controller.arrayProductName[index]) ?  Row(
              children: [
                InkWell(
                  onTap: () {
                    setState((){
                      controller.qty.value--;

                      if (controller.qty.value == 0) {
                        controller.tempListProduct.remove(controller.arrayProductName[index]);
                        controller.tempListQty.removeAt(index);

                        controller.listMapProductItem.removeWhere((data) {
                          return data['product_name'] == controller.arrayProductName[index].toString();
                        });

                        controller.qty.value = 0;
                      }
                      else {
                        controller.listMapProductItem.removeWhere((data) {
                          return data['product_name'] == controller.arrayProductName[index].toString();
                        });
                        controller.listMapProductItem.add({'product_name': controller.arrayProductName[index].toString(), 'qty': controller.qty.value.toString()});

                      }

                      debugPrint('tempListQty: ${controller.tempListQty}');
                      debugPrint('listMapProductItem: ${controller.listMapProductItem}');
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Icon(Icons.remove, color: Colors.white, size: 16),
                  ),
                ),
                Text('   ${controller.arrayProductQty[index]}   ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                InkWell(
                  onTap: () {
                    setState((){
                      controller.qty.value++;

                      controller.listMapProductItem.removeWhere((data) {
                        return data['product_name'] == controller.arrayProductName[index].toString();
                      });
                      controller.listMapProductItem.add({'product_name': controller.arrayProductName[index].toString(), 'qty': controller.qty.value.toString()});

                      debugPrint('listMapProductItem: ${controller.listMapProductItem}');
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 16),
                  ),
                ),
              ],
            ) :
            InkWell(
              onTap: () {
                setState((){
                  if (controller.tempListProduct.contains(controller.arrayProductName[index].toString())) {
                    controller.tempListProduct.remove(controller.arrayProductName[index].toString());
                    controller.tempListQty.removeAt(index);

                    controller.listMapProductItem.removeWhere((data) {
                      return data['product_name'] == controller.arrayProductName[index].toString();
                    });
                  }
                  else {
                    controller.tempListProduct.add(controller.arrayProductName[index].toString());
                    controller.tempListQty.add((int.parse(controller.arrayProductQty[index]) + 1).toString());

                    controller.listMapProductItem.add({
                      'product_name': controller.arrayProductName[index].toString(),
                      'qty': (int.parse(controller.arrayProductQty[index]) + 1).toString(),
                    });
                    controller.qty.value++;
                  }
                });

                debugPrint('tempArray: ${controller.tempListProduct}');
                debugPrint('qty: ${controller.qty.value}');
                debugPrint('listMapProductItem: ${controller.listMapProductItem}');
              },
              child: Container(
                width: 55,
                height: 25,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Center(
                  child: Text('  Add + ', style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  )),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}