import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ForgotPassword(),
    );
  }
}

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
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
      isOTPValid = otpText == staticOtp;
      showError = !isOTPValid;
      isButtonClicked = true; // Mark button as clicked
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isOtpSent)
              ElevatedButton(
                onPressed: () {
                  setState(
                    () {
                      isOtpSent = true;
                    },
                  );
                },
                child: const Text("Send OTP"),
              ),
            if (isOtpSent)
              Column(
                children: [
                  const SizedBox(height: 10),
                  PinCodeTextField(
                    appContext: context,
                    length: 6,
                    focusNode: otpFocusNode,
                    // Attach the focus node
                    pastedTextStyle: const TextStyle(
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
                        isButtonClicked = false;
                      });
                    },
                    controller: TextEditingController(text: otpText),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: verifyOTP, // Call the verifyOTP function
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isButtonClicked
                          ? (otpText.length == 6)
                              ? (isOTPValid ? Colors.green : Colors.red)
                              : Colors.blue
                          : Colors.blue,
                    ),
                    child: const Text(
                      "Verify OTP",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  isButtonClicked == true
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: (otpText.length != 6)
                              ? const SizedBox(
                                  child: Text('Please fill the otp first!'),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  padding: const EdgeInsets.all(8),
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
                                ),
                        )
                      : const SizedBox(),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
