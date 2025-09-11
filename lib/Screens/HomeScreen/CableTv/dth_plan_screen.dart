import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DthPlansScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? {};
    final operator = args["operator"];
    final mobile = args["mobile"];
    final plans = args["plans"] ?? [];

    return Scaffold(
      appBar: AppBar(title: Text("$operator Plans")),
      body: plans.isEmpty
          ? Center(child: Text("No plans available"))
          : ListView.builder(
              itemCount: plans.length,
              itemBuilder: (context, index) {
                final plan = plans[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(plan["planname"]?.toString() ?? "No Plan"),
                    subtitle: Text("Monthly Recharge: ₹${plan["MonthlyRecharge"] ?? 0}"),
                  ),
                );
              },
            ),
    );
  }
}
