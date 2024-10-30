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