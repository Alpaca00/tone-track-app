import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tone_track/pages/home_page.dart';
import 'package:tone_track/utils/constants.dart';
import 'package:tone_track/viewmodels/entry_viewmodel.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => EntryViewModel(),
      child: const ToneTrackApp(),
    ),
  );
}

class ToneTrackApp extends StatelessWidget {
  const ToneTrackApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.appName,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}
