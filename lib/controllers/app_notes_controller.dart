import 'dart:developer';
import 'dart:io';

import 'package:conduit/conduit.dart';
import 'package:conduittest/model/note.dart';

import '../utils/app_response.dart';
import '../utils/app_utils.dart';

class AppNotesController extends ResourceController {
  AppNotesController(this.managedContext);

  final ManagedContext managedContext;

  @Operation.get()
  Future<Response> getNotes(
    @Bind.query('page') int page,
    @Bind.query('amount') int amount,
  ) async {
    try {
      final id = amount;
      final qGetAll = await Query<Note>(managedContext)
        ..offset = page
        ..fetchLimit = id;

      final notes = await qGetAll.fetch();

      var map2 = notes.map((e) {
        return {
          "id": e.id,
          "noteName": e.noteName,
          "noteCategory": e.noteCategory,
          "noteDateCreated": e.noteDateCreated,
          "noteDateChanged": e.noteDateChanged
        };
      }).toList();
      return AppResponse.ok(message: 'Успешное получение заметки', body: map2);
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка получения заметки');
    }
  }
}
