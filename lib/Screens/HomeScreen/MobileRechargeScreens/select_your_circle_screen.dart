import 'package:digitalwalletpaytmcloneapp/Constants/colors.dart';
import 'package:digitalwalletpaytmcloneapp/Constants/images.dart';
import 'package:digitalwalletpaytmcloneapp/Screens/HomeScreen/MobileRechargeScreens/prepaid_operator_detaile_screen.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_text_widget.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_textfeild_widget.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/lists_view.dart';
import 'package:digitalwalletpaytmcloneapp/Service/Api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SelectYourCircleScreen extends StatefulWidget {
  const SelectYourCircleScreen({Key? key}) : super(key: key);

  @override
  State<SelectYourCircleScreen> createState() => _SelectYourCircleScreenState();
}

class _SelectYourCircleScreenState extends State<SelectYourCircleScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isLoading = true;
  List<dynamic> circles = [];
  List<dynamic> filteredCircles = [];

  @override
  void initState() {
    super.initState();
    fetchCircles();
    searchController.addListener(_filterCircles);
  }

  void _filterCircles() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredCircles = circles
          .where((c) => c['name'].toString().toLowerCase().contains(query))
          .toList();
    });
  }

  Future<void> fetchCircles() async {
    try {
      final response = await ApiService.get("/get-circles"); // Backend endpoint
      final data = response.data;

      if (data['success'] == true && data['circles'] != null) {
        setState(() {
          circles = data['circles'];
          filteredCircles = data['circles'];
          isLoading = false;
        });
        print("Fetched circles: $circles");
      } else {
        setState(() {
          isLoading = false;
        });
        Get.snackbar("Error", data['message'] ?? "Failed to fetch circles");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching circles: $e");
      Get.snackbar("Error", "Failed to fetch circles");
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
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back, size: 20, color: black171),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: SvgPicture.asset(Images.information),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              CommonTextWidget.InterBold(
                text: "Select your circle",
                fontSize: 22,
                color: black171,
              ),
              SizedBox(height: 15),
              CommonTextFieldWidget.TextFormField2(
                prefixIcon: Padding(
                  padding: EdgeInsets.all(15),
                  child: SvgPicture.asset(Images.search, color: Colors.green),
                ),
                keyboardType: TextInputType.text,
                hintText: "Search",
                controller: searchController,
              ),
              SizedBox(height: 15),
              isLoading
                  ? Center(child: CircularProgressIndicator(color: Colors.green))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: filteredCircles.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: InkWell(
                          onTap: () {
                            // Pass selected circle to next screen if needed
                            Get.to(() => PrepaidOperatorDetailScreen(
                               ));
                          },
                          child: Container(
                            width: Get.width,
                            decoration: BoxDecoration(
                              border: Border.all(color: greyE5E, width: 1),
                              borderRadius: BorderRadius.circular(16),
                              color: white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: CommonTextWidget.InterSemiBold(
                                text: filteredCircles[index]['name'] ?? "",
                                fontSize: 16,
                                color: black171,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
