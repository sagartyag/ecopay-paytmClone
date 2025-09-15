import 'package:digitalwalletpaytmcloneapp/Constants/colors.dart';
import 'package:digitalwalletpaytmcloneapp/Constants/images.dart';
import 'package:digitalwalletpaytmcloneapp/Service/Api.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:digitalwalletpaytmcloneapp/Screens/HomeScreen/CableTv/enter_cable_recharge_detail_screen.dart';

class SelectCableScreen extends StatefulWidget {
  const SelectCableScreen({Key? key}) : super(key: key);

  @override
  State<SelectCableScreen> createState() => _SelectCableScreenState();
}

class _SelectCableScreenState extends State<SelectCableScreen> {
  bool isLoading = true;
  List<dynamic> prepaidOperators = [];
  List<dynamic> filteredOperators = [];
  final TextEditingController searchController = TextEditingController();

  /// ✅ Added missing field
  String? circle;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args != null && args is Map && args.containsKey("circle")) {
      circle = args["circle"];
    }
    fetchOperators();
    searchController.addListener(_filterOperators);
  }

  /// 🔍 Search filter
  void _filterOperators() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredOperators = prepaidOperators
          .where((op) => op['name'].toString().toLowerCase().contains(query))
          .toList();
    });
  }

  /// 📡 Fetch operators from API
  Future<void> fetchOperators() async {
    try {
      final response = await ApiService.get("/get-operators");
      final data = response.data;
      print("API Response: $data");

      List<dynamic> operatorsList = [];

      if (data['success'] == true && data['services'] != null) {
        for (var service in data['services']) {
          if (service['serviceType']
              .toString()
              .toLowerCase()
              .contains("dth")) {
            operatorsList.addAll(service['operators']);
          }
        }
      }

      setState(() {
        prepaidOperators = operatorsList;
        filteredOperators = operatorsList;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      Get.snackbar("Error", "Failed to fetch operators");
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
        title: CommonTextWidget.InterSemiBold(
          text: "Recharge DTH or TV",
          fontSize: 18,
          color: black171,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: SvgPicture.asset(Images.information, color: Colors.green),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),

            // 🔍 Search Box
            Container(
              height: 45,
              width: Get.width,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: greyF1F,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: black171, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      style: TextStyle(
                        color: black171,
                        fontSize: 16,
                        fontFamily: "InterRegular",
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Type your Cable TV Operator Name",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),
            CommonTextWidget.InterBold(
              text: "Select DTH Operators",
              fontSize: 20,
              color: black171,
            ),
            const SizedBox(height: 18),

            // 📋 Operator List
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.green),
                    )
                  : ListView.builder(
                      itemCount: filteredOperators.length,
                      itemBuilder: (context, index) {
                        final operator = filteredOperators[index];
                        return InkWell(
                          onTap: () {
                            print("Selected Operator: ${operator['name']}");
                            print("Selected Circle: $circle");

                           Get.to(() => EnterCableRechargeDetailScreen(),
  arguments: {
    "operatorCode": operator['code'] ?? "",
        "operatorName": operator['name'] ?? "",

    "circleCode": circle ?? "",
  },
);

                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.tv, color: Colors.green),
                                const SizedBox(width: 12),
                                Text(
                                  operator['name'] ?? "",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
