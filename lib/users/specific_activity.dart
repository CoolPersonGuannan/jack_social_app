import 'package:cached_network_image/cached_network_image.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jack_social_app_v2/classes/admin_post.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({
    super.key,
    required this.info,
    required this.user,
  });

  final  Posts info;
  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(info.title ?? "default"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CachedNetworkImage(
                //fit: BoxFit.fitWidth,
                imageUrl: info.picURL ?? "https:firebasestorage.googleapis.com/v0/b/khoatrancodingminds.appspot.com/o/WechatIMG83.jpg?alt=media&token=90fc2853-7f45-441f-b0de-e83529a86ae0",
                placeholder: (context, url) => const Center(child:  CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              Text(info.content ?? "default",
                style: TextStyle(fontSize: 26),),
              Text(info.postOwner ?? "love"),
              const Divider(),
              // CommentInitiator(user: user,),
              // ListView.builder(
              //     physics: const NeverScrollableScrollPhysics(),
              //     shrinkWrap: true,
              //     itemCount:100,
              //     itemBuilder: (context,index){
              //       return  Text('Some text');
              //     })
              //info.comments!.isEmpty ? const Center(child: Text('Empty')):
              // Expanded(
              //   //flex: 2,
              //   child: ListView.builder(
              //       itemCount: info.comments!.length,
              //       prototypeItem: Text(info.comments!.first),
              //       itemBuilder: (context,index) {
              //         String comment = info.comments![index];
              //         return Card(
              //           child: Text(
              //           comment,
              //             style: const TextStyle(
              //           fontSize: 20
              //             ),
              //           ),
              //         );
              //       }
              //   ),
              //  ),
            ],
          ),
        ),
      ),
    );
  }
}