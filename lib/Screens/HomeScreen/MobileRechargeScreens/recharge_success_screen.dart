import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:digitalwalletpaytmcloneapp/Screens/HomeScreen/home_screen.dart';

class RechargeSuccessScreen extends StatelessWidget {
  final Map<String, dynamic> apiResponse;

  const RechargeSuccessScreen({Key? key, required this.apiResponse}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ✅ Success Icon
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.green,
                child: const Icon(Icons.check, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 25),

              // ✅ Title
              Text(
                apiResponse["Status"] == "Success"
                    ? "Recharge Successful!"
                    : "Recharge Pending!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: apiResponse["Status"] == "Success"
                      ? Colors.green
                      : Colors.red,
                ),
              ),
              const SizedBox(height: 15),

              // ✅ Details Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      infoRow("Txn ID", apiResponse["ApiTransID"] ?? "-"),
                      const Divider(),
                      infoRow("Operator Ref", apiResponse["OperatorRef"] ?? "-"),
                      const Divider(),
                      infoRow("Status", apiResponse["Status"] ?? "-"),
                      const Divider(),
                      infoRow("Date", apiResponse["TransactionDate"] ?? "-"),
                      if ((apiResponse["ErrorMessage"] ?? "").trim().isNotEmpty) ...[
                        const Divider(),
                        infoRow("Message", apiResponse["ErrorMessage"]),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // ✅ Done Button → Dashboard
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.off(() => HomeScreen()); // redirect to dashboard
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Done",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
