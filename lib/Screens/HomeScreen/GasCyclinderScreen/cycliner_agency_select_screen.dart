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

class CyclinerAgencyScreen extends StatefulWidget {
  const CyclinerAgencyScreen({Key? key}) : super(key: key);

  @override
  State<CyclinerAgencyScreen> createState() => _CyclinerAgencyScreenState();
}

class _CyclinerAgencyScreenState extends State<CyclinerAgencyScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isLoading = true;
  List<dynamic> prepaidOperators = [];
  List<dynamic> filteredCircles = [];

  @override
  void initState() {
    super.initState();
    fetchOperators();

    searchController.addListener(() {
      filterStates(searchController.text);
    });
  }

  Future<void> fetchOperators() async {
    try {
      final response = await ApiService.get("/get-operators");
      final data = response.data;
      List<dynamic> operatorsList = [];

      if (data['success'] == true && data['services'] != null) {
        for (var service in data['services']) {
            

          if (service['serviceType']
              .toString()
              .toLowerCase()
              .contains("lpg gas")) {
            operatorsList.addAll(service['operators']);
          }
        }
      }
       print("👉 Operators Lis11t:$operatorsList");
 
      setState(() {
        prepaidOperators = operatorsList;
        filteredCircles = operatorsList;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Get.snackbar("Error", "Failed to fetch operators");
    }
  }

  void filterStates(String query) {
    if (query.isEmpty) {
      setState(() => filteredCircles = prepaidOperators);
    } else {
      setState(() {
        filteredCircles = prepaidOperators
            .where((item) => item['name']
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
                        text: "Book LPG Gas Cylinder",
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
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Text(
        "Select Gas Provider",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.grey[700],
        ),
      ),
    ),
  ),
),


          // 🌟 List
       Expanded(
  child: isLoading
      ? Center(child: CircularProgressIndicator(color: Colors.green))
      : filteredCircles.isEmpty
          ? Center(
              child: CommonTextWidget.InterMedium(
                text: "No states found",
                fontSize: 16,
                color: grey757,
              ),
            )
          : ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: filteredCircles.length,
              padding: EdgeInsets.symmetric(horizontal: 20),
              itemBuilder: (context, index) {
                final state = filteredCircles[index];

                // 👉 यहाँ condition लगाई गई है
                IconData iconData;
                Color iconColor;

                if (index == 0) {
                  iconData = Icons.local_gas_station; // Bharat Gas BPCL
                  iconColor = Colors.blue;
                } else if (index == 1) {
                  iconData = Icons.fireplace; // HP Gas HPCL
                  iconColor = Colors.red;
                } else if (index == 2) {
                  iconData = Icons.energy_savings_leaf; // Indian Gas
                  iconColor = Colors.orange;
                } else {
                  iconData = Icons.store; // Bharat Gas BPCL Commercial
                  iconColor = Colors.green;
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Get.to(() => AddMobileAgency(), arguments: state);
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
                        leading: CircleAvatar(
                          backgroundColor: iconColor.withOpacity(0.1),
                          child: Icon(iconData, color: iconColor),
                        ),
                        title: CommonTextWidget.InterSemiBold(
                          text: state['name'] ?? "",
                          fontSize: 16,
                          color: black171,
                        ),
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
