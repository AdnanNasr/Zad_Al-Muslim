import 'package:isar/isar.dart';

part 'mark.g.dart';

@collection
class Mark {
  Id id = Isar.autoIncrement;

  late String surahName;
  late int pageNumber;
  late DateTime date;
}
