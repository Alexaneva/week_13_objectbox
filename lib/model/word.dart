
import 'package:objectbox/objectbox.dart';

@Entity()
class Word {
  @Id()
  int id;
  String name;
  String trans;

  Word({this.id = 0, required this.name, required this.trans});
}
