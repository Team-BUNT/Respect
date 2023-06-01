import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:respect/model/form_field_template.dart';
import '../utils/form_maker.dart';
import 'filter_menu_chip.dart';

class FormFieldCard extends StatefulWidget {
  const FormFieldCard({super.key, required this.fieldIndex});

  final int fieldIndex;

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

  @override
  void dispose() {
    titleTextFieldController.dispose();
    shortTextFieldController.dispose();
    longTextFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<FormBuilder>(context);

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
                        context
                            .read<FormBuilder>()
                            .formFieldList[widget.fieldIndex]
                            .type = type;
                      });
                      if (type == FormFieldType.short) {
                        context
                            .read<FormBuilder>()
                            .getFormFieldList()[widget.fieldIndex]
                            .shortText = '';
                      }
                      if (type == FormFieldType.long) {
                        context
                            .read<FormBuilder>()
                            .getFormFieldList()[widget.fieldIndex]
                            .longText = '';
                      }
                      if (type == FormFieldType.multiple) {
                        context
                            .read<FormBuilder>()
                            .getFormFieldList()[widget.fieldIndex]
                            .options = ['옵션 1', '옵션 2'];
                        multipleControllers = [
                          TextEditingController(),
                          TextEditingController(),
                        ];
                      }
                      if (type == FormFieldType.checkBox) {
                        context
                            .read<FormBuilder>()
                            .getFormFieldList()[widget.fieldIndex]
                            .checkBoxes = ['옵션 1', '옵션 2'];
                        context
                            .read<FormBuilder>()
                            .getFormFieldList()[widget.fieldIndex]
                            .selectedBoxes = [];
                        checkBoxesControllers = [
                          TextEditingController(),
                          TextEditingController(),
                        ];
                      }
                    },
                    title: type.convertToString,
                  );
                }).toList(),
                buttonBuilder: (context, showMenu) => CupertinoButton(
                  onPressed: showMenu,
                  padding: EdgeInsets.zero,
                  child: FilterMenuChip(
                    chipName: context
                        .watch<FormBuilder>()
                        .getFormFieldList()[widget.fieldIndex]
                        .type
                        .convertToString,
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
              model.formFieldList[widget.fieldIndex].title = text;
              setState(() {
                context
                    .read<FormBuilder>()
                    .formFieldList[widget.fieldIndex]
                    .title = text;
              });
            },
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontFamily: 'Pretendard',
            ),
          ),
          const SizedBox(height: 6.0),
          if (context
                  .watch<FormBuilder>()
                  .formFieldList[widget.fieldIndex]
                  .type ==
              FormFieldType.short)
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
                setState(() {
                  context
                      .read<FormBuilder>()
                      .getFormFieldList()[widget.fieldIndex]
                      .shortText = text;
                });
              },
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.black,
                fontFamily: 'Pretendard',
              ),
            ),
          if (context
                  .watch<FormBuilder>()
                  .formFieldList[widget.fieldIndex]
                  .type ==
              FormFieldType.long)
            TextField(
              controller: shortTextFieldController,
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
                setState(() {
                  context
                      .read<FormBuilder>()
                      .getFormFieldList()[widget.fieldIndex]
                      .longText = text;
                });
              },
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.black,
                fontFamily: 'Pretendard',
              ),
            ),
          if (context
                  .watch<FormBuilder>()
                  .formFieldList[widget.fieldIndex]
                  .type ==
              FormFieldType.multiple)
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
                    children: context
                        .read<FormBuilder>()
                        .getFormFieldList()[widget.fieldIndex]
                        .options!
                        .map((option) {
                      return RadioListTile(
                        value: option,
                        groupValue: context
                            .watch<FormBuilder>()
                            .getFormFieldList()[widget.fieldIndex]
                            .selectedOption,
                        title: TextField(
                          controller: multipleControllers[context
                              .watch<FormBuilder>()
                              .getFormFieldList()[widget.fieldIndex]
                              .options!
                              .indexOf(option)],
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
                              context
                                      .read<FormBuilder>()
                                      .getFormFieldList()[widget.fieldIndex]
                                      .options![
                                  context
                                      .read<FormBuilder>()
                                      .getFormFieldList()[widget.fieldIndex]
                                      .options!
                                      .indexOf(option)] = text;
                            });
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
                            context
                                .read<FormBuilder>()
                                .getFormFieldList()[widget.fieldIndex]
                                .selectedOption = option;
                          });
                        },
                        activeColor: Colors.black,
                      );
                    }).toList(),
                  ),
                  RadioListTile(
                    value: '',
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
                        context
                            .read<FormBuilder>()
                            .getFormFieldList()[widget.fieldIndex]
                            .options!
                            .add(
                                '옵션 ${context.read<FormBuilder>().getFormFieldList()[widget.fieldIndex].options!.length + 1}');
                        multipleControllers.add(TextEditingController());
                      });
                    },
                  ),
                ],
              ),
            ),
          if (context
                  .watch<FormBuilder>()
                  .formFieldList[widget.fieldIndex]
                  .type ==
              FormFieldType.checkBox)
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
                    children: context
                        .read<FormBuilder>()
                        .getFormFieldList()[widget.fieldIndex]
                        .checkBoxes!
                        .map((option) {
                      return ListTile(
                        title: TextField(
                          controller: checkBoxesControllers[context
                              .watch<FormBuilder>()
                              .getFormFieldList()[widget.fieldIndex]
                              .checkBoxes!
                              .indexOf(option)],
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
                              context
                                      .read<FormBuilder>()
                                      .getFormFieldList()[widget.fieldIndex]
                                      .checkBoxes![
                                  context
                                      .read<FormBuilder>()
                                      .getFormFieldList()[widget.fieldIndex]
                                      .checkBoxes!
                                      .indexOf(option)] = text;
                            });
                          },
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontFamily: 'Pretendard',
                          ),
                        ),
                        leading: Checkbox(
                          value: context
                              .watch<FormBuilder>()
                              .getFormFieldList()[widget.fieldIndex]
                              .selectedBoxes!
                              .contains(option),
                          onChanged: (value) {
                            setState(() {
                              if (context
                                  .read<FormBuilder>()
                                  .getFormFieldList()[widget.fieldIndex]
                                  .selectedBoxes!
                                  .contains(option)) {
                                context
                                    .read<FormBuilder>()
                                    .getFormFieldList()[widget.fieldIndex]
                                    .selectedBoxes!
                                    .remove(option);
                              } else {
                                context
                                    .read<FormBuilder>()
                                    .getFormFieldList()[widget.fieldIndex]
                                    .selectedBoxes!
                                    .add(option);
                              }
                            });
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
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        context
                            .read<FormBuilder>()
                            .getFormFieldList()[widget.fieldIndex]
                            .checkBoxes!
                            .add(
                                '옵션 ${context.read<FormBuilder>().getFormFieldList()[widget.fieldIndex].checkBoxes!.length + 1}');
                        checkBoxesControllers.add(TextEditingController());
                      });
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
