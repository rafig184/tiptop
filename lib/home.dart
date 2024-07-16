import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
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
  TextEditingController customTipController = TextEditingController();
  List<TextEditingController> controllers = [];
  final tipController = GroupButtonController();
  final FocusNode _focusNode = FocusNode();
  int totalTip = 0;
  int? selectedTipIndex;
  double? selectedTip;
  bool isCustomTip = false;
  String otherTip = "Other";
  List<Widget> textFields = [];
  List personalTips = [];
  int userIndex = 0;
  int personalTip = 0;

  void tipSelection(selectedTipIndex) {
    if (selectedTipIndex == 0) {
      setState(() {
        selectedTip = 0.10;
        isCustomTip = false;
        customTipController.clear();
      });
    } else if (selectedTipIndex == 1) {
      setState(() {
        selectedTip = 0.12;
        isCustomTip = false;
        customTipController.clear();
      });
    } else if (selectedTipIndex == 2) {
      setState(() {
        selectedTip = 0.15;
        isCustomTip = false;
        customTipController.clear();
      });
    } else if (selectedTipIndex == 3) {
      _showMyDialog();
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

  void calculatePersonalTip(int index) {
    setState(() {
      double cost = double.tryParse(controllers[index].text) ?? 0.0;
      double personalTip = cost * (selectedTip ?? 0.0);

      // Update the state with the calculated personal tip
      personalTips[index] = personalTip;
    });
    print(personalTips);
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Dialog(
                backgroundColor: backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const Text(
                        "Choose another Tip here:",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: secondaryColor),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        onChanged: (val) {
                          if (val.isNotEmpty) {
                            if (int.parse(val) >= 99) {
                              customTipController.text = "99";
                            }
                          }
                        },
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        controller: customTipController,
                        decoration: const InputDecoration(
                          hintText: "Type your own tip in %",
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              onPressed: () {
                                String fixedPresentageTip =
                                    '0.${customTipController.text}';
                                double fixedCustomeTip =
                                    double.tryParse(fixedPresentageTip) ?? 0;

                                setState(() {
                                  selectedTip = fixedCustomeTip;
                                  isCustomTip = true;
                                });
                                Navigator.of(context).pop();

                                calculateTotalTip();
                              },
                              child: const Text("OK")),
                          const SizedBox(
                            width: 15,
                          ),
                          TextButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                customTipController.clear();
                              },
                              child: const Text("Close")),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> errorDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Dialog(
                backgroundColor: backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const Text(
                        "Please select total price first..",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("OK",
                                  style: TextStyle(color: secondaryColor)))
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _addTextField() {
    setState(() {
      userIndex = userIndex + 1;

      TextEditingController controller = TextEditingController();
      controllers.add(controller);

      textFields.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    onSubmitted: (String value) {
                      calculatePersonalTip(userIndex);
                    },
                    controller: controller,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    decoration: InputDecoration(
                      icon:
                          const Icon(Icons.credit_card, color: secondaryColor),
                      filled: true,
                      fillColor: inputsColor,
                      border: InputBorder.none,
                      labelText: 'TipToper $userIndex cost',
                    ),
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                          ),
                          color: Colors.white,
                        ),
                        height: 55,
                        child: Center(
                          child: Text(
                            'Tip : $personalTip',
                            style: const TextStyle(
                              color: secondaryColor,
                              fontSize: 20,
                            ),
                          ),
                        ))),
              ],
            ),
          ),
        ),
      );
    });
    print(controllers);
  }

  @override
  Widget build(BuildContext context) {
    otherTip = customTipController.text.isNotEmpty
        ? '${customTipController.text}%'
        : "Other";

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
      body: InkWell(
          highlightColor: Colors.transparent,
          focusColor: Colors.transparent,
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: () {
            // Unfocus the TextField when tapping outside
            _focusNode.unfocus();
          },
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 5),
                      const Text(
                        "Total Price :",
                        style: TextStyle(color: secondaryColor, fontSize: 20),
                      ),
                      TextField(
                        focusNode: _focusNode,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                        onSubmitted: (val) => _focusNode.unfocus(),
                        onChanged: (val) {
                          if (val.isEmpty) {
                            setState(() {});
                          }
                        },
                        style: const TextStyle(
                            color: secondaryColor, fontSize: 40),
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
                      buttons: ['10%', '12%', '15%', otherTip],
                      onSelected: (String value, int index, bool isSelected) {
                        if (totalPriceController.text.isEmpty) {
                          selectedTipIndex = null;
                          errorDialog();
                          return;
                        }
                        setState(() {
                          selectedTipIndex = index;
                        });
                        tipSelection(index);
                      },
                      options: GroupButtonOptions(
                        selectedColor: secondaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    IconButton.filledTonal(
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(secondaryColor),
                        ),
                        color: Colors.white,
                        onPressed: () {
                          _addTextField();
                        },
                        icon: const Icon(Icons.add)),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: textFields.length,
                    itemBuilder: (context, index) {
                      return textFields[index];
                    },
                  ),
                ),
              ],
            ),
          )),
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
                child: totalPriceController.text.isEmpty
                    ? const Text(
                        "Total Tip : 0",
                        style: TextStyle(color: secondaryColor, fontSize: 20),
                      )
                    : Text("Total Tip : $totalTip",
                        style: const TextStyle(
                            color: secondaryColor, fontSize: 20)),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    totalPriceController.dispose();
    _focusNode.dispose();
  }
}
