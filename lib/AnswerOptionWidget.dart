import 'package:flutter/material.dart';

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
    final txtCol = const Color(0xffc77800);
    final _answerOptionWidgets = answerOptions
        .map((e) => ChoiceChip(
              backgroundColor: Colors.white70,
              label: Text(e.value,
                  style: TextStyle(color: e.selected ? txtCol : null)),
              shape: StadiumBorder(
                  side:
                      BorderSide(color: e.selected ? accentCol : Colors.grey)),
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

class AnswerOption {
  final String value;
  final String id;
  bool selected;

  factory AnswerOption.fromJson(Map<String, dynamic> json) => AnswerOption(
        id: json["_id"],
        value: json["value"],
      );

  AnswerOption({this.value, this.id, this.selected = false});
}
