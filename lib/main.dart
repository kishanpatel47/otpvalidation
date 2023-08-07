import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ForgotPassword(),
    );
  }
}

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool isOTPValid = true;
  String otpText = "";
  bool isOtpSent = false;
  String staticOtp = "123456"; // Static OTP for demonstration

  FocusNode otpFocusNode = FocusNode();
  bool showError = false;
  bool isButtonClicked = false; // Added to track button click

  @override
  void initState() {
    super.initState();
    otpFocusNode.addListener(() {
      if (!otpFocusNode.hasFocus) {
        setState(() {
          isOTPValid = otpText == staticOtp;
          showError = !isOTPValid; // Show error if OTP is invalid
        });
      }
    });
  }

  void verifyOTP() {
    setState(() {
      showError = !isOTPValid;
      isButtonClicked = true; // Mark button as clicked
      if (isOTPValid) {
        otpText = ""; // Clear the OTP text on successful verification
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isOtpSent)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isOtpSent = true;
                  });
                },
                child: Text("Send OTP"),
              ),
            if (isOtpSent)
              Column(
                children: [
                  SizedBox(height: 10),
                  PinCodeTextField(
                    appContext: context,
                    length: 6,
                    focusNode: otpFocusNode, // Attach the focus node
                    pastedTextStyle: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      inactiveColor: Colors.blue,
                      activeColor: Colors.blue,
                      selectedColor: Colors.blue,
                      selectedFillColor: Colors.blue,
                      inactiveFillColor: Colors.blue,
                      borderWidth: 2,
                    ),
                    onChanged: (value) {
                      setState(() {
                        otpText = value;
                        showError = false; // Hide error while typing
                      });
                    },
                    controller: TextEditingController(text: otpText),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: verifyOTP, // Call the verifyOTP function
                    style: ElevatedButton.styleFrom(
                      primary: isButtonClicked
                          ? isOTPValid
                              ? Colors.green
                              : Colors.red
                          : Colors.blue,
                    ),
                    child: Text(
                      "Verify OTP",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  isButtonClicked == true
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: otpText.isNotEmpty
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    showError
                                        ? "Invalid OTP. Please try again."
                                        : "OTP verified successfully!",
                                    style: TextStyle(
                                      color:
                                          showError ? Colors.red : Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              : SizedBox(),
                        )
                      : SizedBox(),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
