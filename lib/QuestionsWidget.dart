import 'dart:convert';

import 'package:flutter/material.dart';
import 'AnswerOptionWidget.dart';
import 'package:http/http.dart' as http;

class QuestionsWidget extends StatefulWidget {
  const QuestionsWidget(this.jwt);

  final roomId = "5db749e9d4449b0aa6b77e6c";
  final String jwt;

  @override
  State<StatefulWidget> createState() => _QuestionsState();
}

class _QuestionsState extends State<QuestionsWidget> {
  @override
  void initState() {
    super.initState();
  }

  final List<Question> questions = List();

  @override
  Widget build(BuildContext context) => FutureBuilder<List<Question>>(
      builder: (ctx, snapshot) {
        Widget bodyWidget;
        if (snapshot.hasData) {
          bodyWidget = DisplayQuestionsWidget(
            questions: snapshot.data,
          );
        } else if (snapshot.hasError) {
          bodyWidget = FetchQuestionsError(
            errorMsg: snapshot.error,
          );
        } else {
          bodyWidget = Center(child: CircularProgressIndicator());
        }
        return Container(color: const Color(0xffffcc80), child: bodyWidget);
      },
      future: fetchQuestions());
  // DisplayQuestionsWidget(questions: questions);

  Future<List<Question>> fetchQuestions() async {
    final headers = {
      "x-auth-token":
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI1ZTI4YWI5ODhhMDdkNTBhZDEyOGNiZjUiLCJyb2xlIjoxLCJpYXQiOjE1ODA0ODM3OTd9.ULQSGc2Y9_6N05jtRerx7gR_eP0xDu0MOTS1bhWjpnw",
      "roomId": "5db749e9d4449b0aa6b77e6c"
    };

    final response = await http.get(
        'http://feedme.compute.dtu.dk/api-dev/questions/',
        headers: headers);

    print(response.body);
    if (response.statusCode == 200) {
      List<Question> fetchedQuestions = new List();

      final jsonData = json.decode(response.body) as List;

      for (var item in jsonData) {
        fetchedQuestions.add(Question.fromJson(item));
      }

      return fetchedQuestions;
      // If the server did return a 200 OK response,
      // then parse the JSON.

      // print(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to login user ${response.statusCode}');
    }
  }
}

class FetchQuestionsError extends StatelessWidget {
  final errorMsg;

  const FetchQuestionsError({Key key, this.errorMsg}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        errorMsg,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class DisplayQuestionsWidget extends StatelessWidget {
  final List<Question> questions;

  const DisplayQuestionsWidget({Key key, this.questions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final questionWidgets = questions.map((q) {
      return Card(
          margin: EdgeInsets.only(top: 8, left: 8, right: 8),
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            padding: EdgeInsets.all(16),
            child: QuestionWidget(
              q.value,
              q.id,
              q.answerOptions,
            ),
          ));
    }).toList();

    return ListView(
      children: questionWidgets,
    );
  }
}

class QuestionWidget extends StatefulWidget {
  const QuestionWidget(this.value, this.questionId, this.answerOptions);
  final value;
  final questionId;

  final List<AnswerOption> answerOptions;

  @override
  State<StatefulWidget> createState() => _QuestionState();
}

class _QuestionState extends State<QuestionWidget> {
  final selectedAnswer = null;
  int timesAnswered;
  String feedbackId;
  @override
  void initState() {
    super.initState();
    timesAnswered = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        Text(
          widget.value,
          style: TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
        AnswerOptionsWidget(
            widget.answerOptions, answerSelected, selectedAnswer)
      ],
    ));
  }

  void answerSelected(bool selected, String answerId) {
    widget.answerOptions.forEach((element) {
      setState(() {
        if (element.id == answerId) {
          element.selected = selected;
        } else {
          element.selected = false;
        }
      });
    });

    if (timesAnswered == 0) {
      postFeedback(answerId);
      timesAnswered++;
    } else {
      updateFeedback(answerId);
    }
  }

  Future<void> postFeedback(String answerId) async {
    final headers = <String, String>{
      // TODO: this should be replaced by valid jwt
      "x-auth-token":
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI1ZTI4YWI5ODhhMDdkNTBhZDEyOGNiZjUiLCJyb2xlIjoxLCJpYXQiOjE1ODA0ODM3OTd9.ULQSGc2Y9_6N05jtRerx7gR_eP0xDu0MOTS1bhWjpnw",
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final body = jsonEncode(<String, String>{
      'answerId': answerId,
      "questionId": widget.questionId,
      "roomId": "5db749e9d4449b0aa6b77e6c"
    });

    print(body);
    final response = await http.post(
        'http://feedme.compute.dtu.dk/api-dev/feedback/',
        body: body,
        headers: headers);

    if (response.statusCode != 200) {
      // If the server did not return a 200 OK response,
      // then throw an exception.

      throw Exception(
          'Failed to post question ${response.statusCode}, error message: ${response.body}');
    }

    feedbackId = json.decode(response.body)["_id"];

    print(feedbackId);
  }

  void updateFeedback(String answerId) async {
    final headers = <String, String>{
      // TODO: this should be replaced by valid jwt
      "x-auth-token":
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI1ZTI4YWI5ODhhMDdkNTBhZDEyOGNiZjUiLCJyb2xlIjoxLCJpYXQiOjE1ODA0ODM3OTd9.ULQSGc2Y9_6N05jtRerx7gR_eP0xDu0MOTS1bhWjpnw",
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final body = jsonEncode(<String, String>{'answerId': answerId});

    print(body);
    final response = await http.patch(
        'http://feedme.compute.dtu.dk/api-dev/feedback/change-answer/$feedbackId',
        body: body,
        headers: headers);

    if (response.statusCode != 200) {
      // If the server did not return a 200 OK response,
      // then throw an exception.

      throw Exception(
          'Failed to post question ${response.statusCode}, error message: ${response.body}');
    }
  }
}

class Question {
  final String id;
  final String value;
  final List<AnswerOption> answerOptions;
  final List<String> roomIds;

  factory Question.fromJson(Map<String, dynamic> json) {
    final List<AnswerOption> answers = (json["answerOptions"] as List)
        .map((e) => AnswerOption.fromJson(e))
        .toList();

    final List<String> rooms =
        (json["rooms"] as List).map((e) => e.toString()).toList();

    return Question(
      id: json["_id"],
      value: json["value"],
      answerOptions: answers,
      roomIds: rooms,
      isActive: json["isActive"],
    );
  }

  Question({
    this.id,
    this.value,
    this.answerOptions,
    this.roomIds,
    isActive,
  });
}
