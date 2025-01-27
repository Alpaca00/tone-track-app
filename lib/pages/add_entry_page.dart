import 'package:flutter/material.dart';
import 'package:lens_button/lens_button.dart';
import 'package:provider/provider.dart';

import '../utils/constants.dart';
import '../viewmodels/entry_viewmodel.dart';
import '../widgets/shared_app_bar.dart';
import '../models/entry.dart';
import '../models/mood.dart';
import '../services/database_service.dart';
import '../services/sentiment_service.dart';

class AddEntryPage extends StatefulWidget {
  const AddEntryPage({super.key});

  @override
  _AddEntryPageState createState() {
    return _AddEntryPageState();
  }
}

class _AddEntryPageState extends State<AddEntryPage> {
  final TextEditingController _controller = TextEditingController();
  bool _animationCompleted = false;
  final DatabaseService _databaseService = DatabaseService();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _saveEntry() async {
    String entryText = _controller.text;

    if (entryText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please write something in your diary entry')),
      );
      return;
    }

    Mood mood = await SentimentService().analyzeMood(entryText);

    Entry entry = Entry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      note: entryText,
      date: DateTime.now(),
      mood: mood,
    );

    await _databaseService.saveEntry(entry);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Diary entry saved with mood: ${mood.name}')),
    );
    Provider.of<EntryViewModel>(context, listen: false).fetchEntries();
    _controller.clear();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SharedAppBar(
        animationCompleted: _animationCompleted,
        onAnimationFinished: () {
          setState(() {
            _animationCompleted = true;
          });
        },
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Constants.backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter your diary entry',
                style: TextStyle(fontSize: 18, color: Colors.brown[50]),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                maxLines: 15,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Write your entry here...',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: LensButton(
                  label: 'Save',
                  onPressed: () {
                    _saveEntry();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
