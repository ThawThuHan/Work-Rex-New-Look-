import 'package:cloud_firestore/cloud_firestore.dart';

class WorkRexUser {
  String userid;
  String name;
  String phone;
  String staffId;
  String department;
  String email;
  String imgUrl;
  dynamic performance;
  dynamic personality;
  dynamic knowledge;
  dynamic teamwork;
  dynamic overall;

  WorkRexUser({
    this.name,
    this.userid,
    this.phone,
    this.staffId,
    this.department,
    this.email,
    this.imgUrl,
    this.performance,
    this.personality,
    this.knowledge,
    this.teamwork,
    this.overall,
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
      performance: doc[performanceField],
      personality: doc[personalityField],
      knowledge: doc[knowledgeField],
      teamwork: doc[teamworkField],
      overall: doc[overallField],
    );
  }

  static const String useridField = 'userid';
  static const String nameField = 'name';
  static const String phoneField = 'phone';
  static const String staffidField = 'staffid';
  static const String deptField = 'department';
  static const String emailfield = 'email';
  static const String imgUrlField = 'imgUrl';
  static const String performanceField = 'performance';
  static const String personalityField = 'personality';
  static const String knowledgeField = 'knowledge';
  static const String teamworkField = 'teamwork';
  static const String overallField = 'overall';

  static Map<String, dynamic> toMap({WorkRexUser user, isNew = true}) {
    Map<String, dynamic> map = Map<String, dynamic>();
    map[useridField] = user.userid;
    map[nameField] = user.name;
    map[phoneField] = user.phone;
    map[staffidField] = user.staffId;
    map[deptField] = user.department;
    map[emailfield] = user.email;
    map[imgUrlField] = user.imgUrl;
    map[performanceField] = user.performance;
    map[personalityField] = user.personality;
    map[knowledgeField] = user.knowledge;
    map[teamworkField] = user.teamwork;
    map[overallField] = user.overall;
    if (isNew) {
      map['onCreated'] = FieldValue.serverTimestamp();
    }
    return map;
  }
}
