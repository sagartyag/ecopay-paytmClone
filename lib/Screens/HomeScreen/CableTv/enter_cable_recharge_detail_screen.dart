import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:digitalwalletpaytmcloneapp/Service/Api.dart';
import 'package:digitalwalletpaytmcloneapp/Screens/HomeScreen/CableTv/dth_plan_screen.dart';

class EnterCableRechargeDetailScreen extends StatelessWidget {
  EnterCableRechargeDetailScreen({Key? key}) : super(key: key);

  final TextEditingController numberController = TextEditingController();

  /// 👉 Backend से DTH Plans fetch करने का function
  Future<void> fetchDthPlan(String operator, String mobile, BuildContext context) async {
    try {
      final response = await ApiService.post(
        "/dth-plans", // केवल endpoint, baseUrl ApiService में पहले से है
        {
          "operator": operator,
          "mobile": mobile,
        },
      );

      final data = response.data;
        print("data sagar: $data");
      if (data["success"] == true) {
        final plans = data["data"]["records"] ?? [];

        // ✅ Plans Screen पर navigate
        Get.to(() => DthPlansScreen(), arguments: {
          "operator": operator,
          "mobile": mobile,
          "plans": plans,
        });
      } else {
        Get.snackbar("Error", data["message"] ?? "No plans found");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? {};
    final operatorName = args["operatorName"] ?? "Unknown Operator";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back, size: 20, color: Colors.black),
        ),
        title: Text(
          "Cable TV Recharge",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text("Enter Details", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 25),

            // ✅ Operator Name
            Text(operatorName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
            SizedBox(height: 20),

            // ✅ Customer ID Field
            Text("Mobile Number", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            SizedBox(height: 10),
            TextFormField(
              controller: numberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter Mobile Number",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              ),
            ),

            Spacer(),

            // ✅ Proceed Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  final mobile = numberController.text.trim();
                  if (mobile.isEmpty) {
                    Get.snackbar("Error", "Please enter Customer ID");
                    return;
                  }
                  fetchDthPlan(operatorName, mobile, context);
                },
                child: Text("Proceed", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(height: 45),
          ],
        ),
      ),
    );
  }
}
