import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/date_utils.dart';
import '../utils/text_utils.dart';
import '../viewmodels/entry_viewmodel.dart';
import '../widgets/shared_app_bar.dart';
import 'add_entry_page.dart';
import 'entry_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _animationCompleted = false;

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    await Provider.of<EntryViewModel>(context, listen: false).fetchEntries();
    setState(() {});
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
            icon: Icon(Icons.add, color: Colors.brown[50]),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddEntryPage(),
                ),
              );
              _loadEntries();
            },
          ),
        ],
      ),
      body: Container(
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
        child: Consumer<EntryViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.entries.isEmpty) {
              return const Center(
                  child: Text(
                'The first entries will appear as soon as you add them.',
                style: TextStyle(
                    fontFamily: 'LuckyMoonFont',
                    color: Colors.white,
                    fontSize: 28),
              ));
            } else {
              return ListView.separated(
                itemCount: viewModel.entries.length,
                separatorBuilder: (context, index) =>
                    Divider(color: Colors.brown[50]),
                itemBuilder: (context, index) {
                  final entry = viewModel.entries[index];
                  return ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Note: ${CustomTextRenderingUtils.formatHomeListItem(entry)}',
                          style: const TextStyle(
                              fontFamily: 'FuneverFont',
                              color: Colors.white,
                              fontSize: 16),
                        ),
                        Text(
                          'Mood: ${entry.mood.name}',
                          style: const TextStyle(
                              fontFamily: 'FuneverFont',
                              color: Colors.white,
                              fontSize: 16),
                        ),
                        Text(
                          CustomDateUtils.formatDate(entry),
                          style: const TextStyle(
                              fontFamily: 'FuneverFont',
                              color: Colors.white,
                              fontSize: 16),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EntryDetailPage(entry: entry),
                        ),
                      );
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
