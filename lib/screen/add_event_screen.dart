import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../constants.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  static String routeName = "/add_event_screen";

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  XFile? posterImage;

  void _showActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            isDefaultAction: false,
            onPressed: () {
              _getPhotoLibraryImage();
              Navigator.pop(context);
            },
            child: const Text('라이브러리에서 불러오기'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('취소하기'),
        ),
      ),
    );
  }

  void _getPhotoLibraryImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        posterImage = pickedFile;
      });
    }
  }

  final _nameTextFieldController = TextEditingController();

  @override
  void dispose() {
    _nameTextFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '행사 등록',
          style: navTextStyle,
        ),
        actions: [
          CupertinoButton(
              child: const Text(
                '완료',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              onPressed: () {})
        ],
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0.1,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                const Row(
                  children: [
                    Text(
                      '포스터 이미지',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '(1:1.3 비율 권장)',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '*',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFF64747),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                CupertinoButton(
                  child: Column(
                    children: [
                      if (posterImage == null)
                        Container(
                          width: 146,
                          height: 192,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.0),
                            color: const Color(0xFFF4F4F4),
                          ),
                          child: const Icon(
                            CupertinoIcons.plus,
                            color: Colors.black,
                          ),
                        )
                      else
                        Container(
                          width: 146,
                          height: 192,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.0),
                            color: const Color(0xFFF4F4F4),
                            image: DecorationImage(
                                image: FileImage(File(posterImage!.path)),
                                fit: BoxFit.cover),
                          ),
                        )
                    ],
                  ),
                  onPressed: () {
                    _showActionSheet(context);
                  },
                ),
                const SizedBox(
                  height: 24.0,
                ),
                const Row(
                  children: [
                    Text(
                      '행사 이름',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '*',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFF64747),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                TextField(
                  controller: _nameTextFieldController,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(20.0),
                    hintText: 'ex. 2023 리스펙트 댄스 페스티벌',
                    hintStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF969696),
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
                    suffixIcon: _nameTextFieldController.text.isNotEmpty //엑스버튼
                        ? CupertinoButton(
                            alignment: Alignment.centerRight,
                            child: const Icon(
                              CupertinoIcons.xmark_circle_fill,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              _nameTextFieldController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                  ),
                  onChanged: (text) {
                    setState(() {});
                  },
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 27.0),
                const Row(
                  children: [
                    Text(
                      '행사 위치',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '*',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFF64747),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                const SizedBox(height: 27.0),
                const Row(
                  children: [
                    Text(
                      '지역',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '*',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFF64747),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                TextField(
                  controller: _nameTextFieldController,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(20.0),
                    hintText: 'ex. 2023 리스펙트 댄스 페스티벌',
                    hintStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF969696),
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
                    suffixIcon: _nameTextFieldController.text.isNotEmpty //엑스버튼
                        ? CupertinoButton(
                            alignment: Alignment.centerRight,
                            child: const Icon(
                              CupertinoIcons.xmark_circle_fill,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              _nameTextFieldController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                  ),
                  onChanged: (text) {
                    setState(() {});
                  },
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
