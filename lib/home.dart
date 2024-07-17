import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:tiptop/utils/colors.dart';
import 'package:group_button/group_button.dart';
import 'package:collection/collection.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
  List personalBills = [];
  int userIndex = 0;
  int personalTip = 0;
  num tipSum = 0;
  num billSum = 0;
  num personalBillSum = 0;
  num tipLeft = 0;
  num billLeft = 0;
  double totalPriceWithTip = 0;
  List totalPersonalWithTip = [];

  Future<void> tipSelection(selectedTipIndex) async {
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
    await totalTipsSum();
    await totalBillsSum();
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
    double cost = double.tryParse(controllers[index].text) ?? 0.0;
    double personalTip = cost * (selectedTip ?? 0.0);
    var totalPersonalWithTips = cost + personalTip;
    // Update the state with the calculated personal tip
    setState(() {
      personalTips[index] = personalTip;
      personalBills[index] = cost;
      totalPersonalWithTip[index] = totalPersonalWithTips;
    });
    print(personalTips);
    print(totalPersonalWithTips);
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
                              onPressed: () async {
                                String fixedPresentageTip =
                                    '0.${customTipController.text}';
                                double fixedCustomeTip =
                                    double.tryParse(fixedPresentageTip) ?? 0;

                                setState(() {
                                  selectedTip = fixedCustomeTip;
                                  isCustomTip = true;
                                });
                                for (int i = 0; i < controllers.length; i++) {
                                  calculatePersonalTip(i);
                                  // calculatePersonalBill(i);
                                }
                                calculateTotalTip();
                                await totalTipsSum();
                                await totalBillsSum();
                                Navigator.of(context).pop();
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

  Future<void> errorDialog(text) async {
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
                      Text(
                        text,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
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
                                setState(() {});
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
      personalTips.add(0.0);
      personalBills.add(0.0);
      totalPersonalWithTip.add(0.0);
    });
  }

  Future<void> deletePersonalBill(dynamic index) async {
    setState(() {
      userIndex = userIndex - 1;
      controllers.removeAt(index);
      personalBills.removeAt(index);
      personalTips.removeAt(index);
      totalPersonalWithTip.removeAt(index);
    });
    calculateTotalTip();
    await totalTipsSum();
    await totalBillsSum();
  }

  Future<void> totalTipsSum() async {
    setState(() {
      tipSum = 0.0;
    });
    for (int i = 0; i < personalTips.length; i++) {
      tipSum += personalTips[i];
    }
    setState(() {
      tipLeft = totalTip - tipSum;
      tipLeft = double.parse(tipLeft.toStringAsFixed(2));

      double totalPrice = double.tryParse(totalPriceController.text) ?? 0.0;
      totalPriceWithTip = totalTip + totalPrice;
    });
    print('tipSum: $tipSum');
    print('tipLeft: $tipLeft');
  }

  // Future<void> totalBillsSum() async {
  //   setState(() {
  //     billSum = 0.0;
  //   });
  //   setState(() {
  //     for (int i = 0; i < personalBills.length; i++) {
  //       billSum += personalBills[i];
  //     }

  //     double totalPrice = double.tryParse(totalPriceController.text) ?? 0.0;
  //     billLeft = totalPrice - billSum;
  //   });

  //   print('bill sum: $billSum');
  //   print('bill Left: $billLeft');
  // }
  Future<void> totalBillsSum() async {
    double billSumTemp = 0.0;
    for (int i = 0; i < personalBills.length; i++) {
      billSumTemp += personalBills[i];
    }

    double totalPrice = double.tryParse(totalPriceController.text) ?? 0.0;
    setState(() {
      billSum = billSumTemp;
      billLeft = totalPrice - billSum;
    });

    print('bill sum: $billSum');
    print('bill Left: $billLeft');
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
                        "Total Bill :",
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
                          setState(() {
                            for (int i = 0; i < controllers.length; i++) {
                              calculatePersonalTip(i);
                              calculateTotalTip();
                              totalTipsSum();
                              totalBillsSum();
                            }
                          });

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
                    const SizedBox(height: 10),
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
                          errorDialog("Please select total price first..");
                          return;
                        } else {
                          setState(() {
                            selectedTipIndex = index;
                          });
                          tipSelection(index);
                          setState(() {
                            for (int i = 0; i < controllers.length; i++) {
                              calculatePersonalTip(i);
                              totalTipsSum();
                              totalBillsSum();
                            }
                          });

                          print(personalTips);
                        }
                      },
                      options: GroupButtonOptions(
                        selectedColor: secondaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    const SizedBox(height: 10),
                    IconButton.filledTonal(
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(secondaryColor),
                        ),
                        color: Colors.white,
                        onPressed: () {
                          if (totalTip == tipSum) {
                            errorDialog(
                                "You already calculate the whole bill..");
                            return;
                          } else {
                            _addTextField();
                          }
                        },
                        icon: const Icon(Icons.add)),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: userIndex,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Slidable(
                          startActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              extentRatio: 0.2,
                              children: [
                                SlidableAction(
                                  onPressed: (context) =>
                                      deletePersonalBill(index),
                                  icon: Icons.delete,
                                  backgroundColor: Colors.red.shade300,
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      bottomLeft: Radius.circular(12)),
                                ),
                              ]),
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            extentRatio: 0.6,
                            children: [
                              CustomSlidableAction(
                                onPressed: (context) {},
                                backgroundColor:
                                    const Color.fromARGB(255, 219, 219, 219),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                child: Text(
                                  'Total + Tip : ${totalPersonalWithTip[index].toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    color: secondaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          child: Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: TextField(
                                    style: const TextStyle(fontSize: 18),
                                    onChanged: (String value) async {
                                      num cost = int.tryParse(value) ?? 0;
                                      double newTip =
                                          cost * (selectedTip ?? 0.0);
                                      double totalPrice = double.tryParse(
                                              totalPriceController.text) ??
                                          0.0;

                                      setState(() {
                                        personalTips[index] = newTip;
                                        personalBills[index] = cost;
                                        totalPersonalWithTip[index] =
                                            cost + newTip;
                                      });

                                      // Calculate sums
                                      await totalTipsSum();
                                      await totalBillsSum();
                                      if (billSum > totalPrice) {
                                        print('new tip==> $newTip');
                                        print('total tip ==> $totalTip');
                                        print('tip sum ==> $tipSum');

                                        errorDialog(
                                            "You try to pay more than the bill is..");

                                        return;
                                      }
                                      // } else {
                                      //   calculatePersonalTip(index);
                                      //   await totalTipsSum();
                                      //   await totalBillsSum();
                                      // }
                                    },
                                    controller: controllers[index],
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d+\.?\d{0,2}')),
                                    ],
                                    decoration: InputDecoration(
                                      icon: const Icon(Icons.credit_card,
                                          color: secondaryColor),
                                      filled: true,
                                      fillColor: Colors.grey[200],
                                      border: InputBorder.none,
                                      labelText: 'TipToper ${index + 1} bill',
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
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Tip: ${personalTips[index].toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              color:
                                                  secondaryColor, // Replace with your secondary color
                                              fontSize: 20,
                                            ),
                                          ),
                                          const Icon(
                                              Icons
                                                  .keyboard_double_arrow_right_rounded,
                                              color: secondaryColor)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Text(
                  'Bill left to pay : $billLeft',
                  style: const TextStyle(
                    color: secondaryColor,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'Tips left to pay : $tipLeft',
                  style: const TextStyle(
                    color: secondaryColor,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          )),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 70,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 7),
                    Center(
                      child: totalPriceController.text.isEmpty
                          ? const Text(
                              "Total Tip : 0",
                              style: TextStyle(
                                  color: secondaryColor, fontSize: 18),
                            )
                          : Text("Total Tip : $totalTip",
                              style: const TextStyle(
                                  color: secondaryColor, fontSize: 18)),
                    ),
                    Text("Total Bill + Tip : $totalPriceWithTip",
                        style: const TextStyle(
                            color: secondaryColor, fontSize: 20)),
                  ],
                ),
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
