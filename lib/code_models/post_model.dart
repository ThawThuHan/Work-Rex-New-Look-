import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postOwnerName;
  final String postOwerDept;
  final String postOwnerImgUrl;
  final String postTo;
  final String postText;
  final List<dynamic> postImgUrls;
  final dynamic postLikes;
  final Timestamp onCreated;

  PostModel({
    this.postOwnerName,
    this.postOwnerImgUrl,
    this.postOwerDept,
    this.postTo,
    this.postText,
    this.postImgUrls,
    this.postLikes,
    this.onCreated,
  });

  factory PostModel.formDoc(DocumentSnapshot doc) {
    final data = doc.data();
    return PostModel(
      postOwnerName: data['postOwnerName'],
      postOwnerImgUrl: data['postOwnerImgUrl'],
      postOwerDept: data['postOwnerDept'],
      postTo: data['postTo'],
      postText: data['postText'],
      postImgUrls: data['postImgUrls'],
      postLikes: data['postLikes'],
      onCreated: data['onCreated'],
    );
  }

  static toMap(PostModel postModel, {bool isNew = true}) {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['postOwnerName'] = postModel.postOwnerName;
    map['postOwnerImgUrl'] = postModel.postOwnerImgUrl;
    map['postOwnerDept'] = postModel.postOwerDept;
    map['postTo'] = postModel.postTo;
    map['postText'] = postModel.postText;
    map['postImgUrls'] = postModel.postImgUrls;
    map['postLikes'] = postModel.postLikes;
    if (isNew) {
      map['onCreated'] = FieldValue.serverTimestamp();
    }
    return map;
  }
}
