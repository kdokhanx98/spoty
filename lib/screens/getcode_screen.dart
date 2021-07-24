import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:spoty/screens/initial_profile.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class GetCode extends StatefulWidget {
  static const routeName = '/GetCode';

  @override
  State<GetCode> createState() => _GetCodeState();
}

class _GetCodeState extends State<GetCode> {
  String mobileNo = "+970595166453";

  final numberController = TextEditingController();

  final CountdownController _controller = CountdownController(autoStart: false);

  bool isStarted = false;

  var currentText = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: HexColor("#006D72"), //change your color here
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Enter Verification Code",
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 26),
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                "Sent a code on $mobileNo",
                style:
                    const TextStyle(fontWeight: FontWeight.w300, fontSize: 18),
              ),
              const SizedBox(
                height: 50,
              ),
              PinCodeTextField(
                length: 6,
                obscureText: true,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  activeFillColor: Colors.white,
                  inactiveFillColor: Colors.grey.shade200,
                  selectedFillColor: Colors.grey.shade200,
                ),
                animationDuration: const Duration(milliseconds: 300),
                enableActiveFill: true,
                /*     errorAnimationController: errorController,
                controller: textEditingController,*/
                onCompleted: (v) {
                  print("Completed");
                },
                onChanged: (value) {
                  print(value);
                  setState(() {
                    currentText = value;
                  });
                },
                beforeTextPaste: (text) {
                  print("Allowing to paste $text");
                  //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                  //but you can show anything you want here, like your pop up saying wrong paste format or etc
                  return true;
                },
                appContext: context,
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 35.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        const Text("Didn't receive a code?"),
                        Row(
                          children: [
                            GestureDetector(
                              child: Text(
                                "Resend Code",
                                style: TextStyle(color: HexColor("#006D72")),
                              ),
                              onTap: () {
                                if (!isStarted) {
                                  _controller.start();
                                  setState(() {
                                    isStarted = !isStarted;
                                  });
                                } else {
                                  _controller.restart();
                                }
                              },
                            ),
                            const SizedBox(
                              width: 10,
                              height: 20,
                            ),
                            Countdown(
                              controller: _controller,
                              seconds: 30,
                              build: (BuildContext context, double time) =>
                                  Text(time.toString()),
                              interval: const Duration(milliseconds: 100),
                              onFinished: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        " Didn't receive code yet? Resend Code"),
                                  ),
                                );
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                    RawMaterialButton(
                      onPressed: () {
                        Navigator.pushNamed(context, InitialProfile.routeName);
                      },
                      elevation: 2.0,
                      fillColor: HexColor("#006D72"),
                      child: const Icon(
                        Icons.forward,
                        size: 35.0,
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(15.0),
                      shape: const CircleBorder(),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void onEnd() {
    print('onEnd');
  }
}
