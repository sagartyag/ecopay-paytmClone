import 'package:digitalwalletpaytmcloneapp/Constants/colors.dart';
import 'package:digitalwalletpaytmcloneapp/Constants/images.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_text_widget.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_textfeild_widget.dart';
import 'package:digitalwalletpaytmcloneapp/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:digitalwalletpaytmcloneapp/Service/Api.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:share_plus/share_plus.dart';

class ReferAndEarnScreen extends StatefulWidget {
  const ReferAndEarnScreen({Key? key}) : super(key: key);

  @override
  State<ReferAndEarnScreen> createState() => _ReferAndEarnScreenState();
}

class _ReferAndEarnScreenState extends State<ReferAndEarnScreen> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController enterNumberController = TextEditingController();

  List<Contact> allContacts = [];
  List<Contact> filteredContacts = [];
  Set<String> upiUsers = {};
  bool isLoading = true;

  /// 🔹 Referral link from backend
  String referralLink = "https://www.ecovillages.co.in/register?ref=guest";

  @override
  void initState() {
    super.initState();
    fetchContacts();
    fetchUserName();

    // Add listener for search input changes
    searchController.addListener(() {
      filterContacts(searchController.text);
    });
  }

  /// 🔹 Fetch username from backend
  void fetchUserName() async {
    try {
      final response = await ApiService.get("/profile");
      print("Response: $response");

      final success = response.data["success"];
      final userData = response.data["data"];

      if (success == true) {
        setState(() {
          final username = userData["username"] ?? "guest";
          referralLink = "https://www.ecovillages.co.in/register?ref=$username";
        });
      } else {
        setState(() {
          referralLink = "https://www.ecovillages.co.in/register?ref=guest";
        });
      }
    } catch (e) {
      print("Error fetching user profile: $e");
      setState(() {
        referralLink = "https://www.ecovillages.co.in/register?ref=guest";
      });
    }
  }

  /// 🔹 Function to share referral link
  void shareReferralLink(String referralLink) {
    Share.share(
      "Hey! Join DigiWallet and earn rewards. Use my referral link: $referralLink",
      subject: "DigiWallet Referral",
    );
  }

  /// Fetch registered UPI users from backend
  Future<void> fetchUpiUsersFromServer() async {
    try {
      final response = await ApiService.get("/registered-phones");

      if (response.statusCode == 200) {
        final data = response.data;
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

  /// Fetch contacts from device
  Future<void> fetchContacts() async {
    bool permissionGranted = await FlutterContacts.requestPermission();
    PermissionStatus status = await Permission.contacts.status;

    if (status.isGranted) {
      List<Contact> contacts =
          await FlutterContacts.getContacts(withProperties: true);

      setState(() {
        allContacts = contacts.where((c) => c.phones.isNotEmpty).toList();
        filteredContacts = allContacts;
        isLoading = false;
      });

      await fetchUpiUsersFromServer();
    } else {
      setState(() {
        isLoading = false;
      });
      Get.defaultDialog(
        title: 'Permission Required',
        middleText:
            'This feature requires contact access. Please enable it in settings.',
        textConfirm: 'Open Settings',
        textCancel: 'Cancel',
        onConfirm: () {
          openAppSettings();
          Get.back();
        },
      );
    }
  }

  /// Filter contacts by name or phone
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

  /// Get initials for avatar
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
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Top Banner
              Container(
                width: Get.width,
                color: Colors.green,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 25, right: 25, top: 62, bottom: 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () => Get.back(),
                            child: Icon(Icons.arrow_back,
                                size: 20, color: white),
                          ),
                          SvgPicture.asset(Images.referAndEarnImage),
                          const SizedBox(width: 20), // Placeholder
                        ],
                      ),
                      const SizedBox(height: 15),
                      Center(
                        child: CommonTextWidget.InterSemiBold(
                          text: "Refer & Earn ₹100",
                          fontSize: 28,
                          color: white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CommonTextWidget.InterRegular(
                        text:
                            "Earn ₹100 every time a referred friend makes their 1st UPI money transfer on DigiWallet",
                        fontSize: 14,
                        color: white,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 60),
                        child: InkWell(
                          onTap: () {
                            shareReferralLink(referralLink);
                          },
                          child: Container(
                            width: Get.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                              color: whiteF9F,
                              border: Border.all(color: greyA6A),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: Row(
                                children: [
                                  Image.asset(Images.whatsApp,
                                      height: 24, width: 24),
                                  const SizedBox(width: 6),
                                  CommonTextWidget.InterBold(
                                    text: "Refer via Whatsapp",
                                    fontSize: 14,
                                    color: black171,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 🔹 UPI Money Transfer + Contacts
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    CommonTextWidget.InterBold(
                      text: "Referral",
                      fontSize: 18,
                      color: black171,
                    ),
                  
                    const SizedBox(height: 15),
                    CommonTextFieldWidget.TextFormField3(
                      controller: searchController,
                      hintText: "Enter Name or Mobile Number",
                      keyboardType: TextInputType.text,
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(12),
                        child: InkWell(
                          onTap: () {
                            // Optional search action
                          },
                          child: SvgPicture.asset(Images.search,
                              color: Colors.green),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    CommonTextWidget.InterBold(
                      text: "Contacts",
                      fontSize: 20,
                      color: grey757,
                    ),
                    const SizedBox(height: 5),

                    // 🔹 Contact List
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredContacts.length,
                            itemBuilder: (context, index) {
                              final contact = filteredContacts[index];
                              final phone = contact.phones.isNotEmpty
                                  ? contact.phones.first.number
                                      .replaceAll(' ', '')
                                  : '';

                              final isUpiUser = upiUsers.contains(phone);

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: CircleAvatar(
                                    backgroundColor:
                                        Colors.green.withOpacity(0.1),
                                    child: Text(
                                      getInitials(contact.displayName),
                                      style: const TextStyle(
                                          color: Colors.green),
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
                                  trailing: InkWell(
                                    onTap: () {
                                      if (!isUpiUser) {
                                        shareReferralLink(referralLink);
                                      }
                                    },
                                    child: CommonTextWidget.InterMedium(
                                      text: isUpiUser ? "Active" : "Invite",
                                      fontSize: 14,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
