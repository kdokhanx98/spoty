import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:spoty/screens/getcode_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../services/authservice.dart';
import 'package:spoty/screens/initial_profile.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class SignUp extends StatefulWidget {
  static const routeName = '/SignUp';

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String mobileNo = "+9720594418545	";
  String? phoneNo, verificationId, smsCode;
  bool codeSent = false;
  bool goToCodeScreen = true;
  final numberController = TextEditingController();

  final CountdownController _controller = CountdownController(autoStart: false);

  bool isStarted = false;

  var currentText = "";

  SmsAutoFill smsAutoFill = SmsAutoFill();

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: HexColor("#006D72"), //change your color here
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: codeSent
            ? Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Enter Verification Code",
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 26),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      "Sent a code on $mobileNo",
                      style: const TextStyle(
                          fontWeight: FontWeight.w300, fontSize: 18),
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
                                      style:
                                          TextStyle(color: HexColor("#006D72")),
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
                                    build:
                                        (BuildContext context, double time) =>
                                            Text(time.toString()),
                                    interval: const Duration(milliseconds: 100),
                                    onFinished: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
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
                              print("verificationId $verificationId");
                              print("smsCode $smsCode");
                              codeSent
                                  ? AuthService().signInWithOTP(
                                      currentText, verificationId)
                                  : verifyPhone(mobileNo);
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
              )
            : Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Enter Phone Number",
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 26),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 24),
                      child: Text(
                        "Phone Number",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: Image.asset(
                              "assets/images/flag.png",
                              width: 32,
                              height: 32,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Container(
                              height: 56,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.circular(15)),
                                color: Colors.grey.shade200,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                child: TextFormField(
                                  keyboardType: TextInputType.phone,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Ex: +1 416 555 0134",
                                    labelStyle: TextStyle(fontSize: 24),
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 18),
                                  ),
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    codeSent
                        ? Padding(
                            padding: EdgeInsets.only(left: 25.0, right: 25.0),
                            child: TextFormField(
                              keyboardType: TextInputType.phone,
                              decoration:
                                  InputDecoration(hintText: 'Enter OTP'),
                              onChanged: (val) {
                                setState(() {
                                  this.smsCode = val;
                                });
                              },
                            ))
                        : Container(),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                              "By registering you agree to the\nTerms and Conditions of Spoty"),
                          RawMaterialButton(
                            onPressed: () {
                              codeSent
                                  ? AuthService()
                                      .signInWithOTP(smsCode, verificationId)
                                  : verifyPhone(mobileNo);
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

  Future<void> verifyPhone(phoneNo) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      AuthService().signIn(authResult);
    };

    final PhoneVerificationFailed verificationfailed =
        (FirebaseAuthException authException) {
      print('${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, int? forceResend) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
        this.goToCodeScreen = true;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 20),
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }
}
