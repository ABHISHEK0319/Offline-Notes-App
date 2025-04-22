import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final box = Hive.box('notesBox');
  final TextEditingController controller = TextEditingController();

  void addNote(String note) {
    if (note.isNotEmpty) {
      box.add(note);
      controller.clear();
    }
  }

  void deleteNote(int index) {
    box.deleteAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hive Notes')),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box box, _) {
          if (box.isEmpty) {
            return const Center(child: Text("No notes yet"));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final note = box.getAt(index);
              return Dismissible(
                key: Key(index.toString()),
                onDismissed: (_) {
                  deleteNote(index); // Delete from Hive
                  setState(() {}); // Refresh UI
                },
                background: Container(color: Colors.red),
                child: Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(title: Text(note)),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => showDialog(
              context: context,
              builder:
                  (_) => AlertDialog(
                    title: const Text("Add Note"),
                    content: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: "Write something",
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          addNote(controller.text);
                          Navigator.pop(context);
                        },
                        child: const Text("Save"),
                      ),
                    ],
                  ),
            ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
