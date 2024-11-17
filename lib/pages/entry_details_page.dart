import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/entry.dart';
import '../services/database_service.dart';
import '../utils/constants.dart';
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
          content: Text('Do not found entry: $error'),
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
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete the entry'),
                  backgroundColor: Colors.grey.withOpacity(0.3),
                  content:
                      const Text('Do you really want to delete this entry?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.red[200],
                          foregroundColor: Colors.black),
                      child: const Text('No'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.green[200],
                          foregroundColor: Colors.black),
                      child: const Text('Yes'),
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
              image: DecorationImage(
                image: AssetImage(Constants.backgroundImage),
                fit: BoxFit.cover,
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
                  color: Colors.grey.withOpacity(0.3),
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
                                  ? Colors.green
                                  : Colors.red,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Mood: ${widget.entry.mood.name}',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white70),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          CustomDateUtils.formatDate(widget.entry),
                          style: const TextStyle(
                              fontSize: 14, color: Colors.white70),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Note:    ${widget.entry.note}',
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70),
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
