import 'package:digitalwalletpaytmcloneapp/Constants/colors.dart';
import 'package:digitalwalletpaytmcloneapp/Constants/images.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class BillConfirmScreen extends StatefulWidget {
  final String operatorName;
  final String operatorLogo;
  final String customerId;
  final String customerName;
  final String billDate;
  final String dueDate;
  final double amount;

  const BillConfirmScreen({
    Key? key,
    required this.operatorName,
    required this.operatorLogo,
    required this.customerId,
    required this.customerName,
    required this.billDate,
    required this.dueDate,
    required this.amount,
  }) : super(key: key);

  @override
  State<BillConfirmScreen> createState() => _BillConfirmScreenState();
}

class _BillConfirmScreenState extends State<BillConfirmScreen> {
  bool autoPay = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        leading: InkWell(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: CommonTextWidget.InterSemiBold(
          text: "Pay Electricity Bill",
          fontSize: 18,
          color: Colors.black,
        ),
        actions: [
          SvgPicture.asset(
            Images.information,
            color: Colors.black,
            height: 22,
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Board + Customer ID
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: greyE5E),
              ),
              child: Row(
                children: [
                  // Logo
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage(widget.operatorLogo),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonTextWidget.InterSemiBold(
                          text: widget.operatorName,
                          fontSize: 14,
                          color: black171,
                        ),
                        CommonTextWidget.InterRegular(
                          text: widget.customerId,
                          fontSize: 12,
                          color: grey757,
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.expand_more, color: grey757),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Bill Details Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: greyE5E),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonTextWidget.InterSemiBold(
                    text: "Bill Details",
                    fontSize: 14,
                    color: black171,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonTextWidget.InterRegular(
                        text: "Customer Name",
                        fontSize: 13,
                        color: grey757,
                      ),
                      CommonTextWidget.InterMedium(
                        text: widget.customerName,
                        fontSize: 13,
                        color: black171,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonTextWidget.InterRegular(
                        text: "Bill Date",
                        fontSize: 13,
                        color: grey757,
                      ),
                      CommonTextWidget.InterMedium(
                        text: widget.billDate,
                        fontSize: 13,
                        color: black171,
                      ),
                    ],
                  ),
                  const Divider(height: 22),
                  CommonTextWidget.InterBold(
                    text: "₹ ${widget.amount.toStringAsFixed(0)}",
                    fontSize: 22,
                    color: black171,
                  ),
                  const SizedBox(height: 6),
                  CommonTextWidget.InterRegular(
                    text: "Due Date: ${widget.dueDate}",
                    fontSize: 13,
                    color: Colors.red,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // AutoPay Option
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: greyE5E),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: autoPay,
                    onChanged: (value) {
                      setState(() {
                        autoPay = value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CommonTextWidget.InterMedium(
                              text: "Pay future bills with ",
                              fontSize: 13,
                              color: black171,
                            ),
                            CommonTextWidget.InterMedium(
                              text: "AUTOPAY",
                              fontSize: 13,
                              color: Colors.purple,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        CommonTextWidget.InterRegular(
                          text:
                              "We’ll remember and automatically pay your future bills on time",
                          fontSize: 12,
                          color: grey757,
                        ),
                        const SizedBox(height: 4),
                        InkWell(
                          onTap: () {},
                          child: CommonTextWidget.InterMedium(
                            text: "Know More",
                            fontSize: 12,
                            color: Colors.purple,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Pay Bill Button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            print("Pay Bill Clicked");
          },
          child: CommonTextWidget.InterSemiBold(
            text: "PAY BILL",
            fontSize: 16,
            color: white,
          ),
        ),
      ),
    );
  }
}
