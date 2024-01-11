import 'package:flutter/material.dart';
import '../model/word.dart';
import '../repository/words_repository.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final _wordsRepo = WordsRepository();
  late var _words = <Word>[];

  @override
  void initState() {
    super.initState();
    _wordsRepo
        .initDB()
        .whenComplete(() => setState(() => _words = _wordsRepo.words));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
          height: 200,
          child: ListView.builder(
              itemCount: _words.length,
              itemBuilder: (_, i) {
                return Slidable(
                  startActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: deleteWord,
                        backgroundColor: const Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                      SlidableAction(
                        onPressed: editWord,
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Edit',
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(_words[i].name),
                    subtitle: Text(_words[i].trans),
                  ),
                );
              })),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future _showDialog() => showGeneralDialog(
        context: context,
        barrierDismissible: false,
        pageBuilder: (_, __, ___) {
          final nameController = TextEditingController();
          final transController = TextEditingController();
          return AlertDialog(
            title: const Text('New word'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(hintText: 'Name'),
                ),
                TextField(
                  controller: transController,
                  decoration: const InputDecoration(hintText: 'Translation'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  await _wordsRepo.addWord(Word(
                    name: nameController.text,
                    trans: transController.text,
                  ));
                  setState(() {
                    _words = _wordsRepo.words;
                    Navigator.pop(context);
                  });
                },
                child: const Text('Add'),
              )
            ],
          );
        },
      );

  void deleteWord(BuildContext context) {
    _wordsRepo.deleteWord(_words);
    _words = _wordsRepo.words;
  }

  void editWord(BuildContext context) {
    _wordsRepo.editWord(_words as Word).whenComplete(() => setState(() {
          _words = _wordsRepo.words;
        }));
  }
}
