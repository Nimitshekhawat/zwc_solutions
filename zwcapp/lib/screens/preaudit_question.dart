import 'dart:io';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';
import 'package:zwcapp/screens/customwidgets.dart';
import 'package:image/image.dart' as img; // For image compression
import 'package:zwcapp/screens/submitted_ans_text_vid.dart';
import '../Model/preaudit_model.dart';
import '../services/preaudit_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skeletonizer/skeletonizer.dart';
// import 'package:video_compress/video_compress.dart';


class Answer {
  final String answerText;
  final List<String>? answerMedia;  // List of media URLs (both images and videos)
  final String? answeredBy;
  final String? time;

  Answer({
    required this.answerText,
    this.answerMedia,  // List of media URLs (images or videos)
    required this.answeredBy,
    required this.time,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      answerText: json['answer_text'],
      answerMedia: json['answer_image'] != null
          ? List<String>.from(json['answer_image'])  // Handle array of URLs (images/videos)
          : null,
      answeredBy: json['answered_by'],
      time: json['created_at'],
    );
  }
}




class PreAuditScreen extends StatefulWidget {
  final String locationId;

  const PreAuditScreen({super.key, required this.locationId});

  @override
  State<PreAuditScreen> createState() => _PreAuditScreenState();
}

class _PreAuditScreenState extends State<PreAuditScreen> {
  late TextEditingController answer = TextEditingController();
  bool _isLoading = false;
  Future<PreauditQuestionsmodel?>? _questionsFuture;
  final PreauditQuestionsService _service = PreauditQuestionsService();
  PreauditQuestionsmodel? _fetchedData;
  int sectionIndex = 0;
  int subSectionIndex = 0;
  int questionIndex = 0;

  final ImagePicker _picker = ImagePicker();

  // File? _selectedMedia;
  List<File> _selectedMedia = [];
  List<Answer> questionAnswers = []; // List to hold answers

  @override
  void initState() {
    super.initState();
    _questionsFuture = _service.fetchData(widget.locationId);
    _questionsFuture!.then((data) {
      setState(() {
        _fetchedData = data;
        _loadAnswersForCurrentQuestion(); // Load answers for the first question
      });
    });
  }

  // Future<File> _compressImage(File file) async {
  //   final bytes = await file.readAsBytes();
  //   final image = img.decodeImage(bytes);
  //   final compressed = img.encodeJpg(image!, quality: 70);
  //   final compressedFile = File(file.path)..writeAsBytesSync(compressed);
  //   return compressedFile;
  // }
  Future<File?> _compressImage(File file) async {
    final filePath = file.absolute.path;

    // Ensure the file has a valid image extension
    final lastIndex = filePath.lastIndexOf(RegExp(r'\.(jpg|jpeg|png)$', caseSensitive: false));
    if (lastIndex == -1) {
      print("Unsupported file type.");
      return null;
    }

    // Generate the compressed file output path
    final outPath = "${filePath.substring(0, lastIndex)}_compressed${filePath.substring(lastIndex)}";

    try {
      // Compress the image
      final XFile? compressedFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        outPath,
        quality: 70, // Adjust compression quality as needed
      );

      // Convert XFile to File before returning
      return compressedFile != null ? File(compressedFile.path) : null;
    } catch (e) {
      print("Error compressing image: $e");
      return null; // Return null in case of an error
    }
  }


  Future<void> _pickImagesFromGallery() async {
    // Request permissions
    var status = await _requestMediaPermissions();
    if (!status) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Media permission is required to upload images.")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Use ImagePicker to pick multiple images
      final List<XFile>? selectedImages = await ImagePicker().pickMultiImage();

      if (selectedImages != null) {
        // Compress images in parallel
        final List<Future<File?>> compressionTasks = selectedImages.map((image) {
          return _compressImage(File(image.path));
        }).toList();

        // Wait for all compression tasks to complete
        final List<File?> compressedImages = await Future.wait(compressionTasks);

        // Add non-null compressed images to the media list
        final List<File> validImages = compressedImages.whereType<File>().toList();
        if (validImages.isNotEmpty) {
          setState(() => _selectedMedia.addAll(validImages));
        }
      }
    } catch (e) {
      print("Error picking images: $e");
    }

    setState(() => _isLoading = false);
  }

  Future<void> _pickVideosFromGallery() async {
    // Request permissions
    var status = await _requestMediaPermissions();

    if (!status) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Media permission is required to upload videos.")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Use ImagePicker to pick a video
      final XFile? video = await ImagePicker().pickVideo(source: ImageSource.gallery);

      if (video != null) {
        // Compress video
        final File? compressedVideo = await _compressVideo(File(video.path));

        // Add non-null compressed video to the media list
        if (compressedVideo != null) {
          // Get the size of the compressed video in bytes
          final int fileSizeInBytes = await compressedVideo.length();

          // Convert bytes to kilobytes (KB) or megabytes (MB) for readability
          final double fileSizeInKB = fileSizeInBytes / 1024;
          final double fileSizeInMB = fileSizeInKB / 1024;

          // Print the size
          print('Compressed video size: $fileSizeInBytes bytes');
          print('Compressed video size: ${fileSizeInKB.toStringAsFixed(2)} KB');
          print('Compressed video size: ${fileSizeInMB.toStringAsFixed(2)} MB');

          // Add the video to the media list
          setState(() => _selectedMedia.add(compressedVideo));
        }
      }
    } catch (e) {
      print("Error picking videos: $e");
    }

    setState(() => _isLoading = false);
  }

// Request media permissions
  Future<bool> _requestMediaPermissions() async {
    if (Platform.isAndroid) {
      // For Android 13+ (API 33+)
      if (await Permission.photos.isGranted ||
          await Permission.videos.isGranted ||
          await Permission.mediaLibrary.isGranted) {
        return true;
      }

      // For Android 10+ (API 29+) and below
      var status = await Permission.storage.request();
      if (status.isDenied || status.isPermanentlyDenied) {
        status = await Permission.camera.request();
      }
      return status.isGranted;
    } else if (Platform.isIOS) {
      // For iOS
      final status = await Permission.photos.request();
      return status.isGranted;
    }

    return false;
  }


  Future<File?> _compressVideo(File videoFile) async {
    try {
      // Initialize video compression
      final MediaInfo? mediaInfo = await VideoCompress.compressVideo(
        videoFile.path,
        quality: VideoQuality.LowQuality,
        frameRate: 24,
        deleteOrigin: false, // Keep original file
      );

      // Return the compressed video file
      return mediaInfo?.file != null ? File(mediaInfo!.file!.path) : null;
    } catch (e) {
      print("Error compressing video: $e");
      return null;
    }
  }

  void _showMediaPickerDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Choose Media Type"),
          content: Text("Do you want to upload images or videos?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _pickImagesFromGallery();
              },
              child: Text("Images"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _pickVideosFromGallery();
              },
              child: Text("Video"),
            ),
          ],
        );
      },
    );
  }





  Future<void> _takePictureFromCamera() async {
    // Check and request camera permission
    var status = await Permission.camera.request();

    if (status.isGranted) {
      try {
        // Open the camera
        final XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
        if (image != null) {
          final compressedImage = await _compressImage(File(image.path));
          if (compressedImage != null) {
            setState(() {
              _selectedMedia.add(compressedImage);
            });
          }
        }
      } catch (e) {
        print("Error capturing image: $e");
      }
    } else if (status.isDenied || status.isPermanentlyDenied) {
      // Show a message if permission is denied
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Camera permission is required to take photos.")),
      );
      if (status.isDenied || status.isPermanentlyDenied) {
        status = await Permission.camera.request();
      }
    }
  }


  void _removeallmedia() {
    setState(() {
      _selectedMedia = [];
    });
  }

  void _removeMedia(int index) {
    setState(() {
      _selectedMedia.removeAt(index);
    });
  }

  // Future<void> _submitAnswerWithImage() async {
  //   if (_fetchedData == null) return;
  //
  //   final currentQuestion = _fetchedData!.data[sectionIndex]
  //       .subSections[subSectionIndex].questions[questionIndex];
  //
  //   // if (answer.text.isEmpty && _selectedMedia == null) {
  //   //   ScaffoldMessenger.of(context).showSnackBar(
  //   //     SnackBar(content: Text("Answer is empty! Please provide an answer or an image.")),
  //   //   );
  //   //   return;
  //   // }
  //
  //   bool success = await _service.submitAnswerWithImages(
  //     areaId: widget.locationId,
  //     questionId: currentQuestion.questionId,
  //     textAnswer: answer.text,
  //     files: _selectedMedia,
  //   );
  //
  //   // Handle success/failure accordingly
  // }

  Future<void> _reloadData() async {
    final newData = await _service.fetchData(widget.locationId);
    setState(() {
      _fetchedData = newData;
    });
  }

  // void handleYesOrSkip(bool isYes, {bool isSkip = false}) async {
  //   if (isYes && !isSkip) {
  //     // Check if an answer or image is provided
  //     if (answer.text.isEmpty && _selectedMedia == null) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //             content: Text(
  //                 "Answer is empty! Please provide an answer or an image.")),
  //       );
  //       return; // Exit early
  //     }
  //     // Submit the answer before moving forward
  //     await _submitAnswerWithImage();
  //     _reloadData();
  //   }
  //
  //   // Move forward (for both "Yes" and "Skip")
  //   if (isYes || isSkip) {
  //     setState(() {
  //       if (_fetchedData != null) {
  //         if (questionIndex <
  //             _fetchedData!.data[sectionIndex].subSections[subSectionIndex]
  //                     .questions.length -
  //                 1) {
  //           questionIndex++;
  //         } else if (subSectionIndex <
  //             _fetchedData!.data[sectionIndex].subSections.length - 1) {
  //           subSectionIndex++;
  //           questionIndex = 0;
  //         } else if (sectionIndex < _fetchedData!.data.length - 1) {
  //           sectionIndex++;
  //           subSectionIndex = 0;
  //           questionIndex = 0;
  //         } else {
  //           print("Completed all sections");
  //         }
  //         answer.clear();
  //         _removeallmedia();
  //
  //         _loadAnswersForCurrentQuestion(); // Load answers for the new question
  //       }
  //     });
  //   } else {
  //     // Move backward
  //     setState(() {
  //       if (_fetchedData != null) {
  //         if (questionIndex > 0) {
  //           questionIndex--;
  //         } else if (subSectionIndex > 0) {
  //           subSectionIndex--;
  //           questionIndex = _fetchedData!.data[sectionIndex]
  //                   .subSections[subSectionIndex].questions.length -
  //               1;
  //         } else if (sectionIndex > 0) {
  //           sectionIndex--;
  //           subSectionIndex =
  //               _fetchedData!.data[sectionIndex].subSections.length - 1;
  //           questionIndex = _fetchedData!.data[sectionIndex]
  //                   .subSections[subSectionIndex].questions.length -
  //               1;
  //         } else {
  //           print("Already at the first question");
  //         }
  //         answer.clear();
  //         _removeallmedia();
  //         // Load answers for the new question
  //         _loadAnswersForCurrentQuestion();
  //       }
  //     });
  //   }
  // }
  void handleYesOrSkip(bool isYes, {bool isSkip = false}) async {
    if (isYes && !isSkip) {
      // Check if an answer or image is provided
      if (answer.text.isEmpty && _selectedMedia == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Answer is empty! Please provide an answer or an image."),
          ),
        );
        return; // Exit early
      }
      // Print the number of files in _selectedMedia array
      print("Number of files in _selectedMedia: ${_selectedMedia.length}");

      // Print the size of each file in MB
      for (var file in _selectedMedia) {
        int fileSizeInBytes = file.lengthSync();
        double fileSizeInMB = fileSizeInBytes / (1024 * 1024); // Convert bytes to MB
        print("File size of ${file.path}: ${fileSizeInMB.toStringAsFixed(2)} MB");
      }

      // Set loading state to true before API call
      setState(() {
        _isLoading = true;
      });

      // Submit the answer with the image/video
      bool success = await _submitAnswerWithImage();

      // Stop loader and handle navigation only on success
      setState(() {
        _isLoading = false;
      });

      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to submit answer. Please try again.")),
        );
        return; // Exit if submission failed
      }
      _reloadData();
    }

    // Move forward (for both "Yes" and "Skip")
    if (isYes || isSkip) {
      _navigateToNextQuestion();
    } else {
      // Move backward
      _navigateToPreviousQuestion();
    }
  }

// Submit answer with the loading state
  Future<bool> _submitAnswerWithImage() async {
    if (_fetchedData == null) return false;

    final currentQuestion = _fetchedData!.data[sectionIndex]
        .subSections[subSectionIndex].questions[questionIndex];

    try {
      bool success = await _service.submitAnswerWithImages(
        areaId: widget.locationId,
        questionId: currentQuestion.questionId,
        textAnswer: answer.text,
        files: _selectedMedia,
      );

      return success; // Return success status
    } catch (e) {
      // Log or handle error
      print("Error submitting answer: $e");
      return false;
    }
  }

// Navigate to the next question
  void _navigateToNextQuestion() {
    setState(() {
      if (_fetchedData != null) {
        if (questionIndex <
            _fetchedData!.data[sectionIndex].subSections[subSectionIndex]
                .questions.length -
                1) {
          questionIndex++;
        } else if (subSectionIndex <
            _fetchedData!.data[sectionIndex].subSections.length - 1) {
          subSectionIndex++;
          questionIndex = 0;
        } else if (sectionIndex < _fetchedData!.data.length - 1) {
          sectionIndex++;
          subSectionIndex = 0;
          questionIndex = 0;
        } else {
          print("Completed all sections");
        }
        answer.clear();
        _removeallmedia();
        _loadAnswersForCurrentQuestion(); // Load answers for the new question
      }
    });
  }

// Navigate to the previous question
  void _navigateToPreviousQuestion() {
    setState(() {
      if (_fetchedData != null) {
        if (questionIndex > 0) {
          questionIndex--;
        } else if (subSectionIndex > 0) {
          subSectionIndex--;
          questionIndex = _fetchedData!.data[sectionIndex]
              .subSections[subSectionIndex].questions.length -
              1;
        } else if (sectionIndex > 0) {
          sectionIndex--;
          subSectionIndex =
              _fetchedData!.data[sectionIndex].subSections.length - 1;
          questionIndex = _fetchedData!.data[sectionIndex]
              .subSections[subSectionIndex].questions.length -
              1;
        } else {
          print("Already at the first question");
        }
        answer.clear();
        _removeallmedia();
        _loadAnswersForCurrentQuestion();
      }
    });
  }


  // void _loadAnswersForCurrentQuestion() {
  //   if (_fetchedData != null) {
  //     // Fetch answers for the current question
  //     final answersData = _fetchedData!
  //         .data[sectionIndex]
  //         .subSections[subSectionIndex]
  //         .questions[questionIndex]
  //         .answers; // Adjust this if your answers are structured differently
  //
  //     setState(() {
  //       // Only load answer_text and answer_image
  //       questionAnswers = List<Answer>.from(
  //         answersData.map((answer) => Answer.fromJson(answer)),
  //       );
  //     });
  //   }
  // }
  // void _loadAnswersForCurrentQuestion() {
  //   if (_fetchedData != null) {
  //     // Fetch answers for the current question
  //     final answersData = _fetchedData!
  //         .data[sectionIndex]
  //         .subSections[subSectionIndex]
  //         .questions[questionIndex]
  //         .answers; // Adjust this if your answers are structured differently
  //
  //     setState(() {
  //       // Only load answer_text and answer_images
  //       questionAnswers = List<Answer>.from(
  //         answersData.map((answer) => Answer.fromJson(answer)),
  //       );
  //     });
  //   }
  // }
  void _loadAnswersForCurrentQuestion() {
    if (_fetchedData != null) {
      // Fetch answers for the current question
      final answersData = _fetchedData!
          .data[sectionIndex]
          .subSections[subSectionIndex]
          .questions[questionIndex]
          .answers; // Adjust this if your answers are structured differently

      setState(() {
        // Only load answer_text and answer_images
        questionAnswers = List<Answer>.from(
          answersData.map((answer) => Answer.fromJson(answer)),
        );
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(63),
        child: Mainappbar(name: "Checklist", context: context),
      ),
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/images/dashboard_background.png',
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onHorizontalDragEnd: (details) {
                        if (details.primaryVelocity! < 0) {
                          // Swiped Left -> Skip to next question
                          handleYesOrSkip(false, isSkip: true);
                        } else if (details.primaryVelocity! > 0) {
                          // Swiped Right -> Back to previous question
                          handleYesOrSkip(false);
                        }
                      },
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 34),
                            if (_fetchedData != null)
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: TextpoppinsExtraBold_18(
                                          text: _fetchedData!
                                              .data[sectionIndex].sectionName,
                                          color: Colors.black,
                                          textalign: TextAlign.start,
                                          fontsize: 18,
                                          textoverflow: TextOverflow.visible,
                                          maxline: 2),
                                    ),
                                  ],
                                ),
                              ),
                            const SizedBox(height: 20),
                            if (_fetchedData != null)
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextpoppinsExtraBold_18(
                                      text: (subSectionIndex + 1).toString() +
                                          ".",
                                      color: Colors.black,
                                      textalign: TextAlign.start,
                                      fontweight: FontWeight.w600,
                                      fontsize: 18,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                      child: TextpoppinsMedium_16(
                                        text: _fetchedData!
                                            .data[sectionIndex]
                                            .subSections[subSectionIndex]
                                            .subSectionName,
                                        color: Colors.black,
                                        textalign: TextAlign.start,
                                        fontweight: FontWeight.w600,
                                        maxline: 2,
                                        fontsize: 17,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            const SizedBox(height: 25),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 15, bottom: 7),
                              child: TextpoppinsMedium_16(
                                text: "Question",
                                color: Colors.black,
                                textalign: TextAlign.start,
                                fontweight: FontWeight.w500,
                                fontsize: 17,
                              ),
                            ),
                            FutureBuilder<PreauditQuestionsmodel?>(
                              future: _questionsFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.greenAccent,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text("Error loading data"));
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.data.isEmpty) {
                                  return Center(
                                      child: Text("No data available"));
                                }

                                final currentSection =
                                    snapshot.data!.data[sectionIndex];
                                final currentSubSection =
                                    currentSection.subSections[subSectionIndex];
                                final currentQuestion =
                                    currentSubSection.questions[questionIndex];

                                return GestureDetector(
                                  onHorizontalDragEnd: (details) {
                                    if (details.primaryVelocity! < 0) {
                                      // Swiped Left -> Skip to next question
                                      handleYesOrSkip(false, isSkip: true);
                                    } else if (details.primaryVelocity! > 0) {
                                      // Swiped Right -> Back to previous question
                                      handleYesOrSkip(false);
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Text(
                                          currentQuestion.questionText,
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.redAccent),
                                          maxLines: 10,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: TextpoppinsMedium_16(
                        text: "Your Answer",
                        color: Colors.black,
                        textalign: TextAlign.start,
                        fontweight: FontWeight.w500,
                        fontsize: 17,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: answertext_field(
                          context: context,
                          controller: answer,
                          height: 180,
                          hintText: "Fill your answer here",
                          keyboardType: TextInputType.multiline,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          // if (_isLoading)
                          //   Center(
                          //     child: CircularProgressIndicator(
                          //       color: Colors.green,
                          //     ), // Show loader while loading media
                          //   ),
                          _selectedMedia.isEmpty
                              ? Container()
                              : GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _selectedMedia.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 4,
                              mainAxisSpacing: 4,
                            ),
                            itemBuilder: (context, index) {
                              final file = _selectedMedia[index];
                              final isImage =
                                  file.path.endsWith('.jpg') || file.path.endsWith('.png');
                              final isVideo =
                                  file.path.endsWith('.mp4') || file.path.endsWith('.mov');

                              return Stack(
                                children: [
                                  Container(
                                    child: Center(
                                      child: isImage
                                          ? Image.file(
                                        file,
                                        fit: BoxFit.cover,
                                      )
                                          : isVideo
                                          ? FutureBuilder<File?>(
                                        future: VideoCompress.getFileThumbnail(
                                          file.path,
                                          quality: 50, // Adjust thumbnail quality
                                          position: -1, // Default position
                                        ),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Center(
                                              child: CircularProgressIndicator(
                                                color: Colors.green,
                                              ),
                                            );
                                          } else if (snapshot.hasData &&
                                              snapshot.data != null) {
                                            return Image.file(
                                              snapshot.data!,
                                              fit: BoxFit.cover,
                                            );
                                          } else {
                                            return Icon(
                                              Icons.videocam,
                                              size: 50,
                                              color: Colors.grey,
                                            );
                                          }
                                        },
                                      )
                                          : Icon(
                                        Icons.broken_image,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 2,
                                    top: 4,
                                    child: GestureDetector(
                                      onTap: () => setState(() {
                                        _selectedMedia.removeAt(index);
                                      }),
                                      child: Icon(
                                        Icons.remove_circle,
                                        color: Colors.red.shade500,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),


                    // Image upload buttons
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton.icon(
                              onPressed: _showMediaPickerDialog,
                              icon: Icon(
                                Icons.photo_library,
                                color: Colors.green,
                              ),
                              label: Textpoppinslight_16(
                                text: "Upload Media",
                                fontsize: 13.5,
                              ),
                            ),
                            SizedBox(width: 1),
                            ElevatedButton.icon(
                              onPressed: _takePictureFromCamera,
                              icon: Icon(
                                Icons.camera_alt,
                                color: Colors.green,
                              ),
                              label: Textpoppinslight_16(
                                text: "Take a Photo",
                                fontsize: 13.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                                onTap: () {
                                  handleYesOrSkip(false);
                                },
                                child: yes_skip(
                                    text: "Back",
                                    textcolor: Colors.black,
                                    bgcolor: Color(0xFFCDFFD2))),
                            InkWell(
                                onTap: () {
                                  handleYesOrSkip(false, isSkip: true);
                                },
                                child: yes_skip(
                                    text: "Skip",
                                    textcolor: Colors.black,
                                    bgcolor: Color(0xFFCDFFD2))),
                            InkWell(
                                onTap: () {
                                  handleYesOrSkip(true);

                                },
                                child: yes_skip(
                                    text: "Next", textcolor: Colors.black)),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 30,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: TextpoppinsExtraBold_18(
                        text: "Submitted Answers",
                        color: Colors.black,
                        textalign: TextAlign.start,
                        fontsize: 17,
                      ),
                    ),

                    // Load and display answers
                    if (questionAnswers.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: questionAnswers.map((answer) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SubmittedAnsTextVid(answer:answer),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Flexible(
                                              child: TextpoppinsMedium_16(
                                                text: answer.answeredBy,
                                                fontsize: 13,
                                                color: Colors.black54,
                                                maxline: 2,
                                                textoverflow: TextOverflow.visible,
                                              ),
                                            ),
                                            TextpoppinsMedium_16(
                                              text: answer.time,
                                              fontsize: 13,
                                              color: Colors.black54,
                                              maxline: 2,
                                              textoverflow: TextOverflow.visible,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 3, top: 5),
                                          child: TextpoppinsMedium_16(
                                            text: "Answer",
                                            color: Colors.grey.shade600,
                                            fontsize: 13,
                                            fontweight: FontWeight.w600,
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 7, bottom: 8, top: 8),
                                            child: TextpoppinsMedium_16(
                                              text: answer.answerText,
                                              fontsize: 13.5,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      )

                    else
                      Padding(
                        padding: const EdgeInsets.only(left: 14, top: 10),
                        child: TextpoppinsMedium_16(text: "No submitted data"),
                      ),


                    SizedBox(height: 20),

                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
          ),
          if(_isLoading)
            Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.greenAccent,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
