import 'package:flutter/material.dart';

import '../model/form_field_template.dart';

class FormBuilder with ChangeNotifier {
  List<FormFieldTemplate> formFieldList = [FormFieldTemplate()];

  FormBuilder({required this.formFieldList});

  List<FormFieldTemplate> getFormFieldList() {
    return formFieldList;
  }

  void addFormField() {
    formFieldList.add(
      FormFieldTemplate(),
    );
    notifyListeners();
  }

  void removeFormField({required int index}) {
    if (formFieldList.isNotEmpty) {
      formFieldList.removeAt(index);
    }
    notifyListeners();
  }

  void resetFormField() {
    formFieldList = [FormFieldTemplate()];
    notifyListeners();
  }

  void setFormField(
      {required int index,
      required FormFieldType type,
      required String title,
      required String shortText,
      required String longText,
      required List<String> options,
      required String selectedOption,
      required List<String> checkBoxes,
      required List<String> selectedBoxes}) {
    formFieldList[index].type = type;
    formFieldList[index].title = title;
    formFieldList[index].shortText = shortText;
    formFieldList[index].longText = longText;
    formFieldList[index].options = options;
    formFieldList[index].selectedOption = selectedOption;
    formFieldList[index].checkBoxes = checkBoxes;
    formFieldList[index].selectedBoxes = selectedBoxes;
    notifyListeners();
  }
}
