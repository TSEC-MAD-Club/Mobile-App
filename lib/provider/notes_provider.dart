import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/models/notes_model/notes_model.dart';
import 'package:tsec_app/models/user_model/user_model.dart';
import 'package:tsec_app/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:tsec_app/services/notes_service.dart';

final notesProvider =
    StateNotifierProvider<NotesProvider, List<NotesModel>>(((ref) {
  final data = ref.watch(userModelProvider);
  return NotesProvider(
      ref: ref, user: data, notesService: ref.read(notesServiceProvider));
}));

class NotesProvider extends StateNotifier<List<NotesModel>> {
  final NotesService _notesService;
  UserModel _user;

  NotesProvider({notesService, user, ref})
      : _notesService = notesService,
        _user = user,
        super([]) {
    fetchNotes(_user);
  }

  Future<List<String>> uploadAttachments(
      List<String> files, BuildContext context) async {
    // _ref.read(profilePicProvider.notifier).state = image;
    if (files.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'We are uploading your attachments, this might take some time. We will notify you when the process completes.')),
      );
      List<String> urls = await _notesService.uploadAttachments(files);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('All the attached files have been uploaded')),
      );
      return urls;
    } else {
      return [];
    }
  }

  Future deleteAttachments(List<String> files) async {
    // _ref.read(profilePicProvider.notifier).state = image;
    await _notesService.deleteAttachments(files);
  }

  Future<void> fetchNotes(UserModel? user) async {
    // UserModel? user = _ref.watch(userModelProvider);
    List<NotesModel> allNotes = await _notesService.fetchNotes(user);
    state = allNotes;
  }

  Future uploadNote(NotesModel note, List<String> newFiles,
      List<String> deletedFiles, BuildContext context) async {
    try {
      // debugPrint(newFiles.toString());
      // debugPrint(deletedFiles.toString());
      // debugPrint(note.attachments.toString());
      List<NotesModel> oldNotes = state;
      bool isNewNote = note.id == "";
      NotesModel uploadedNote = await _notesService.uploadNote(note);

      // debugPrint("in notes provider ${note.id}");
      List<String> originalAttachments = note.attachments;
      // debugPrint("before updating state ${note.attachments.toString()}");
      if (!isNewNote) {
        note.attachments = [...note.attachments, ...newFiles];
        List<NotesModel> updatedNotes = oldNotes.map((currNote) {
          return currNote.id == note.id ? note : currNote;
        }).toList();
        oldNotes = updatedNotes;
      } else {
        note = uploadedNote;
        uploadedNote.attachments = [...note.attachments, ...newFiles];
        oldNotes.add(uploadedNote);
      }
      state = [...oldNotes];

      //attachments stuff
      List<String> urls = await uploadAttachments(newFiles, context);
      // debugPrint("after uploading attachments, urls ${urls}");
      // debugPrint(
      //     "after uploading attachments, attachments ${note.attachments}");
      note.attachments = [...originalAttachments, ...urls];
      // debugPrint("finally, attachments ${note.attachments}");
      uploadedNote = await _notesService.uploadNote(note);

      await deleteAttachments(deletedFiles);
    } catch (e) {
      print('Error uploading note: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('An error occurred. Please try again later.')),
      );
    }
  }

  Future deleteNote(String noteId, BuildContext context) async {
    try {
      List<NotesModel> oldNotes = state;
      // Map<DateTime, List<NotesModel>> newNotes = {};
      oldNotes = oldNotes.where((note) => note.id != noteId).toList();
      state = oldNotes;
      await _notesService.deleteNote(noteId);
    } catch (e) {
      print('Error deleting note: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('An error occurred. Please try again later.')),
      );
    }
  }
}
