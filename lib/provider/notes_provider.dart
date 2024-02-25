import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/models/notes_model/notes_model.dart';
import 'package:tsec_app/models/student_model/student_model.dart';
import 'package:tsec_app/models/user_model/user_model.dart';
import 'package:tsec_app/provider/auth_provider.dart';
import 'package:tsec_app/provider/firebase_provider.dart';
import 'package:tsec_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:tsec_app/services/notes_service.dart';
import 'package:tsec_app/utils/notification_type.dart';

final notesProvider =
    StateNotifierProvider<NotesProvider, List<NotesModel>>(((ref) {
  return NotesProvider(ref: ref, notesService: ref.read(notesServiceProvider));
}));

class NotesProvider extends StateNotifier<List<NotesModel>> {
  final NotesService _notesService;

  final Ref _ref;

  NotesProvider({notesService, ref})
      : _notesService = notesService,
        _ref = ref,
        super([]);

  Future<List<String>> uploadAttachments(FilePickerResult? files) async {
    // _ref.read(profilePicProvider.notifier).state = image;
    List<String> urls = await _notesService.uploadAttachments(files);
    return urls;
  }

  Future<void> fetchNotes() async {
    UserModel? user = _ref.read(userModelProvider);
    List<NotesModel> allNotes = await _notesService.fetchNotes(user);
    state = allNotes;
  }

  Future uploadNote(NotesModel note, BuildContext context) async {
    try {
      List<NotesModel> oldNotes = state;
      bool isNewNote = note.id == "";
      NotesModel uploadedNote = await _notesService.uploadNote(note);

      // debugPrint("in notes provider ${note.id}");

      if (!isNewNote) {
        List<NotesModel> updatedNotes = oldNotes.map((currNote) {
          return currNote.id == note.id ? note : currNote;
        }).toList();
        oldNotes = updatedNotes;
      } else {
        oldNotes.add(uploadedNote);
      }
      state = [...oldNotes];
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
