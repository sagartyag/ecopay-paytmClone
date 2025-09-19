import 'package:digitalwalletpaytmcloneapp/Constants/colors.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_text_widget.dart';
import 'package:digitalwalletpaytmcloneapp/Service/Api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:digitalwalletpaytmcloneapp/Screens/HomeScreen/MunicipalTax/municipal_screen.dart';

class SelectBalanceScreen1 extends StatefulWidget {
  const SelectBalanceScreen1({Key? key}) : super(key: key);

  @override
  State<SelectBalanceScreen1> createState() => _SelectBalanceScreen1State();
}

class _SelectBalanceScreen1State extends State<SelectBalanceScreen1> {
  bool isLoading = true;
  bool isMoreLoading = false;
  int currentPage = 1;
  List<dynamic> transactions = [];

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchTransactionHistory();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> fetchTransactionHistory({bool loadMore = false}) async {
    if (loadMore) {
      setState(() => isMoreLoading = true);
    } else {
      setState(() => isLoading = true);
    }

    try {
      final response = await ApiService.get("/all-transaction-history?page=$currentPage&limit=10");
      final data = response.data;

      if (data['success'] == true && data['transactions'] != null) {
        setState(() {
          if (loadMore) {
            transactions.addAll(data['transactions']); // add next page data
          } else {
            transactions = data['transactions']; // first load
          }
          isLoading = false;
          isMoreLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        isMoreLoading = false;
      });
      Get.snackbar("Error", "Failed to fetch transaction history");
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (!isMoreLoading) {
        currentPage++;
        fetchTransactionHistory(loadMore: true);
      }
    }
  }
String formatDate(String dateString) {
  try {
    final date = DateTime.parse(dateString);
    return "${date.day}-${date.month}-${date.year} ${date.hour}:${date.minute}";
  } catch (e) {
    return dateString;
  }
}

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // बाकी UI Same (आपका Design as-it-is रहेगा)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: const Text("Transaction History", style: TextStyle(color: Colors.white)),
        leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Get.back()),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : ListView.builder(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: transactions.length + 1,
              itemBuilder: (context, index) {
                if (index == transactions.length) {
                  return isMoreLoading
                      ? Center(child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: CircularProgressIndicator(color: Colors.green)))
                      : SizedBox.shrink();
                }

                final txn = transactions[index];
                final isCredit = txn['status'] == "SUCCESS";

             return Container(
  margin: const EdgeInsets.only(bottom: 12),
  decoration: BoxDecoration(
    color: white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 4,
        offset: const Offset(0, 2),
      )
    ],
    border: Border.all(color: Colors.grey.shade300, width: 1),
  ),
  child: ListTile(
    onTap: () {
      // ✅ yaha se data next page me bhej rahe hai
      Get.to(() => TransactionDetailScreen(transaction: txn));
    },
    leading: CircleAvatar(
      backgroundColor:
          isCredit ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
      child: Icon(
        isCredit ? Icons.arrow_downward : Icons.arrow_upward,
        color: isCredit ? Colors.green : Colors.red,
      ),
    ),
    title: Text(
      txn['remark'] ?? "Transaction",
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
    ),
    subtitle: Text(formatDate(txn['ttime'] ?? "")),
    trailing: Text(
      "₹${txn['amount'] ?? 0}",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: isCredit ? Colors.green : Colors.red,
        fontSize: 16,
      ),
    ),
  ),
);

              },
            ),
    );
  }
}

