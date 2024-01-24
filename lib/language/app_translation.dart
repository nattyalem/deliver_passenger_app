import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'am_et.dart';
import 'en_us.dart';

class AppTranslation extends Translations {
  static Locale locale = Locale('en', 'US');
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUS,
    'am_ET': amET,
  };
}