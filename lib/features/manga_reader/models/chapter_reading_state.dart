import 'package:isar/isar.dart';

part 'chapter_reading_state.g.dart';

@collection
class ChapterReadingState {
  Id id = Isar.autoIncrement;

  @Index()
  late int mangaId;

  @Index()
  late int chapterNumber;

  String? chapterId;
  late String selectedSource;
  late bool isColored;
  late int lastReadPage;
}
