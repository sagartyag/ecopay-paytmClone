// ignore_for_file: file_names

import 'package:digitalwalletpaytmcloneapp/Constants/colors.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_text_widget.dart';
import 'package:digitalwalletpaytmcloneapp/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  TermsAndConditionsScreen({Key? key}) : super(key: key);

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
          text: "Terms & Conditions",
          fontSize: 18,
          color: black171,
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
                SizedBox(height: 25),
                CommonTextWidget.InterSemiBold(
                  text: "1 . Terms",
                  fontSize: 18,
                  color: black171,
                ),
                SizedBox(height: 7),
                CommonTextWidget.InterRegular(
                  text: "Lorem Ipsum is simply dummy text of the printing "
                      "and typesetting industry. Lorem Ipsum has been the "
                      "indu stry's standard dummy text ever since the "
                      "1500s, whe an unknown printer took a galley of type "
                      "and sc rambled it to make a type",
                  fontSize: 13,
                  color: grey6A7,
                ),
                SizedBox(height: 15),
                CommonTextWidget.InterSemiBold(
                  text: "2 . User Account",
                  fontSize: 18,
                  color: black171,
                ),
                SizedBox(height: 7),
                CommonTextWidget.InterRegular(
                  text: "Lorem Ipsum is simply dummy text of the printing "
                      "and typesetting industry. Lorem Ipsum has been the "
                      "indu stry's standard dummy text ever since the "
                      "1500s, whe an unknown printer took a galley of type "
                      "and sc rambled it to make a type",
                  fontSize: 13,
                  color: grey6A7,
                ),
                SizedBox(height: 15),
                CommonTextWidget.InterSemiBold(
                  text: "3 . Your Content",
                  fontSize: 18,
                  color: black171,
                ),
                SizedBox(height: 7),
                CommonTextWidget.InterRegular(
                  text: "Lorem Ipsum is simply dummy text of the printing "
                      "and typesetting industry. Lorem Ipsum has been the "
                      "indu stry's standard dummy text ever since the "
                      "1500s, whe an unknown printer took a galley of type "
                      "and sc rambled it to make a type",
                  fontSize: 13,
                  color: grey6A7,
                ),
                SizedBox(height: 15),
                CommonTextWidget.InterSemiBold(
                  text: "4. Using Our Site",
                  fontSize: 18,
                  color: black171,
                ),
                SizedBox(height: 7),
                CommonTextWidget.InterRegular(
                  text: "Lorem Ipsum is simply dummy text of the printing "
                  "and typesetting industry.",
                  fontSize: 13,
                  color: grey6A7,
                ),
                SizedBox(height: 15),
                CommonTextWidget.InterSemiBold(
                  text: "5 . Use License",
                  fontSize: 18,
                  color: black171,
                ),
                SizedBox(height: 7),
                CommonTextWidget.InterRegular(
                  text: "Lorem Ipsum is simply dummy text of the printing "
                      "and typesetting industry. Lorem Ipsum has been the "
                      "indu stry's standard dummy text ever since the "
                      "1500s, whe an unknown printer took a galley of type "
                      "and sc rambled it to make a type",
                  fontSize: 13,
                  color: grey6A7,
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
