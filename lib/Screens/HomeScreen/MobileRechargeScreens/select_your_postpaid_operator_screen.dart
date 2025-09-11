import 'package:digitalwalletpaytmcloneapp/Constants/colors.dart';
import 'package:digitalwalletpaytmcloneapp/Constants/images.dart';
import 'package:digitalwalletpaytmcloneapp/Screens/HomeScreen/MobileRechargeScreens/select_your_circle_screen.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_text_widget.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/lists_view.dart';
import 'package:digitalwalletpaytmcloneapp/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SelectYourPostpaidOperatorScreen2 extends StatelessWidget {
  SelectYourPostpaidOperatorScreen2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ✅ Phone number le lo Get.arguments se
    final args = Get.arguments ?? {};
    final String? phone = args["phone"];

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
          Padding(
            padding: EdgeInsets.only(right: 25),
            child: SvgPicture.asset(Images.information),
          ),
        ],
      ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),

              // 🔹 Yaha Phone Number Show Kar diya
              if (phone != null && phone.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 22),
                  child: CommonTextWidget.InterSemiBold(
                    text: "Phone Number: $phone",
                    fontSize: 18,
                    color: Colors.green,
                  ),
                ),

              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 22),
                child: CommonTextWidget.InterBold(
                  text: "Select your Prepaid Operator",
                  fontSize: 22,
                  color: black171,
                ),
              ),
              SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: Lists.selectYourPostpaidOperator2List.length,
                padding: EdgeInsets.symmetric(horizontal: 22),
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: InkWell(
                    onTap: () {
                      // ✅ Next page me bhi phone forward ho jayega
                      Get.to(() => SelectYourCircleScreen(), arguments: {
                        "operator": Lists.selectYourPostpaidOperator2List[index]["text"],
                        "phone": phone,
                      });
                    },
                    child: Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        border: Border.all(color: greyE5E, width: 1),
                        borderRadius: BorderRadius.circular(16),
                        color: white,
                      ),
                      child: ListTile(
                        leading: Image.asset(
                          Lists.selectYourPostpaidOperator2List[index]["image"],
                          height: 45,
                          width: 45,
                        ),
                        title: CommonTextWidget.InterSemiBold(
                          text: Lists.selectYourPostpaidOperator2List[index]["text"],
                          fontSize: 16,
                          color: black171,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  width: Get.width,
                  color: greyF3F,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: Center(
                      child: CommonTextWidget.InterSemiBold(
                        text: "I am a Postpaid User",
                        fontSize: 16,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
