import 'package:flutter/material.dart';
import 'package:tennis_app/ui/ui.dart';

import 'app.dart';
import 'app/app.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initApp();
  await initUI();
  runApp(const MyApp());
}
