import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:digitalwalletpaytmcloneapp/Service/Api.dart';
import 'package:intl/intl.dart';
import 'dart:async';
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key, required this.beneficiary}) : super(key: key);

  final Map<String, dynamic> beneficiary;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool isSubmitting = false;
  final Map<String, dynamic> beneficiary = {
    "name": "Laalu",
    "account_no": "123456789012",
    "ifsc": "SBIN0001234",
    "mobile_no": "8708261224",
    "customer_mobile_no": "9876543210",
    "BENEFICIARYID": "BEN123456"
  };

 final List<Map<String, dynamic>> messages = [];



Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Call immediately when screen opens
    checkAndFetchTransactions();

    // Schedule every 1 minute
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) {
        checkAndFetchTransactions();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // cancel the timer when screen is closed
    super.dispose();
  }

  final TextEditingController _amountController = TextEditingController();
 final TextEditingController amountController = TextEditingController();

 String maskAccount(String? acc) {
    if (acc == null || acc.length < 7) return acc ?? "";
    return "${'*' * 7}${acc.substring(7)}";
  }
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


   Future<void> checkAndFetchTransactions() async {
    try {
      // Call backend to update transaction status
      final checkResponse = await ApiService.get("/check-transactions");
      print("ita worked");
      if (checkResponse.data['success'] == true) {
        print("Checked pending transactions successfully.");
      }

      // Fetch transactions for the current beneficiary
      await fetchTransactions();
    } catch (e) {
      print("Error checking and fetching transactions: $e");
    }
  }

Future<void> fetchTransactions() async {
  final b = widget.beneficiary;
  try {
    final response = await ApiService.get("/get-transactions");
    final data = response.data;
    print(data);

    if (data['success'] == true) {
      setState(() {
        messages.clear();
        for (var tx in data['transactions']) {
          // ✅ Check if account number matches
          print("Comparing ${tx['accountNo']} with ${b['account_no']}");
          if (tx['accountNo'] == b['account_no']) {
            messages.add({
              "amount": tx['amount'],
              "type": "sent",
              "status": tx['status'] ?? "Pending",
              "timestamp": tx['createdAt'],
              "accountNo": tx['account_no'], // keep it for reference
            });
          }
        }
      });
    }
  } catch (e) {
    print("Error fetching transactions: $e");
  }
}


  void _sendPayment() {
    if (_amountController.text.isEmpty) return;

    final int amount = int.parse(_amountController.text);

    setState(() {
      messages.add({
        "amount": amount,
        "type": "sent",
        "status": "Sent to Bank A/c",
        "timestamp": "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year} • ${TimeOfDay.now().format(context)}",
      });
    });

    _amountController.clear();
  }

  String formatTimestamp(String rawDate) {
  try {
    DateTime date = DateTime.parse(rawDate); // e.g. "2025-01-05T17:55:00Z"
    return DateFormat("dd MMM yyyy • h:mm a").format(date);
  } catch (e) {
    return rawDate; // fallback if parse fails
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.green,
        elevation: 1,
        title: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                   widget.beneficiary['name'] ?? "Unknown",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                Text(
                   "+91 ${widget.beneficiary['mobile_no'] ?? ''}",
                  style: TextStyle(color: Colors.grey[300], fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final m = messages[index];
                final isSent = m['type'] == 'sent';

              return Align(
  alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
  child: Container(
    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
    padding: const EdgeInsets.all(20), // increased padding
    constraints: BoxConstraints(
      maxWidth: MediaQuery.of(context).size.width * 0.85, // wider
    ),
    decoration: BoxDecoration(
      color: isSent ? Colors.lightBlue[50] : Colors.white,
      borderRadius: BorderRadius.circular(20), // bigger curve
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
        // Amount
        Text(
          "₹${m['amount']}",
          style: const TextStyle(
            fontSize: 26, // bigger
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),

        // Status
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              m['status'].toString().toLowerCase().contains("received")
                  ? Icons.check_circle
                  : Icons.pending,
              color: m['status'].toString().toLowerCase().contains("received")
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

        // Timestamp
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

          // Input + Button
         Container(
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
      ),
      const SizedBox(width: 12),
      ElevatedButton.icon(
        onPressed: isSubmitting
            ? null // 🔒 disable button during submission
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
        icon: isSubmitting
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.currency_rupee, color: Colors.white),
        label: isSubmitting
            ? const Text(
                "Processing...",
                style: TextStyle(color: Colors.white),
              )
            : const Text(
                "Pay",
                style: TextStyle(color: Colors.white),
              ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          disabledBackgroundColor: Colors.green.withOpacity(0.6),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
    );
  }
}
