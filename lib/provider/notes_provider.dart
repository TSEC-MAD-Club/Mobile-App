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
    StateNotifierProvider<NotesProvider, Map<DateTime, List<NotesModel>>>(
        ((ref) {
  return NotesProvider(ref: ref, notesService: ref.read(notesServiceProvider));
}));

class NotesProvider extends StateNotifier<Map<DateTime, List<NotesModel>>> {
  final NotesService _notesService;

  final Ref _ref;

  NotesProvider({notesService, ref})
      : _notesService = notesService,
        _ref = ref,
        super(Map<DateTime, List<NotesModel>>());

  Future<List<String>> uploadAttachments(FilePickerResult? files) async {
    // _ref.read(profilePicProvider.notifier).state = image;
    List<String> urls = await _notesService.uploadAttachments(files);
    return urls;
  }

  Future<void> fetchNotes() async {
    UserModel? user = _ref.read(userModelProvider);
    Map<DateTime, List<NotesModel>> allNotes =
        await _notesService.fetchNotes(user);
    // debugPrint("fetched notes are:");
    // for (var note in allNotes.entries) {
    //   debugPrint("fetched note: ${note.value[0].id}");
    // }
    state = allNotes;
  }

  Future uploadNote(NotesModel note, BuildContext context) async {
    try {
      Map<DateTime, List<NotesModel>> oldNotes = state;
      List<NotesModel>? oldNotesSameTime = oldNotes[note.time];

      NotesModel uploadedNote = await _notesService.uploadNote(note);

      if (note.id != "") {
        debugPrint("in notes provider");
        if (oldNotesSameTime == null) {
          oldNotes[note.time] = [note];
        } else {
          oldNotes[note.time] = oldNotesSameTime
              .where((element) => element.id != note.id)
              .toList();
          oldNotes[note.time]!.add(note);
        }
      } else {
        if (oldNotesSameTime != null)
          oldNotes[uploadedNote.time] = [...oldNotesSameTime, uploadedNote];
        else
          oldNotes[uploadedNote.time] = [uploadedNote];
      }

      // debugPrint(state.hashCode.toString());
      // // state = oldNotes;
      // debugPrint(state.hashCode.toString());

      state = {...oldNotes};
      // debugPrint("inside provider, ${state}");
      // _ref.read(userModelProvider.notifier).state =
      //     UserModel(isStudent: false, facultyModel: updatedFacultyData);
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
      Map<DateTime, List<NotesModel>> oldNotes = state;
      Map<DateTime, List<NotesModel>> newNotes = {};
      for (var key in oldNotes.keys) {
        List<NotesModel> notes = [];
        for (NotesModel note in oldNotes[key]!) {
          if (note.id != noteId) notes.add(note);
        }
        if (notes != []) newNotes[key] = notes;
      }
      state = newNotes;
      await _notesService.deleteNote(noteId);
      // NotesModel uploadedNote = await _notesService.uploadNote(note);
      // Map<DateTime, List<NotesModel>> oldNotes =
      //     _ref.read(fetchedNotesProvider);
      // List<NotesModel>? oldNotesSameTime = oldNotes[uploadedNote.time];
      // if (oldNotesSameTime != null)
      //   oldNotes[uploadedNote.time] = [...oldNotesSameTime, uploadedNote];
      // else
      //   oldNotes[uploadedNote.time] = [uploadedNote];
      // _ref.read(fetchedNotesProvider.notifier).state = oldNotes;

      // _ref.read(userModelProvider.notifier).state =
      //     UserModel(isStudent: false, facultyModel: updatedFacultyData);
    } catch (e) {
      print('Error deleting note: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('An error occurred. Please try again later.')),
      );
    }
  }
}
