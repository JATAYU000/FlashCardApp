import 'dart:convert';

List<FlashCard> flashCardFromJson(String str) => List<FlashCard>.from(json.decode(str).map((x) => FlashCard.fromJson(x)));

String flashCardToJson(List<FlashCard> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FlashCard {
    String topic;
    String question;
    String answer;

    FlashCard({
        required this.topic,
        required this.question,
        required this.answer,
    });

    factory FlashCard.fromJson(Map<String, dynamic> json) => FlashCard(
        topic: json['topic'],
        question: json["question"],
        answer: json["answer"],
    );

    Map<String, dynamic> toJson() => {
        "topic": topic,
        "question": question,
        "answer": answer,
    };
}
