import 'package:digitalwalletpaytmcloneapp/Constants/colors.dart';
import 'package:digitalwalletpaytmcloneapp/Constants/images.dart';
import 'package:digitalwalletpaytmcloneapp/Screens/ChatScreens/chat_screen1.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_text_widget.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/lists_view.dart';
import 'package:digitalwalletpaytmcloneapp/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:digitalwalletpaytmcloneapp/Service/Api.dart';
import 'package:digitalwalletpaytmcloneapp/Screens/HomeScreen/MunicipalTax/municipal_screen.dart';

class ToBankAccountScreen extends StatefulWidget {
  ToBankAccountScreen({Key? key}) : super(key: key);

  
  @override
  State<ToBankAccountScreen> createState() => _ToBankAccountScreenState();
}

class _ToBankAccountScreenState extends State<ToBankAccountScreen> {
    double totalBalance = 0.0; // API se aane wala balance
  bool isLoading = true;
  List<dynamic> transactionHistoryList = []; // ✅ API se aane wala data
 @override
  void initState() {
    super.initState();
    fetchTransactionHistory(); // ✅ Screen open hote hi call hoga

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
String formatTimestamp(String rawDate) {
    try {
      DateTime date = DateTime.parse(rawDate);
      return DateFormat("dd MMM yyyy • h:mm a").format(date);
    } catch (e) {
      return rawDate;
    }
  }
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
        actions: [
        SvgPicture.asset(Images.information, color: Colors.green,),
          SizedBox(width: 15),
          Padding(
            padding: EdgeInsets.only(right: 25),
            child:SvgPicture.asset(Images.setting, color: Colors.green,),
          ),
        ],
      ),
     body: Padding(
  padding: EdgeInsets.symmetric(horizontal: 22),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 20),
      CommonTextWidget.InterBold(
        text: "Money transfer to Bank a/c",
        fontSize: 22,
        color: black171,
      ),
      SizedBox(height: 25),

      /// ✅ GridView ko scroll na hone do
      ScrollConfiguration(
        behavior: MyBehavior(),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: MediaQuery.of(context).size.aspectRatio * 4 / 0.8,
                // MediaQuery.of(context).size.aspectRatio * 2 / 0.8,
          ),
          shrinkWrap: true,
          primary: false,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: Lists.toBankAccountList.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: Lists.toBankAccountList[index]["onTap"],
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: white,
                  border: Border.all(color: greyE5E, width: 1),
                ),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset(
                        Lists.toBankAccountList[index]["image"],
                        color: Colors.green,
                      ),
                      SizedBox(height: 9),
                      CommonTextWidget.InterSemiBold(
                        color: black171,
                        text: Lists.toBankAccountList[index]["text1"],
                        fontSize: 14,
                      ),
                      SizedBox(height: 3),
                      CommonTextWidget.InterMedium(
                        color: grey757,
                        text: Lists.toBankAccountList[index]["text2"],
                        fontSize: 10,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),

      SizedBox(height: 25),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CommonTextWidget.InterBold(
            text: "Transaction",
            fontSize: 17,
            color: grey757,
          ),
          // SvgPicture.asset(Images.search),
        ],
      ),
      SizedBox(height: 10),

      /// ✅ Sirf history scrollable banayi
      Expanded(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: EdgeInsets.zero,
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
                                           Container(
  padding: EdgeInsets.all(8),
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    color: Colors.green.withOpacity(0.1),
    border: Border.all(color: Colors.green, width: 1),
  ),
  child: Icon(
    Icons.south_west,
    color: Colors.green,
    size: 24,
  ),
),
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
                                    text: formatTimestamp(tx["ttime"]),
                                    fontSize: 12,
                                    color: grey757,
                                  ),
                                  SizedBox(height: 2),
                                  Row(
                                    children: [
                                      CommonTextWidget.InterMedium(
                                        text: " ${tx["status"] ?? "Pending"}",
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
      ),
    ],
  ),
),

    );
  }
}
