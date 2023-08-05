import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jack_social_app_v2/auth.dart';
import 'package:jack_social_app_v2/main.dart';
import 'package:mime/mime.dart';
import 'package:video_player/video_player.dart';

class FormWidgetsDemo extends StatefulWidget {
  const FormWidgetsDemo({super.key});

  @override
  State<FormWidgetsDemo> createState() => _FormWidgetsDemoState();
}

class _FormWidgetsDemoState extends State<FormWidgetsDemo> {

  List<XFile>? _mediaFileList;

  void _setImageFileListFromFile(XFile? value) {
    _mediaFileList = value == null ? null : <XFile>[value];
  }

  dynamic _pickImageError;
  bool isVideo = false;

  VideoPlayerController? _controller;
  VideoPlayerController? _toBeDisposed;
  String? _retrieveDataError;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();

  Future<void> _playVideo(XFile? file) async {
    if (file != null && mounted) {
      await _disposeVideoController();
      late VideoPlayerController controller;
      if (kIsWeb) {
        // TODO(gabrielokura): remove the ignore once the following line can migrate to
        // use VideoPlayerController.networkUrl after the issue is resolved.
        // https://github.com/flutter/flutter/issues/121927
        // ignore: deprecated_member_use
        controller = VideoPlayerController.network(file.path);
      } else {
        controller = VideoPlayerController.file(File(file.path));
      }
      _controller = controller;
      // In web, most browsers won't honor a programmatic call to .play
      // if the video has a sound track (and is not muted).
      // Mute the video so it auto-plays in web!
      // This is not needed if the call to .play is the result of user
      // interaction (clicking on a "play" button, for example).
      const double volume = kIsWeb ? 0.0 : 1.0;
      await controller.setVolume(volume);
      await controller.initialize();
      await controller.setLooping(true);
      await controller.play();
      setState(() {});
    }
  }

  Future<void> _onImageButtonPressed(
      ImageSource source, {
        required BuildContext context,
        bool isMultiImage = false,
        bool isMedia = false,
      }) async {
    if (_controller != null) {
      await _controller!.setVolume(0.0);
    }
    if (context.mounted) {
      if (isVideo) {
        final XFile? file = await _picker.pickVideo(
            source: source, maxDuration: const Duration(seconds: 10));
        await _playVideo(file);
      } else if (isMultiImage) {
        await _displayPickImageDialog(context,
                (double? maxWidth, double? maxHeight, int? quality) async {
              try {
                final List<XFile> pickedFileList = isMedia
                    ? await _picker.pickMultipleMedia(
                  maxWidth: maxWidth,
                  maxHeight: maxHeight,
                  imageQuality: quality,
                )
                    : await _picker.pickMultiImage(
                  maxWidth: maxWidth,
                  maxHeight: maxHeight,
                  imageQuality: quality,
                );
                setState(() {
                  _mediaFileList = pickedFileList;
                });
              } catch (e) {
                setState(() {
                  _pickImageError = e;
                });
              }
            });
      } else if (isMedia) {
        await _displayPickImageDialog(context,
                (double? maxWidth, double? maxHeight, int? quality) async {
              try {
                final List<XFile> pickedFileList = <XFile>[];
                final XFile? media = await _picker.pickMedia(
                  maxWidth: maxWidth,
                  maxHeight: maxHeight,
                  imageQuality: quality,
                );
                if (media != null) {
                  pickedFileList.add(media);
                  setState(() {
                    _mediaFileList = pickedFileList;
                  });
                }
              } catch (e) {
                setState(() {
                  _pickImageError = e;
                });
              }
            });
      } else {
        await _displayPickImageDialog(context,
                (double? maxWidth, double? maxHeight, int? quality) async {
              try {
                final XFile? pickedFile = await _picker.pickImage(
                  source: source,
                  maxWidth: maxWidth,
                  maxHeight: maxHeight,
                  imageQuality: quality,
                );
                setState(() {
                  _setImageFileListFromFile(pickedFile);
                });
              } catch (e) {
                setState(() {
                  _pickImageError = e;
                });
              }
            });
      }
    }
  }

  @override
  void deactivate() {
    if (_controller != null) {
      _controller!.setVolume(0.0);
      _controller!.pause();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    _disposeVideoController();
    maxWidthController.dispose();
    maxHeightController.dispose();
    qualityController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _disposeVideoController() async {
    if (_toBeDisposed != null) {
      await _toBeDisposed!.dispose();
    }
    _toBeDisposed = _controller;
    _controller = null;
  }

  Widget _previewVideo() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_controller == null) {
      return const Text(
        'You have not yet picked a video',
        textAlign: TextAlign.center,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: AspectRatioVideo(_controller),
    );
  }

  Widget _previewImages() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_mediaFileList != null) {
      return Semantics(
        label: 'image_picker_example_picked_images',
        child: ListView.builder(
          shrinkWrap: true,
          key: UniqueKey(),
          itemBuilder: (BuildContext context, int index) {
            final String? mime = lookupMimeType(_mediaFileList![index].path);
            return Semantics(
              label: 'image_picker_example_picked_image',
              child: kIsWeb
                  ? Image.network(_mediaFileList![index].path)
                  : (mime == null || mime.startsWith('image/')
                  ? Image.file(
                File(_mediaFileList![index].path),
                errorBuilder: (BuildContext context, Object error,
                    StackTrace? stackTrace) {
                  return const Center(
                      child:
                      Text('This image type is not supported'));
                },
              )
                  : _buildInlineVideoPlayer(index)),
            );
          },
          itemCount: _mediaFileList!.length,
        ),
      );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  Widget _buildInlineVideoPlayer(int index) {
    final VideoPlayerController controller =
    VideoPlayerController.file(File(_mediaFileList![index].path));
    const double volume = kIsWeb ? 0.0 : 1.0;
    controller.setVolume(volume);
    controller.initialize();
    controller.setLooping(true);
    controller.play();
    return Center(child: AspectRatioVideo(controller));
  }

  Widget _handlePreview() {
    if (isVideo) {
      return _previewVideo();
    } else {
      return _previewImages();
    }
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      if (response.type == RetrieveType.video) {
        isVideo = true;
        await _playVideo(response.file);
      } else {
        isVideo = false;
        setState(() {
          if (response.files == null) {
            _setImageFileListFromFile(response.file);
          } else {
            _mediaFileList = response.files;
          }
        });
      }
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  final database = FirebaseDatabase.instance.ref();
  //final storageRef = FirebaseStorage.instance.ref();


  late User user;
  late TextEditingController controller;
  final phoneController = TextEditingController();

  String? photoURL;

  bool showSaveButton = false;
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  DateTime date = DateTime.now();
  double maxValue = 0;
  bool? brushedTeeth = false;
  bool enableFeature = false;

  @override
  void initState() {
    user = auth.currentUser!;
    controller = TextEditingController(text: user.displayName);

    auth.userChanges().listen((event) {
      if (event != null && mounted) {
        setState(() {
          user = event;
        });
      }
    });

    super.initState();
  }
  TextEditingController descriptionController = TextEditingController();
  bool? BrushedTeeth = false;
  bool? FinishedHomework = false;
  bool? PracticedTennis = false;


  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Future<void> _displayPickImageDialog(
      BuildContext context, OnPickImageCallback onPick) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add optional parameters'),
            content: Column(
              children: <Widget>[
                TextField(
                  controller: maxWidthController,
                  keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                      hintText: 'Enter maxWidth if desired'),
                ),
                TextField(
                  controller: maxHeightController,
                  keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                      hintText: 'Enter maxHeight if desired'),
                ),
                TextField(
                  controller: qualityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: 'Enter quality if desired'),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                  child: const Text('PICK'),
                  onPressed: () {
                    final double? width = maxWidthController.text.isNotEmpty
                        ? double.parse(maxWidthController.text)
                        : null;
                    final double? height = maxHeightController.text.isNotEmpty
                        ? double.parse(maxHeightController.text)
                        : null;
                    final int? quality = qualityController.text.isNotEmpty
                        ? int.parse(qualityController.text)
                        : null;
                    onPick(width, height, quality);
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  Future updateYourDay() async {
    // ignore: use_build_context_synchronously
    ScaffoldSnackbar.of(context).show('Your Day has been updated');
  }

  @override
  Widget build(BuildContext context) {
    final todayDiary = database.child("/users/${user.uid}");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stories of your day"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
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
                              TextFormField(
                                decoration: const InputDecoration(
                                  filled: true,
                                  hintText: 'Reason...',
                                  labelText: 'Rate today /10',
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    title = value;
                                  });
                                },
                              ),
                              TextFormField(
                                //controller: descriptionController,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  filled: true,
                                  hintText:
                                      'Write anything that happened today in 200 words...',
                                  labelText: 'Mood for the day',
                                  counterText:
                                      "Word count: ${200 - description.length} ",
                                  // counter:
                                  //     Text("${descriptionController.text.length}"),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    description = value;
                                  });
                                },
                                maxLines: 5,
                                maxLength: 200,
                              ),
                              _FormDatePicker(
                                date: date,
                                onChanged: (value) {
                                  setState(() {
                                    date = value;
                                  });
                                },
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Approximate value',
                                        style: Theme.of(context).textTheme.bodyLarge,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    intl.NumberFormat.currency(
                                            symbol: "\$", decimalDigits: 0)
                                        .format(maxValue),
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  Slider(
                                    min: 0,
                                    max: 10,
                                    divisions: 10,
                                    value: maxValue,
                                    onChanged: (value) {
                                      setState(() {
                                        maxValue = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Checkbox(
                                    value: BrushedTeeth,
                                    onChanged: (checked) {
                                      setState(() {
                                        BrushedTeeth = checked;
                                      });
                                    },
                                  ),
                                  Checkbox(
                                    value: FinishedHomework,
                                    onChanged: (checked) {
                                      setState(() {
                                        FinishedHomework = checked;
                                      });
                                    },
                                  ),
                                  Checkbox(
                                    value: PracticedTennis,
                                    onChanged: (checked) {
                                      setState(() {
                                        PracticedTennis = checked;
                                      });
                                    },
                                  ),
                                  Text('Brushed Teeth and Mouth',
                                      style: Theme.of(context).textTheme.titleMedium),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Disable feature',
                                      style: Theme.of(context).textTheme.bodyLarge),
                                  Switch(
                                    value: enableFeature,
                                    onChanged: (enabled) {
                                      setState(() {
                                        enableFeature = enabled;
                                      });
                                    },
                                  ),
                                ],
                              ),
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
            Center(
                child: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
                    ? FutureBuilder<void>(
                  future: retrieveLostData(),
                  builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return const Text(
                          'You have not yet picked an image.',
                          textAlign: TextAlign.center,
                        );
                      case ConnectionState.done:
                        return _handlePreview();
                      case ConnectionState.active:
                        if (snapshot.hasError) {
                          return Text(
                            'Pick image/video error: ${snapshot.error}}',
                            textAlign: TextAlign.center,
                          );
                        } else {
                          return const Text(
                            'You have not yet picked an image.',
                            textAlign: TextAlign.center,
                          );
                        }
                    }
                  },
                )
                    : _handlePreview(),
            ),
            ElevatedButton(
              onPressed: () async {
                final todayFood = <String, dynamic> {
                  "date": date.millisecondsSinceEpoch,
                  "title_for_today": title,
                  //"breakfastPicUrl": await uploadBreakfastPics(),
                  "mood_of_the_day": description,
                  //"lunchPicUrl": await uploadLunchPics(),
                  "happiness_level": maxValue,
                  //"dinnerPicUrl": await uploadDinnerPics(),
                };
                var key = database.push().key;
                todayDiary
                    .child(key!)
                    .set(todayFood)
                    .then((_) => print('Food has been posted'))
                    .catchError((error) => print("You got error on $error"));
                updateYourDay();
              },
              child: const Text("Update your Diet today!"),
            ),
          ],
        ),
      ),
      // body: Center(
      //   child: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
      //       ? FutureBuilder<void>(
      //     future: retrieveLostData(),
      //     builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
      //       switch (snapshot.connectionState) {
      //         case ConnectionState.none:
      //         case ConnectionState.waiting:
      //           return const Text(
      //             'You have not yet picked an image.',
      //             textAlign: TextAlign.center,
      //           );
      //         case ConnectionState.done:
      //           return _handlePreview();
      //         case ConnectionState.active:
      //           if (snapshot.hasError) {
      //             return Text(
      //               'Pick image/video error: ${snapshot.error}}',
      //               textAlign: TextAlign.center,
      //             );
      //           } else {
      //             return const Text(
      //               'You have not yet picked an image.',
      //               textAlign: TextAlign.center,
      //             );
      //           }
      //       }
      //     },
      //   )
      //       : _handlePreview(),
      // ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: FloatingActionButton(
              onPressed: () {
                isVideo = false;
                _onImageButtonPressed(
                  ImageSource.gallery,
                  context: context,
                  isMultiImage: true,
                  isMedia: true,
                );
              },
              heroTag: 'multipleMedia',
              tooltip: 'Pick Multiple Media from gallery',
              child: const Icon(Icons.photo_library),
            ),
          ),
          if (_picker.supportsImageSource(ImageSource.camera))
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: FloatingActionButton(
                onPressed: () {
                  isVideo = false;
                  _onImageButtonPressed(ImageSource.camera, context: context);
                },
                heroTag: 'image2',
                tooltip: 'Take a Photo',
                child: const Icon(Icons.camera_alt),
              ),
            ),
        ],
      ),
    );

  }
}

class _FormDatePicker extends StatefulWidget {
  final DateTime date;
  final ValueChanged<DateTime> onChanged;

  const _FormDatePicker({
    required this.date,
    required this.onChanged,
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
        TextButton(
          child: const Text('Edit'),
          onPressed: () async {
            var newDate = await showDatePicker(
              context: context,
              initialDate: widget.date,
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );

            // Don't change the date if the date picker returns null.
            if (newDate == null) {
              return;
            }

            widget.onChanged(newDate);
          },
        )
      ],
    );
  }
}

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality);

class AspectRatioVideo extends StatefulWidget {
  const AspectRatioVideo(this.controller, {super.key});

  final VideoPlayerController? controller;

  @override
  AspectRatioVideoState createState() => AspectRatioVideoState();
}

class AspectRatioVideoState extends State<AspectRatioVideo> {
  VideoPlayerController? get controller => widget.controller;
  bool initialized = false;

  void _onVideoControllerUpdate() {
    if (!mounted) {
      return;
    }
    if (initialized != controller!.value.isInitialized) {
      initialized = controller!.value.isInitialized;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    controller!.addListener(_onVideoControllerUpdate);
  }

  @override
  void dispose() {
    controller!.removeListener(_onVideoControllerUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (initialized) {
      return Center(
        child: AspectRatio(
          aspectRatio: controller!.value.aspectRatio,
          child: VideoPlayer(controller!),
        ),
      );
    } else {
      return Container();
    }
  }
}