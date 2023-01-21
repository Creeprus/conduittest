import 'dart:io';

import 'package:conduit/conduit.dart';
import 'package:conduittest/model/note.dart';

import '../utils/app_response.dart';
import '../utils/app_utils.dart';

class AppNoteConttolelr extends ResourceController {
  AppNoteConttolelr(this.managedContext);

  final ManagedContext managedContext;

  @Operation.put()
  Future<Response> updateNote(
    @Bind.header(HttpHeaders.authorizationHeader) String header,
    @Bind.body() Note note,
  ) async {
    try {
      // Получаем id пользователя
      // Была создана новая функция ее нужно реализоваться для просмотра функции нажмите на картинку
      final id = note.id;
      // Получаем данные пользователя по его id
      final fNote = await managedContext.fetchObjectWithID<Note>(id);
      // Запрос для обновления данных пользователя
      final qUpdateUser = Query<Note>(managedContext)
        ..where((element) => element.id)
            .equalTo(id) // Поиск пользователя осущетсвляется по id
        ..values.noteName = note.noteName ?? fNote!.noteName
        ..values.noteDateCreated =
            note.noteDateCreated ?? fNote!.noteDateCreated
        ..values.noteDateChanged =
            note.noteDateChanged ?? fNote!.noteDateChanged
        ..values.noteCategory = note.noteCategory ?? fNote!.noteCategory;
      // Вызов функция для обновления данных пользователя
      await qUpdateUser.updateOne();
      // Получаем обновленного пользователя
      final findUser = await managedContext.fetchObjectWithID<Note>(id);
      // Удаляем не нужные параметры для красивого вывода данных пользователя
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
      // Получаем id пользователя
      // Была создана новая функция ее нужно реализоваться для просмотра функции нажмите на картинку
      int id = AppUtils.getIdFromHeader(header);
      // Получаем данные пользователя по его id

      // Запрос для обновления данных пользователя

      await managedContext.transaction((transaction) async {
        final qCreateNote = Query<Note>(transaction)
          ..values.noteName = note.noteName
          ..values.noteDateCreated = note.noteDateCreated
          ..values.noteDateChanged = note.noteDateChanged
          ..values.noteCategory = note.noteCategory;

        final createdUser = await qCreateNote.insert();
        id = createdUser.id!;
      });
      // Вызов функция для обновления данных пользователя

      // Получаем обновленного пользователя
      final findUser = await managedContext.fetchObjectWithID<Note>(id);
      // Удаляем не нужные параметры для красивого вывода данных пользователя
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
      // Получаем данные пользователя по его id
      final fNote = await managedContext.fetchObjectWithID<Note>(id);
      // Запрос для обновления данных пользователя
      final qDeleteUser = Query<Note>(managedContext)
        ..where((element) => element.id)
            .equalTo(id); // Поиск пользователя осущетсвляется по id

      // Вызов функция для обновления данных пользователя
      await qDeleteUser.delete();
      // Получаем обновленного пользователя

      // Удаляем не нужные параметры для красивого вывода данных пользователя

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
      // Получаем id пользователя
      // Была создана новая функция ее нужно реализоваться для просмотра функции нажмите на картинку
      final id = note.id;
      // Получаем данные пользователя по его id
      final user = await managedContext.fetchObjectWithID<Note>(id);
      // Удаляем не нужные параметры для красивого вывода данных пользователя
      user!.removePropertiesFromBackingMap(['refreshToken', 'accessToken']);

      return AppResponse.ok(
          message: 'Успешное получение заметки', body: user.backing.contents);
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка получения заметки');
    }
  }
}
