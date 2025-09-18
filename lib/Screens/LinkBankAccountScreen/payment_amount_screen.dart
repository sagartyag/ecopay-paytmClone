import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:digitalwalletpaytmcloneapp/Service/Api.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key, required this.beneficiary}) : super(key: key);

  final Map<String, dynamic> beneficiary;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool isSubmitting = false;
  double totalBalance = 0.0;
  bool isLoading = true;

  Timer? _timer;
  final List<Map<String, dynamic>> messages = [];
  final TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkAndFetchTransactions();
    fetchBalance();

    // Schedule balance + transaction check every 1 min
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) checkAndFetchTransactions();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
 String maskAccountNumber(String? accountNo) {
  if (accountNo == null || accountNo.length <= 7) return accountNo ?? '';
  String masked = '*' * 7; // 7 asterisks
  String lastDigits = accountNo.substring(7); // show from 8th char
  return masked + lastDigits;
}
  /// 🔹 Fetch wallet balance
  Future<void> fetchBalance() async {
    try {
      final response = await ApiService.get("/direct-income");
      final data = response.data;

      setState(() {
        if (data["success"] == true) {
          totalBalance = double.tryParse(data["balance"].toString()) ?? 0.0;
        } else {
          totalBalance = 0.0;
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        totalBalance = 0.0;
        isLoading = false;
      });
    }
  }

  /// 🔹 Payment confirmation bottom sheet
  void showPaymentBottomSheet(String amount) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
            // Balance Card
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
                        "Eco Pay Wallet",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isLoading
                            ? "Loading..."
                            : "₹${totalBalance.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Confirm Button
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

  /// 🔹 API call: Make payment
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
  "Payment successfully", // Fixed message
  backgroundColor: Colors.green.withOpacity(0.8),
  colorText: Colors.white,
);
        fetchTransactions(); // refresh history
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

  /// 🔹 Periodic check
  Future<void> checkAndFetchTransactions() async {
    try {
      await ApiService.get("/check-transactions");
      await fetchTransactions();
    } catch (e) {
      print("Error checking and fetching transactions: $e");
    }
  }

  /// 🔹 Fetch transactions for current beneficiary
  Future<void> fetchTransactions() async {
    final b = widget.beneficiary;
    try {
      final response = await ApiService.get("/get-transactions");
      final data = response.data;

      if (data['success'] == true) {
        setState(() {
          messages.clear();
          for (var tx in data['transactions']) {
            if (tx['accountNo'] == b['account_no']) {
              messages.add({
                "amount": tx['amount'],
                "type": "sent",
                "status": tx['status'] ?? "Pending",
                "timestamp": tx['createdAt'],
              });
            }
          }
        });
      }
    } catch (e) {
      print("Error fetching transactions: $e");
    }
  }

  /// 🔹 Format timestamps
  String formatTimestamp(String rawDate) {
    try {
      DateTime date = DateTime.parse(rawDate);
      return DateFormat("dd MMM yyyy • h:mm a").format(date);
    } catch (e) {
      return rawDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.green,
        elevation: 1,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.beneficiary['name'] ?? "Unknown",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            Text(
              "${maskAccountNumber(widget.beneficiary['account_no'] ?? '')}",
              style: TextStyle(color: Colors.grey[300], fontSize: 12),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          Column(
            children: [
              // 🔹 Transactions List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final m = messages[index];
                    final isSent = m['type'] == 'sent';

                    return Align(
                      alignment:
                          isSent ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 6),
                        padding: const EdgeInsets.all(20),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.85,
                        ),
                        decoration: BoxDecoration(
                          color: isSent ? Colors.lightBlue[50] : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 10,
                              offset: const Offset(2, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "₹${m['amount']}",
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  m['status']
                                          .toString()
                                          .toLowerCase()
                                          .contains("success")
                                      ? Icons.check_circle
                                      : Icons.pending,
                                  color: m['status']
                                          .toString()
                                          .toLowerCase()
                                          .contains("success")
                                      ? Colors.green
                                      : Colors.orange,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  m['status'],
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              formatTimestamp(m['timestamp']),
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // 🔹 Input + Pay Button
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Enter amount",
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: isSubmitting
                          ? null
                          : () {
                              String amount = amountController.text.trim();
                              if (amount.isEmpty ||
                                  double.tryParse(amount) == null) {
                                Get.snackbar("Error", "Enter a valid amount",
                                    backgroundColor:
                                        Colors.red.withOpacity(0.8),
                                    colorText: Colors.white);
                                return;
                              }
                              showPaymentBottomSheet(amount);
                            },
                      icon: const Icon(Icons.currency_rupee,
                          color: Colors.white),
                      label: const Text(
                        "Pay",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        disabledBackgroundColor:
                            Colors.green.withOpacity(0.6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // 🔹 Fullscreen Loader
          if (isSubmitting)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.green),
              ),
            ),
        ],
      ),
    );
  }
}
