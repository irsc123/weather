import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/notes_controller.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../widgets/app_button.dart';
import '../widgets/glass_card.dart';
import '../widgets/glass_background.dart';
import '../models/note.dart';

class NoteFormScreen extends StatefulWidget {
  final Note? note;
  const NoteFormScreen({super.key, this.note});

  @override
  State<NoteFormScreen> createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends State<NoteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  final _notesController = Get.find<NotesController>();
  bool _isSaving = false;

  bool get _isEditing => widget.note != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    try {
      if (_isEditing) {
        await _notesController.updateNote(widget.note!,
            _titleController.text.trim(), _contentController.text.trim());
      } else {
        await _notesController.addNote(
            _titleController.text.trim(), _contentController.text.trim());
      }
      if (!mounted) return;
      // Return to the notes screen and let it show the confirmation, so the
      // snackbar is not tied to a route that is being popped.
      Get.back<bool>(result: true);
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ أثناء الحفظ',
          backgroundColor: AppColors.error,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.fromLTRB(16, 0, 16, bottomInset + 92),
          borderRadius: 14,
          duration: const Duration(seconds: 2));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(_isEditing ? AppStrings.editNote : AppStrings.addNote),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.all(20),
            child: GlassCard(
              blurSigma: 28,
              borderRadius: 24,
              padding: const EdgeInsets.all(22),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: AppStrings.noteTitle,
                        prefixIcon: Icon(Icons.title),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? AppStrings.titleRequired
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _contentController,
                      decoration: const InputDecoration(
                        labelText: AppStrings.noteContent,
                        alignLabelWithHint: true,
                      ),
                      maxLines: 8,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? AppStrings.contentRequired
                          : null,
                    ),
                    const SizedBox(height: 24),
                    AppButton(
                      text: AppStrings.save,
                      icon: Icons.save_outlined,
                      isLoading: _isSaving,
                      onPressed: _save,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        child: const Text(AppStrings.cancel),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}