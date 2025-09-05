import 'package:digitalwalletpaytmcloneapp/Constants/colors.dart';
import 'package:digitalwalletpaytmcloneapp/Constants/images.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_text_widget.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_textfeild_widget.dart';
import 'package:digitalwalletpaytmcloneapp/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:digitalwalletpaytmcloneapp/Service/Api.dart';
import 'package:digitalwalletpaytmcloneapp/Screens/HomeScreen/GasCyclinderScreen/add_mobile_agency.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class BillPaymentPage extends StatelessWidget {
  const BillPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: Icon(Icons.arrow_back, color: Colors.white),
        title: Text(
          "Indane Gas (Indian Oil)",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        actions: [
          Icon(Icons.help_outline, color: Colors.white),
          SizedBox(width: 12),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 25,
                  child: Icon(Icons.local_gas_station,
                      color: Colors.deepOrange, size: 30),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("9034782553",
                        style: TextStyle(color: Colors.white, fontSize: 14)),
                    SizedBox(height: 2),
                    Text(
                      "Indane Gas (Indian Oil)",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: 20),

            // Customer details
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade700),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  detailRow("Customer Name", "Rakesh Kumar So Khim Raj"),
                  Divider(color: Colors.grey.shade700),
                  detailRow("Bill Date", "04-Sep-2025"),
                  Divider(color: Colors.grey.shade700),
                  detailRow("Consumer Number", "7574625283"),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Amount Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Amount",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("Due on 06 Sep",
                        style: TextStyle(
                            color: Colors.orange,
                            fontSize: 12,
                            fontWeight: FontWeight.w500)),
                    SizedBox(height: 4),
                    Text("₹ 860",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            Spacer(),

            // Proceed Button
            Column(
              children: [
                Text(
                  "By proceeding further, you allow PhonePe to fetch your current and future bills and remind you",
                  style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 12,
                      height: 1.4),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                    child: Text(
                      "Proceed to Pay",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget detailRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
        Flexible(
          child: Text(value,
              textAlign: TextAlign.end,
              style: TextStyle(color: Colors.white, fontSize: 14)),
        ),
      ],
    );
  }
}
