import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:respect/model/form_field_template.dart';
import '../utils/form_builder.dart';
import 'filter_menu_chip.dart';

class FormFieldCard extends StatefulWidget {
  const FormFieldCard(
      {super.key, required this.fieldIndex, required this.formFieldTemplate});

  final int fieldIndex;
  final FormFieldTemplate formFieldTemplate;

  @override
  State<FormFieldCard> createState() => _FormFieldCardState();
}

class _FormFieldCardState extends State<FormFieldCard> {
  final titleTextFieldController = TextEditingController();
  final shortTextFieldController = TextEditingController();
  final longTextFieldController = TextEditingController();
  List<TextEditingController> multipleControllers = [];
  List<TextEditingController> checkBoxesControllers = [];

  FormFieldType selectedType = FormFieldType.short;
  late List<String> options;
  late String selectedOption;
  late List<String> checkBoxes;
  late List<String> selectedBoxes;

  void _initFields() {
    titleTextFieldController.text = widget.formFieldTemplate.title;
    shortTextFieldController.text = widget.formFieldTemplate.shortText;
    longTextFieldController.text = widget.formFieldTemplate.longText;
    options = widget.formFieldTemplate.options;
    selectedOption = widget.formFieldTemplate.selectedOption;
    checkBoxes = widget.formFieldTemplate.checkBoxes;
    selectedBoxes = widget.formFieldTemplate.selectedBoxes;

    for (var option in widget.formFieldTemplate.options) {
      multipleControllers.add(TextEditingController());
      multipleControllers.last.text = option;
    }
    selectedOption = widget.formFieldTemplate.selectedOption;
    for (var box in widget.formFieldTemplate.checkBoxes) {
      checkBoxesControllers.add(TextEditingController());
      checkBoxesControllers.last.text = box;
    }
    selectedBoxes = widget.formFieldTemplate.selectedBoxes;
  }

  @override
  void initState() {
    _initFields();

    super.initState();
  }

  @override
  void dispose() {
    titleTextFieldController.dispose();
    shortTextFieldController.dispose();
    longTextFieldController.dispose();
    for (var controller in multipleControllers) {
      controller.dispose();
    }
    selectedOption = widget.formFieldTemplate.selectedOption;
    for (var controller in checkBoxesControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var formField =
        context.watch<FormBuilder>().formFieldList[widget.fieldIndex];

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Column(
        children: [
          const SizedBox(height: 34.0),
          Row(
            children: [
              Text(
                '질문 ${widget.fieldIndex + 1}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF000000),
                  fontFamily: 'Pretendard',
                ),
              ),
              const Spacer(),
              CupertinoButton(
                padding: const EdgeInsets.all(0.0),
                child: const Icon(
                  CupertinoIcons.trash_fill,
                  color: Color(0xFFAEAEB2),
                ),
                onPressed: () {
                  context
                      .read<FormBuilder>()
                      .removeFormField(index: widget.fieldIndex);
                },
              )
            ],
          ),
          Row(
            children: [
              PullDownButton(
                itemBuilder: (context) => FormFieldType.values.map((type) {
                  return PullDownMenuItem.selectable(
                    onTap: () {
                      setState(() {
                        formField.type = type;
                      });
                      if (type == FormFieldType.short) {
                        formField.shortText = '';
                        shortTextFieldController.text = '';
                      }
                      if (type == FormFieldType.long) {
                        formField.longText = '';
                        longTextFieldController.text = '';
                      }
                      if (type == FormFieldType.multiple) {
                        setState(() {
                          options = ['옵션 1', '옵션 2'];
                          selectedOption = '옵션 1';
                          multipleControllers = [
                            TextEditingController(),
                            TextEditingController()
                          ];
                          multipleControllers[0].text = '옵션 1';
                          multipleControllers[1].text = '옵션 2';
                        });
                        formField.options = ['옵션 1', '옵션 2'];
                      }
                      if (type == FormFieldType.checkBox) {
                        setState(() {
                          checkBoxes = ['옵션 1', '옵션 2'];
                          formField.selectedBoxes = [];
                          checkBoxesControllers = [
                            TextEditingController(),
                            TextEditingController()
                          ];
                          checkBoxesControllers[0].text = '옵션 1';
                          checkBoxesControllers[1].text = '옵션 2';
                        });
                        formField.checkBoxes = ['옵션 1', '옵션 2'];
                      }
                    },
                    title: type.convertToString,
                  );
                }).toList(),
                buttonBuilder: (context, showMenu) => CupertinoButton(
                  onPressed: showMenu,
                  padding: EdgeInsets.zero,
                  child: FilterMenuChip(
                    chipName: formField.type.convertToString,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          TextField(
            controller: titleTextFieldController,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(20.0),
              hintText: '제목을 입력하세요.',
              hintMaxLines: 1,
              hintStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black,
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
              formField.title = text;
            },
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontFamily: 'Pretendard',
            ),
          ),
          const SizedBox(height: 6.0),
          if (formField.type == FormFieldType.short)
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
                formField.shortText = text;
              },
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.black,
                fontFamily: 'Pretendard',
              ),
            ),
          if (formField.type == FormFieldType.long)
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
                formField.longText = text;
              },
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.black,
                fontFamily: 'Pretendard',
              ),
            ),
          if (formField.type == FormFieldType.multiple)
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
                      final controllerIndex = options.indexOf(option);
                      return RadioListTile(
                        value: option,
                        groupValue: selectedOption,
                        title: TextField(
                          controller:
                              multipleControllers[controllerIndex],
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                              hintText: option,
                              hintMaxLines: 1,
                              hintStyle: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Color(0XFF636366),
                                fontFamily: 'Pretendard',
                              ),
                              border: InputBorder.none),
                          onChanged: (text) {
                            setState(() {
                              options[options.indexOf(option)] = text;
                            });
                            formField.options[
                                formField.options.indexOf(option)] = text;
                          },
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
                          formField.selectedOption = option ?? '';
                        },
                        activeColor: Colors.black,
                      );
                    }).toList(),
                  ),
                  RadioListTile(
                    value: null,
                    groupValue: context
                        .watch<FormBuilder>()
                        .getFormFieldList()[widget.fieldIndex]
                        .selectedOption,
                    title: const Text(
                      '옵션 추가',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Color(0XFF636366),
                        fontFamily: 'Pretendard',
                      ),
                    ),
                    onChanged: (_) {
                      setState(() {
                        options.add('옵션 ${options.length + 1}');
                        multipleControllers.add(TextEditingController());
                      });
                      formField.options
                          .add('옵션 ${formField.options.length + 1}');
                    },
                  ),
                ],
              ),
            ),
          if (formField.type == FormFieldType.checkBox)
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
                    children: checkBoxes.map((option) {
                      final controllerIndex = options.indexOf(option);
                      return ListTile(
                        title: TextField(
                          controller:
                              checkBoxesControllers[controllerIndex],
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                              hintText: option,
                              hintMaxLines: 1,
                              hintStyle: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Color(0XFF636366),
                                fontFamily: 'Pretendard',
                              ),
                              border: InputBorder.none),
                          onChanged: (text) {
                            setState(() {
                              checkBoxes[checkBoxes.indexOf(option)] = text;
                            });
                            formField.checkBoxes[
                                formField.checkBoxes.indexOf(option)] = text;
                          },
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
                              } else {
                                selectedBoxes.add(option);
                              }
                            });
                            if (formField.selectedBoxes.contains(option)) {
                              formField.selectedBoxes.remove(option);
                            } else {
                              formField.selectedBoxes.remove(option);
                            }
                          },
                          checkColor: Colors.white,
                          activeColor: Colors.black,
                        ),
                      );
                    }).toList(),
                  ),
                  CupertinoButton(
                    padding: const EdgeInsets.all(0.0),
                    child: ListTile(
                      title: const Text(
                        '옵션 추가',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(0XFF636366),
                          fontFamily: 'Pretendard',
                        ),
                      ),
                      leading: Checkbox(
                        value: false,
                        onChanged: (_) {},
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        checkBoxes.add('옵션 ${checkBoxes.length + 1}');
                        checkBoxesControllers.add(TextEditingController());
                      });
                      formField.checkBoxes
                          .add('옵션 ${formField.checkBoxes.length + 1}');
                    },
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}
