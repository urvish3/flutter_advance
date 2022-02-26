import 'package:firebase_database/firebase_database.dart';

class RTDBHelper {
  RTDBHelper._();

  static final RTDBHelper rtdbHelper = RTDBHelper._();

  static final FirebaseDatabase database = FirebaseDatabase.instance;

  insert1(Map data) async {
    DatabaseReference ref = database.ref('students');
    await ref.set(data);
  }

  Future<void> insert(int uid, Map data) async {
    DatabaseReference ref = database.ref('students');
    await ref.child("$uid").set(data);
  }

  fetchAllData()async{
    DatabaseReference ref=database.ref('students');
    DatabaseEvent event = await ref.once();
    print(event.snapshot.value);
  }

  Stream stream() {
    return database.ref('students').onValue;
  }

  Future<void> delete(String key) async {
    await database.ref('students/$key').remove();
  }

  Future<void> update(String key, Map<String, dynamic> data) async {
    await database.ref('students/$key').update(data);
  }
}
