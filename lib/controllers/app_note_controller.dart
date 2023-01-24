import 'dart:io';

import 'package:conduit/conduit.dart';
import 'package:conduittest/model/note.dart';

import '../utils/app_response.dart';
import '../utils/app_utils.dart';

class AppNoteController extends ResourceController {
  AppNoteController(this.managedContext);

  final ManagedContext managedContext;

  @Operation.put()
  Future<Response> updateNote(
    @Bind.header(HttpHeaders.authorizationHeader) String header,
    @Bind.body() Note note,
  ) async {
    try {

      final id = note.id;
      final fNote = await managedContext.fetchObjectWithID<Note>(id);
      final qUpdateUser = Query<Note>(managedContext)
        ..where((element) => element.id)
            .equalTo(id) 
        ..values.noteName = note.noteName ?? fNote!.noteName
        ..values.noteDateCreated =
            note.noteDateCreated ?? fNote!.noteDateCreated
        ..values.noteDateChanged =
            note.noteDateChanged ?? fNote!.noteDateChanged
        ..values.noteCategory = note.noteCategory ?? fNote!.noteCategory;
      await qUpdateUser.updateOne();
      final findUser = await managedContext.fetchObjectWithID<Note>(id);
      findUser!.removePropertiesFromBackingMap(['refreshToken', 'accessToken']);

      return AppResponse.ok(
        message: 'Успешное обновление данных',
        body: findUser.backing.contents,
      );
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка обновление данных');
    }
  }

  @Operation.post()
  Future<Response> addNote(
    @Bind.header(HttpHeaders.authorizationHeader) String header,
    @Bind.body() Note note,
  ) async {
    try {

      int id = AppUtils.getIdFromHeader(header);

      await managedContext.transaction((transaction) async {
        final qCreateNote = Query<Note>(transaction)
          ..values.noteName = note.noteName
          ..values.noteDateCreated = note.noteDateCreated
          ..values.noteDateChanged = note.noteDateChanged
          ..values.noteCategory = note.noteCategory;

        final createdUser = await qCreateNote.insert();
        id = createdUser.id!;
      });

      final findUser = await managedContext.fetchObjectWithID<Note>(id);

      findUser!.removePropertiesFromBackingMap(['refreshToken', 'accessToken']);

      return AppResponse.ok(
        message: 'Успешное добавление данных',
        body: findUser.backing.contents,
      );
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка добавление данных');
    }
  }

  @Operation.delete()
  Future<Response> deleteNote(
    @Bind.header(HttpHeaders.authorizationHeader) String header,
    @Bind.body() Note note,
  ) async {
    try {
      final id = note.id;

      final fNote = await managedContext.fetchObjectWithID<Note>(id);

      final qDeleteUser = Query<Note>(managedContext)
        ..where((element) => element.id)
            .equalTo(id); 

      await qDeleteUser.delete();

      return AppResponse.ok(
        message: 'Успешное удаление данных',
      );
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка удаление данных');
    }
  }

  @Operation.get()
  Future<Response> getNote(
    @Bind.body() Note note,
  ) async {
    try {
      final id = note.id;

      final user = await managedContext.fetchObjectWithID<Note>(id);

      user!.removePropertiesFromBackingMap(['refreshToken', 'accessToken']);

      return AppResponse.ok(
          message: 'Успешное получение заметки', body: user.backing.contents);
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка получения заметки');
    }
  }
}
