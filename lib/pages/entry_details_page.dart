import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/entry.dart';
import '../services/database_service.dart';
import '../utils/date_utils.dart';
import '../viewmodels/entry_viewmodel.dart';
import '../widgets/shared_app_bar.dart';

class EntryDetailPage extends StatefulWidget {
  final Entry entry;

  const EntryDetailPage({super.key, required this.entry});

  @override
  State<EntryDetailPage> createState() => _EntryDetailPageState();
}

class _EntryDetailPageState extends State<EntryDetailPage> {
  bool _animationCompleted = false;
  final DatabaseService _databaseService = DatabaseService();

  Future<void> _deleteEntry() async {
    try {
      await _databaseService.deleteEntry(widget.entry.id);
      Provider.of<EntryViewModel>(context, listen: false).fetchEntries();

      Navigator.pop(context, true);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Do not found entry: $error',
            style: const TextStyle(
                fontFamily: 'FuneverFont', color: Colors.white, fontSize: 16),
          ),
        ),
      );
    }
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
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.brown[50]),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text(
                    'Delete the entry',
                    style: TextStyle(
                        fontFamily: 'FuneverFont',
                        color: Colors.white,
                        fontSize: 16),
                  ),
                  backgroundColor: const Color(0xFF212121),
                  content: const Text(
                    'Do you really want to delete this entry?',
                    style: TextStyle(
                        fontFamily: 'FuneverFont',
                        color: Colors.white,
                        fontSize: 16),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black),
                      child: Text(
                        'No',
                        style: TextStyle(
                            fontFamily: 'FuneverFont',
                            color: Colors.red[200],
                            fontSize: 16),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black),
                      child: Text(
                        'Yes',
                        style: TextStyle(
                            fontFamily: 'FuneverFont',
                            color: Colors.green[200],
                            fontSize: 16),
                      ),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await _deleteEntry();
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF212121),
                  Color(0xFF484848),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.4),
          ),
          Positioned.fill(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 32.0),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  color: const Color(0xFF212121),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              widget.entry.mood.name == 'positive'
                                  ? Icons.sentiment_satisfied
                                  : Icons.sentiment_dissatisfied,
                              color: widget.entry.mood.name == 'positive'
                                  ? Colors.green[200]
                                  : Colors.red[200],
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Mood: ${widget.entry.mood.name}',
                              style: const TextStyle(
                                  fontFamily: 'FuneverFont',
                                  color: Colors.white,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          CustomDateUtils.formatDate(widget.entry),
                          style: const TextStyle(
                              fontFamily: 'FuneverFont',
                              color: Colors.white,
                              fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Note:    ${widget.entry.note}',
                          style: const TextStyle(
                              fontFamily: 'FuneverFont',
                              color: Colors.white,
                              fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
