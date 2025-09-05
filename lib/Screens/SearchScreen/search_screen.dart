import 'package:digitalwalletpaytmcloneapp/Constants/colors.dart';
import 'package:digitalwalletpaytmcloneapp/Constants/images.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_grid_widget_view.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_text_widget.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/common_textfeild_widget.dart';
import 'package:digitalwalletpaytmcloneapp/Utils/lists_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> filteredList = [];

  @override
  void initState() {
    super.initState();
    // Initialize filtered list with original data
    filteredList = Lists.ticketBookingList
        .map((e) => Map<String, dynamic>.from(e))
        .toList();

    // Listen to search input
    searchController.addListener(() {
      final query = searchController.text.toLowerCase();
      setState(() {
        filteredList = Lists.ticketBookingList
            .map((e) => Map<String, dynamic>.from(e))
            .where((item) =>
                item["text"].toString().toLowerCase().contains(query))
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
      backgroundColor: whiteFBF,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TextField Widget View
            TextFieldWidgetView(),

            /// Body Widget View
            BodyWidgetView(context),
          ],
        ),
      ),
    );
  }

  /// TextField Widget View
  Widget TextFieldWidgetView() {
    return Padding(
      padding: EdgeInsets.only(top: 45, left: 25, right: 25, bottom: 20),
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
                child: SvgPicture.asset(Images.search, color: Colors.green),
              ),
              keyboardType: TextInputType.text,
              hintText: "Search",
              controller: searchController,
            ),
          ),
        ],
      ),
    );
  }

  /// Body Widget View
  Widget BodyWidgetView(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: CommonTextWidget.InterBold(
            color: black171,
            text: "All Services",
            fontSize: 18,
          ),
        ),
        SizedBox(height: 15),
        CommonGridWidget.grid(
          context,
          filteredList, // <-- Use filtered list here
          () {},
        ),
      ],
    );
  }
}
