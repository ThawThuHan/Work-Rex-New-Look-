import 'package:cloud_firestore/cloud_firestore.dart';

class WorkRexUser {
  String userid;
  String name;
  String phone;
  String staffId;
  String department;
  String email;
  String imgUrl;

  WorkRexUser({
    this.name,
    this.userid,
    this.phone,
    this.staffId,
    this.department,
    this.email,
    this.imgUrl,
  });

  factory WorkRexUser.formDoc(DocumentSnapshot doc) {
    return WorkRexUser(
      userid: doc.data()[useridField],
      name: doc[nameField],
      phone: doc[phoneField],
      staffId: doc[staffidField],
      department: doc[deptField],
      email: doc[emailfield],
      imgUrl: doc[imgUrlField],
    );
  }

  static const String useridField = 'userid';
  static const String nameField = 'name';
  static const String phoneField = 'phone';
  static const String staffidField = 'staffid';
  static const String deptField = 'department';
  static const String emailfield = 'email';
  static const String imgUrlField = 'imgUrl';

  static Map<String, dynamic> toMap({WorkRexUser user, isNew = true}) {
    Map<String, dynamic> map = Map<String, dynamic>();
    map[useridField] = user.userid;
    map[nameField] = user.name;
    map[phoneField] = user.phone;
    map[staffidField] = user.staffId;
    map[deptField] = user.department;
    map[emailfield] = user.email;
    map[imgUrlField] = user.imgUrl;
    if (isNew) {
      map['onCreated'] = FieldValue.serverTimestamp();
    }
    return map;
  }
}
