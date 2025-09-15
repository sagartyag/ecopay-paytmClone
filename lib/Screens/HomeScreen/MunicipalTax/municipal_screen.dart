import 'package:digitalwalletpaytmcloneapp/Constants/colors.dart';
import 'package:digitalwalletpaytmcloneapp/Constants/images.dart';
import 'package:digitalwalletpaytmcloneapp/Controllers/dth_recharge_controller.dart';
import 'package:digitalwalletpaytmcloneapp/Screens/HomeScreen/MunicipalTax/municipal_list_view.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SelectMunicipalScreen extends StatelessWidget {
  SelectMunicipalScreen({Key? key}) : super(key: key);

  final DthRechargeTabController dthRechargeTabController =
      Get.put(DthRechargeTabController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
         backgroundColor: white,
      appBar: AppBar(
          backgroundColor: Colors.green,
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back, size: 20, color: white),
        ),
        title: CommonTextWidget.InterSemiBold(
          text: "Municipal Services",
          fontSize: 18,
          color: white,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 25),
            child:SvgPicture.asset(Images.information, color: Colors.green,),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// Top Section
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    /// 🔹 Main Payment Box
    Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// Profile Pic
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.grey.shade200,
            child: const Icon(Icons.person, color: Colors.green, size: 30),
          ),
          const SizedBox(width: 14),

          /// Name & Number
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Paid to",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                SizedBox(height: 2),
                Text(
                  "Ramesh",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 2),
                Text(
                  "********9929",
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          ),

          /// Amount
          const Text(
            "₹20,000",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    ),

    /// 🔹 Banking Name (Outside Box)
    Padding(
      padding: const EdgeInsets.only(left: 28, right: 16, bottom: 8),
      child: Row(
        children: const [
          Icon(Icons.account_balance, size: 16, color: Colors.green),
          SizedBox(width: 6),
          Text(
            "Banking Name : Ramesh",
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ],
      ),
    ),
  ],
),



              const SizedBox(height: 4),

              /// Payment Details
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Payment Details",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.keyboard_arrow_down),
                      ],
                    ),
                    const SizedBox(height: 12),

                    /// Transaction ID
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text(
                            "Transaction ID\nT2506261647538407249817",
                            style: TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                        ),
                        Icon(Icons.copy, size: 18, color: Colors.green),
                      ],
                    ),
                    const SizedBox(height: 10),

                    /// Bank & Amount Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.account_balance, color: Colors.red, size: 28),
                            SizedBox(width: 10),
                            Text(
                              "HDFC BANK\nUTR: 000616180736",
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        const Text(
                          "₹20,000",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// Buttons Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _actionButton(Icons.send, "Send Again"),
                  _actionButton(Icons.history, "View History"),
                  _actionButton(Icons.call_split, "Split Expense"),
                  _actionButton(Icons.share, "Share Receipt"),
                ],
              ),

              const SizedBox(height: 20),

              /// Support Section
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Contact PhonePe Support",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// Footer Logo
              Column(
                children: [
                  const Text("Powered by", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.payments, color: Colors.black87, size: 20),
                      SizedBox(width: 4),
                      Text("UPI | YES BANK", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionButton(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.green, size: 22),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
