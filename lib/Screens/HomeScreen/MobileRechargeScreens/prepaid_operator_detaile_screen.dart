import 'package:digitalwalletpaytmcloneapp/Constants/colors.dart';
import 'package:digitalwalletpaytmcloneapp/Constants/font_family.dart';
import 'package:digitalwalletpaytmcloneapp/Constants/images.dart';
import 'package:digitalwalletpaytmcloneapp/Screens/HomeScreen/MobileRechargeScreens/prepaid_operator_payment_screen.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_text_widget.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_textfeild_widget.dart';
import 'package:digitalwalletpaytmcloneapp/Service/Api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class PrepaidOperatorDetailScreen extends StatefulWidget {
  const PrepaidOperatorDetailScreen({Key? key}) : super(key: key);

  @override
  State<PrepaidOperatorDetailScreen> createState() =>
      _PrepaidOperatorDetailScreenState();
}

class _PrepaidOperatorDetailScreenState
    extends State<PrepaidOperatorDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  final TextEditingController searchController = TextEditingController();

  Map<String, List<dynamic>> groupedPlans = {};
  List<String> rechargeTypes = [];
  bool isLoading = true;
  late String operatorCode;

  late String operatorName;
  late String phone;
  late String circle;

  @override
  void initState() {
    super.initState();

    final args = Get.arguments as Map<String, dynamic>? ?? {};
    operatorCode = args["operator"] ?? "";
    phone = args["phone"] ?? "";
    circle = args["circle"] ?? "";
    operatorName = args["operatorName"] ?? "";

    fetchPlans();
  }

  Future<void> fetchPlans() async {
    try {
      final response = await ApiService.post("/recharge-plans", {
        "operator": operatorCode,
        "phone": phone,
        "circle": circle,
      });

      final data = response.data;
        print("👉 recharge type: $data");

      if (data['success'] == true) {
        final List<dynamic> plans = data['apiData']['PlanDescription'] ?? [];
            
        // 🔹 Group by recharge_type
        for (var plan in plans) {
          final type = plan["recharge_type"] ?? "Other";

          if (!groupedPlans.containsKey(type)) {
            groupedPlans[type] = [];
          }
          groupedPlans[type]!.add(plan);
        }

        setState(() {
          rechargeTypes = groupedPlans.keys.toList();
          tabController = TabController(length: rechargeTypes.length, vsync: this);
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        Get.snackbar("Error", data['message'] ?? "Failed to fetch plans");
      }
    } catch (e) {
      setState(() => isLoading = false);
      Get.snackbar("Error", "Something went wrong");
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
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back, size: 20, color: black171),
        ),
  title: Text(
    operatorName, 
    style: TextStyle(
      color: black171,
      fontWeight: FontWeight.w600,
      fontSize: 18,
    ),
  ),      ),
     body: isLoading
    ? const Center(child: CircularProgressIndicator(color: Colors.green))
    : rechargeTypes.isEmpty
        ? Center(
            child: CommonTextWidget.InterMedium(
              text: "No Plans Available",
              fontSize: 16,
              color: grey757,
            ),
          )
        : Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                child: CommonTextFieldWidget.TextFormField2(
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(15),
                    child: SvgPicture.asset(Images.search, color: Colors.green),
                  ),
                  keyboardType: TextInputType.text,
                  hintText: "Search Plan",
                  controller: searchController,
                ),
              ),

            
              TabBar(
                isScrollable: true,
                controller: tabController,
                labelColor: black171,
                unselectedLabelColor: grey757,
                indicatorColor: Colors.green,
                indicatorWeight: 2,
                tabs: rechargeTypes.map((type) => Tab(text: type)).toList(),
              ),

              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: rechargeTypes.map((type) {
                    final plans = groupedPlans[type] ?? [];
                    if (plans.isEmpty) {
                      return Center(
                        child: CommonTextWidget.InterMedium(
                          text: "No Plans Available",
                          fontSize: 16,
                          color: grey757,
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: plans.length,
                      itemBuilder: (context, index) {
                        final plan = plans[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: InkWell(
                            onTap: () {
                              Get.to(() => PrepaidOperatorPaymentScreen(),
                                  arguments: {
                                    "plan": plan,
                                    "operator": operatorCode,
                                    "phone": phone,
                                    "circle": circle,
                                     "operatorName": operatorName,

                                  });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonTextWidget.InterSemiBold(
                                  text:
                                      "₹${plan['recharge_amount'] ?? ''}",
                                  fontSize: 20,
                                  color: black171,
                                ),
                                SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CommonTextWidget.InterMedium(
                                        text:
                                            "Validity: ${plan['recharge_validity'] ?? 'N/A'}",
                                        fontSize: 14,
                                        color: black171,
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        plan['recharge_short_desc'] ??
                                            plan['recharge_long_desc'] ??
                                            "",
                                        style: TextStyle(
                                          fontFamily:
                                              FontFamily.InterRegular,
                                          fontSize: 12,
                                          color: grey757,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Icon(Icons.arrow_forward_ios,
                                      color: grey757, size: 18),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              )
            ],
          ),

    );
  }
}
