import 'package:get/get.dart';
import 'package:loy_eat_customer/view/food_by_category.dart';
import 'package:loy_eat_customer/view/food_detail.dart';
import 'package:loy_eat_customer/view/home.dart';
import 'package:loy_eat_customer/view/merchant_detail.dart';

List<GetPage<dynamic>>? getRoutPage = [
  GetPage(name: '/home', page: () => Home()),
  GetPage(name: '/food_detail', page: () => FoodDetail()),
  GetPage(name: '/food_by_category', page: () => FoodByCategory()),
  GetPage(name: '/merchant_detail', page: () => const MerchantDetail()),
];