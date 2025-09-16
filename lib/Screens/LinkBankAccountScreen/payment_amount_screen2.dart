import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:digitalwalletpaytmcloneapp/Service/Api.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_text_widget.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic> beneficiary;
  const PaymentScreen({Key? key, required this.beneficiary}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController amountController = TextEditingController();
  bool isSubmitting = false;

  /// 🚀 Mask first 7 digits
  String maskAccount(String? acc) {
    if (acc == null || acc.length < 7) return acc ?? "";
    return "${'*' * 7}${acc.substring(7)}";
  }

  /// 🚀 Show Bottom Sheet Payment Confirmation
  void showPaymentBottomSheet(String amount) {
    final b = widget.beneficiary;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Wrap(
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            // Beneficiary Card
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.green, width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.person, color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          b['name'] ?? "Unknown",
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "A/c No: ${maskAccount(b['account_no'])}",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        Text(
                          "IFSC: ${b['ifsc']}",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        Text(
                          "Mobile: ${b['mobile_no'] ?? 'N/A'}",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Pay Button
            ElevatedButton(
              onPressed: () {
                Get.back();
                makePayment(amount);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                "Pay ₹ $amount",
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  /// 🚀 API call
  Future<void> makePayment(String amount) async {
    final b = widget.beneficiary;
    setState(() => isSubmitting = true);

    try {
      final response = await ApiService.post("/send-money", {
        "CustomerMobile": b['customer_mobile_no'],
        "beneficiaryAccount": b['account_no'],
        "beneficiaryIFSC": b['ifsc'],
        "beneficiaryId": b['BENEFICIARYID'],
        "orderId": DateTime.now().millisecondsSinceEpoch.toString(),
        "amount": amount,
        "comments": "Payment via app",
      });

      final data = response.data;
      setState(() => isSubmitting = false);

      if (data['success'] == true) {
        Get.snackbar(
          "Success",
          data['message'] ?? "₹$amount sent to ${b['name']}",
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Error",
          data['message'] ?? "Payment failed",
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      setState(() => isSubmitting = false);
      Get.snackbar(
        "Error",
        "Server error: $e",
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final b = widget.beneficiary;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          "Send Money",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Beneficiary Info Card
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.green.withOpacity(0.2),
                      child: const Icon(Icons.person, color: Colors.green, size: 30),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            b['name'] ?? "Unknown",
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "A/c No: ${maskAccount(b['account_no'])}",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          Text("IFSC: ${b['ifsc']}", style: TextStyle(color: Colors.grey[700])),
                          Text("Mobile: ${b['mobile_no'] ?? 'N/A'}",
                              style: TextStyle(color: Colors.grey[700])),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Amount Input
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: "₹ ",
                prefixStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                hintText: "Enter amount",
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.green.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.green, width: 2),
                ),
              ),
            ),

            const Spacer(),

            // Pay Button
           SizedBox(
  width: double.infinity,
  height: 55,
  child: ElevatedButton(
    onPressed: isSubmitting
        ? null // 🔒 disable when submitting
        : () {
            String amount = amountController.text.trim();
            if (amount.isEmpty || double.tryParse(amount) == null) {
              Get.snackbar("Error", "Enter a valid amount",
                  backgroundColor: Colors.red.withOpacity(0.8),
                  colorText: Colors.white);
              return;
            }
            showPaymentBottomSheet(amount);
          },
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.green,
      disabledBackgroundColor: Colors.green.withOpacity(0.6), // faded look
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    child: isSubmitting
        ? const SizedBox(
            height: 22, // smaller loader
            width: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: Colors.white,
            ),
          )
        : const Text(
            "Pay Now",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
  ),
),

          ],
        ),
      ),
    );
  }
}
