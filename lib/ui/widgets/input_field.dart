import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/ui/size_config.dart';
import 'package:todo/ui/theme.dart';

class InputField extends StatelessWidget {
  final String title;

  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  const InputField({
    super.key,
    required this.title,
    required this.hint,
    this.controller,
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: titleStyle),
          Container(
            width: SizeConfig.screenWidth,
            height: 52,
            padding: const EdgeInsets.only(left: 14),
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    style: subTitleStyle,
                    cursorColor:
                        Get.isDarkMode ? Colors.grey[100] : Colors.grey[700],
                    controller: controller,
                    autofocus: false,
                    readOnly: widget != null,
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: subTitleStyle,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: context.theme.colorScheme.surface,
                          width: 0,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          width: 0,
                          color: context.theme.colorScheme.surface,
                        ),
                      ),
                    ),
                  ),
                ),
                widget ?? Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
