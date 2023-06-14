import 'package:flutter/material.dart';
import 'package:respect/model/form_field_template.dart';

// ignore: must_be_immutable
class ApplyFieldCard extends StatefulWidget {
  ApplyFieldCard({super.key, required this.formFieldTemplate});

  FormFieldTemplate formFieldTemplate;

  @override
  State<ApplyFieldCard> createState() => _ApplyFieldCardState();
}

class _ApplyFieldCardState extends State<ApplyFieldCard> {
  final shortTextFieldController = TextEditingController();
  final longTextFieldController = TextEditingController();

  late List<String> options;
  late List<String> checkBoxes;

  String? shortText;
  String? longText;
  String? selectedOption;
  List<String?> selectedBoxes = [];

  void _initFields() {
    options = widget.formFieldTemplate.options;
    checkBoxes = widget.formFieldTemplate.checkBoxes;
    widget.formFieldTemplate.selectedBoxes.clear();
  }

  @override
  void initState() {
    _initFields();

    super.initState();
  }

  @override
  void dispose() {
    shortTextFieldController.dispose();
    longTextFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Column(
        children: [
          const SizedBox(height: 12.0),
          Row(
            children: [
              Text(
                widget.formFieldTemplate.title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF000000),
                  fontFamily: 'Pretendard',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          if (widget.formFieldTemplate.type == FormFieldType.short)
            TextField(
              controller: shortTextFieldController,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(20.0),
                hintText: '단답형 텍스트',
                hintMaxLines: 1,
                hintStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF969696),
                  fontFamily: 'Pretendard',
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
                filled: true,
                fillColor: const Color(0xFFF4F4F4),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
              ),
              onChanged: (text) {
                shortText = text;
                widget.formFieldTemplate.shortText = text;
              },
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.black,
                fontFamily: 'Pretendard',
              ),
            ),
          if (widget.formFieldTemplate.type == FormFieldType.long)
            TextField(
              controller: longTextFieldController,
              cursorColor: Colors.black,
              maxLines: 15,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(20.0),
                hintText: '장문형 텍스트',
                hintMaxLines: 15,
                hintStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF969696),
                  fontFamily: 'Pretendard',
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
                filled: true,
                fillColor: const Color(0xFFF4F4F4),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
              ),
              onChanged: (text) {
                longText = text;
                widget.formFieldTemplate.longText = text;
              },
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.black,
                fontFamily: 'Pretendard',
              ),
            ),
          if (widget.formFieldTemplate.type == FormFieldType.multiple)
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF4F4F4),
                borderRadius: BorderRadius.all(
                  Radius.circular(6.0),
                ),
              ),
              child: Column(
                children: [
                  Column(
                    children: options.map((option) {
                      return RadioListTile(
                        value: option,
                        groupValue: selectedOption,
                        title: Text(
                          option,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontFamily: 'Pretendard',
                          ),
                        ),
                        onChanged: (option) {
                          setState(() {
                            selectedOption = option ?? '';
                          });
                          widget.formFieldTemplate.selectedOption = option ?? '';
                        },
                        activeColor: Colors.black,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          if (widget.formFieldTemplate.type == FormFieldType.checkBox)
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF4F4F4),
                borderRadius: BorderRadius.all(
                  Radius.circular(6.0),
                ),
              ),
              child: Column(
                children: checkBoxes.map((option) {
                  return ListTile(
                    title: Text(
                      option,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontFamily: 'Pretendard',
                      ),
                    ),
                    leading: Checkbox(
                      value: selectedBoxes.contains(option),
                      onChanged: (value) {
                        setState(() {
                          if (selectedBoxes.contains(option)) {
                            selectedBoxes.remove(option);
                            widget.formFieldTemplate.selectedBoxes.remove(option);
                          } else {
                            selectedBoxes.add(option);
                            widget.formFieldTemplate.selectedBoxes.add(option);
                          }
                        });
                      },
                      checkColor: Colors.white,
                      activeColor: Colors.black,
                    ),
                  );
                }).toList(),
              ),
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
