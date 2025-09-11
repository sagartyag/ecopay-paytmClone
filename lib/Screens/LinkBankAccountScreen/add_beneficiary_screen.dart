import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:digitalwalletpaytmcloneapp/Constants/colors.dart';
import 'package:digitalwalletpaytmcloneapp/Constants/images.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_text_widget.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_textfeild_widget.dart';
import 'package:digitalwalletpaytmcloneapp/Service/Api.dart';
import 'otp_verification_screen.dart'; // Import OTP screen
class AddBeneficiaryScreen extends StatefulWidget {
  final String bankId;
  final String bankName;
  final String ifsc;

  const AddBeneficiaryScreen({
    Key? key,
    required this.bankId,
    required this.bankName,
    required this.ifsc,
  }) : super(key: key);

  @override
  State<AddBeneficiaryScreen> createState() => _AddBeneficiaryScreenState();
}

class _AddBeneficiaryScreenState extends State<AddBeneficiaryScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController customerMobileController = TextEditingController();
  final TextEditingController accountNoController = TextEditingController();
  final TextEditingController ifscController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    ifscController.text = widget.ifsc;
  }

  Future<void> addBeneficiary() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSubmitting = true);

try {
  final response = await ApiService.post(
    "/add-beneficiary",
    {
      "MobileNo": mobileController.text.trim(),
      "CustomerMobileNo": customerMobileController.text.trim(),
      "BankId": widget.bankId,
      "AccountNo": accountNoController.text.trim(),
      "IFSC": ifscController.text.trim(),
      "Name": nameController.text.trim(),
    },
  );

  final data = response.data;
  setState(() => isSubmitting = false);

  if (data['success'] == true) {
    Get.snackbar("Success", data['message'] ?? "Beneficiary added successfully");
    // Get.back(result: true);
     
  } else {
    Get.snackbar("Error", data['message'] ?? "Failed to add beneficiary");
  }
} catch (e) {
  setState(() => isSubmitting = false);
  Get.snackbar("Error", "Server error: $e");
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
                        text: "Add Beneficiary",
                        fontSize: 20,
                        color: white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CommonTextWidget.InterSemiBold(
                      text: "Bank: ${widget.bankName}",
                      fontSize: 16,
                      color: black171,
                    ),
                    SizedBox(height: 20),

                    // Mobile No
                    CommonTextFieldWidget.TextFormField2(
                      controller: mobileController,
                      keyboardType: TextInputType.phone,
                      hintText: "Sender Mobile Number",
                      validator: (v) =>
                          v!.isEmpty ? "Enter sender mobile no" : null,
                    ),
                    SizedBox(height: 16),

                    // Customer Mobile No
                    CommonTextFieldWidget.TextFormField2(
                      controller: customerMobileController,
                      keyboardType: TextInputType.phone,
                      hintText: "Customer Mobile Number",
                      validator: (v) =>
                          v!.isEmpty ? "Enter customer mobile no" : null,
                    ),
                    SizedBox(height: 16),

                    // Account No
                    CommonTextFieldWidget.TextFormField2(
                      controller: accountNoController,
                      keyboardType: TextInputType.number,
                      hintText: "Account Number",
                      validator: (v) =>
                          v!.isEmpty ? "Enter account number" : null,
                    ),
                    SizedBox(height: 16),

                    // IFSC
                    CommonTextFieldWidget.TextFormField2(
                      controller: ifscController,
                      hintText: "IFSC Code",
                      validator: (v) => v!.isEmpty ? "Enter IFSC code" : null,
                    ),
                    SizedBox(height: 16),

                    // Name
                    CommonTextFieldWidget.TextFormField2(
                      controller: nameController,
                      hintText: "Beneficiary Name",
                      validator: (v) => v!.isEmpty ? "Enter name" : null,
                    ),
                    SizedBox(height: 30),

                    // Submit Button
                    ElevatedButton(
                      onPressed: isSubmitting ? null : addBeneficiary,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: isSubmitting
                          ? CircularProgressIndicator(color: white)
                          : Text(
                              "Add Beneficiary",
                              style: TextStyle(
                                color: white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
