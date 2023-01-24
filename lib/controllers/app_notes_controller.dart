import 'dart:developer';
import 'dart:io';

import 'package:conduit/conduit.dart';
import 'package:conduittest/model/note.dart';

import '../model/history.dart';
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
        if(e.active==1)
        return {
          "id": e.id,
          "noteName": e.noteName,
          "noteCategory": e.noteCategory,
          "noteDateCreated": e.noteDateCreated,
          "noteDateChanged": e.noteDateChanged,
          "active":e.active
        };
      }).toList();
      return AppResponse.ok(message: 'Успешное получение заметки', body: map2);
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка получения заметки');
    }
  }
   @Operation.put()
  Future<Response> setActiveNote(
    @Bind.query('active') int active,
    @Bind.query('id') int id,
  
  ) async {
      try{
      final fNote = await managedContext.fetchObjectWithID<Note>(id);
      final qUpdateUser = Query<Note>(managedContext)
        ..where((element) => element.id)
            .equalTo(id) 
       ..values.active=active;
        final user = await managedContext.fetchObjectWithID<Note>(id);
           await managedContext.transaction((transaction) async {
        final qHistoryAdd = Query<History>(transaction)
          ..values.noteNameChange = user?.noteName
          ..values.date = DateTime.now()
          ..values.operation="The note was updated";
     

        await qHistoryAdd.insert();
    
      });
      await qUpdateUser.updateOne();
      final findUser = await managedContext.fetchObjectWithID<Note>(id);
      findUser!.removePropertiesFromBackingMap(['refreshToken', 'accessToken']);

      return AppResponse.ok(
        message: 'Запись скрыта',
        body: findUser.backing.contents,
      );
    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка обновление данных');
    }
  }
}
