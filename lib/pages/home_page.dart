import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart';
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
    Provider.of<EntryViewModel>(context, listen: false).fetchEntries();
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
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddEntryPage(),
                ),
              );
              Provider.of<EntryViewModel>(context, listen: false)
                  .fetchEntries();
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Constants.backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Consumer<EntryViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.entries.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return ListView.separated(
                itemCount: viewModel.entries.length,
                separatorBuilder: (context, index) =>
                    Divider(color: Colors.pink[100]),
                itemBuilder: (context, index) {
                  final entry = viewModel.entries[index];
                  return ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Note: ${CustomTextRenderingUtils.formatHomeListItem(entry)}',
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.blueGrey[50]),
                        ),
                        Text(
                          'Mood: ${entry.mood.name}',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blueGrey[50],
                          ),
                        ),
                        Text(
                          CustomDateUtils.formatDate(entry),
                          style: TextStyle(
                              fontSize: 14, color: Colors.blueGrey[50]),
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
