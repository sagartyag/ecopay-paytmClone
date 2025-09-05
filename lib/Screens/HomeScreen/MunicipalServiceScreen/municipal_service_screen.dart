import 'package:digitalwalletpaytmcloneapp/Constants/colors.dart';
import 'package:digitalwalletpaytmcloneapp/Constants/images.dart';
import 'package:digitalwalletpaytmcloneapp/Controllers/dth_recharge_controller.dart';
// import 'package:digitalwalletpaytmcloneapp/Screens/HomeScreen/DthRechargeScreen/cabletv_listview_screen.dart';
import 'package:digitalwalletpaytmcloneapp/Screens/HomeScreen/Landline/landline_list_view.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import'municipal_list_view.dart';
class MunicipalServiceScreen extends StatelessWidget {
  MunicipalServiceScreen({Key? key}) : super(key: key);

  final DthRechargeTabController dthRechargeTabController =
      Get.put(DthRechargeTabController());

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
        title: CommonTextWidget.InterSemiBold(
          text: "Municipal Services",
          fontSize: 18,
          color: black171,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 25),
            child:SvgPicture.asset(Images.information, color: Colors.green,),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 25),

// 🔍 Search Box
Container(
  height: 45,
  width: Get.width,
  padding: EdgeInsets.symmetric(horizontal: 12),
  decoration: BoxDecoration(
    color: greyF1F,
    borderRadius: BorderRadius.circular(25),
  ),
  child: Row(
    children: [
      Icon(Icons.search, color: black171, size: 20),
      SizedBox(width: 10),
      Expanded(
        child: TextField(
          style: TextStyle(
            color: black171,
            fontSize: 16,
            fontFamily: "InterRegular",
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Search Landline Operators",
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          onChanged: (value) {
            // 👇 Yaha aap search filter logic laga sakte ho
            print("Searching: $value");
          },
        ),
      ),
    ],
  ),
),

            SizedBox(height: 25),
            CommonTextWidget.InterBold(
              text: "Top Landline Operators",
              fontSize: 20,
              color: black171,
            ),
            SizedBox(height: 18),
            Expanded(
              child: TabBarView(
                controller: dthRechargeTabController.controller,
                children: [
                  MunicipalListviewScreen(),
                  // CableTvListviewScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
