import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ColorController extends GetxController with SingleGetTickerProviderMixin {
  var selectedColor = Colors.blue.obs;
  var selectedSpeed = 2.obs; // Initial speed set to smooth
  var totalItems = ''.obs;
  var itemsInLine = ''.obs;
  // late AnimationController _controller;
  late AnimationController _controller;

  AnimationController get animationController => _controller;
  Color getTextFieldBorderColor() {
    return selectedColor.value.withOpacity(0.7);
  }

  Color getTextFieldCursorColor() {
    return selectedColor.value;
  }

  Color getTextFieldTextColor() {
    return selectedColor.value;
  }

  double calculateProgress() {
    if (totalItems.value.isEmpty || itemsInLine.value.isEmpty) {
      return 0.0;
    }
    int total = int.tryParse(totalItems.value) ?? 0;
    int inLine = int.tryParse(itemsInLine.value) ?? 0;
    return inLine / total;
  }

  @override
  void onInit() {
    super.onInit();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 2));
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        resetAnimation(); // Reset animation when it completes
      }
    });
    selectedSpeed.listen((value) {
      // Map slider values to corresponding animation durations
      switch (value) {
        case 1:
          _controller.duration = Duration(seconds: 9);
          break;
        case 2:
          _controller.duration = Duration(seconds: 4);
          break;
        case 3:
          _controller.duration = Duration(seconds: 2);
          break;
      }
    });
    itemsInLine.listen((value) {
      if (value.isNotEmpty) {
        resetAnimation();
      }
    });
  }

  @override
  void onClose() {
    _controller.dispose();
    super.onClose();
  }

  void resetAnimation() {
    _controller.reset();
    _controller.forward();
  }

  static void showColorMenu(BuildContext context, Offset buttonPosition) {
    final List<String> colors = ['Red', 'Green', 'Blue', 'Purple'];

    final buttonSize = context.findRenderObject()!.paintBounds.size;
    final buttonCenter = buttonPosition + Offset(buttonSize.width / 2, buttonSize.height / 2);

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        buttonCenter.dx - 100, // Adjust the x-coordinate to center the menu above the button
        buttonPosition.dy - 10, // Adjust the y-coordinate to position the menu above the button
        buttonCenter.dx + 100,
        buttonPosition.dy + 10,
      ),
      items: colors.map((String color) {
        return PopupMenuItem<String>(
          value: color,
          child: Text(color),
        );
      }).toList(),
    ).then((String? color) {
      if (color != null) {
        switch (color) {
          case 'Red':
            Get.find<ColorController>().selectedColor.value = Colors.red;
            break;
          case 'Green':
            Get.find<ColorController>().selectedColor.value = Colors.green;
            break;
          case 'Blue':
            Get.find<ColorController>().selectedColor.value = Colors.blue;
            break;
          case 'Purple':
            Get.find<ColorController>().selectedColor.value = Colors.purple;
            break;
          default:
            Get.find<ColorController>().selectedColor.value = Colors.blue;
        }
      }
    });
  }

  static int calculateRows(int totalItems, int itemsInLine) {
    if (totalItems <= 0 || itemsInLine <= 0) {
      return 0;
    }
    final double rowsDouble = totalItems / itemsInLine;
    final int rows = rowsDouble.ceil();
    return rows;
  }

  static String getColorName(Color color) {
    if (color == Colors.red) {
      return 'Red';
    } else if (color == Colors.green) {
      return 'Green';
    } else if (color == Colors.blue) {
      return 'Blue';
    } else if (color == Colors.purple) {
      return 'Purple';
    } else {
      return 'Unknown';
    }
  }

  static String getLabelForSpeed(int speed) {
    switch (speed) {
      case 1:
        return 'Slow';
      case 2:
        return 'Smooth';
      case 3:
        return 'Fast';
      default:
        return '';
    }
  }
}
