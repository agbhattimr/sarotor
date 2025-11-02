import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> clientShellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'clientShell');
final GlobalKey<NavigatorState> adminShellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'adminShell');
