import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
   LoginScreen({Key? key}) : super(key: key);

   final phoneNumber = TextEditingController();
   final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: body,
      ),
    );
  }

  Widget get body {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        textEditingController(
          controller: phoneNumber,
          labletext: 'Phone number',
          suffixIcon: GestureDetector(
              onTap: () => {},
              child: const Icon(Icons.phone_android_outlined)),),
        textEditingController(
          controller: password,
          labletext: 'Password',
          obscureText: true,
          suffixIcon: GestureDetector(onTap: () => {}, child: const Icon(Icons.key_rounded)),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 36),
          child: Center(
            child: SizedBox(
              height: 36,
              width: 345,
              // ignore: deprecated_member_use
              child: RaisedButton(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                onPressed: () {
                  //controller.submit();
                },
                color: Colors.blue,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: const Text(
                  "Submit",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('You don\'t have account?  '),
              InkWell(child: const Text('Register Now!',style:  TextStyle(color: Colors.blue),),
                  onTap: (){
                    //Get.to(() => const CustomerScreen());
                  }
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget textEditingController({required TextEditingController controller, required String labletext, bool obscureText = false, Widget? suffixIcon}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: TextField(
        keyboardType: TextInputType.number,
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          border: const OutlineInputBorder(),
          labelText: labletext,
        ),
        onSubmitted: (value) {
          controller.text = value;
        },
      ),
    );
  }
}
