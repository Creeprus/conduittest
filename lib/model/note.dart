import 'dart:ffi';

import 'package:conduit/conduit.dart';


class Note extends ManagedObject<_Note> implements _Note {}

class _Note {
  @primaryKey
  int? id;
  @Column(unique: true, indexed: true)
  String? noteName;
  @Column(unique: false, indexed: true)
  String? noteCategory;
  @Column(unique: false, indexed: true)
  String? noteDateCreated;
  @Column(unique: false, indexed: true)
  String? noteDateChanged;
  @Column(unique:false, indexed:true)
  int? active;
}
