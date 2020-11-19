import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workrex/services/user_database.dart';

class RateService {
  static CollectionReference _rateRef =
      FirebaseFirestore.instance.collection('Rate');

  static Future<void> saveRate(String objectName, String subjectId,
      String rateName, Map<String, dynamic> data) async {
    _rateRef.doc(objectName).collection(rateName).doc(subjectId).set(data);
  }

  static Future<double> getRateOfType(String name, String rateName) async {
    List totalStar = [];
    double rate;
    QuerySnapshot snapshot =
        await _rateRef.doc(name).collection(rateName).get();
    snapshot.docs.forEach((element) {
      totalStar.add(element.data()['rate']);
    });
    Map map = Map();
    totalStar.forEach((element) {
      map["$element"] =
          !map.containsKey("$element") ? (1) : map["$element"] + 1;
    });
    rate = (((map['0.5'] ?? 0) * 0.5) +
            ((map['1'] ?? 0) * 1) +
            ((map['1.5'] ?? 0) * 1.5) +
            ((map['2'] ?? 0) * 2) +
            ((map['2.5'] ?? 0) * 2.5) +
            ((map['3'] ?? 0) * 3) +
            ((map['3.5'] ?? 0) * 3.5) +
            ((map['4'] ?? 0) * 4) +
            ((map['4.5'] ?? 0) * 4.5) +
            ((map['5'] ?? 0) * 5)) /
        ((map['0.5'] ?? 0) +
            (map['1'] ?? 0) +
            (map['1.5'] ?? 0) +
            (map['2'] ?? 0) +
            (map['2.5'] ?? 0) +
            (map['3'] ?? 0) +
            (map['3.5'] ?? 0) +
            (map['4'] ?? 0) +
            (map['4.5'] ?? 0) +
            (map['5'] ?? 0));
    if (!rate.isNaN) {
      return rate;
    }
    return 0.0;
  }

  static Future<void> overallRate(String name, String objectId) async {
    double performance = await getRateOfType(name, 'performance');
    double personality = await getRateOfType(name, 'personality');
    double knowledge = await getRateOfType(name, 'knowledge');
    double teamwork = await getRateOfType(name, 'teamwork');
    print('$personality, $performance, $knowledge, $teamwork');
    double overall = (performance + personality + knowledge + teamwork) / 4;
    await UserService.updateData(objectId, {
      'performance': performance,
      'personality': personality,
      'knowledge': knowledge,
      'teamwork': teamwork,
      'overall': overall,
    });
  }
}
