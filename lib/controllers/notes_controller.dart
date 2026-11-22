import 'package:get/get.dart';
import '../models/note.dart';
import '../services/database_service.dart';

class NotesController extends GetxController {
  final DatabaseService _service = DatabaseService();

  final notes = <Note>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;

  Future<List<Note>>? _pendingNotesFuture;

  List<Note> get filteredNotes {
    if (searchQuery.value.trim().isEmpty) return notes;
    final q = searchQuery.value.toLowerCase();
    return notes
        .where((n) =>
            n.title.toLowerCase().contains(q) ||
            n.content.toLowerCase().contains(q))
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    ensureNotesLoaded().ignore();
  }

  /// ترجع Future مشترك بين onInit و FutureBuilder.
  Future<List<Note>> ensureNotesLoaded() {
    if (notes.isNotEmpty) return Future.value(notes.toList());
    return _pendingNotesFuture ??= loadNotes();
  }

  /// تقرأ القائمة من SQLite وترجع Future — تستخدمها FutureBuilder.
  Future<List<Note>> loadNotes() async {
    isLoading.value = true;
    try {
      final list = await _service.fetchNotes();
      notes.assignAll(list);
      _pendingNotesFuture = null;
      return list;
    } catch (e) {
      _pendingNotesFuture = null;
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addNote(String title, String content) async {
    final now = DateTime.now();
    await _service.insertNote(Note(
      title: title,
      content: content,
      createdAt: now,
      updatedAt: now,
    ));
    await loadNotes();
  }

  Future<void> updateNote(Note note, String title, String content) async {
    await _service.updateNote(note.copyWith(
      title: title,
      content: content,
      updatedAt: DateTime.now(),
    ));
    await loadNotes();
  }

  Future<void> deleteNote(int id) async {
    await _service.deleteNote(id);
    await loadNotes();
  }

  void setSearchQuery(String q) => searchQuery.value = q;
}