import 'package:digitalwalletpaytmcloneapp/Constants/colors.dart';
import 'package:digitalwalletpaytmcloneapp/Constants/images.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_text_widget.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_textfeild_widget.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/lists_view.dart';
import 'package:digitalwalletpaytmcloneapp/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AllServicesScreen extends StatefulWidget {
  const AllServicesScreen({Key? key}) : super(key: key);

  @override
  State<AllServicesScreen> createState() => _AllServicesScreenState();
}

class _AllServicesScreenState extends State<AllServicesScreen> {
  int _selectedIndex = 0;
  final TextEditingController searchController = TextEditingController();
List<Map<String, dynamic>> filteredServices = [];

 @override
void initState() {
  super.initState();

  // Properly cast original list
  filteredServices = Lists.allServicesList
      .map((e) => Map<String, dynamic>.from(e))
      .toList();

  // Listen to search input
  searchController.addListener(() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredServices = Lists.allServicesList
          .map((e) => Map<String, dynamic>.from(e))
          .where((service) =>
              service["text"].toString().toLowerCase().contains(query))
          .toList();
    });
  });
}

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 45, left: 25, right: 25, bottom: 10),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(Icons.arrow_back, size: 20, color: black171),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: CommonTextFieldWidget.TextFormField2(
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(15),
                      child:SvgPicture.asset(Images.search, color: Colors.green),
                    ),
                    keyboardType: TextInputType.text,
                    hintText: "Search",
                    controller: searchController,
                  ),
                ),
              ],
            ),
          ),
          Divider(thickness: 1, color: greyEDE),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Expanded(
                  child: ScrollConfiguration(
                    behavior: MyBehavior(),
        child: SingleChildScrollView(
  child: GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 4,
      mainAxisSpacing: 15,
      crossAxisSpacing: 5,
      childAspectRatio:
          MediaQuery.of(context).size.aspectRatio * 2 / 1.3,
    ),
    shrinkWrap: true,
    primary: false,
    physics: NeverScrollableScrollPhysics(),
    padding: EdgeInsets.symmetric(horizontal: 22),
    itemCount: filteredServices.length, // <-- use filteredServices
    itemBuilder: (context, index) {
      final service = filteredServices[index];
      return Column(
        children: [
          Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: white,
                  spreadRadius: 0,
                  offset: Offset(0, 0),
                  blurRadius: 12,
                ),
              ],
              color: white,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: service["image"].toString().endsWith(".png") 
                  ? Image.asset(service["image"])
                  : SvgPicture.asset(
                      service["image"],
                      color: Colors.green,
                    ),
            ),
          ),
          SizedBox(height: 5),
          CommonTextWidget.InterSemiBold(
            color: black171,
            text: service["text"],
            fontSize: 12,
            textAlign: TextAlign.center,
          ),
        ],
      );
    },
  ),
),

                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
