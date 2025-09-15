import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:digitalwalletpaytmcloneapp/Constants/colors.dart';
import 'package:digitalwalletpaytmcloneapp/Constants/images.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_text_widget.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_textfeild_widget.dart';
import 'package:digitalwalletpaytmcloneapp/Service/Api.dart';
import 'add_beneficiary_screen.dart';
import 'bank_list_screen.dart';
import 'payment_amount_screen.dart';
class ShowBeneficiary extends StatefulWidget {
  const ShowBeneficiary({Key? key}) : super(key: key);

  @override
  State<ShowBeneficiary> createState() => _ShowBeneficiaryState();
}

class _ShowBeneficiaryState extends State<ShowBeneficiary> {
  final TextEditingController searchController = TextEditingController();
  bool isLoading = true;

  List<dynamic> beneficiaries = [];
  List<dynamic> filteredBeneficiaries = [];

  @override
  void initState() {
    super.initState();
    fetchBeneficiaries();

    searchController.addListener(() {
      filterBeneficiaries(searchController.text);
    });
  }

  Future<void> fetchBeneficiaries() async {
    try {
      final response = await ApiService.get("/get-beneficiary-details");
      print(response);

      final data = response.data;

      if (data['success'] == true && data['data'] != null) {
        setState(() {
          beneficiaries = data['data'];
          filteredBeneficiaries = beneficiaries;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        Get.snackbar("Error", "No beneficiaries found");
      }
    } catch (e) {
      setState(() => isLoading = false);
      print("Error: $e");
      Get.snackbar("Error", "Failed to fetch beneficiaries");
    }
  }

  void proceedToPayment(dynamic beneficiary) {
    Get.to(() => PaymentScreen(beneficiary: beneficiary));
   
  }

  String maskAccountNumber(String? accountNo) {
  if (accountNo == null || accountNo.length <= 7) return accountNo ?? '';
  String masked = '*' * 7; // 7 asterisks
  String lastDigits = accountNo.substring(7); // show from 8th char
  return masked + lastDigits;
}

  void filterBeneficiaries(String query) {
    if (query.isEmpty) {
      setState(() => filteredBeneficiaries = beneficiaries);
    } else {
      setState(() {
        filteredBeneficiaries = beneficiaries
            .where((b) => b['benemobile']
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
                        text: "Beneficiaries",
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
                hintText: "Search phone number",
              ),
            ),
          ),

          // 🌟 List of Beneficiaries
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator(color: Colors.green))
                : filteredBeneficiaries.isEmpty
                    ? Center(
                        child: CommonTextWidget.InterMedium(
                          text: "No beneficiaries found",
                          fontSize: 16,
                          color: grey757,
                        ),
                      )
                    : ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: filteredBeneficiaries.length,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        itemBuilder: (context, index) {
                          final b = filteredBeneficiaries[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
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
                                leading: CircleAvatar(
                                  backgroundColor:
                                      Colors.green.withOpacity(0.1),
                                  child: Icon(Icons.person, color: Colors.green),
                                ),
                                title: CommonTextWidget.InterSemiBold(
                                  text: b['name'] ?? "",
                                  fontSize: 16,
                                  color: black171,
                                ),
                                subtitle: Text(
                                  "${maskAccountNumber(b['account_no'] ?? '')}",
                                ),
                                trailing: Icon(Icons.arrow_forward_ios,
                                    size: 16, color: Colors.green),
                                onTap: () => proceedToPayment(b),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),

      // 🌟 Floating button → Add new Beneficiary
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          Get.to(() => SelectBankScreen());
        },
        child: Icon(Icons.add, color: white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
