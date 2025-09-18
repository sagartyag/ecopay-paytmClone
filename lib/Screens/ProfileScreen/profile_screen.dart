import 'package:digitalwalletpaytmcloneapp/Constants/colors.dart';
import 'package:digitalwalletpaytmcloneapp/Constants/images.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_text_widget.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_textfeild_widget.dart';
import 'package:digitalwalletpaytmcloneapp/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:digitalwalletpaytmcloneapp/Service/Api.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String userName = "Loading...";
  String userEmail = "Loading...";
  String userid = "Loading...";

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  void fetchUserProfile() async {
  try {
    final response = await ApiService.get("/profile");
    print("Response: $response");

    final resData = response.data;

    if (resData["success"] == true && resData["data"] != null) {
      final userData = resData["data"];

      setState(() {
        userName = userData["name"] ?? "Guest User";
        userEmail = userData["email"] ?? "No Email";
        userid = userData["username"] ?? "No userid";
      });
    } else {
      // Agar success false ho
      setState(() {
        userName = "Guest User";
        userEmail = "No Email";
        userid = "No userid";
      });
    }
  } catch (e) {
    print("Error fetching user profile: $e");
    setState(() {
      userName = "Guest User";
      userEmail = "No Email";
      userid = "No userid";
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
          text: "Profile",
          fontSize: 18,
          color: black171,
        ),
      ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Center(
                  child: Image.asset(Images.profileImage, height: 100, width: 100),
                ),
                SizedBox(height: 20),

                // Name Field
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: CommonTextWidget.InterMedium(
                    text: "Name",
                    fontSize: 14,
                    color: black171,
                  ),
                ),
                SizedBox(height: 10),
                CommonTextFieldWidget.TextFormField3(
                  controller: nameController,
                  hintText: userName,
                  keyboardType: TextInputType.name,
                ),
                SizedBox(height: 20),

                // Email Field
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: CommonTextWidget.InterMedium(
                    text: "Email Address",
                    fontSize: 14,
                    color: black171,
                  ),
                ),
                SizedBox(height: 10),
                CommonTextFieldWidget.TextFormField3(
                  controller: emailController,
                  hintText: userEmail,
                  keyboardType: TextInputType.emailAddress,
                  suffixIcon: Padding(
                    padding: EdgeInsets.all(15),
                    child: CommonTextWidget.InterMedium(
                      text: "",
                      fontSize: 14,
                      color: Colors.green,
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Phone Field
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: CommonTextWidget.InterMedium(
                    text: "User Id",
                    fontSize: 14,
                    color: black171,
                  ),
                ),
                SizedBox(height: 10),
                CommonTextFieldWidget.TextFormField3(
                  controller: phoneController,
                  hintText: userid,
                  keyboardType: TextInputType.number,
                  suffixIcon: Padding(
                    padding: EdgeInsets.all(15),
                    child: CommonTextWidget.InterMedium(
                      text: "",
                      fontSize: 14,
                      color: Colors.green,
                    ),
                  ),
                ),
                SizedBox(height: 40),

                // // Payment Section
                // CommonTextWidget.InterBold(
                //   text: "Payment Accounts Status",
                //   fontSize: 18,
                //   color: black171,
                // ),
                SizedBox(height: 20),
                // ListTile(
                //   contentPadding: EdgeInsets.zero,
                //   horizontalTitleGap: 8,
                //   leading: SvgPicture.asset(Images.digiWallet, color: Colors.green),
                //   title: CommonTextWidget.InterBold(
                //     text: "DigiWallet",
                //     fontSize: 14,
                //     color: black171,
                //   ),
                //   // subtitle: CommonTextWidget.InterRegular(
                //   //   text: "₹1,00,0000 Monthly Limit",
                //   //   fontSize: 12,
                //   //   color: grey757,
                //   // ),
                //   // trailing: CommonTextWidget.InterMedium(
                //   //   text: "Activate Now",
                //   //   fontSize: 14,
                //   //   color: Colors.green,
                //   // ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
