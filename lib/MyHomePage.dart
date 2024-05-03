import 'package:flutter/material.dart';
import 'MyFunctions.dart';
import 'package:get/get.dart';
import 'MyFunctions.dart'; // Import ColorController class

class MyHomePage extends StatelessWidget {
  final ColorController colorController = Get.put(ColorController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('My App'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() => Container(
                  width: 1,
                  height: 1,
                  color: colorController.selectedColor.value,
                )),
                SizedBox(height: 13.0),
                ElevatedButton(
                  onPressed: () {
                    RenderBox renderBox = context.findRenderObject() as RenderBox;
                    Offset buttonPosition = renderBox.localToGlobal(Offset.zero);
                    ColorController.showColorMenu(context, buttonPosition);
                  },
                  child: Obx(() => Text(
                    '${ColorController.getColorName(colorController.selectedColor.value)}',
                    style: TextStyle(
                      color: colorController.getTextFieldBorderColor(),
                    ),
                  ),
                  ),
                ),
                SizedBox(height: 16.0),
                Obx(() => Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  width: 350,
                  child: Slider(
                    value: colorController.selectedSpeed.value.toDouble(),
                    min: 1,
                    max: 3,
                    divisions: 2,
                    onChanged: (value) {
                      colorController.selectedSpeed.value = value.toInt();
                      colorController.resetAnimation();
                      if (value.toInt() == 1) {
                        colorController.resetAnimation(); // Reset animation when transitioning to slow
                      }
                    },
                    activeColor: colorController.selectedColor.value,
                    inactiveColor: Colors.grey[300],
                    label: ColorController.getLabelForSpeed(colorController.selectedSpeed.value),
                  ),
                )),
                SizedBox(height: 16.0),
                Obx(() => Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  width: 350,
                  child: TextField(
                    cursorColor:colorController.getTextFieldBorderColor() ,
                    onChanged: (value) {
                      colorController.totalItems.value = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'Total Items',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: colorController.getTextFieldBorderColor(),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: colorController.getTextFieldBorderColor(),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: colorController.getTextFieldBorderColor(),
                        ),
                      ),
                      labelStyle: TextStyle(
                        color: colorController.getTextFieldTextColor(),
                      ),
                    ),
                    style: TextStyle(
                      color: colorController.getTextFieldTextColor(),
                    ),
                  ),
                )),
                SizedBox(height: 16.0),
                Obx(() => Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  width: 350,
                  child: TextField(
                    cursorColor:colorController.getTextFieldBorderColor() ,
                    onChanged: (value) {
                      colorController.itemsInLine.value = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'Items in Line',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: colorController.getTextFieldBorderColor(),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: colorController.getTextFieldBorderColor(),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: colorController.getTextFieldBorderColor(),
                        ),
                      ),
                      labelStyle: TextStyle(
                        color: colorController.getTextFieldTextColor(),
                      ),
                    ),
                    style: TextStyle(
                      color: colorController.getTextFieldTextColor(),
                    ),
                  ),
                )),
                SizedBox(height: 16.0),
                Obx(() {
                  final total = int.tryParse(colorController.totalItems.value) ?? 0;
                  final inLine = int.tryParse(colorController.itemsInLine.value) ?? 0;
                  final List<Widget> progressBars = List.generate(
                    ColorController.calculateRows(total, inLine),
                        (rowIndex) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                            inLine,
                                (itemIndex) {
                              final itemNumber = rowIndex * inLine + itemIndex + 1;
                              return Expanded(
                                child: itemNumber <= total
                                    ? Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  child: AnimatedBuilder(
                                    animation: colorController.animationController, // Accessing the animation controller here
                                    builder: (context, child) {
                                      final animation = Tween<double>(
                                        begin: 0.0,
                                        end: 1.0,
                                      ).animate(
                                        CurvedAnimation(
                                          parent: colorController.animationController, // Accessing the animation controller here
                                          curve: Interval(
                                            (itemNumber - 1) / total,
                                            itemNumber / total,
                                            curve: Curves.linear,
                                          ),
                                        ),
                                      );
                                      return Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.black),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: LinearProgressIndicator(
                                          value: animation.value,
                                          backgroundColor: Colors.grey[300],
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            colorController.selectedColor.value,
                                          ),
                                          minHeight: 12,
                                        ),
                                      );
                                    },
                                  ),
                                )
                                    : SizedBox(),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                  return Column(
                    children: progressBars,
                  );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
