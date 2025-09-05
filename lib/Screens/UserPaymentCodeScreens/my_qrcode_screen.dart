import 'package:digitalwalletpaytmcloneapp/Constants/colors.dart';
import 'package:digitalwalletpaytmcloneapp/Constants/images.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:digitalwalletpaytmcloneapp/Service/Api.dart';
import 'package:digitalwalletpaytmcloneapp/Constants/font_family.dart';


class MyQrCodeScreen extends StatefulWidget {
  const MyQrCodeScreen({Key? key}) : super(key: key);

  @override
  State<MyQrCodeScreen> createState() => _MyQrCodeScreenState();
}

class _MyQrCodeScreenState extends State<MyQrCodeScreen> {
  String userName = "Loading...";
  String userEmail = "Loading...";
  String userId = "Loading...";

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

void fetchUserProfile() async {
  try {
    final response = await ApiService.get("/profile");
    print("Response: $response");

    final data = response.data;

    if (data["success"] == true) {
      final user = data["data"]; // yaha user ka object aayega

      setState(() {
        userName = user["name"] ?? "Guest User";
        userEmail = user["email"] ?? "No Email";
        userId = user["username"] ?? "No userId";
      });
    } else {
      // agar success false hoga
      setState(() {
        userName = "Guest User";
        userEmail = "No Email";
        userId = "No userId";
      });
    }
  } catch (e) {
    print("Error fetching user profile: $e");
    setState(() {
      userName = "Guest User";
      userEmail = "No Email";
      userId = "No userId";
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteFBF,
      appBar: AppBar(
        backgroundColor: whiteFBF,
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
          text: "My QR Code",
          fontSize: 18,
          color: black171,
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            CommonTextWidget.InterSemiBold(
              color: black171,
              text: userName, // ✅ API se aaya hua user name
              fontSize: 26,
            ),
            SizedBox(height: 4),
            CommonTextWidget.InterRegular(
              color: black171,
              text: "Email: $userEmail", // ✅ API se aaya hua email
              fontSize: 12,
            ),
            SizedBox(height: 6),
            CommonTextWidget.InterRegular(
              color: black171,
              text: "UserId: $userId", // ✅ API se aaya hua userId
              fontSize: 12,
            ),
            SizedBox(height: 50),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 35),
              child: Container(
                width: Get.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: white,
                  boxShadow: [
                    BoxShadow(
                      color: grey6B7.withOpacity(0.06),
                      offset: Offset(0, 15),
                      blurRadius: 25,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 30, bottom: 35),
                      child: Image.asset(Images.userQrCodeImage),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text:
                              "Anyone can scan this QR or send money to you on 1234567890. you will receive money in your  ",
                          style: TextStyle(
                            fontFamily: FontFamily.InterRegular,
                            fontSize: 11,
                            color: grey757,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: "default bank account ",
                              style: TextStyle(
                                  fontSize: 11,
                                  fontFamily: FontFamily.InterRegular,
                                  color: Colors.green),
                            ),
                            TextSpan(
                              text: "(Bank of Baroda - 3137)",
                              style: TextStyle(
                                  fontSize: 11,
                                  fontFamily: FontFamily.InterRegular,
                                  color: grey757),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 35),
                  ],
                ),
              ),
            ),
            SizedBox(height: 50),
            Container(
              height: 40,
              width: 130,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.share,color: white),
                    SizedBox(width: 8),
                    CommonTextWidget.InterMedium(
                      color: white,
                      text: "Share QR",
                      fontSize: 14,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
