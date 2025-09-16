import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionDetailScreen extends StatelessWidget {
  final Map<String, dynamic> transaction;

  const TransactionDetailScreen({Key? key, required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final remark = transaction['remark'] ?? "No Remark";
    final amount = transaction['amount']?.toString() ?? "0";
    final txnId = transaction['api_trans_id'] ?? "---";
    final status = transaction['status'] ?? "Pending";
    final phone = transaction['phone'] ?? "N/A";
    final orderId = transaction['orderId'] ?? "N/A";
    final accountNo = transaction['accountNo'] ?? "N/A";

    // ✅ Check if this is a Bank Transfer transaction
    final isBankTransfer = remark == "Bank Transfer";

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Column(
          children: [
            /// 🔹 Gradient AppBar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade700, Colors.green.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    child: const Icon(Icons.arrow_back,
                        color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Transaction Details",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green.shade50, Colors.white],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(color: Colors.green.shade100),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /// 🔹 Amount + Icon
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.green.shade100,
                        child: const Icon(Icons.account_balance_wallet,
                            color: Colors.green, size: 36),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "₹$amount",
                        style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        remark,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 16),
                      const Divider(thickness: 1),

                      /// 🔹 Details List (conditionally show OrderId/AccountNo)
                      if (isBankTransfer)
                        _buildDetailRow("Order ID", orderId)
                      else
                        _buildDetailRow("Mobile", phone),

                      if (isBankTransfer)
                        _buildDetailRow("Account No", accountNo, selectable: true)
                      else
                        _buildDetailRow("Transaction ID", txnId,
                            selectable: true),

                      _buildStatusRow(status),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Reusable Row Widget
  Widget _buildDetailRow(String label, String value, {bool selectable = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500)),
          selectable
              ? SelectableText(value,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87))
              : Text(value,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87)),
        ],
      ),
    );
  }

  /// 🔹 Status Badge
  Widget _buildStatusRow(String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Status:",
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: status == "Success"
                  ? Colors.green.shade100
                  : Colors.red.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: status == "Success"
                    ? Colors.green.shade800
                    : Colors.red.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
