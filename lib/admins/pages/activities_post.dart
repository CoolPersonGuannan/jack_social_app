import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:jack_social_app_v2/auth/auth.dart';
import 'package:jack_social_app_v2/classes/admin_post.dart';
import 'package:jack_social_app_v2/main.dart';
import 'package:path_provider/path_provider.dart';

class AdminActivitiesPostPage extends StatefulWidget {
  const AdminActivitiesPostPage({super.key});

  @override
  State<AdminActivitiesPostPage> createState() => _AdminActivitiesPostPageState();
}

class _AdminActivitiesPostPageState extends State<AdminActivitiesPostPage> {
  final storageRef = FirebaseStorage.instance.ref();
  late final DocumentReference<Posts> postRef;
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  DateTime date = DateTime.now();
  double maxValue = 0;

  late User user;
  late TextEditingController controller;
  final phoneController = TextEditingController();

  String? photoURL;

  bool showSaveButton = false;
  bool isLoading = false;

  final ImagePicker _picker = ImagePicker();
  File? _image;
  late File love;


  @override
  void initState() {
    user = auth.currentUser!;
    super.initState();
  }


  _imgFromCamera() async {
    final image =
    await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = File(image!.path);
    });
  }

  _imgFromGallery() async {
    final image =
    await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = File(image!.path);
    });
  }

  void _showPicker() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Photo Library'),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Do you want to change the current image?")
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                _image = null;
                Navigator.of(context).pop();
                _showPicker();
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Padding buildImageContainer() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Container(
        child: _image == null
            ? Column(
          children: [
            IconButton(
              icon: const Icon(
                Icons.camera_alt_outlined,
              ),
              iconSize: 40,
              onPressed: () {
                _showPicker();
              },
            ),
            const Text('Input your amazing volunteer activity here!'),
          ],
        )
            : Stack(children: [
          Image.file(
            File(_image!.path),
          ),
          Positioned(
              top: 5,
              right: 0, //give the values according to your requirement
              child: MaterialButton(
                onPressed: () {
                  _showMyDialog();
                },
                color: const Color.fromRGBO(243, 222, 186, 1),
                // padding: EdgeInsets.all(16),
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.edit,
                  size: 24,
                ),
              ))
        ]),
      ),
    );
  }

  Future<String> uploadProblemPics() async {
    String problemPicUrl = "";
    final problemUrl = storageRef.child("JackSocialApp/Users/${user.uid}/${date.year}-${date.month}-${date.day}-${_formKey.toString()}.jpg");
    UploadTask uploadProblemPic = problemUrl.putFile(_image!);
    await uploadProblemPic.whenComplete(() async => {
      print("love: ${problemUrl.getDownloadURL()}"),
      problemPicUrl = await problemUrl.getDownloadURL(),
    });
    return problemPicUrl.toString();
  }

  Future updateYourDay() async {
    // ignore: use_build_context_synchronously
    ScaffoldSnackbar.of(context).show('Your Activity has been updated');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Your Activity - Admins'),
      ),
      body: Form(
        key: _formKey,
        child: Scrollbar(
          child: Align(
            alignment: Alignment.topCenter,
            child: Card(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ...[
                        _FormDatePicker(
                          date: date,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                filled: true,
                                hintText: 'Enter the Post Title',
                                labelText: 'Title',
                              ),
                              onChanged: (value) {
                                title = value;
                              },
                              maxLines: 1,
                            ),
                          ],
                        ),
                        buildImageContainer(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                filled: true,
                                hintText: 'Enter the information',
                                labelText: 'Information',
                              ),
                              onChanged: (value) {
                                description = value;
                              },
                              maxLines: 5,
                            ),
                          ],
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  });
                              final post = Posts(
                                title: title,
                                content: description,
                                picURL: await uploadProblemPics(),
                                postOwner: user.uid,
                                date: date.millisecondsSinceEpoch,
                                likes: 0,
                                comments: [],
                              );
                              final docRef = FirebaseFirestore
                                  .instance
                                  .collection("JackSocialAppAdminPosts")
                                  .withConverter(
                                fromFirestore: Posts.fromFirestore,
                                toFirestore: (Posts post, options) => post.toFirestore(),
                              );
                              await docRef.add(post);
                              if(mounted) {
                                ScaffoldSnackbar.of(context).show('Updated activities');
                                Navigator.pop(context);
                              }
                            },
                            child: const Text('Upload your Activities')
                        )
                      ].expand(
                            (widget) => [
                          widget,
                          const SizedBox(
                            height: 24,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FormDatePicker extends StatefulWidget {
  final DateTime date;
  //final ValueChanged<DateTime> onChanged;

  const _FormDatePicker({
    required this.date,
    //required this.onChanged,
  });

  @override
  State<_FormDatePicker> createState() => _FormDatePickerState();
}

class _FormDatePickerState extends State<_FormDatePicker> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Date',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              intl.DateFormat.yMd().format(widget.date),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ],
    );
  }
}