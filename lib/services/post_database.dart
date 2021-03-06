import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workrex/code_models/post_model.dart';

class PostService {
  static CollectionReference _postRef =
      FirebaseFirestore.instance.collection('Post');

  static Future<void> updatePost(
    String postTo,
    String postId,
    Map<String, dynamic> map,
  ) async {
    _postRef.doc(postTo).collection('user posts').doc(postId).update(map);
  }

  static Future<void> uploadPost(
    String postId,
    String postTo,
    Map<String, dynamic> data,
  ) async {
    await _postRef.doc(postTo).collection('user posts').doc(postId).set(data);
  }

  static Stream<List<PostModel>> getPostsfromPublic() {
    final snapshot = _postRef
        .doc('public')
        .collection('user posts')
        .orderBy('onCreated', descending: true)
        .snapshots();
    return snapshot
        .map((event) => event.docs.map((e) => PostModel.formDoc(e)).toList());
  }

  static Stream<List<PostModel>> getPostsfromDept(String department) {
    final snapshot = _postRef
        .doc(department)
        .collection('user posts')
        .orderBy('onCreated', descending: true)
        .snapshots();
    return snapshot
        .map((event) => event.docs.map((e) => PostModel.formDoc(e)).toList());
  }

  static Future<void> postDelete(String postTo, String postId) async {
    await _postRef.doc(postTo).collection('user posts').doc(postId).delete();
  }
}
