import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zwcapp/screens/customwidgets.dart';
import 'package:image/image.dart' as img; // For image compression
import '../Model/preaudit_model.dart';
import '../services/preaudit_service.dart';
import 'package:permission_handler/permission_handler.dart';

class Answer {
  final String answerText;
  final String? answerImage; // Image can be null

  Answer({
    required this.answerText,
    this.answerImage,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      answerText: json['answer_text'],
      answerImage: json['answer_image'] ?? null,
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
  Future<PreauditQuestionsmodel?>? _questionsFuture;
  final PreauditQuestionsService _service = PreauditQuestionsService();
  PreauditQuestionsmodel? _fetchedData;
  int sectionIndex = 0;
  int subSectionIndex = 0;
  int questionIndex = 0;

  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

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

  Future<File> _compressImage(File file) async {
    final bytes = await file.readAsBytes();
    final image = img.decodeImage(bytes);
    final compressed = img.encodeJpg(image!, quality: 70);
    final compressedFile = File(file.path)..writeAsBytesSync(compressed);
    return compressedFile;
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final compressedImage = await _compressImage(File(image.path));
      setState(() {
        _selectedImage = compressedImage;
      });
    }
  }

  // Future<void> _takePictureFromCamera() async {
  //   final XFile? image = await _picker.pickImage(source: ImageSource.camera);
  //   if (image != null) {
  //     final compressedImage = await _compressImage(File(image.path));
  //     setState(() {
  //       _selectedImage = compressedImage;
  //     });
  //   }
  // }

  // Method to handle camera permissions and capture image
  Future<void> _takePictureFromCamera() async {
    // Check if camera permission is granted
    var status = await Permission.camera.status;
    if (status.isDenied || status.isPermanentlyDenied) {
      // Request permission if it's denied
      status = await Permission.camera.request();
    }

    // If permission is granted, take a picture
    if (status.isGranted) {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        final compressedImage = await _compressImage(File(image.path));
        setState(() {
          _selectedImage = compressedImage;
        });
      }
    } else {
      // Handle case where permission is permanently denied and user needs to enable it manually
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Camera permission is required to take photos."),
        ),
      );
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  Future<void> _submitAnswerWithImage() async {
    if (_fetchedData == null) return;

    final currentQuestion = _fetchedData!.data[sectionIndex].subSections[subSectionIndex].questions[questionIndex];

    // if (answer.text.isEmpty && _selectedImage == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text("Answer is empty! Please provide an answer or an image.")),
    //   );
    //   return;
    // }

    bool success = await _service.submitAnswerWithImages(
      areaId: widget.locationId,
      questionId: currentQuestion.questionId,
      textAnswer: answer.text,
      file: _selectedImage,
    );

    // Handle success/failure accordingly
  }

  void handleYesOrSkip(bool isYes) async {


    if (isYes) {
      if (answer.text.isEmpty && _selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Answer is empty! Please provide an answer or an image.")),
        );
        return; // Exit early, do not proceed to the next question
      }
      // Submit the answer before moving to the next question
      await _submitAnswerWithImage();
    }

    // Move to the next question or subsection
    setState(() {
      if (_fetchedData != null) {
        if (questionIndex < _fetchedData!.data[sectionIndex].subSections[subSectionIndex].questions.length - 1) {
          questionIndex++;
        } else if (subSectionIndex < _fetchedData!.data[sectionIndex].subSections.length - 1) {
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
        _removeImage();
        _loadAnswersForCurrentQuestion(); // Load answers for the new current question
      }
    });
  }

  void _loadAnswersForCurrentQuestion() {
    if (_fetchedData != null) {
      // Fetch answers for the current question
      final answersData = _fetchedData!.data[sectionIndex]
          .subSections[subSectionIndex]
          .questions[questionIndex]
          .answers; // Adjust this if your answers are structured differently

      setState(() {
        // Only load answer_text and answer_image
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
                    const SizedBox(height: 34),
                    if (_fetchedData != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: TextpoppinsExtraBold_18(
                          text: _fetchedData!.data[sectionIndex].sectionName,
                          color: Colors.black,
                          textalign: TextAlign.start,
                          fontsize: 18.5,
                        ),
                      ),
                    const SizedBox(height: 40),
                    if (_fetchedData != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: TextpoppinsExtraBold_18(
                          text: _fetchedData!.data[sectionIndex].subSections[subSectionIndex].subSectionName,
                          color: Colors.black,
                          textalign: TextAlign.start,
                          fontsize: 17,
                        ),
                      ),
                    const SizedBox(height: 10),

                    FutureBuilder<PreauditQuestionsmodel?>(
                      future: _questionsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text("Error loading data"));
                        } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
                          return Center(child: Text("No data available"));
                        }

                        // Ensure that we have valid indices before accessing
                        final currentSection = snapshot.data!.data[sectionIndex];
                        if (sectionIndex >= snapshot.data!.data.length) {
                          return Center(child: Text("Invalid section index."));
                        }

                        final currentSubSection = currentSection.subSections[subSectionIndex];
                        if (subSectionIndex >= currentSection.subSections.length) {
                          return Center(child: Text("Invalid sub-section index."));
                        }

                        final currentQuestion = currentSubSection.questions[questionIndex];
                        if (questionIndex >= currentSubSection.questions.length) {
                          return Center(child: Text("Invalid question index."));
                        }

                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Text(
                                currentQuestion.questionText,
                                style: TextStyle(fontSize: 20),
                                maxLines: 10,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: TextpoppinsExtraBold_18(
                        text: "Your Answer",
                        color: Colors.black,
                        textalign: TextAlign.start,
                        fontsize: 17,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
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
                    // Display selected image
                    if (_selectedImage != null)
                      Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 180,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.file(
                                _selectedImage!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 5,
                            right: 5,
                            child: IconButton(
                              icon: Icon(Icons.close, color: Colors.red),
                              onPressed: _removeImage,
                            ),
                          ),
                        ],
                      ),

                    // Image upload buttons
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _pickImageFromGallery,
                          icon: Icon(Icons.photo_library,color: Colors.green,),
                          label: Textpoppinslight_16(text: "Upload Image"),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: _takePictureFromCamera,
                          icon: Icon(Icons.camera_alt,color: Colors.green,),
                          label: Text("Take a Photo"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [


                          InkWell(
                              onTap: (){
                                handleYesOrSkip(false);
                              },
                              child: yes_skip(text: "Skip",textcolor: Colors.black,bgcolor: Color(0xFFCDFFD2))),
                          SizedBox(
                            width: 5,
                          ),
                          InkWell(
                              onTap: (){
                                handleYesOrSkip(true);
                              },
                              child: yes_skip(text: "Next",textcolor: Colors.black)),


                        ],
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
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8.0),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextpoppinsMedium_16(
                                        text: "Answer : " + answer.answerText),
                                    if (answer.answerImage != null &&
                                        answer.answerImage!.isNotEmpty)
                                      GestureDetector(
                                        onTap: () {
                                          // Navigate to full-screen image viewer
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  FullScreenImage(
                                                      url: answer.answerImage!),
                                            ),
                                          );
                                        },
                                        child: Image.network(
                                          answer.answerImage!,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: 100,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Text('Error loading image');
                                          },
                                        ),
                                      ),
                                  ],
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

                    const SizedBox(height: 20),

                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
