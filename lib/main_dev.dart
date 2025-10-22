import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sartor_order_management/main.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env.dev");
  runApp(const ProviderScope(
    child: SartorApp(),
  ));
}
