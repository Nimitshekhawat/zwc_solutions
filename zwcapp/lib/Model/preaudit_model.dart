// To parse this JSON data, do
//
//     final preauditQuestionsmodel = preauditQuestionsmodelFromJson(jsonString);

import 'dart:convert';

PreauditQuestionsmodel preauditQuestionsmodelFromJson(String str) => PreauditQuestionsmodel.fromJson(json.decode(str));

String preauditQuestionsmodelToJson(PreauditQuestionsmodel data) => json.encode(data.toJson());

class PreauditQuestionsmodel {
  bool status;
  List<Datum> data;

  PreauditQuestionsmodel({
    required this.status,
    required this.data,
  });

  factory PreauditQuestionsmodel.fromJson(Map<String, dynamic> json) => PreauditQuestionsmodel(
    status: json["status"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String sectionId;
  String sectionNo;
  String sectionName;
  List<SubSection> subSections;

  Datum({
    required this.sectionId,
    required this.sectionNo,
    required this.sectionName,
    required this.subSections,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    sectionId: json["section_id"],
    sectionNo: json["section_no"],
    sectionName: json["section_name"],
    subSections: List<SubSection>.from(json["sub_sections"].map((x) => SubSection.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "section_id": sectionId,
    "section_no": sectionNo,
    "section_name": sectionName,
    "sub_sections": List<dynamic>.from(subSections.map((x) => x.toJson())),
  };
}

class SubSection {
  String subSectionId;
  String subSectionNo;
  String subSectionName;
  List<Question> questions;

  SubSection({
    required this.subSectionId,
    required this.subSectionNo,
    required this.subSectionName,
    required this.questions,
  });

  factory SubSection.fromJson(Map<String, dynamic> json) => SubSection(
    subSectionId: json["sub_section_id"],
    subSectionNo: json["sub_section_no"],
    subSectionName: json["sub_section_name"],
    questions: List<Question>.from(json["questions"].map((x) => Question.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "sub_section_id": subSectionId,
    "sub_section_no": subSectionNo,
    "sub_section_name": subSectionName,
    "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
  };
}

class Question {
  String questionId;
  String questionText;
  QuestionType questionType;
  bool isAnswered;
  List<dynamic> answers;

  Question({
    required this.questionId,
    required this.questionText,
    required this.questionType,
    required this.isAnswered,
    required this.answers,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    questionId: json["question_id"],
    questionText: json["question_text"],
    questionType: questionTypeValues.map[json["question_type"]]!,
    isAnswered: json["is_answered"],
    answers: List<dynamic>.from(json["answers"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "question_id": questionId,
    "question_text": questionText,
    "question_type": questionTypeValues.reverse[questionType],
    "is_answered": isAnswered,
    "answers": List<dynamic>.from(answers.map((x) => x)),
  };
}

enum QuestionType {
  TEXT
}

final questionTypeValues = EnumValues({
  "text": QuestionType.TEXT
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
