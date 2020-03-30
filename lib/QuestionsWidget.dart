import 'package:flutter/material.dart';

class QuestionsWidget extends StatefulWidget {
  const QuestionsWidget(this.jwt);

  final roomId = "5db749e9d4449b0aa6b77e6c";
  final jwt;

  @override
  State<StatefulWidget> createState() => _QuestionsState();
}

class _QuestionsState extends State<QuestionsWidget> {
  final List<Question> questions = [
    Question(
        "q1",
        "How is the temperature?How is the temperature?How is the temperature?",
        [AnswerOption("value", "id1"), AnswerOption("answer2", "id2")]),
    Question("q2", "How are you doing?",
        [AnswerOption("answer", "id3"), AnswerOption("answer2", "id4")]),
    Question("q3", "value3?", [
      AnswerOption("answer", "id5"),
      AnswerOption("answer2", "id6"),
      AnswerOption("answer2", "id7"),
    ]),
    Question("q2", "How are you doing?",
        [AnswerOption("answer", "id3"), AnswerOption("answer2", "id4")]),
    Question("q2", "How are you doing?",
        [AnswerOption("answer", "id3"), AnswerOption("answer2", "id4")]),
    Question("q2", "How are you doing?",
        [AnswerOption("answer", "id3"), AnswerOption("answer2", "id4")]),
  ];

  @override
  Widget build(BuildContext context) {
    final questionWidgets = questions
        .map((q) => Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              padding: EdgeInsets.all(16),
              child: QuestionWidget(
                q.value,
                q.answerOptions,
              ),
            )))
        .toList();

    return Container(
      color: const Color(0xffffcc80),
      padding: EdgeInsets.all(8),
      child: ListView(
        children: questionWidgets,
      ),
    );
  }
}

class QuestionWidget extends StatefulWidget {
  const QuestionWidget(this.value, this.answerOptions);

  final value;
  final List<AnswerOption> answerOptions;

  @override
  State<StatefulWidget> createState() => _QuestionState();
}

class _QuestionState extends State<QuestionWidget> {
  final selectedAnswer = null;

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
  }
}

class AnswerOptionsWidget extends StatelessWidget {
  const AnswerOptionsWidget(
      this.answerOptions, this.onSelected, this.selectedAnswer,
      {Key key})
      : super(key: key);

  final selectedAnswer;
  final onSelected;
  final List<AnswerOption> answerOptions;

  @override
  Widget build(BuildContext context) {
    final accentCol = Theme.of(context).accentColor;
    final txtCol = Theme.of(context).textTheme.bodyText1.color;
    final _answerOptionWidgets = answerOptions
        .map((e) => ChoiceChip(
              backgroundColor: Colors.white70,
              label: Text(e.value,
                  style: TextStyle(color: e.selected ? txtCol : null)),
              shape: StadiumBorder(
                  side: BorderSide(
                      color: e.selected
                          ? Theme.of(context).accentColor
                          : Colors.grey)),
              onSelected: (b) {
                onSelected(b, e.id);
              },
              selected: e.selected,
              selectedColor: Colors.white70,
            ))
        .toList();

    return Container(
        margin: EdgeInsets.only(top: 8),
        child: Wrap(
            spacing: 10,
            alignment: WrapAlignment.center,
            children: _answerOptionWidgets));
  }
}

class Question {
  final String id;
  final String value;
  final List<AnswerOption> answerOptions;

  Question(this.id, this.value, this.answerOptions);
}

class AnswerOption {
  final String value;
  final String id;
  bool selected;

  AnswerOption(this.value, this.id, {this.selected = false});
}
