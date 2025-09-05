import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:digitalwalletpaytmcloneapp/Constants/colors.dart';
import 'package:digitalwalletpaytmcloneapp/Constants/images.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_text_widget.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_textfeild_widget.dart';
import 'bill_confirm_screen.dart';
class ElectricityBillScreen extends StatefulWidget {
  final String boardName;

  const ElectricityBillScreen({Key? key, required this.boardName})
      : super(key: key);

  @override
  State<ElectricityBillScreen> createState() => _ElectricityBillScreenState();
}

class _ElectricityBillScreenState extends State<ElectricityBillScreen> {
  final TextEditingController accountController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    accountController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        leading: InkWell(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Row(
          children: [
            Expanded(
              child: CommonTextWidget.InterSemiBold(
                text: widget.boardName,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            SvgPicture.asset(
              Images.information, // must be a String: 'assets/information.svg'
              color: Colors.white,
              height: 20,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Number
            CommonTextWidget.InterSemiBold(
              text: "Account Number",
              fontSize: 14,
              color: Colors.white,
            ),
            const SizedBox(height: 6),
            CommonTextFieldWidget.TextFormField2(
              controller: accountController,
              keyboardType: TextInputType.number,
              hintText: "Please Enter Valid Consumer ID",
            ),
           

            // Phone Number
            CommonTextWidget.InterSemiBold(
              text: "Phone Number",
              fontSize: 14,
              color: Colors.white,
            ),
            const SizedBox(height: 6),
            // CommonTextFieldWidget.TextFormField2(
            //   controller: phoneController,
            //   keyboardType: TextInputType.phone,
            //   hintText: "Please enter your phone number",
            // ),
            const SizedBox(height: 25),

            // Info Box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    Images.information,
                    color: Colors.white,
                    height: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CommonTextWidget.InterRegular(
                      text:
                          "By proceeding further, you allow the app to fetch your current and future bills and remind you.",
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            if (accountController.text.isEmpty) {
              Get.snackbar("Error", "Please fill all fields");
              return;
            }
            print(
                "Confirm clicked with Account: ${accountController.text}");
                  // Navigate to BillConfirmScreen and pass data
      Get.to(() => BillConfirmScreen(
            operatorName: widget.boardName,
            operatorLogo: Images.information,
            customerId: accountController.text.trim(),
            customerName: "John Doe", // Replace with actual customer name
            billDate: "2023-10-01", // Replace with actual bill date
            dueDate: "2023-10-15", // Replace with actual due date
            amount: 100.0, // Replace with actual amount
          ));

          },
          child: CommonTextWidget.InterSemiBold(
            text: "Confirm",
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
