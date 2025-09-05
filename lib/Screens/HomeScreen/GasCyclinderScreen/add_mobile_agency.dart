import 'package:digitalwalletpaytmcloneapp/Constants/colors.dart';
import 'package:digitalwalletpaytmcloneapp/Constants/images.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_text_widget.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_textfeild_widget.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/lists_view.dart';
import 'package:digitalwalletpaytmcloneapp/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:digitalwalletpaytmcloneapp/Service/Api.dart';

class AddMobileAgency extends StatefulWidget {
  const AddMobileAgency({Key? key}) : super(key: key);

  @override
  State<AddMobileAgency> createState() => _AddMobileAgencyState();
}

class _AddMobileAgencyState extends State<AddMobileAgency> {
  dynamic selectedOperator;
  final TextEditingController searchController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  bool isLoading = true;
  List<dynamic> circles = [];
  List<dynamic> filteredCircles = [];
  dynamic selectedState;

  @override
  void initState() {
    super.initState();
    selectedOperator = Get.arguments;
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

void _showStateDialog() {
  showModalBottomSheet(
    context: context,
    backgroundColor: white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CommonTextFieldWidget.TextFormField2(
              prefixIcon: Padding(
                padding: const EdgeInsets.all(15),
                child: SvgPicture.asset(
                  Images.search,
                  color: Colors.green,
                ),
              ),
              keyboardType: TextInputType.text,
              hintText: "Search State",
              controller: searchController,
            ),
            const SizedBox(height: 20),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.green),
                  )
                : SizedBox(
                    height: 300, // set a fixed height for ListView
                    child: ListView.builder(
                      itemCount: filteredCircles.length,
                      itemBuilder: (context, index) {
                        final state = filteredCircles[index];
                        return ListTile(
                          title: CommonTextWidget.InterMedium(
                            text: state['name'] ?? "",
                            fontSize: 16,
                            color: black171,
                          ),
                          onTap: () {
                            setState(() {
                              selectedState = state['name'];
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
          ],
        ),
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        leading: InkWell(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back, size: 22, color: black171),
        ),
        centerTitle: true,
        title: CommonTextWidget.InterBold(
          text: "Add Mobile Agency",
          fontSize: 18,
          color: black171,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 25),
            child: SvgPicture.asset(Images.information),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selected Provider
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: CommonTextWidget.InterSemiBold(
                text: "Provider: ${selectedOperator['name'] ?? ''}",
                fontSize: 16,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 20),

            // Mobile Number Input
            CommonTextFieldWidget.TextFormField2(
              controller: mobileController,
              keyboardType: TextInputType.phone,
              hintText: "Enter Mobile Number",
              prefixIcon: Padding(
                padding: EdgeInsets.all(15),
                child: Icon(Icons.phone, color: Colors.green),
              ),
            ),
            SizedBox(height: 20),

            // Select State (as input style)
            InkWell(
              onTap: _showStateDialog,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                decoration: BoxDecoration(
                  border: Border.all(color: greyE5E, width: 1),
                  borderRadius: BorderRadius.circular(16),
                  color: white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonTextWidget.InterMedium(
                      text: selectedState ?? "Select State",
                      fontSize: 16,
                      color: selectedState == null ? grey757 : black171,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
