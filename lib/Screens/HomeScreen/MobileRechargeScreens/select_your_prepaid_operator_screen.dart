import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:digitalwalletpaytmcloneapp/Service/Api.dart';
import 'package:digitalwalletpaytmcloneapp/Constants/colors.dart';
import 'package:digitalwalletpaytmcloneapp/Constants/images.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_text_widget.dart';
import 'prepaid_operator_payment_screen.dart';
import 'select_your_postpaid_operator_screen.dart';
import 'select_your_circle_screen.dart';
class SelectYourPrepaidOperatorScreen extends StatefulWidget {
  const SelectYourPrepaidOperatorScreen({Key? key}) : super(key: key);

  @override
  State<SelectYourPrepaidOperatorScreen> createState() =>
      _SelectYourPrepaidOperatorScreenState();
}

class _SelectYourPrepaidOperatorScreenState
    extends State<SelectYourPrepaidOperatorScreen> {
  bool isLoading = true;
  List<dynamic> prepaidOperators = [];

  @override
  void initState() {
    super.initState();
    fetchOperators();
  }

  Future<void> fetchOperators() async {
    try {
      final response = await ApiService.get("/get-operators");
      final data = response.data;

      List<dynamic> operatorsList = [];

      if (data['success'] == true && data['services'] != null) {
        for (var service in data['services']) {
          if (service['serviceType']
              .toString()
              .toLowerCase()
              .contains("prepaid")) {
            operatorsList.addAll(service['operators']);
          }
        }
      }

      setState(() {
        prepaidOperators = operatorsList;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Get.snackbar("Error", "Failed to fetch operators");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back, size: 20, color: Colors.black),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 25),
            child: SvgPicture.asset(Images.information),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.green))
          : prepaidOperators.isEmpty
              ? Center(child: Text("No prepaid operators found"))
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 22, vertical: 20),
                  itemCount: prepaidOperators.length,
                  itemBuilder: (context, index) {
                    final operator = prepaidOperators[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: InkWell(
                        onTap: () {
                          // Pass operator to payment screen
                          Get.to(() => SelectYourCircleScreen());
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey.shade300, width: 1),
                            borderRadius: BorderRadius.circular(16),
                            color: white,
                          ),
                          child: ListTile(
                            leading: Icon(Icons.sim_card,
                                size: 45, color: Colors.green),
                            title: CommonTextWidget.InterSemiBold(
                              text: operator['name'] ?? "",
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
      // bottomNavigationBar: InkWell(
      //   onTap: () {
      //     Get.to(() => SelectYourPostpaidOperatorScreen2());
      //   },
      //   child: Container(
      //     color: Colors.grey.shade200,
      //     padding: EdgeInsets.symmetric(vertical: 12),
      //     child: Center(
      //       child: Text(
      //         "I am a Postpaid User",
      //         style: TextStyle(fontSize: 16, color: Colors.green),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
