import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:digitalwalletpaytmcloneapp/Constants/colors.dart';
import 'package:digitalwalletpaytmcloneapp/Constants/images.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_text_widget.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_textfeild_widget.dart';
import 'package:digitalwalletpaytmcloneapp/Service/Api.dart';
import 'add_beneficiary_screen.dart';
import 'otp_verification_screen.dart';

class SelectBankScreen extends StatefulWidget {
  const SelectBankScreen({Key? key}) : super(key: key);

  @override
  State<SelectBankScreen> createState() => _SelectBankScreenState();
}

class _SelectBankScreenState extends State<SelectBankScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isLoading = true;
  List<dynamic> banks = [];
  List<dynamic> filteredBanks = [];

  @override
  void initState() {
    super.initState();
    fetchBanks();

    searchController.addListener(() {
      filterBanks(searchController.text);
    });
  }

  // Fetch banks from Cyrus API
  Future<void> fetchBanks() async {
    try {
      final response = await ApiService.get("/get-banks");
      final data = response.data;
      print("Fetched banks: $data");
      if (data['success'] == true && data['banks'] != null) {
        setState(() {
          banks = data['banks'];
          filteredBanks = data['banks'];
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        Get.snackbar("Error", "Failed to fetch banks");
      }
    } catch (e) {
      setState(() => isLoading = false);
      Get.snackbar("Error", "Failed to fetch banks");
    }
  }

  // Filter banks by name
  void filterBanks(String query) {
    if (query.isEmpty) {
      setState(() => filteredBanks = banks);
    } else {
      setState(() {
        filteredBanks = banks
            .where((bank) => bank['name']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Column(
        children: [
          // 🌟 Gradient Header
          Container(
            height: 140,
            width: Get.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade600, Colors.green.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(25),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => Get.back(),
                      child: Icon(Icons.arrow_back, color: white, size: 22),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: CommonTextWidget.InterSemiBold(
                        text: "Select Bank",
                        fontSize: 20,
                        color: white,
                      ),
                    ),
                    SvgPicture.asset(
                      Images.information,
                      color: white,
                      height: 22,
                      width: 22,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 🌟 Search Box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Container(
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: CommonTextFieldWidget.TextFormField2(
                controller: searchController,
                prefixIcon: Padding(
                  padding: EdgeInsets.all(15),
                  child: SvgPicture.asset(Images.search, color: Colors.green),
                ),
                hintText: "Search Bank",
              ),
            ),
          ),

          // 🌟 List of banks
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator(color: Colors.green))
                : filteredBanks.isEmpty
                    ? Center(
                        child: CommonTextWidget.InterMedium(
                          text: "No banks found",
                          fontSize: 16,
                          color: grey757,
                        ),
                      )
                    : ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: filteredBanks.length,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        itemBuilder: (context, index) {
                          final bank = filteredBanks[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              
                               onTap: () async {
  try {
    // 1️⃣ Call backend to check user status
    final response = await ApiService.get("/check-user-status");
    final data = response.data;
    print("check-user-status response: $data");
    if (data['success'] == true) {
      final status = data['status'];   // active / inactive
      final action = data['action'];   // PROCEED / KYC_REQUIRED / REGISTER_REQUIRED

      if (status == "active" && action == "PROCEED") {
        // ✅ User is active → go to Add Beneficiary screen
        Get.to(() => AddBeneficiaryScreen(
              bankId: bank['bank_id'].toString(),
              bankName: bank['name'],
              ifsc: bank['ifsc'] ?? "",
            ));
      } else if (action == "KYC_REQUIRED") {
        // ❌ User inactive → redirect to OTP/KYC screen
        Get.to(() => OtpVerificationScreen(bankId: bank['bank_id'].toString(),
              bankName: bank['name'],
              ifsc: bank['ifsc'] ?? "",));
      } else if (action == "REGISTER_REQUIRED") {
        // ❌ User not registered
        Get.snackbar("Error",
            "User not registered. Please complete registration.");
      } else {
        // ❌ Unexpected case
        Get.snackbar("Error", data['message'] ?? "Unexpected status");
      }
    } else {
      Get.snackbar("Error", data['message'] ?? "Failed to check status");
    }
  } catch (e) {
    print("check-user-status error: $e");
    Get.snackbar("Error", "Something went wrong while checking status");
  }
},

                              
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: white,
                                  border: Border.all(color: greyE5E, width: 1),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  leading:CircleAvatar(
                                          backgroundColor:
                                              Colors.green.withOpacity(0.1),
                                          child: Icon(Icons.account_balance,
                                              color: Colors.green),
                                        ),
                                  title: CommonTextWidget.InterSemiBold(
                                    text: bank['name'] ?? "",
                                    fontSize: 16,
                                    color: black171,
                                  ),
                                  subtitle: Text(bank['ifsc'] ?? ""),
                                  trailing: Icon(Icons.arrow_forward_ios,
                                      size: 16, color: Colors.green),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
