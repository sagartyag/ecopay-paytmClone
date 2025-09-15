import 'package:digitalwalletpaytmcloneapp/Constants/colors.dart';
import 'package:digitalwalletpaytmcloneapp/Constants/images.dart';
import 'package:digitalwalletpaytmcloneapp/Screens/HomeScreen/MobileRechargeScreens/prepaid_operator_detaile_screen.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_text_widget.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_textfeild_widget.dart';
import 'package:digitalwalletpaytmcloneapp/Service/Api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:digitalwalletpaytmcloneapp/Screens/HomeScreen/CableTv/cable_screen.dart';

class SelectYourCircle extends StatefulWidget {
  const SelectYourCircle({Key? key}) : super(key: key);

  @override
  State<SelectYourCircle> createState() => SelectYourCircleState();
}

class SelectYourCircleState extends State<SelectYourCircle> {
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
      final response = await ApiService.get("/get-circles");
      final data = response.data;

      if (data['success'] == true && data['circles'] != null) {
        setState(() {
          circles = data['circles'];
          filteredCircles = data['circles'];
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        Get.snackbar("Error", data['message'] ?? "Failed to fetch circles");
      }
    } catch (e) {
      setState(() => isLoading = false);
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
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back, size: 20, color: black171),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: SvgPicture.asset(Images.information,color: Colors.green),
          ),
        ],
        
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          
              const SizedBox(height: 15),
              CommonTextWidget.InterBold(
                text: "Select your circle",
                fontSize: 22,
                color: black171,
              ),
              const SizedBox(height: 15),
              CommonTextFieldWidget.TextFormField2(
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(15),
                  child: SvgPicture.asset(Images.search, color: Colors.green),
                ),
                keyboardType: TextInputType.text,
                hintText: "Search",
                controller: searchController,
              ),
              const SizedBox(height: 15),
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.green),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredCircles.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        final circle = filteredCircles[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: InkWell(
                            onTap: () {
                              // 👇 Just pass parameters to next screen
                              Get.to(() => SelectCableScreen(),
                                  arguments: {
                                  
                                    "circle": circle['code'],
                                  });
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
                                  text: circle['name'] ?? "",
                                  fontSize: 16,
                                  color: black171,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
