import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../Classes/User.dart';

class dbHelper {
  static Database? _db;
  String dbName = 'my_database.db';
  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialDB();
      return _db;
    } else {
      return _db;
    }
  }

  _onCR(Database db, int v) async {
    await db.execute('CREATE TABLE "Users" ('
        'fname TEXT NOT NULL, '
        'lname TEXT NOT NULL, '
        'email TEXT NOT NULL, '
        'phonenum TEXT NOT NULL, '
        'currentBalance REAL'
        ')');
    await db.execute('CREATE TABLE "Transfers" ('
        'senderName TEXT NOT NULL, '
        'receiverName TEXT NOT NULL, '
        'amount REAL NOT NULL'
        ')');

    final Database? mydb = await db;

    final List<Map<String, dynamic>> dummyUsersData = [
      {
        'fname': 'John',
        'lname': 'Doe',
        'email': 'john@example.com',
        'phonenum': '123-456-7890',
        'currentBalance': 8500.0,
      },
      {
        'fname': 'Robert',
        'lname': 'Joseph',
        'email': 'Robert@example.com',
        'phonenum': '123-546-7990',
        'currentBalance': 2500.0,
      },
      {
        'fname': 'Thomas',
        'lname': 'Richard',
        'email': 'Thomas@example.com',
        'phonenum': '123-654-7890',
        'currentBalance': 500.0,
      },
      {
        'fname': 'Nancy',
        'lname': 'William',
        'email': 'Nancy@example.com',
        'phonenum': '321-456-7890',
        'currentBalance': 4000.0,
      },
      {
        'fname': 'Jennifer',
        'lname': 'David',
        'email': 'Jennifer@example.com',
        'phonenum': '944-654-3210',
        'currentBalance': 1500.0,
      },
      {
        'fname': 'Martin',
        'lname': 'Michael',
        'email': 'Martin@example.com',
        'phonenum': '817-654-7890',
        'currentBalance': 200.0,
      },
      {
        'fname': 'Sophia',
        'lname': 'Clark',
        'email': 'Sophia@example.com',
        'phonenum': '999-654-7890',
        'currentBalance': 1000.0,
      },
      {
        'fname': 'Emma',
        'lname': 'White',
        'email': 'Emma@example.com',
        'phonenum': '123-004-7890',
        'currentBalance': 500.0,
      }
    ];
    for (final userData in dummyUsersData) {
      await mydb!.insert('Users', userData);
    }
  }

  Future<void> updateUserBalance(String firstName, double newBalance) async {
    Database? mydb = await db;

    await mydb!.update(
      'Users',
      {'currentBalance': newBalance},
      where: 'fname = ?',
      whereArgs: [firstName],
    );
  }

  initialDB() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, 'my_database.db');
    Database myDB = await openDatabase(path, onCreate: _onCR, version: 1);
    await myDB.execute("DELETE FROM Transfers");

    return myDB;
  }

  Future<List<User>> readUsers() async {
    Database? mydb = await db;
    List<Map<String, dynamic>> response =
        await mydb!.rawQuery("SELECT * FROM Users");
    return List.generate(response.length, (i) {
      return User(
        fname: response[i]['fname'],
        lname: response[i]['lname'],
        phone_num: response[i]['phonenum'],
        current_balance: response[i]['currentBalance'],
        email: response[i]['email'],
      );
    });
  }

  Future<List<Map<String, dynamic>>> getTransfers() async {
    final db = await dbHelper._db;
    if (db == null) {
      return [];
    }
    return await db.query('Transfers');
  }

  Future<void> insertTransfer(
      String senderName, String receiverName, double amount) async {
    Database? mydb = await db;

    await mydb!.insert('Transfers', {
      'senderName': senderName,
      'receiverName': receiverName,
      'amount': amount,
    });
  }
}
