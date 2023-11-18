import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jack_social_app_v2/admins/home_page.dart';
import 'package:jack_social_app_v2/users/home_page.dart';

import 'auth/auth.dart';
import 'auth/firebase_options.dart';

bool shouldUseFirebaseEmulator = false;

late final FirebaseApp app;
late final FirebaseAuth auth;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  auth = FirebaseAuth.instanceFor(app: app);

  if (shouldUseFirebaseEmulator) {
    await auth.useAuthEmulator('localhost', 9099);
  }

  runApp(const AuthExampleApp());
}

class AuthExampleApp extends StatelessWidget {
  const AuthExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jack Social App',
      //initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        //'/': (context) => const AuthGate(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/Admins': (context) => const AdminHomePage(),
        '/Users': (context) => const BottomNavigationBarControl(),
      },
      theme: ThemeData(primarySwatch: Colors.amber),
      home: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              children: [
                Visibility(
                  visible: constraints.maxWidth >= 1200,
                  child: Expanded(
                    child: Container(
                      height: double.infinity,
                      color: Theme.of(context).colorScheme.primary,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Firebase Auth Desktop',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: constraints.maxWidth >= 1200
                      ? constraints.maxWidth / 2
                      : constraints.maxWidth,
                  child: StreamBuilder(
                    stream: auth.authStateChanges(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                           FirebaseFirestore.instance.collection('JackSocialApp')
                              .doc("All Users")
                              .collection("Users")
                              .doc(snapshot.data!.uid)
                              .get()
                              .then((value) {
                            var userType = value.data()!["role"];
                            if (userType == "Users") {
                              print("testPushUsersMain");
                              Navigator.pushReplacementNamed(
                                  context,
                                  "/Users"
                              );
                            }
                            if (userType == "Admins") {
                              print("testPushAdminsMain");
                              Navigator.pushReplacementNamed(
                                  context,
                                  "/Admins"
                              );
                            }
                          });
                      }
                      return const AuthGate();
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
