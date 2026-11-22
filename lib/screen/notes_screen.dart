import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/notes_controller.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../widgets/glass_card.dart';
import '../widgets/skeleton_widgets.dart';
import '../widgets/fade_slide_in.dart';
import '../models/note.dart';
import 'note_form_screen.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen>
    with AutomaticKeepAliveClientMixin {
  final controller = Get.find<NotesController>();
  late Future<List<Note>> _notesFuture;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _notesFuture = controller.ensureNotesLoaded();
  }

  void _reload() {
    setState(() {
      _notesFuture = controller.loadNotes();
    });
  }

  Future<void> _refresh() async {
    final future = controller.loadNotes();
    setState(() => _notesFuture = future);
    try {
      await future;
    } catch (_) {}
  }

  Future<void> _openForm([Note? note]) async {
    final saved = await Get.to<bool>(
      () => NoteFormScreen(note: note),
      transition: Transition.downToUp,
      duration: const Duration(milliseconds: 320),
    );
    if (saved != true || !mounted) return;
    // تحويل حالة المتحكم الحالية إلى Future محلولة ليُعيد FutureBuilder البناء
    setState(() {
      _notesFuture = Future<List<Note>>.value(controller.notes.toList());
    });
    Get.snackbar(
      AppStrings.saveSuccessTitle,
      AppStrings.saveSuccess,
      backgroundColor: AppColors.success,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.fromLTRB(
          16, 0, 16, MediaQuery.viewPaddingOf(context).bottom + 92),
      borderRadius: 14,
      duration: const Duration(seconds: 2),
    );
  }

  Future<void> _confirmDelete(Note note) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text(AppStrings.deleteConfirmTitle),
        content: const Text(AppStrings.deleteConfirm),
        actions: [
          TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text(AppStrings.no)),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text(AppStrings.yes,
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (confirmed != true || note.id == null || !mounted) return;
    try {
      await controller.deleteNote(note.id!);
      if (!mounted) return;
      setState(() {
        _notesFuture = Future<List<Note>>.value(controller.notes.toList());
      });
    } catch (_) {
      Get.snackbar(
        'تعذر الحذف',
        'حدث خطأ أثناء حذف الملاحظة.',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.fromLTRB(
            16, 0, 16, MediaQuery.viewPaddingOf(context).bottom + 92),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: false,
      appBar: AppBar(title: const Text(AppStrings.notesTitle)),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: GlassCard(
                borderRadius: 16,
                blurSigma: 18,
                padding: EdgeInsets.zero,
                showHighlight: false,
                child: TextField(
                  textInputAction: TextInputAction.search,
                  onTapOutside: (_) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                  decoration: const InputDecoration(
                    hintText: AppStrings.searchNotesHint,
                    prefixIcon:
                        Icon(Icons.search, color: AppColors.textSecondary),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: false,
                  ),
                  onChanged: controller.setSearchQuery,
                ),
              ),
            ),
            Expanded(
              // Obx يجعل FutureBuilder يُعيد بناء محتواه عند تغيير نص البحث.
              child: Obx(() {
                final query = controller.searchQuery.value.trim();
                return FutureBuilder<List<Note>>(
                  future: _notesFuture,
                  builder: (context, snapshot) {
                    // 1) Waiting
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const NotesSkeleton();
                    }

                    // 2) Error
                    if (snapshot.hasError) {
                      return _ScrollableError(
                        message: snapshot.error
                                ?.toString()
                                .replaceFirst('Exception: ', '') ??
                            'تعذر تحميل الملاحظات.',
                        onRetry: _reload,
                      );
                    }

                    // 3) Has Data (أو Empty)
                    final allNotes = snapshot.data ?? <Note>[];
                    final notes = query.isEmpty
                        ? allNotes
                        : allNotes
                            .where((n) =>
                                n.title.toLowerCase().contains(query.toLowerCase()) ||
                                n.content.toLowerCase().contains(query.toLowerCase()))
                            .toList();

                    if (notes.isEmpty) {
                      return _EmptyState(hasSearch: query.isNotEmpty);
                    }

                    return RefreshIndicator(
                      onRefresh: _refresh,
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        padding: EdgeInsets.fromLTRB(
                            16,
                            8,
                            16,
                            MediaQuery.viewPaddingOf(context).bottom + 100),
                        itemCount: notes.length,
                        itemBuilder: (context, i) {
                          final note = notes[i];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: FadeSlideIn(
                              key: ValueKey('note_${note.id}'),
                              child: _NoteCard(
                                note: note,
                                onEdit: () => _openForm(note),
                                onDelete: () => _confirmDelete(note),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.viewPaddingOf(context).bottom + 104),
        child: FloatingActionButton.extended(
          onPressed: _openForm,
          icon: const Icon(Icons.add),
          label: const Text(AppStrings.addNote),
        ),
      ),
    );
  }
}

class _ScrollableError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ScrollableError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline,
                      size: 48, color: AppColors.textSecondary),
                  const SizedBox(height: 12),
                  Text(message,
                      textAlign: TextAlign.center,
                      style:
                          const TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh),
                    label: const Text(AppStrings.retry),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool hasSearch;
  const _EmptyState({required this.hasSearch});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    hasSearch ? Icons.search_off : Icons.note_alt_outlined,
                    size: 72,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    hasSearch
                        ? AppStrings.noSearchResults
                        : AppStrings.noNotes,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  if (!hasSearch) ...[
                    const SizedBox(height: 8),
                    const Text(
                      AppStrings.noNotesHint,
                      style: TextStyle(color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _NoteCard({
    required this.note,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      blurSigma: 24,
      borderRadius: 22,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  note.title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                onPressed: onEdit,
                tooltip: AppStrings.edit,
                visualDensity: VisualDensity.compact,
                constraints:
                    const BoxConstraints(minWidth: 36, minHeight: 36),
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.edit_outlined,
                    size: 20, color: AppColors.primary),
              ),
              IconButton(
                onPressed: onDelete,
                tooltip: AppStrings.delete,
                visualDensity: VisualDensity.compact,
                constraints:
                    const BoxConstraints(minWidth: 36, minHeight: 36),
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.delete_outline,
                    size: 20, color: AppColors.error),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            note.content,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Text(
            DateFormat('yyyy/MM/dd HH:mm').format(note.updatedAt),
            style:
                const TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}