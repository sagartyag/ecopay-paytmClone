import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:digitalwalletpaytmcloneapp/Screens/HomeScreen/CableTv/dth_plan_screen.dart';

class EnterCableRechargeDetailScreen extends StatelessWidget {
  EnterCableRechargeDetailScreen({Key? key}) : super(key: key);

  final TextEditingController numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? {};
    final operatorCode = args["operatorCode"] ?? "Unknown";
    final circleCode = args["circleCode"] ?? "Unknown";
    final operatorName = args["operatorName"] ?? "Unknown";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back, size: 20, color: Colors.black),
        ),
        title: const Text(
          "Recharge DTH or TV",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),

            // 🔰 Operator Card (Paytm style)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.tv, color: Colors.green, size: 22),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      operatorName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.back(); // User ko operator change karne ke liye pichhe bhej sakte ho
                    },
                    child: const Text(
                      "Change",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔰 Input Field (Paytm style)
            TextFormField(
              controller: numberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Registered Mobile No / Viewing Card Number",
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                suffixIcon: const Icon(Icons.contact_page_outlined,
                    color: Colors.grey),
              ),
            ),

            const SizedBox(height: 8),
            const Text(
              "Enter your Registered Mobile Number or 11 digit Viewing Card Number starting with 0.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),

            const Spacer(),

            // 🔰 Proceed Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  final mobile = numberController.text.trim();
                  if (mobile.isEmpty) {
                    Get.snackbar("Error", "Please enter mobile number");
                    return;
                  }

                  Get.to(() => DthPlansScreen(), arguments: {
                    "operatorCode": operatorCode,
                    "circleCode": circleCode,
                    "mobileNumber": mobile,
                   "operatorName": operatorName,

                  });
                },
                child: const Text(
                  "Proceed",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
