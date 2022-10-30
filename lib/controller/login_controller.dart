import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat_customer/controller/cache_helper.dart';
import 'package:loy_eat_customer/view/home.dart';

class LoginController extends GetxController {
  var showOtpText = false.obs;
  var phoneCorrect = true.obs;
  var otpCorrect = true.obs;

  final phoneNumberController = TextEditingController();
  final otpCodeController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  var customerNumber = ''.obs;
  var verificationIDReceived = '';

  final cacheHelper = CacheHelper();
  final customerCollection = FirebaseFirestore.instance.collection('customers');

  void buttonNextClick() {
    getCustomerPhoneNumber();
  }

  void buttonSubmitClick() {
    verifyOTP();
  }

  void checkList() {
    if (phoneNumberController.text != '') {
      int num = int.parse(phoneNumberController.text);
      phoneNumberController.text = num.toString();
      customerNumber.value = '+855${phoneNumberController.text}';
    }
  }

  void getCustomerPhoneNumber() async {
    checkList();
    final customer = await customerCollection
        .where('tel', isEqualTo: customerNumber.value)
        .get();
    if (customer.docs.isNotEmpty) {
      showOtpText.value = true;
      phoneCorrect.value = true;
      verifyPhoneNumber();
    } else {
      debugPrint('Phone number is not correctly.');
      showOtpText.value = false;
      phoneCorrect.value = false;
      phoneNumberController.text = '';
      customerNumber.value = '';
    }
  }

  void verifyPhoneNumber() async {
    debugPrint('Phone Number : ${customerNumber.value}');
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+855${phoneNumberController.text}',
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) {
        auth
            .signInWithCredential(credential)
            .then((value) => debugPrint('You are logged in successfully'));
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          debugPrint('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        verificationIDReceived = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void verifyOTP() async {
    try {
      otpCorrect.value = true;
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationIDReceived, smsCode: otpCodeController.text);
      await auth.signInWithCredential(credential);

      Navigator.pushAndRemoveUntil(
          Get.context!,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => Home(),
          ),
          (route) => false,
      );
    } catch (e) {
      debugPrint('your otp number not correctly.');
      otpCorrect.value = false;
    }
  }
}
