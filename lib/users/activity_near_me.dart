// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class ActivityNearMePage extends StatefulWidget {
//   const ActivityNearMePage({ super.key });
//
//   @override
//   State<ActivityNearMePage> createState() => _ActivityNearMePageState();
// }
//
// class _ActivityNearMePageState extends State<ActivityNearMePage> {
//   String city = "u sub NOW";
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Look up for activities"),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Text("Enter a city that you want to Volunteer in"),
//           ),
//           TextField(
//             onChanged: (value) {
//               city = value;
//             },
//           ),
//           ElevatedButton(onPressed:()async{
//             await launchUrl(Uri.parse("https://www.google.com/search?q=volunteer%20works%20in%20$city"));
//             },
//             child:const Text("Let's go!"),
//           )
//         ],
//       ),
//     );
//
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jack_social_app_v2/classes/admin_post.dart';
import 'package:jack_social_app_v2/main.dart';
import 'package:jack_social_app_v2/users/specific_activity.dart';

class ActivityNearMePage extends StatefulWidget {
  const ActivityNearMePage({super.key});

  @override
  State<ActivityNearMePage> createState() => _ActivityNearMePageState();
}

class _ActivityNearMePageState extends State<ActivityNearMePage> {

  late final CollectionReference<Posts> postRef;

  @override
  void initState(){
    //user = auth.currentUser!;
    postRef = FirebaseFirestore
        .instance
        .collection("JackSocialAppAdminPosts")
        .withConverter(
      fromFirestore: Posts.fromFirestore,
      toFirestore: (Posts post, options) => post.toFirestore(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("Explore Page"),
        // actions: <Widget>[
        //   IconButton(
        //     icon: const Icon(Icons.add_alert),
        //     tooltip: 'Show Snackbar',
        //     onPressed: () {
        //       ScaffoldMessenger.of(context).showSnackBar(
        //           const SnackBar(content: Text('This is a snackbar')));
        //     },
        //   ),
        //   IconButton(
        //     icon: const Icon(Icons.search),
        //     tooltip: 'Go to the next page',
        //     onPressed: () {
        //       // Navigator.push(context, MaterialPageRoute<void>(
        //       //   builder: (BuildContext context) {
        //       //     return Scaffold(
        //       //       appBar: AppBar(
        //       //         title: const Text('Next page'),
        //       //       ),
        //       //       body: Padding(
        //       //         padding: const EdgeInsets.all(8.0),
        //       //         child: SearchAnchor(
        //       //             builder: (BuildContext context, SearchController controller) {
        //       //               return SearchBar(
        //       //                 controller: controller,
        //       //                 padding: const MaterialStatePropertyAll<EdgeInsets>(
        //       //                     EdgeInsets.symmetric(horizontal: 16.0)),
        //       //                 onTap: () {
        //       //                   controller.openView();
        //       //                 },
        //       //                 onChanged: (_) {
        //       //                   controller.openView();
        //       //                 },
        //       //                 leading: const Icon(Icons.search),
        //       //               );
        //       //             },
        //       //             suggestionsBuilder: (BuildContext context, SearchController controller) {
        //       //               return <Widget> {
        //       //                 Padding(
        //       //                   padding: const EdgeInsets.all(8),
        //       //                   child: Row(
        //       //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       //                     children: [
        //       //                       GestureDetector(
        //       //                         child: const Text("#Algebra"),
        //       //                         onTap: () {
        //       //                           Navigator.push(
        //       //                             context,
        //       //                             MaterialPageRoute(builder: (context) =>  const AlgebraPage()),
        //       //                           );
        //       //                         },
        //       //                       ),
        //       //                       GestureDetector(
        //       //                         child: const Text("#Number Theory"),
        //       //                         onTap: () {
        //       //                           Navigator.push(
        //       //                             context,
        //       //                             MaterialPageRoute(builder: (context) => const NumberTheoryPage()),
        //       //                           );
        //       //                         },
        //       //                       ),
        //       //                       const Text("#Geometry"),
        //       //                     ],
        //       //                   ),
        //       //                 ),
        //       //                 const Padding(
        //       //                   padding: EdgeInsets.all(8),
        //       //                   child: Row(
        //       //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //       //                     children: [
        //       //                       Text("#Combinatorics"),
        //       //                       Text("#Others"),
        //       //                       // Text("data 6"),
        //       //                     ],
        //       //                   ),
        //       //                 ),
        //       //                 SizedBox(
        //       //                   height: 240,
        //       //                   child: ListView.builder(
        //       //                     padding: const EdgeInsets.symmetric(vertical: 16.0),
        //       //                     physics: const PageScrollPhysics(),
        //       //                     itemBuilder: (BuildContext context, int index) {
        //       //                       if(index % 2 == 0) {
        //       //                         return _buildCarousel(context, index ~/ 2);
        //       //                       }
        //       //                       else {
        //       //                         return const Divider();
        //       //                       }
        //       //                     },
        //       //                   ) ,
        //       //                 ),
        //       //                 SizedBox(
        //       //                   height: 240,
        //       //                   child: ListView.builder(
        //       //                     padding: const EdgeInsets.symmetric(vertical: 16.0),
        //       //                     physics: const PageScrollPhysics(),
        //       //                     itemBuilder: (BuildContext context, int index) {
        //       //                       if(index % 2 == 0) {
        //       //                         return _buildCarousel(context, index ~/ 2);
        //       //                       }
        //       //                       else {
        //       //                         return const Divider();
        //       //                       }
        //       //                     },
        //       //                   ) ,
        //       //                 ),
        //       //                 SizedBox(
        //       //                   height: 240,
        //       //                   child: ListView.builder(
        //       //                     padding: const EdgeInsets.symmetric(vertical: 16.0),
        //       //                     physics: const PageScrollPhysics(),
        //       //                     itemBuilder: (BuildContext context, int index) {
        //       //                       if(index % 2 == 0) {
        //       //                         return _buildCarousel(context, index ~/ 2);
        //       //                       }
        //       //                       else {
        //       //                         return const Divider();
        //       //                       }
        //       //                     },
        //       //                   ) ,
        //       //                 ),
        //       //               };
        //       //             }),
        //       //       ),
        //       //     );
        //       //   },
        //       // ));
        //     },
        //   ),
        // ],
      ),
      body: StreamBuilder(
          stream: postRef.orderBy("date",descending: true).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final data = snapshot.requireData.docs.toList();
            return GridView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  PostScreen(info: data[index].data(), user: auth.currentUser!,)),
                    );
                  },
                  child: Card(
                    child: Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: CachedNetworkImage(
                            imageUrl: data[index].data().picURL ?? "https:firebasestorage.googleapis.com/v0/b/khoatrancodingminds.appspot.com/o/WechatIMG83.jpg?alt=media&token=90fc2853-7f45-441f-b0de-e83529a86ae0",
                            placeholder: (context, url) => const Center(child:  CircularProgressIndicator()),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                            imageBuilder: (context, imageProvider) => Container(

                              width: double.infinity,
                              decoration: BoxDecoration(
                                // borderRadius: BorderRadius.circular(16),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${data[index].data().title}',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
            );
          }
      ),
    );
  }
}


