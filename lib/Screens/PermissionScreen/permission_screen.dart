import 'package:digitalwalletpaytmcloneapp/Constants/colors.dart';
import 'package:digitalwalletpaytmcloneapp/Constants/images.dart';
import 'package:digitalwalletpaytmcloneapp/Screens/SendSmsScreen/send_sms_screen.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_button_widget.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_text_widget.dart';
import 'package:digitalwalletpaytmcloneapp/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class PermissionScreen extends StatelessWidget {
  PermissionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 225),
      child: Column(
        children: [
          Container(
            height: 6,
            width: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: white,
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: Container(
              height: Get.height,
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40),
                  topLeft: Radius.circular(40),
                ),
                color: white,
              ),
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding:
                                EdgeInsets.only(top: 25, right: 25, bottom: 8),
                            child: CommonTextWidget.InterBold(
                              color: black171,
                              text: "Cancel",
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    SvgPicture.asset(Images.permissionUserImage),
                      SizedBox(height: 28),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 52),
                        child: CommonTextWidget.InterSemiBold(
                          color: black171,
                          text: "We need some permissions: "
                              "Phone State, SMS and "
                              "Location",
                          fontSize: 20,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 26),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 52),
                        child: CommonTextWidget.InterRegular(
                          color: grey757,
                          text: "Phone State includes your Phone number, SIM "
                              "Serial Number and carrier information. This is "
                              "used for a secure login experience to ensure "
                              "your Paytm account can only be accessed by "
                              "you.",
                          fontSize: 14,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 52),
                        child: CommonTextWidget.InterRegular(
                          color: grey757,
                          text: "Location and SMS may also be used to give "
                              "you a richer experience through bill reminders, "
                              "deals, and recommen",
                          fontSize: 14,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 40, bottom: 25, left: 25, right: 25),
                        child: CommonButtonWidget.button(
                          text: "Proceed Securely",
                          buttonColor: Colors.green,
                          onTap: () {
                            Get.bottomSheet(
                              SendSmsScreen(),
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
