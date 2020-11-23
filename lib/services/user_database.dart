import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workrex/code_models/user_model.dart';

class UserService {
  static CollectionReference _userRef =
      FirebaseFirestore.instance.collection('Users');

  static Future<void> saveUser({Map<String, dynamic> data}) async {
    await _userRef.doc(data['userid']).set(data);
  }

  static Future<void> updateData(
      String objectId, Map<String, dynamic> data) async {
    _userRef.doc(objectId).update(data);
  }

  static Stream<List<WorkRexUser>> getUsers() {
    return _userRef
        .snapshots()
        .map((event) => event.docs.map((e) => WorkRexUser.formDoc(e)).toList());
  }

  static Stream<List<WorkRexUser>> getUserbyDepartment(String department) {
    return _userRef
        .where(department)
        .orderBy('overall', descending: true)
        .snapshots()
        .map((event) => event.docs.map((e) => WorkRexUser.formDoc(e)).toList());
  }

  static Future<List<WorkRexUser>> getUserbyname(String name) async {
    QuerySnapshot snapshot = await _userRef.get();
    List<WorkRexUser> usersformData =
        snapshot.docs.map((e) => WorkRexUser.formDoc(e)).toList();
    List<WorkRexUser> users = usersformData
        .where((element) =>
            element.name.toLowerCase().contains(name.toLowerCase()))
        .toList();
    return users;
  }

  static Future<WorkRexUser> getUserbyId(String userid) async {
    DocumentSnapshot doc = await _userRef.doc(userid).get();
    WorkRexUser user = WorkRexUser.formDoc(doc);
    return user;
  }

  static Stream<WorkRexUser> getStreamUserbyId(String userid) {
    return _userRef
        .doc(userid)
        .snapshots()
        .map((event) => WorkRexUser.formDoc(event));
  }
}
