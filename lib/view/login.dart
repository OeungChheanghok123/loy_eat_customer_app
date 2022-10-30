import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loy_eat_customer/controller/login_controller.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  final loginViewModel = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          onTap: () => Get.back(),
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.only(top: 20, left: 20),
            child: Container(
              height: 30,
              width: 30,
              color: Colors.blue,
              child: const Icon(Icons.close, size: 34, color: Colors.white),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(child: getLoginForm(context)),
    );
  }

  Widget getLoginForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30 * 3,
              ),
              Container(
                height: 75,
                width: 75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.blue.withOpacity(0.7),
                ),
                child: const Icon(
                  Icons.lock_open_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(
                height: 5 * 3,
              ),
              const Text(
                'Sign up your account',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Please Enter your phone number',
                style:TextStyle(fontSize: 14),
              ),
              const Text(
                'for sign in your account',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(
                height: 10 * 3,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    (() => loginViewModel.showOtpText.value
                        ? const SizedBox()
                        : Container(
                            margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                            child: TextField(
                              autocorrect: false,
                              autofocus: false,
                              controller: loginViewModel.phoneNumberController,
                              keyboardType: TextInputType.phone,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.phone, size: 32),
                                hintText: 'Enter phone number',
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black.withOpacity(0.4),
                                ),
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.grey[200],
                                contentPadding: const EdgeInsets.only(top: 15),
                              ),
                            ),
                    )
                    ),
                  ),
                  Obx(
                    (() => loginViewModel.showOtpText.value
                        ? Container(
                            margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                            child: TextField(
                              autocorrect: false,
                              autofocus: false,
                              controller: loginViewModel.otpCodeController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.search, size: 32),
                                hintText: 'Enter OTP Code',
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black.withOpacity(0.4),
                                ),
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.grey[200],
                                contentPadding: const EdgeInsets.only(top: 15),
                              ),
                            ),
                        )
                        : const SizedBox()
                    ),
                  ),
                  Obx((() => loginViewModel.phoneCorrect.value
                      ? const SizedBox()
                      : const Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text('Phone number is not correctly..', style: TextStyle(fontSize: 14, color: Colors.red)),
                      ))),
                  Obx((() => loginViewModel.otpCorrect.value
                      ? const SizedBox()
                      : const Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text('Otp code is not correctly..', style: TextStyle(fontSize: 14, color: Colors.red)),
                      ))),
                ],
              ),
              const SizedBox(
                height: 10 * 2,
              ),
              Obx((() => loginViewModel.showOtpText.value ? const SizedBox() : InkWell(
                onTap: () {
                  debugPrint('button next click');
                  loginViewModel.buttonNextClick();
                },
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                child: Container(
                  height: 50,
                  width: Get.width,
                  margin: const EdgeInsets.fromLTRB(20, 15, 20, 30),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  alignment: Alignment.center,
                  child: const Text('Next', style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  )),
                ),
              ))),
              Obx((() => loginViewModel.showOtpText.value ? InkWell(
                onTap: (){
                  debugPrint('button Submit click');
                  loginViewModel.buttonSubmitClick();
                },
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                child: Container(
                  height: 50,
                  width: Get.width,
                  margin: const EdgeInsets.fromLTRB(20, 15, 20, 30),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  alignment: Alignment.center,
                  child: const Text('Submit', style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  )),
                ),
              ) : const SizedBox())),
            ],
          ),
        ),
      ),
    );
  }
}
