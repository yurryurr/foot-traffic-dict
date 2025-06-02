import 'dart:io' as io;
import 'package:dict_foot_traffic/Model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;

import 'package:riverpod/riverpod.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:csv/csv.dart' as csv;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class UsersNotifier extends StateNotifier<List<User>> {
  UsersNotifier() : super([]);

  Future<sql.Database> openDB() async {
    final databaseFact = databaseFactoryFfi;
    final io.Directory appDocumentsDir =
        await syspath.getApplicationDocumentsDirectory();
    final String dbPath =
        path.join(appDocumentsDir.path, "databases", 'dictuser.db');
    var db = await databaseFact.openDatabase(dbPath);
    await db.execute(
        '''CREATE TABLE if not exists dictuser(id text not null, full_name TEXT not null, contact_number TEXT not null,barangay TEXT not null ,gender TEXT not null,age Integer not null, purpose TEXT not null, duplicate Integer not null)''');
    return db;
  }

  Future<sql.Database> openDBUser() async {
    final databaseFact = databaseFactoryFfi;
    final io.Directory appDocumentsDir =
        await syspath.getApplicationDocumentsDirectory();
    final String dbPath =
        path.join(appDocumentsDir.path, "databases", 'dictuser.db');
    var db = await databaseFact.openDatabase(dbPath);
    await db.execute(
        '''CREATE TABLE if not exists dictuserdb(userid integer primary key autoincrement, id text not null, full_name TEXT not null, contact_number TEXT not null,barangay TEXT not null ,gender TEXT not null,age Integer not null, purpose TEXT not null, duplicate Integer not null)''');
    return db;
  }

  Future<void> createUser(User user1) async {
    //add to log database
    var db = await openDB();
    await db.insert(
      'dictuser',
      user1.toMap(),
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
    state = [user1, ...state];

    //add to user database for permanent storage
    db = await openDBUser();
    final data = await db.query('dictuserdb');
    final users = data
        .map((row) => User(
              fullName: row['full_name'] as String,
              contact: row['contact_number'] as String,
              brgy: row['barangay'] as String,
              gender: row['gender'] as String,
              age: row['age'] as int,
              use: row['purpose'] as String,
              duplicate: row['duplicate'] as int,
            ))
        .toList();
    bool isDuplicate = false;
    for (final user in users) {
      if (user.fullName == user1.fullName) {
        isDuplicate = true;
        break;
      }
    }
    if (!isDuplicate) {
      await db.insert(
        'dictuserdb',
        user1.toMap(),
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<User>> getUsers() async {
    final db = await openDBUser();
    final data = await db.query('dictuserdb');
    List<User> users = [];
    for (final {
          'id': id as String,
          'full_name': fullName as String,
          'contact_number': contact as String,
          'barangay': brgy as String,
          'gender': gender as String,
          'age': age as int,
          'purpose': purpose as String,
          'duplicate': onlyUpdating as int,
        } in data) {
      users.add(User(
        id: id,
        brgy: brgy,
        contact: contact,
        use: purpose,
        fullName: fullName,
        age: age,
        gender: gender,
        duplicate: onlyUpdating,
      ));
    }
    return users;
  }

  void clearDBnow() async {
    final db = await openDB();
    await db.delete('dictuser');
  }

  void clearDBYurr() async {
    final db = await openDB();
    await db.delete('dictuserdb');
    await db.delete('dictuser');
    await sql.deleteDatabase("${db.path}/dictuser.db");
    state = [];
    openDB();
  }

  List<User> listed() {
    openDB()
        .then(
      (value1) => value1.query('dictuser'),
    )
        .then(
      (value2) {
        return value2;
      },
    );
    return [];
  }

  Future<void> loadDatabase(bool download) async {
    final db = await openDB();
    final data = await db.query('dictuser');
    final users = data
        .map((row) => User(
              id: row['id'] as String,
              fullName: row['full_name'] as String,
              contact: row['contact_number'] as String,
              brgy: row['barangay'] as String,
              gender: row['gender'] as String,
              age: row['age'] as int,
              use: row['purpose'] as String,
              duplicate: row['duplicate'] as int,
            ))
        .toList()
        .reversed
        .toList();
    state = users;
  }

  Future<void> sendEmail(BuildContext context) async {
    /**
     * CREATE FIRST INTO CSV
     */
    List<List<String>> val = [[]];
    for (var user in state) {
      val.add([
        user.id.toString(),
        user.fullName,
        user.contact,
        user.brgy,
        user.gender,
        user.age.toString(),
        user.use,
      ]);
    }
    val = val.reversed.toList();
    String csv1 = const csv.ListToCsvConverter().convert(val);
    /**
     * SENDING NOW VIA EMAIL
     */
    final Email email = Email(
      body: csv1,
      subject: 'DICT Foot Traffic as of ${DateTime.now()}',
      recipients: ['putoldagger@gmail.com'],
      isHTML: false,
    );
    String resp = '';
    try {
      await FlutterEmailSender.send(email);
      resp = 'SUCCESS';
    } catch (error) {
      resp = error.toString();
    }
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(resp)));
  }

  void addUser(String brgy, String contactNumber, String purpose,
      String fullName, int age, String gender, int onlyUpdating) async {
    final newUser = User(
      brgy: brgy,
      contact: contactNumber,
      use: purpose,
      fullName: fullName,
      age: age,
      gender: gender,
      duplicate: onlyUpdating,
    );

    final db = await openDB();
    await db.insert(
        'dictuser',
        {
          'full_name': fullName.toUpperCase(),
          'contact_number': contactNumber.toUpperCase(),
          'barangay': brgy.toUpperCase(),
          'gender': gender.toUpperCase(),
          'age': age,
          'purpose': purpose.toUpperCase(),
          'duplicate': onlyUpdating,
        },
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    state = [newUser, ...state];
  }

  void removeUser() async {
    final db = await openDB();
    await db.delete('dictuser');
    await sql.deleteDatabase("${db.path}/dictuser.db");

    state = [];
    openDB();
  }

  Future<List<User>> showMe() async {
    final db = await openDB();
    final List<Map<String, Object?>> list = await db.query('dictuser1');
    return [
      for (final {
            'full_name': fullName as String,
            'contact_number': contact as String,
            'barangay': brgy as String,
            'gender': gender as String,
            'age': age as int,
            'purpose': purpose as String,
            'duplicate': onlyUpdating as int,
          } in list)
        User(
          brgy: brgy,
          contact: contact,
          use: purpose,
          fullName: fullName,
          age: age,
          gender: gender,
          duplicate: onlyUpdating,
        )
    ];
  }

  void loadUsers() async {
    final db = await openDB();
    final list = await db.query('dictuser');
    for (final {
          'id': id as String,
          'full_name': fullName as String,
          'contact_number': contact as String,
          'barangay': brgy as String,
          'gender': gender as String,
          'age': age as int,
          'purpose': purpose as String,
          'duplicate': onlyUpdating as int,
        } in list) {
      state = [
        User(
          id: id,
          brgy: brgy,
          contact: contact,
          use: purpose,
          fullName: fullName,
          age: age,
          gender: gender,
          duplicate: onlyUpdating,
        ),
        ...state
      ];
    }

    return;
  }
}

final usersProvider =
    StateNotifierProvider<UsersNotifier, List<User>>((ref) => UsersNotifier());
