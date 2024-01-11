import '../model/word.dart';
import '../objectbox.g.dart';

class WordsRepository {
  late final Store _store;
  late final Box<Word> _box;

  List<Word> get words => _box.getAll();

  Future initDB() async {
    _store = await openStore();
    _box = _store.box<Word>();
  }

  Future <void> addWord(Word word) async {
    _box.put(word);
  }

  deleteWord(word) {
    _box.remove(word.id);
  }

  editWord(Word word) {
    _box.put(Word(
      id: word.id,
      name: word.name,
      trans: word.trans,
    ));
  }
}
