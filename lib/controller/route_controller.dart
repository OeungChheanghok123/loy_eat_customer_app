import 'package:get/get.dart';
import 'package:loy_eat_customer/view/food_by_category.dart';
import 'package:loy_eat_customer/view/food_detail.dart';
import 'package:loy_eat_customer/view/home.dart';
import 'package:loy_eat_customer/view/login.dart';
import 'package:loy_eat_customer/view/merchant_detail.dart';
import 'package:loy_eat_customer/view/order.dart';

List<GetPage<dynamic>>? getRoutPage = [
  GetPage(name: '/home', page: () => Home()),
  GetPage(name: '/food_detail', page: () => FoodDetail()),
  GetPage(name: '/food_by_category', page: () => FoodByCategory()),
  GetPage(name: '/merchant_detail', page: () => MerchantDetail()),
  GetPage(name: '/order', page: () => Order()),
  GetPage(name: '/login', page: () => Login()),
];