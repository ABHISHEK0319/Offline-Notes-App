# 📱 Mini Project: Offline Notes App

## 🧰 Features:
    - Add notes (title + body)
    - List notes
    - Delete note
    - Data save ho Hive me (offline)

## 🔧 Step 1: Setup Hive in Flutter

    ### pubspec.yaml
    
    dependencies:
      hive: ^2.2.3
      hive_flutter: ^1.1.0
      path_provider: ^2.0.15
      flutter:
        sdk: flutter

    dev_dependencies:
      hive_generator: ^2.0.1
      build_runner: ^2.4.6


## 📂 Step 2: Hive Init (main.dart)

    import 'package:flutter/material.dart';
    import 'package:hive_flutter/hive_flutter.dart';

    void main() async {
      WidgetsFlutterBinding.ensureInitialized();
      await Hive.initFlutter(); // Hive initialize
      await Hive.openBox('notesBox'); // Box open karo
      runApp(const MyApp());
    }

    class MyApp extends StatelessWidget {
      const MyApp({super.key});

      @override
      Widget build(BuildContext context) {
        return MaterialApp(
          title: 'Hive Notes App',
          home: const HomeScreen(),
        );
      }
    }  


## 📦 Step 3: Hive Box Usage (Without Model)
### A simple example of saving notes:

    import 'package:flutter/material.dart';
    import 'package:hive/hive.dart';
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
                    onDismissed: (_) => deleteNote(index),
                    child: Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(note),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text("Add Note"),
                content: TextField(
                  controller: controller,
                  decoration: 
                  const InputDecoration(hintText: "Write  something"),
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



## ✅ Output:
    - Notes add ho jayenge FAB se
    - Dismiss karo to delete ho jayega
    - Offline bhi chalne lagega


## 🧪 Test Kar:
    - Run app
    - Note add karo
    - App restart karke check karo — data save ho raha hai ya nahi
    - Swipe to delete test kar



## Test Phase me Error Aya 

[Error:](screenshots/error.png)

    '''A dismissed Dismissible widget is still part of the tree.
    Make sure to implement the onDismissed handler and to immediately remove the Dismissible widget from the application once the handler has fired.'''

    "iska simple matlab hai ki Dismissible se note delete karne ke baad UI ko update nahi kar raha hai immediately."

## 🔧 Solution:
    Humein setState(() {}) lagana hoga onDismissed ke andar taaki UI turant refresh ho jaaye.

    ### ✅ Fix Code in itemBuilder:
    return Dismissible(
      key: Key(index.toString()),
      onDismissed: (_) {
        deleteNote(index);    // Delete from Hive
        setState(() {});      // Refresh UI
      },
      background: Container(color: Colors.red),
      child: Card(
        margin: const EdgeInsets.all(10),
        child: ListTile(
          title: Text(note),
        ),
      ),
    );


### 🔁 Why this works:
    - deleteNote() sirf Hive se data delete karta hai
    - setState() UI ko bolta hai "data badal gaya hai bhai, refresh kar lo"



## ScreenShots: 

[1.](screenshots/flutter_01.png)

[2.](screenshots/flutter_02.png)

[3.](screenshots/flutter_03.png)
