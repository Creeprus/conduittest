import 'dart:developer';
import 'dart:io';

import 'package:conduit/conduit.dart';
import 'package:conduittest/model/note.dart';

import '../utils/app_response.dart';
import '../utils/app_utils.dart';

class AppNotesConttoller extends ResourceController {
  AppNotesConttoller(this.managedContext);

  final ManagedContext managedContext;
   
  @Operation.get()
  Future<Response> getNotes(
       @Bind.query('page') int page,
    @Bind.query('amount') int amount,
  ) async {
    try {
    
   
      // Получаем id пользователя
      // Была создана новая функция ее нужно реализоваться для просмотра функции нажмите на картинку
      final id = amount;
      // Получаем данные пользователя по его id
      final qGetAll= await Query<Note>(managedContext)
     ..fetchLimit=id;
      final notes=await qGetAll.fetch();

//     var map2 = {};
//     notes.forEach((customer) => map2[note.noteName] = customer.noteName
//     );
//     notes.forEach((customer) => map2[note.noteCategory] = customer.noteCategory
//     );
// notes.forEach((customer) => map2[note.noteDateChanged] = customer.noteDateChanged
//     );
//     notes.forEach((customer) => map2[note.noteDateCreated] = customer.noteDateCreated
//     );
//      notes.forEach((customer) => map2[note.id] = customer.id
//     );
//     print(map2);
var map2=notes.map((e){ return
{
"id": e.id,
"noteName": e.noteName,
	"noteCategory": e.noteCategory,
	"noteDateCreated": e.noteDateCreated,
	"noteDateChanged": e.noteDateChanged
};
}

).toList();
       return AppResponse.ok(
       //message: 'Успешное получение заметки', body: notes..forEach((Note element) { element.backing.contents;}));
         message: 'Успешное получение заметки', body: map2);
     //message: 'Успешное получение заметки', body: notes[1].backing.contents);

    } catch (e) {
      return AppResponse.serverError(e, message: 'Ошибка получения заметки');
    }
  }
}