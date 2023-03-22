import 'package:hive/hive.dart';
import 'package:hivenotes/models/note_models.dart';
class Boxes {
  static Box<NotesModel> getData() => Hive.box<NotesModel>('notes');
}