import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat_customer/controller/merchant_detail_controller.dart';
import 'package:loy_eat_customer/model/remote_data.dart';
import 'package:loy_eat_customer/view/screen_widget.dart';

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
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            image: DecorationImage(
              image: AssetImage(controller.image.value),
              fit: BoxFit.cover,
              opacity: 0.6,
            ),
          ),
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
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10),
              ),
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Container()),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15, left: 15),
                          child: Text(controller.title.value, style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5, left: 15),
                          child: Row(
                            children: [
                              Icon(Icons.star, size: 16, color: Colors.blue.withOpacity(0.7)),
                              const Text(' 4.9', style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5, left: 15),
                          child: Row(
                            children: [
                              Icon(Icons.location_on, size: 16, color: Colors.blue.withOpacity(0.7)),
                              Text(' 1.6km , ${controller.time.value}min | ', style: const TextStyle(fontSize: 14)),
                              controller.fee.value == '0.00'
                                  ? Text('Free delivery fee',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.withOpacity(0.7),
                                ),
                              )
                                  : Text('\$${controller.fee.value} Delivery fee',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 70,
                    height: 70,
                    margin: const EdgeInsets.only(right: 15, top: 10),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                        image: AssetImage(controller.image.value),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget get bodyMerchantItem {
    return Obx(() {
      final status = controller.productItemData.status;
      if (status == RemoteDataStatus.processing) {
        return ScreenWidgets.loading;
      } else if (status == RemoteDataStatus.error) {
        return ScreenWidgets.error;
      } else {
        final report = controller.productItemData.data;
        return Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: report!.length,
              itemBuilder: (context, index) {
                return bodyItems(
                  index: index,
                  image: controller.arrayProductImage[index],
                  name: controller.arrayProductName[index],
                  price: controller.arrayProductPrice[index],
                );
              },
            ),
          ),
        );
      }
    });

  }

  Widget bodyItems({required int index, required String image, required String name, required String price}) {
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
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  image: DecorationImage(
                    image: AssetImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 15, left: 15, bottom: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name, style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          )),
                          const SizedBox(height: 3),
                          Text('0 Sold', style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                          )),
                        ],
                      ),
                      Text('\$ $price', style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned (
            right: 5,
            bottom: 2,
            child: InkWell(
              onTap: () {
                controller.selectedIndex.value = index;
              },
              child: controller.tempListProduct.contains(controller.arrayProductName[index]) ?
                Row(
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
          ),
        ],
      ),
    );
  }
}
