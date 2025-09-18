import 'package:digitalwalletpaytmcloneapp/Constants/colors.dart';
import 'package:digitalwalletpaytmcloneapp/Constants/images.dart';
import 'package:digitalwalletpaytmcloneapp/Screens/HomeScreen/MobileRechargeScreens/prepaid_operator_payment_screen.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_text_widget.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_textfeild_widget.dart';
import 'package:digitalwalletpaytmcloneapp/Service/Api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class DthPlansScreen extends StatefulWidget {
  const DthPlansScreen({Key? key}) : super(key: key);

  @override
  State<DthPlansScreen> createState() => _DthPlansScreenState();
}

class _DthPlansScreenState extends State<DthPlansScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  final TextEditingController searchController = TextEditingController();

  Map<String, List<dynamic>> groupedPlans = {};
  Map<String, List<dynamic>> filteredPlans = {};
  List<String> rechargeTypes = [];
  bool isLoading = true;

  late String operatorCode;
  late String phone;
  late String circle;
  late String operatorName;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    operatorCode = args["operatorCode"] ?? "";
    phone = args["mobileNumber"] ?? "";
    circle = args["circleCode"] ?? "";
    operatorName = args["operatorName"] ?? "";

    searchController.addListener(() {
      _filterPlans(searchController.text);
    });

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
      if (data['success'] == true) {
        final List<dynamic> plans = data['apiData']['PlanDescription'] ?? [];

        // Group by recharge_type
        for (var plan in plans) {
          final type = plan["recharge_type"] ?? "Other";
          groupedPlans.putIfAbsent(type, () => []);
          groupedPlans[type]!.add(plan);
        }

        filteredPlans = Map.from(groupedPlans);
        rechargeTypes = groupedPlans.keys.toList();

        // Initialize TabController safely
        tabController = TabController(length: rechargeTypes.length, vsync: this);

        setState(() {
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

  void _filterPlans(String query) {
  final Map<String, List<dynamic>> temp = {};

  if (query.isEmpty) {
    temp.addAll(groupedPlans);
  } else {
    groupedPlans.forEach((type, plans) {
      final filtered = plans.where((plan) {
        final amount = plan['recharge_amount']?.toString() ?? '';
        final desc = plan['recharge_short_desc'] ?? plan['recharge_long_desc'] ?? '';
        return amount.contains(query) || desc.toLowerCase().contains(query.toLowerCase());
      }).toList();

      if (filtered.isNotEmpty) temp[type] = filtered;
    });
  }

  final updatedTabs = temp.keys.toList();

  // Only update TabController if number of tabs changed
  if (tabController == null || tabController!.length != updatedTabs.length) {
    final oldController = tabController;
    tabController = TabController(length: updatedTabs.length, vsync: this);
    if (oldController != null) oldController.dispose();
  }

  if (mounted) {
    setState(() {
      filteredPlans = temp;
      rechargeTypes = updatedTabs;
      // Reset index to first tab when search changes
      tabController?.index = 0;
    });
  }
}


@override
void dispose() {
  // Dispose the TabController if it's initialized
  tabController?.dispose();

  // Dispose the TextEditingController
  searchController.dispose();

  super.dispose();
}
  

  String _getOperatorLogo(String operatorName) {
    final name = operatorName.toLowerCase();
    if (name.contains("dish tv")) return "assets/images/dishTv.png";
    if (name.contains("tata play")) return "assets/images/tataPlay.png";
    if (name.contains("videocon dth")) return "assets/images/videocon.png";
    if (name.contains("sun direct")) return "assets/images/sunDirect.png";
    if (name.contains("airtel digital tv")) return "assets/images/airtel.png";
    return "assets/images/default.png";
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
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              _getOperatorLogo(operatorName),
              height: 28,
              width: 28,
            ),
            const SizedBox(width: 8),
            Text(
              operatorName,
              style: const TextStyle(
                  color: black171, fontWeight: FontWeight.w600, fontSize: 18),
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                  child: CommonTextFieldWidget.TextFormField2(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(15),
                      child: SvgPicture.asset(Images.search, color: Colors.green),
                    ),
                    keyboardType: TextInputType.text,
                    hintText: "Search Plan",
                    controller: searchController,
                  ),
                ),
                if (rechargeTypes.isNotEmpty && tabController != null) ...[
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
                        final plans = filteredPlans[type] ?? [];
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
                          padding: const EdgeInsets.all(12),
                          itemCount: plans.length,
                          itemBuilder: (context, index) {
                            final plan = plans[index];
                            return InkWell(
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
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.15),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    )
                                  ],
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        "₹${plan['recharge_amount'] ?? ''}",
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if (plan['recharge_validity'] != null &&
                                              plan['recharge_validity']
                                                  .toString()
                                                  .isNotEmpty)
                                            Text(
                                              "Validity: ${plan['recharge_validity']}",
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          const SizedBox(height: 6),
                                          Text(
                                            plan['recharge_short_desc'] ??
                                                plan['recharge_long_desc'] ??
                                                "",
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black54,
                                              height: 1.3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(Icons.arrow_forward_ios,
                                        size: 16, color: Colors.grey),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ] else
                  const Expanded(
                      child: Center(child: Text("No Plans Available"))),
              ],
            ),
    );
  }
}
