import 'package:digitalwalletpaytmcloneapp/Constants/colors.dart';
import 'package:digitalwalletpaytmcloneapp/Constants/images.dart';
import 'package:digitalwalletpaytmcloneapp/Screens/UserPaymentCodeScreens/my_qrcode_screen.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_text_widget.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/lists_view.dart';
import 'package:digitalwalletpaytmcloneapp/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:digitalwalletpaytmcloneapp/Service/Api.dart';
import 'package:digitalwalletpaytmcloneapp/Screens/AuthScreens/login_screen.dart';

class UserPaymentCodeScreen extends StatefulWidget {
  const UserPaymentCodeScreen({Key? key}) : super(key: key);

  @override
  State<UserPaymentCodeScreen> createState() => _UserPaymentCodeScreenState();
}

class _UserPaymentCodeScreenState extends State<UserPaymentCodeScreen> {
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


  Future<void> _confirmLogout(BuildContext context) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap a button
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Text(
          "Are you sure you want to logout?",
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[300],
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              minimumSize: Size(100, 40),
            ),
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              minimumSize: Size(100, 40),
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text("Logout"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ApiService.removeToken(); // Remove saved token
      Get.offAll(() => LogInScreen()); // Navigate to login screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyEDE,
      appBar: AppBar(
        backgroundColor: greyEDE,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back, size: 20, color: black171),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 25, right: 25, bottom: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonTextWidget.InterSemiBold(
                      color: black171,
                      text: "$userName",
                      fontSize: 26,
                    ),
                    SizedBox(height: 4),
                    CommonTextWidget.InterRegular(
                      color: black171,
                      text: "Email: $userEmail",
                      fontSize: 12,
                    ),
                    SizedBox(height: 6),
                    CommonTextWidget.InterRegular(
                      color: black171,
                      text: "userId: $userId",
                      fontSize: 12,
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    Get.to(() => MyQrCodeScreen());
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: white,
                      boxShadow: [
                        BoxShadow(
                          color: grey6B7.withOpacity(0.15),
                          offset: Offset(0, 0),
                          blurRadius: 25,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Image.asset(Images.userQrCodeImage),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              height: Get.height,
              width: Get.width,
              decoration: BoxDecoration(
                color: whiteFBF,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(28),
                  topLeft: Radius.circular(28),
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: MyBehavior(),
                      child: ListView.builder(
                        padding: EdgeInsets.only(top: 25, left: 25, right: 25),
                        itemCount: Lists.userQrCodeList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) => Padding(
                          padding: EdgeInsets.only(bottom: 14),
                          child: InkWell(
                            onTap: Lists.userQrCodeList[index]["onTap"],
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: SvgPicture.asset(
                                Lists.userQrCodeList[index]["image"],
                                color: Colors.green,
                              ),
                              title: CommonTextWidget.InterBold(
                                color: black171,
                                text: Lists.userQrCodeList[index]["text1"],
                                fontSize: 14,
                              ),
                              subtitle: CommonTextWidget.InterRegular(
                                color: grey757,
                                text: Lists.userQrCodeList[index]["text2"],
                                fontSize: 12,
                              ),
                              trailing: Icon(Icons.arrow_forward_ios,
                                  color: grey757, size: 18),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 25, left: 25, right: 25),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () => _confirmLogout(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "Logout",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        CommonTextWidget.InterRegular(
                          color: greyA6A,
                          text: "V 1.1.0",
                          fontSize: 12,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
