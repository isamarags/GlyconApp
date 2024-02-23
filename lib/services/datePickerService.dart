import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class DatePickerService {

  static Future<DateTime?> selectDateTime(BuildContext context, DateTime initialDate) async {
    return await DatePicker.showDateTimePicker(
      context,
      currentTime: initialDate,
      locale: LocaleType.pt,
      onConfirm: (DateTime picked) {
        return picked;
      },
    );
  }
}