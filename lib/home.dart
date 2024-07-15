import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tiptop/utils/colors.dart';
import 'package:group_button/group_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController totalPriceController = TextEditingController();
  final tipController = GroupButtonController();
  int totalTip = 0;
  int? selectedTipIndex;
  double? selectedTip;
  double? customTip;

  void tipSelection(selectedTipIndex) {
    if (selectedTipIndex == 0) {
      setState(() {
        selectedTip = 0.10;
      });
    } else if (selectedTipIndex == 1) {
      setState(() {
        selectedTip = 0.12;
      });
    } else if (selectedTipIndex == 2) {
      setState(() {
        selectedTip = 0.15;
      });
    } else if (selectedTipIndex == 3) {
      setState(() {
        selectedTip = 0.20;
      });
    } else if (selectedTipIndex == 4) {
      setState(() {
        selectedTip = customTip ?? 0.0;
      });
    }

    calculateTotalTip();
  }

  int calculateTotalTip() {
    // Convert the text to a double value, defaulting to 0 if the conversion fails
    double totalPrice = double.tryParse(totalPriceController.text) ?? 0;
    // Ensure selectedTip is not null by providing a default value
    double tipPercentage = selectedTip ?? 0.0;
    // Calculate the total tip
    int roundedTotalTip = (totalPrice * tipPercentage).round();
    setState(() {
      totalTip = roundedTotalTip;
    });

    return roundedTotalTip;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: primaryColor,
        title: Image.asset(
          "images/toplogo.png",
          width: 200,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius:
                    BorderRadius.circular(12.0), // Adjust the radius as needed
              ),
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  const Text(
                    "Total Price :",
                    style: TextStyle(color: secondaryColor, fontSize: 20),
                  ),
                  TextField(
                    style: const TextStyle(color: secondaryColor, fontSize: 40),
                    textAlign: TextAlign.center,
                    controller: totalPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Enter Total Price...",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: secondaryColor,
                        fontSize: 20,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                const Text(
                  "Select Tip :",
                  style: TextStyle(color: secondaryColor, fontSize: 18),
                ),
                GroupButton(
                  controller: tipController,
                  buttons: ['10%', '12%', '15%', "20%", "Other"],
                  onSelected: (String value, int index, bool isSelected) {
                    setState(() {
                      selectedTipIndex = index;
                    });
                    tipSelection(index);
                    print('Button #$index $value is selected: $isSelected');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 60,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Center(
                child: Text(
                  "Total Tip : $totalTip",
                  style: const TextStyle(color: secondaryColor, fontSize: 20),
                ),
              ),
            ),
          ),
          const SizedBox(
              height:
                  20), // Gap between the bottom navigation bar and the screen
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    totalPriceController.dispose();
  }
}
