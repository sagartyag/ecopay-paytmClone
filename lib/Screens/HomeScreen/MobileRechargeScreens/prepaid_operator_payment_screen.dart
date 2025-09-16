import 'package:digitalwalletpaytmcloneapp/Constants/colors.dart';
import 'package:digitalwalletpaytmcloneapp/Constants/font_family.dart';
import 'package:digitalwalletpaytmcloneapp/Constants/images.dart';
import 'package:digitalwalletpaytmcloneapp/Screens/HomeScreen/MobileRechargeScreens/apply_promocode_screen.dart';
import 'package:digitalwalletpaytmcloneapp/Screens/HomeScreen/MobileRechargeScreens/recharge_detail_screen.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:digitalwalletpaytmcloneapp/Service/Api.dart';
import 'recharge_success_screen.dart';
import 'package:digitalwalletpaytmcloneapp/Screens/HomeScreen/home_screen.dart';
class PrepaidOperatorPaymentScreen extends StatefulWidget {
  const PrepaidOperatorPaymentScreen({Key? key}) : super(key: key);

  @override
  State<PrepaidOperatorPaymentScreen> createState() => _PrepaidOperatorPaymentScreenState();
}

class _PrepaidOperatorPaymentScreenState extends State<PrepaidOperatorPaymentScreen> {
  double totalBalance = 0.0;
  bool isLoading = true;
  bool isSubmitting = false;
  @override
  void initState() {
    super.initState();
    isSubmitting = true;
    fetchBalance();
  }

  Future<void> fetchBalance() async {
    try {
      final response = await ApiService.get("/direct-income");
      print("Response: $response");

      final data = response.data;

      if (data["success"] == true) {
        setState(() {
          totalBalance = double.tryParse(data["balance"].toString()) ?? 0.0;
          isLoading = false;
        });
      } else {
        setState(() {
          totalBalance = 0.0;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching balance: $e");
      setState(() {
        totalBalance = 0.0;
        isLoading = false;
      });
    }
    
  }

  Future<void> doRecharge(Map<String, dynamic> plan) async {
    try {
      final args = Get.arguments as Map<String, dynamic>;

      print("👉 Arguments received in Payment Screen: $args");

      final operator1 = args["operator"];
      final phone = args["phone"];
      final circle = args["circle"];
      final amount = plan["recharge_amount"];
      final operatorName = args["operatorName"];

      print("👉 Operator: $operator1, Phone: $phone, Circle: $circle, Amount: $amount");

      final response = await ApiService.post("/recharge", {
        "operator": operator1,
        "phone": phone,
        "circle": circle,
        "amount": amount.toString(),

      });
 

      final data = response.data;
      if (data['success'] == true) {
        Get.snackbar("✅ Success", "Recharge Successful!");
        final rawResponse = data["rawResponse"] ?? {}; // ✅ backend raw response
        Get.off(() => RechargeSuccessScreen(apiResponse: rawResponse));

      } else {
        Get.snackbar("❌ Failed", data['message'] ?? "Recharge Failed!");
        Future.delayed(Duration(seconds: 30), () {
        Get.off(() => HomeScreen());
         });
      }
    } catch (e) {
      print("❌ Error in doRecharge: $e");
      Get.snackbar("Error", "Something went wrong: $e");
    }
    finally {
      setState(() {
        isSubmitting = false; // 🔹 Hide loader
      });
    }
  }

  @override
  Widget build(BuildContext context) {
      String _getOperatorLogo(String operatorName) {
  final name = operatorName.toLowerCase();

  if (name.contains("airtel")) return "assets/images/airtel.png";
    if (name.contains("airtel express")) return "assets/images/airtel.png";

  if (name.contains("reliance jio")) return "assets/images/jio.png";
    if (name.contains("jio express")) return "assets/images/jio.png";

  if (name.contains("vi") || name.contains("vodafone")) return "assets/images/vi.png";
    if (name.contains("vodafoneidea") || name.contains("vodafone")) return "assets/images/vi.png";

  if (name.contains("bsnl topup")) return "assets/images/bsnl.png";
  if (name.contains("bsnl special(stv)")) return "assets/images/bsnl.png";

  return "assets/images/default.png"; // fallback image
}
  
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final plan = args["plan"] ?? {};
    final amount = plan["recharge_amount"] ?? "0";

    final operator1 = args["operator"] ?? "";
    final phone = args["phone"] ?? "";
    final circle = args["circle"] ?? "";
    final operatorName = args["operatorName"] ?? "";

void showPaymentPopup(BuildContext context, Map<String, dynamic> plan, String amount) {
  final rechargeAmount = plan["recharge_amount"] ?? amount;
  final validity = plan["recharge_validity"] ?? "N/A";
  final desc = plan["recharge_long_desc"] ?? "No details available";

  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Drag Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),

            /// Wallet Card Section
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.green, width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.account_balance_wallet,
                        color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Cyrus Wallet",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 4),

      // 🔹 Balance from API
      Text(
        isLoading
            ? "Loading..."
            : "₹${totalBalance.toStringAsFixed(2)}", // INR format
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.black, // 🔹 Balance black
        ),
      ),
       if (isSubmitting)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.green),
              ),
            ),
                    ],
                  ),
                ],
              ),
            ),

            /// Plan Details Title
            const Text(
              "Plan Details",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),

            /// Plan Details Section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "₹$rechargeAmount",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Validity: $validity",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        desc,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            /// Pay Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
    Get.back();
    doRecharge(plan); // ✅ directly call, kyunki ye _PrepaidOperatorPaymentScreenState me hai
  },
                icon: const Icon(Icons.payment, color: Colors.white),
                label: Text(
              "Pay ₹ $rechargeAmount",
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    isScrollControlled: true,
  );
}

    return Scaffold(
      backgroundColor: Colors.green,
      body: Column(
        children: [
          Container(
            color: Colors.green,
            child: Padding(
              padding: const EdgeInsets.only(top: 50, left: 22, right: 22, bottom: 18),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(Icons.arrow_back, size: 20, color: white),
                  ),
                  const SizedBox(width: 12),
    Image.asset(
      _getOperatorLogo(operatorName), // ✅ Yeh function call karega
      height: 50,
      width: 50,
    ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonTextWidget.InterSemiBold(
                        text: "$operatorName",
                        fontSize: 16,
                        color: white,
                      ),
                      CommonTextWidget.InterRegular(
                        text: "+91$phone", // ✅ phone show
                        fontSize: 12,
                        color: white,
                      ),
                      // CommonTextWidget.InterRegular(
                      //   text: "Prepaid: $operatorName", // ✅ circle show
                      //   fontSize: 10,
                      //   color: white,
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: Get.height,
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(28),
                  topLeft: Radius.circular(28),
                ),
                color: white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 24, right: 24, left: 24, bottom: 15),
                    child: Container(
                      height: 65,
                      width: Get.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: greyE5E, width: 1),
                        color: white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: CommonTextWidget.InterBold(
                          text: "₹ $amount",
                          fontSize: 22,
                          color: black171,
                        ),
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(right: 24, left: 24),
                  //   child: Container(
                  //     height: 50,
                  //     width: 135,
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(16),
                  //       border: Border.all(color: greyE5E, width: 1),
                  //       color: white,
                  //     ),
                  //     child: Center(
                  //       child: CommonTextWidget.InterMedium(
                  //         text: "Change Plan",
                  //         fontSize: 16,
                  //         color: Colors.green,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                            child: InkWell(
                              onTap: () {
                                Get.bottomSheet(
                                  RechargeDetailScreen(plan: plan),
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                );
                              },
                              child: Text(
                                "Recharge Details",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 14,
                                  fontFamily: FontFamily.InterMedium,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(0, 0),
                                  color: black.withOpacity(0.15),
                                  blurRadius: 10,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 18, left: 25, right: 25, bottom: 30),
                              child: Row(
                                children: [
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: InkWell(
                       onTap: () => showPaymentPopup(context, plan, amount),
                                      child: Container(
                                        height: 55,
                                        width: Get.width,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          color: Colors.green,
                                        ),
                                        child: Center(
                                          child: CommonTextWidget.InterSemiBold(
                                            text: "Pay ₹ $amount",
                                            fontSize: 20,
                                            color: white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
