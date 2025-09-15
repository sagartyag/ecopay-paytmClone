import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:digitalwalletpaytmcloneapp/Constants/colors.dart';
import 'package:digitalwalletpaytmcloneapp/Constants/images.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_text_widget.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_textfeild_widget.dart';
import 'package:digitalwalletpaytmcloneapp/Screens/HomeScreen/MobileRechargeScreens/select_your_prepaid_operator_screen.dart';

class MobileRechargeScreen extends StatefulWidget {
  const MobileRechargeScreen({Key? key}) : super(key: key);

  @override
  State<MobileRechargeScreen> createState() => _MobileRechargeScreenState();
}

class _MobileRechargeScreenState extends State<MobileRechargeScreen> {
  final TextEditingController enterNumberController = TextEditingController();

  List<Contact> allContacts = [];
  List<Contact> filteredContacts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchContacts();

    // 🔎 Add listener for live filtering
    enterNumberController.addListener(() {
      filterContacts(enterNumberController.text);
    });
  }

  /// 📲 Fetch Contacts with permission
  Future<void> fetchContacts() async {
    bool permissionGranted = await FlutterContacts.requestPermission();
    PermissionStatus status = await Permission.contacts.status;

    if (status.isGranted) {
      List<Contact> contacts = await FlutterContacts.getContacts(withProperties: true);

      setState(() {
        allContacts = contacts.where((c) => c.phones.isNotEmpty).toList();
        filteredContacts = allContacts;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });

      Get.defaultDialog(
        title: 'Permission Required',
        middleText: 'This feature requires contact access. Please enable it in settings.',
        textConfirm: 'Open Settings',
        textCancel: 'Cancel',
        onConfirm: () {
          openAppSettings();
          Get.back();
        },
      );
    }
  }

  /// 🔎 Filter contacts based on search text
  void filterContacts(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredContacts = allContacts;
      });
    } else {
      final lowerQuery = query.toLowerCase();
      final filtered = allContacts.where((contact) {
        final name = contact.displayName?.toLowerCase() ?? '';
        final phone = contact.phones.isNotEmpty
            ? contact.phones.first.number.replaceAll(' ', '')
            : '';
        return name.contains(lowerQuery) || phone.contains(lowerQuery);
      }).toList();

      setState(() {
        filteredContacts = filtered;
      });
    }
  }

  /// 🟢 Get initials for contact avatar
  String getInitials(String? name) {
    if (name == null || name.isEmpty) return '';
    List<String> parts = name.trim().split(' ');
    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    } else {
      return (parts[0][0] + parts[1][0]).toUpperCase();
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
            child: SvgPicture.asset(Images.information, color: Colors.green),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              CommonTextWidget.InterBold(
                text: "Recharge or Pay Mobile Bill",
                fontSize: 22,
                color: black171,
              ),
              SizedBox(height: 15),
              CommonTextFieldWidget.TextFormField3(
                controller: enterNumberController,
                hintText: "Enter Name or Mobile Number",
                keyboardType: TextInputType.text,
                suffixIcon: Padding(
                  padding: EdgeInsets.all(12),
                  child: SvgPicture.asset(Images.search, color: Colors.green),
                ),
              ),
              SizedBox(height: 18),
              CommonTextWidget.InterBold(
                text: "Contacts",
                fontSize: 20,
                color: grey757,
              ),
              SizedBox(height: 15),

              // 🟢 Contacts list
            // 🟢 Contacts list
isLoading
    ? Center(child: CircularProgressIndicator())
    : Column(
        children: [
          // Contact list
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: filteredContacts.length,
            itemBuilder: (context, index) {
              final contact = filteredContacts[index];
              final phone = contact.phones.isNotEmpty
                  ? contact.phones.first.number.replaceAll(' ', '')
                  : '';

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () {
                    Get.to(() => SelectYourPrepaidOperatorScreen(), arguments: {
                      "name": contact.displayName,
                      "phone": phone,
                    });
                  },
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: Colors.green.withOpacity(0.1),
                      child: Text(
                        getInitials(contact.displayName),
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                    title: CommonTextWidget.InterSemiBold(
                      text: contact.displayName ?? 'Unknown',
                      fontSize: 16,
                      color: black171,
                    ),
                    subtitle: CommonTextWidget.InterRegular(
                      text: phone,
                      fontSize: 12,
                      color: grey757,
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 14, color: Colors.green),
                  ),
                ),
              );
            },
          ),

          // If user types a number not in contacts → show button
          if (enterNumberController.text.isNotEmpty &&
              !allContacts.any((c) =>
                  c.phones.isNotEmpty &&
                  c.phones.first.number.replaceAll(' ', '') ==
                      enterNumberController.text.replaceAll(' ', '')))
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onPressed: () {
                  Get.to(() => SelectYourPrepaidOperatorScreen(), arguments: {
                    "name": "Unknown",
                    "phone": enterNumberController.text.trim(),
                  });
                },
                // child: Text(
                //   enterNumberController.text.trim(),
                //   style: TextStyle(fontSize: 16, color: Colors.white),
                // ),
                  child: ListTile(
  contentPadding: EdgeInsets.zero,
  leading: CircleAvatar(
    backgroundColor: Colors.green.withOpacity(0.1),
    child: Text(
      getInitials('Unknown'), // You can keep initials or use first digit of number
      style: TextStyle(color: Colors.green),
    ),
  ),
  title: CommonTextWidget.InterSemiBold(
    // If user typed a number, show it; otherwise, show contact name
    text: ('Unknown'),
    fontSize: 16,
    color: black171,
  ),
  subtitle: CommonTextWidget.InterRegular(
    text: enterNumberController.text.trim(),
    fontSize: 12,
    color: grey757,
  ),
  trailing: Icon(Icons.arrow_forward_ios, size: 14, color: Colors.green),
  onTap: () {
  Get.to(() => SelectYourPrepaidOperatorScreen(), arguments: {
    "name": "Unknown",
    "phone": enterNumberController.text.trim(), // ✅ String pass kiya
  });
},

),

              ),
            ),
        ],
      ),

              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
