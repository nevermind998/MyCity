//
// Generated file. Do not edit.
//

// ignore: unused_import
import 'dart:ui';

import 'package:image_picker_web/image_picker_web.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void registerPlugins(PluginRegistry registry) {
  ImagePickerWeb.registerWith(registry.registrarFor(ImagePickerWeb));
  SharedPreferencesPlugin.registerWith(registry.registrarFor(SharedPreferencesPlugin));
  registry.registerMessageHandler();
}
