import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../utils/colors.dart';

class RoundedButton extends StatelessWidget {
  final String title;
  bool loading;
  final VoidCallback onPress;
  Color color, textColor;
  RoundedButton({
    Key? key,
    required this.title,
    this.loading = false,
    required this.onPress,
    required this.color,
    this.textColor = AppColors.appColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: ElevatedButton(
        onPressed: onPress,
        style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            minimumSize: const Size.fromHeight(48)),
        child: loading
            ? LoadingAnimationWidget.progressiveDots(
                color: Colors.white, size: 50)
            : Center(
                child: Text(
                  title,
                  style: TextStyle(
                      color: textColor,
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
      ),
    );
  }
}
