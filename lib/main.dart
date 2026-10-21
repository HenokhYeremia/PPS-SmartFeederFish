import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:smart_fish_feeder/app/app.dart';
import 'package:smart_fish_feeder/firebase_options.dart';

/// Application entry point.
///
/// Menginisialisasi Firebase Core dengan konfigurasi resmi FlutterFire
/// sebelum menjalankan [SmartFishFeederApp].
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const SmartFishFeederApp());
}

