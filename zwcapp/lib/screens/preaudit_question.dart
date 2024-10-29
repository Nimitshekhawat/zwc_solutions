import 'package:flutter/material.dart';
import 'package:zwcapp/screens/Question_screen.dart';
import 'package:zwcapp/screens/customwidgets.dart';

import '../Model/preaudit_model.dart';
import '../services/preaudit_service.dart';

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

  @override
  void initState() {
    super.initState();
    _questionsFuture = _service.fetchData(widget.locationId);
    _questionsFuture!.then((data) {
      setState(() {
        _fetchedData = data;
      });
    });
  }

  void handleYesOrSkip(bool isYes) {
    // Ensure _fetchedData is non-null before accessing
    if (_fetchedData == null) return;

    if (isYes) {
      final currentQuestion = _fetchedData!.data[sectionIndex].subSections[subSectionIndex].questions[questionIndex];
      _service.submitAnswer(currentQuestion.questionId, answer.text);
    }

    setState(() {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(63),
        child: Mainappbar(name: "Preaudit Questions", context: context),
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
                    // Display Current Section
                    if (_fetchedData != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: TextpoppinsExtraBold_18(
                          text: _fetchedData!.data[sectionIndex].sectionName, // Adjust based on your model
                          color: Colors.black,
                          textalign: TextAlign.start,
                          fontsize: 18,
                        ),
                      ),
                    SizedBox(
                      height: 40,
                    ),
                    // Display Current Subsection
                    if (_fetchedData != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: TextpoppinsExtraBold_18(
                          text: _fetchedData!.data[sectionIndex].subSections[subSectionIndex].subSectionName, // Adjust based on your model
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

                        final currentSection = snapshot.data!.data[sectionIndex];
                        final currentSubSection = currentSection.subSections[subSectionIndex];
                        final currentQuestion = currentSubSection.questions[questionIndex];

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
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: TextpoppinsExtraBold_18(
                        text: "Your Answer",
                        color: Colors.black,
                        textalign: TextAlign.start,
                        fontsize: 17,
                      ),
                    ),
                    SizedBox(height: 10),
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
                          keyboardType: TextInputType.text,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () => handleYesOrSkip(true),
                            child: yes_skip(text: "Yes", textcolor: Colors.black),
                          ),
                          GestureDetector(
                            onTap: () => handleYesOrSkip(false),
                            child: yes_skip(text: "Skip", bgcolor: Color(0xFFCDFFD2), textcolor: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
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
