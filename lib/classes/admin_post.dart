import 'package:cloud_firestore/cloud_firestore.dart';

class Posts {
  final String? title;
  final String? content;
  final String? picURL;
  final String? postOwner;
  final int? date;
  final int? likes;
  final List<String>? comments;

  Posts({
    this.title,
    this.content,
    this.picURL,
    this.postOwner,
    this.date,
    this.likes,
    this.comments,
  });

  factory Posts.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return Posts(
      title: data?['title'] ?? "default",
      content: data?['content'] ?? "default",
      picURL: data?['picURL'] ?? "https://media.springernature.com/w300/springer-static/image/art%3A10.1038%2F528190a/MediaObjects/41586_2015_Article_BF528190a_Figa_HTML.jpg",
      postOwner: data?['postOwner'] ?? "default",
      date: data?['date'] ?? 1699579139,
      likes: data?['likes'] ?? 0,
      comments:
      data?['comments'] is Iterable ? List.from(data?['comments']) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (title != null) "title": title,
      if (content != null) "content": content,
      if (picURL != null) "picURL": picURL,
      if (postOwner != null) "postOwner": postOwner,
      if (date != null) "date": date,
      if (likes != null) "likes": likes,
      if (comments != null) "comments": comments,
    };
  }
}