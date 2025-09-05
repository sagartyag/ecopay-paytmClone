import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:digitalwalletpaytmcloneapp/Service/Api.dart';
import 'package:digitalwalletpaytmcloneapp/Constants/colors.dart';
import 'package:digitalwalletpaytmcloneapp/Constants/images.dart';
import 'package:digitalwalletpaytmcloneapp/Screens/ChatScreens/chat_screen1.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_text_widget.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_textfeild_widget.dart';
import 'package:digitalwalletpaytmcloneapp/Screens/ReferAndEarnScreen/refer_and_earn_screen.dart';

class ToMobileScreen extends StatefulWidget {
  const ToMobileScreen({Key? key}) : super(key: key);

  @override
  State<ToMobileScreen> createState() => _ToMobileScreenState();
}

class _ToMobileScreenState extends State<ToMobileScreen> {
  final TextEditingController enterNumberController = TextEditingController();
  List<Contact> allContacts = [];
  List<Contact> filteredContacts = [];
   bool isLoading = true;
  // Simulated backend response for UPI users (replace with real API)
  // final Set<String> upiUsers = {
  //   '+919876543210',
  //   '+919812345678',
  // };

  Set<String> upiUsers = {};


  Future<void> fetchUpiUsersFromServer() async {
  try {
    final response = await ApiService.get("/registered-phones");



    if (response.statusCode == 200) {
      final data = response.data;
      print('Registered Phones from server: $response');
      final List<dynamic> phonesFromServer = data['registeredPhones'];

      setState(() {
        upiUsers.clear();
        upiUsers.addAll(phonesFromServer.map((p) => p.toString()));
      });
    } else {
      print('Failed to fetch UPI users from server');
    }
  } catch (e) {
    print('Error fetching UPI users: $e');
  }
}

  @override
  void initState() {
    super.initState();
    fetchContacts();

    // Add listener for search input changes
    enterNumberController.addListener(() {
      filterContacts(enterNumberController.text);
    });
  }

  Future<void> fetchContacts() async {
    bool permissionGranted = await FlutterContacts.requestPermission();
    PermissionStatus status = await Permission.contacts.status;

    if (status.isGranted ) {
      List<Contact> contacts = await FlutterContacts.getContacts(withProperties: true);
      setState(() {
        allContacts = contacts.where((c) => c.phones.isNotEmpty).toList();
        filteredContacts = allContacts; // Show all initially
         isLoading = false;
      });

       // Fetch UPI users from backend after contacts are loaded
    await fetchUpiUsersFromServer();
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
          // SvgPicture.asset(Images.information, color: Colors.green),
          SizedBox(width: 15),
          Padding(
            padding: EdgeInsets.only(right: 25),
            // child: SvgPicture.asset(Images.setting, color: Colors.green),
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
                text: "UPI Money Transfer",
                fontSize: 22,
                color: black171,
              ),
              CommonTextWidget.InterRegular(
                text: "Make payments to DigiWallet, PhonePe or Gpay",
                fontSize: 14,
                color: black1E1,
              ),
              SizedBox(height: 15),
              CommonTextFieldWidget.TextFormField3(
                controller: enterNumberController,
                hintText: "Enter Name or Mobile Number",
                keyboardType: TextInputType.text,
                suffixIcon: Padding(
                  padding: EdgeInsets.all(12),
                  child: InkWell(
                    onTap: () {
                      // Optional: Open contact picker screen or search
                    },
                    child: SvgPicture.asset(Images.search, color: Colors.green),
                  ),
                ),
              ),
              SizedBox(height: 18),
              CommonTextWidget.InterBold(
                text: "Contacts",
                fontSize: 20,
                color: grey757,
              ),
              SizedBox(height: 15),

              // Use filteredContacts for ListView
              isLoading 
  ? Center(child: CircularProgressIndicator()) 
  : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: filteredContacts.length,
                itemBuilder: (context, index) {
                  final contact = filteredContacts[index];
                  final phone = contact.phones.isNotEmpty
                      ? contact.phones.first.number.replaceAll(' ', '')
                      : '';

                  final isUpiUser = upiUsers.contains(phone);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      onTap: () {
                        if (isUpiUser) {
                          Get.to(() => ChatScreen1());
                        } else {
                          Get.to(() => ReferAndEarnScreen());
                        }
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
                        trailing: CommonTextWidget.InterMedium(
                          text: isUpiUser ? "Send" : "Invite",
                          fontSize: 14,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
