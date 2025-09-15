import 'package:digitalwalletpaytmcloneapp/Constants/colors.dart';
import 'package:digitalwalletpaytmcloneapp/Constants/images.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_text_widget.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/lists_view.dart';
import 'package:digitalwalletpaytmcloneapp/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:digitalwalletpaytmcloneapp/Service/Api.dart';
import 'package:digitalwalletpaytmcloneapp/Screens/HomeScreen/MunicipalTax/municipal_screen.dart';


class BalanceAndHistoryScreen extends StatefulWidget {
  const BalanceAndHistoryScreen({Key? key}) : super(key: key);

  @override
  State<BalanceAndHistoryScreen> createState() => _BalanceAndHistoryScreenState();
}

class _BalanceAndHistoryScreenState extends State<BalanceAndHistoryScreen> {
  double totalBalance = 0.0; // API se aane wala balance
  bool isLoading = true;
  List<dynamic> transactionHistoryList = []; // ✅ API se aane wala data

  @override
  void initState() {
    super.initState();
    fetchBalance();
    fetchTransactionHistory(); // ✅ Screen open hote hi call hoga

  }

  /// 🔹 API call to get balance
  void fetchBalance() async {
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

void fetchTransactionHistory() async {
  try {
    final response = await ApiService.get("/transaction-history");
    print("Transaction History Response: ${response.data}");

    final data = response.data;
    setState(() {
      transactionHistoryList = data["transactions"] ?? [];
      isLoading = false;
    });
  } catch (e) {
    print("Error fetching transaction history: $e");
    setState(() => isLoading = false);
  }
}

Widget _buildActionButton(IconData icon, String label) {
  return Column(
    children: [
      CircleAvatar(
        radius: 28,
        backgroundColor: Colors.green, // 🔹 Circle green
        child: Icon(icon, size: 28, color: Colors.white), // 🔹 Icon white
      ),
      SizedBox(height: 8),
      Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.black, // 🔹 Text black
        ),
      ),
    ],
  );
}

 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: white,
    appBar: AppBar(
      backgroundColor: white,
      centerTitle: true,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: InkWell(
        onTap: () {
          Get.back();
        },
        child: Icon(Icons.arrow_back, size: 20, color: black171),
      ),
    ),
    body: Padding(
      padding: EdgeInsets.symmetric(horizontal: 22),
      child: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 1),
              CommonTextWidget.InterBold(
                text: "Account Balance & History",
                fontSize: 20,
                color: black171,
              ),
              SizedBox(height: 25),

              // 🔹 Total Balance Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.green,
                    width: 1,
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Total Balance",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      isLoading
                          ? "Loading..."
                          : "₹${totalBalance.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildActionButton(Icons.arrow_downward, "Withdraw"),
                        _buildActionButton(Icons.send, "Transfer"),
                        _buildActionButton(Icons.add_circle, "Top Up"),
                        _buildActionButton(Icons.account_balance, "Deposit"),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // 🔹 Modern Banner Section
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF3D9642), Color(0xFF2E6B31)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Explore your financial report",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.4,
                            ),
                          ),
                          Text(
                            "and see the highlights!",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Colors.white70,
                              height: 1.4,
                            ),
                          ),
                          SizedBox(height: 12),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "Learn More",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3D9642),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 55,
                      width: 55,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Image.asset(
                          Images.appIcon,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonTextWidget.InterBold(
                    text: "Transaction",
                    fontSize: 17,
                    color: grey757,
                  ),
                  SvgPicture.asset(Images.search),
                ],
              ),

              SizedBox(height: 20),

              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: transactionHistoryList.length,
                      itemBuilder: (context, index) {
                        final tx = transactionHistoryList[index];
                        return InkWell(
                          onTap: () {
                            Get.to(() =>
                                TransactionDetailScreen(transaction: tx));
                          },
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.account_balance_wallet,
                                        color: Colors.green, size: 40),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CommonTextWidget.InterBold(
                                          text: tx["remark"] ?? "No Remark",
                                          fontSize: 15,
                                          color: black171,
                                        ),
                                        SizedBox(height: 2),
                                        CommonTextWidget.InterMedium(
                                          text: tx["ttime"] ?? "",
                                          fontSize: 12,
                                          color: grey757,
                                        ),
                                        SizedBox(height: 2),
                                        Row(
                                          children: [
                                            CommonTextWidget.InterMedium(
                                              text:
                                                  " ${tx["status"] ?? "Pending"}",
                                              fontSize: 12,
                                              color: grey757,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: CommonTextWidget.InterBold(
                                          text: "-₹${tx["amount"] ?? 0}",
                                          fontSize: 14,
                                          color: tx["status"] == "Success"
                                              ? green2CA
                                              : redE50,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Divider(color: greyF3F, thickness: 1),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    ),
  );
}
}