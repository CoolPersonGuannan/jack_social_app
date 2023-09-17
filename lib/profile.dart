import 'dart:developer';

import 'package:animated_background/animated_background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jack_social_app_v2/chat_page.dart';
import 'package:jack_social_app_v2/form_widget.dart';
import 'package:jack_social_app_v2/image_picker_example.dart';
import 'package:jack_social_app_v2/main.dart';
import 'package:jack_social_app_v2/your_journals.dart';

import 'auth/auth.dart';

/// Displayed as a profile image if the user doesn't have one.
const placeholderImage =
    'https://upload.wikimedia.org/wikipedia/commons/c/cd/Portrait_Placeholder_Square.png';

/// Profile page shows after sign in or registeration
class ProfilePage extends StatefulWidget {
  // ignore: public_member_api_docs
  const ProfilePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin{
  late User user;
  late TextEditingController controller;

  String? photoURL;

  bool showSaveButton = false;
  bool isLoading = false;

  @override
  void initState() {
    user = auth.currentUser!;
    controller = TextEditingController(text: user.displayName);

    controller.addListener(_onNameChanged);

    auth.userChanges().listen((event) {
      if (event != null && mounted) {
        setState(() {
          user = event;
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(_onNameChanged);

    super.dispose();
  }

  void setIsLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  void _onNameChanged() {
    setState(() {
      if (controller.text == user.displayName || controller.text.isEmpty) {
        showSaveButton = false;
      } else {
        showSaveButton = true;
      }
    });
  }

  /// Map User provider data into a list of Provider Ids.
  List get userProviders => user.providerData.map((e) => e.providerId).toList();

  Future updateDisplayName() async {
    await user.updateDisplayName(controller.text);

    setState(() {
      showSaveButton = false;
    });

    // ignore: use_build_context_synchronously
    ScaffoldSnackbar.of(context).show('Name updated');
  }

  @override
  Widget build(BuildContext context) {
    ParticleOptions particles = const ParticleOptions(
      baseColor: Colors.cyan,
      spawnOpacity: 0.0,
      opacityChangeRate: 0.25,
      minOpacity: 0.1,
      maxOpacity: 0.4,
      particleCount: 70,
      spawnMaxRadius: 15.0,
      spawnMaxSpeed: 100.0,
      spawnMinSpeed: 30,
      spawnMinRadius: 7.0,
    );
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        body: AnimatedBackground(
          vsync: this,
          behaviour: RandomParticleBehaviour(options: particles),
          child: Stack(
            children: [
              SizedBox(
                // width: 400,
                child: SingleChildScrollView(
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  maxRadius: 100,
                                  backgroundImage: NetworkImage(
                                    user.photoURL ?? placeholderImage,
                                  ),
                                ),
                                Positioned.directional(
                                  textDirection: Directionality.of(context),
                                  end: 0,
                                  bottom: 0,
                                  child: Material(
                                    clipBehavior: Clip.antiAlias,
                                    color: Theme.of(context).colorScheme.secondary,
                                    borderRadius: BorderRadius.circular(40),
                                    child: InkWell(
                                      onTap: () async {
                                        final photoURL = await getPhotoURLFromUser();

                                        if (photoURL != null) {
                                          await user.updatePhotoURL(photoURL);
                                        }
                                      },
                                      radius: 50,
                                      child: const SizedBox(
                                        width: 35,
                                        height: 35,
                                        child: Icon(Icons.edit),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              style: const TextStyle(
                                fontSize: 30,
                              ),
                              textAlign: TextAlign.center,
                              controller: controller,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                alignLabelWithHint: true,
                                label: Center(
                                  child: Text(
                                    'Click to add a display name',
                                  ),
                                ),
                              ),
                            ),
                            Text(
                                user.email ?? user.phoneNumber ?? 'User',
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (userProviders.contains('phone'))
                                  const Icon(Icons.phone),
                                if (userProviders.contains('password'))
                                  const Icon(Icons.mail),
                                if (userProviders.contains('google.com'))
                                  SizedBox(
                                    width: 24,
                                    child: Image.network(
                                      'https://upload.wikimedia.org/wikipedia/commons/0/09/IOS_Google_icon.png',
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // const SizedBox(height: 20),
                      // const SizedBox(height: 20),
                      // TextButton(
                      //   onPressed: () async {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => RealTimeFirebase()),
                      //     );
                      //   },
                      //   child: const Text('Test Firebase'),
                      // ),
                      // TextButton(
                      //   onPressed: () async {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => FormWidgetsDemo()),
                      //     );
                      //   },
                      //   child: const Text('Forms Page'),
                      // ),
                      // TextButton(
                      //   onPressed: ()   {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => const ChatPage(character: "You are a teenager in a high school and you are also participate in multiple school clubs and sport teams. You are also focusing on grades and academics. "),),
                      //     );
                      //   },
                      //   child: const Text('Chat Page'),
                      // ),
                      // const Divider(),
                      // TextButton(
                      //   onPressed: _signOut,
                      //   child: const Text('Sign out'),
                      // ),
                      // GridView.count(
                      //   physics: const BouncingScrollPhysics(),
                      //   shrinkWrap: true,
                      //   primary: false,
                      //   padding: const EdgeInsets.all(20),
                      //   crossAxisSpacing: 10,
                      //   mainAxisSpacing: 10,
                      //   crossAxisCount: 2,
                      //   children: <Widget>[
                      //     Container(
                      //       padding: const EdgeInsets.all(8),
                      //       color: Colors.teal[100],
                      //       child: const Text("He'd have you all unravel at the"),
                      //     ),
                      //     Container(
                      //       padding: const EdgeInsets.all(8),
                      //       color: Colors.teal[200],
                      //       child: const Text('Heed not the rabble'),
                      //     ),
                      //     Container(
                      //       padding: const EdgeInsets.all(8),
                      //       color: Colors.teal[300],
                      //       child: const Text('Sound of screams but the'),
                      //     ),
                      //     Container(
                      //       padding: const EdgeInsets.all(8),
                      //       color: Colors.teal[400],
                      //       child: const Text('Who scream'),
                      //     ),
                      //     Container(
                      //       padding: const EdgeInsets.all(8),
                      //       color: Colors.teal[500],
                      //       child: const Text('Revolution is coming...'),
                      //     ),
                      //     Container(
                      //       padding: const EdgeInsets.all(8),
                      //       color: Colors.teal[600],
                      //       child: const Text('Revolution, they...'),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
              Positioned.directional(
                textDirection: Directionality.of(context),
                end: 40,
                top: 40,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: !showSaveButton
                      ? SizedBox(key: UniqueKey())
                      : TextButton(
                          onPressed: isLoading ? null : updateDisplayName,
                          child: const Text('Save changes'),
                        ),
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FormPage()),
              );
            },
            label: const Text("Let's write about your day"),
        ),
      ),
    );
  }

  Future<String?> getPhotoURLFromUser() async {
    String? photoURL;

    // Update the UI - wait for the user to enter the SMS code
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('New image Url:'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
            OutlinedButton(
              onPressed: () {
                photoURL = null;
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
          content: Container(
            padding: const EdgeInsets.all(20),
            child: TextField(
              onChanged: (value) {
                photoURL = value;
              },
              textAlign: TextAlign.center,
              autofocus: true,
            ),
          ),
        );
      },
    );

    return photoURL;
  }

  /// Example code for sign out.
  Future<void> _signOut() async {
    await auth.signOut();
    await GoogleSignIn().signOut();
  }
}
