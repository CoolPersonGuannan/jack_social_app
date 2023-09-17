import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ActivityNearMePage extends StatefulWidget {
  const ActivityNearMePage({ super.key });

  @override
  State<ActivityNearMePage> createState() => _ActivityNearMePageState();
}

class _ActivityNearMePageState extends State<ActivityNearMePage> {
  String city = "u sub NOW";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Look up for activities"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Enter a city that you want to Volunteer in"),
          ),
          TextField(
            onChanged: (value) {
              city = value;
            },
          ),
          ElevatedButton(onPressed:()async{
            await launchUrl(Uri.parse("https://www.google.com/search?q=volunteer%20works%20in%20$city"));
            },
            child:const Text("Let's go!"),
          )
        ],
      ),
    );

  }
}