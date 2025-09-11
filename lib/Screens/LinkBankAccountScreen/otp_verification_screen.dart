import 'package:digitalwalletpaytmcloneapp/Constants/colors.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_button_widget.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_text_widget.dart';
import 'package:digitalwalletpaytmcloneapp/Service/Api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'add_beneficiary_screen.dart';
class OtpVerificationScreen extends StatelessWidget {
   final String bankId;
  final String bankName;
  final String ifsc;

 OtpVerificationScreen({
    Key? key,
    required this.bankId,
    required this.bankName,
    required this.ifsc,
  }) : super(key: key);


  

  final TextEditingController otpController = TextEditingController();

  Future<void> verifyOtp(BuildContext context) async {
    String otp = otpController.text.trim();

    if (otp.length != 6) {
      Get.snackbar("Error", "Please enter a valid 6-digit OTP");
      return;
    }

    try {
      final response = await ApiService.post(
        "/verify-kyc",
        {
          "otp": otp, // 👈 only send OTP
        },
      );

      final data = response.data;
     print(data);
      if (data['success'] == true) {
        Get.snackbar("Success", data['message'] ?? "OTP Verified Successfully");

        // 👉 Navigate after OTP success
        // Example: move to dashboard or add beneficiary
        Get.offAll(() => AddBeneficiaryScreen(
            bankId: bankId,
        bankName: bankName,
        ifsc: ifsc,
        ));
      } else {
        Get.snackbar("Error", data['message'] ?? "OTP Verification failed");
      }
    } catch (e) {
      Get.snackbar("Error", "Server error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteF9F,
      appBar: AppBar(
        backgroundColor: whiteF9F,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back, size: 20, color: black171),
        ),
        centerTitle: true,
        title: CommonTextWidget.InterSemiBold(
          text: "OTP Verification",
          color: black171,
          fontSize: 18,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonTextWidget.InterBold(
              text: "Enter OTP",
              fontSize: 20,
              color: black171,
            ),
            const SizedBox(height: 8),
            CommonTextWidget.InterRegular(
              text: "We have sent an OTP to your registered mobile number.",
              fontSize: 14,
              color: grey757,
            ),
            const SizedBox(height: 30),

            // OTP Input Field
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                counterText: "",
                hintText: "Enter 6-digit OTP",
                hintStyle: TextStyle(color: grey757, fontSize: 14),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: grey757.withOpacity(0.4)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: grey757.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.green, width: 1.5),
                ),
              ),
            ),

            const SizedBox(height: 20),
            Center(
              child: InkWell(
                onTap: () {
                  // 🔄 Call resend OTP API here
                  Get.snackbar("Info", "Resend OTP clicked");
                },
                child: CommonTextWidget.InterSemiBold(
                  text: "Resend OTP",
                  color: Colors.green,
                  fontSize: 14,
                ),
              ),
            ),

            const Spacer(),

            // Verify Button
            CommonButtonWidget.button(
              text: "Verify & Continue",
              buttonColor: Colors.green,
              onTap: () => verifyOtp(context),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
