import 'package:flutter/material.dart';
import 'package:studyme/ui/widgets/action_button.dart';
import 'package:studyme/ui/widgets/choice_card.dart';
import 'package:studyme/ui/widgets/hint_card.dart';

class GoalEditor extends StatefulWidget {
  final int numberOfInterventions;
  final Function(int numberOfInterventions) onSave;

  GoalEditor({this.numberOfInterventions, this.onSave});

  @override
  _GoalEditorState createState() => _GoalEditorState();
}

class _GoalEditorState extends State<GoalEditor> {
  int _numberOfInterventions;

  @override
  void initState() {
    _numberOfInterventions = widget.numberOfInterventions;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Goal"),
              Visibility(
                visible: true,
                child: Text(
                  'Number of Interventions',
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            ActionButton(
                icon: Icons.check,
                canPress: _canSubmit(),
                onPressed: () => widget.onSave(_numberOfInterventions)),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HintCard(
                  titleText: "Choose number of interventions",
                  body: [
                    Text('1) One Intervention',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                        "This means you are comparing Intervention A to your current lifestyle and when you are in a \"Intervention B\" phase you don't add any additional intervention to your lifestyle."),
                    Text(''),
                    Text(
                        "Example: You want to evaluate if drinking tea makes you more productive than you currently are, so you run a trial with \"Intervention A\" set to \"drink tea\" and \"Intervention B\" set to \"No Intervention\".",
                        style: TextStyle(fontStyle: FontStyle.italic)),
                    Text(''),
                    Text('2) Two Interventions',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                        "This means you are comparing Intervention A to another Intervention and when you are in a \"Intervention B\" phase you follow that intervention."),
                    Text(''),
                    Text(
                        "Example: You want to compare if drinking tea or drinking coffee makes you more productive, so you run a trial with \"Intervention A\" set to \"drink tea\" and \"Intervention B\" set to \"drink coffee\".",
                        style: TextStyle(fontStyle: FontStyle.italic)),
                    Text(''),
                  ],
                ),
                ChoiceCard<int>(
                    value: 1,
                    selectedValue: _numberOfInterventions,
                    onSelect: _selectOption,
                    title: Text('I want to evaluate one intervention')),
                ChoiceCard<int>(
                    value: 2,
                    selectedValue: _numberOfInterventions,
                    onSelect: _selectOption,
                    title: Text('I want to compare two interventions')),
              ],
            ),
          ),
        ));
  }

  _canSubmit() {
    return _numberOfInterventions != null;
  }

  _selectOption(int number) {
    setState(() {
      _numberOfInterventions = number;
    });
  }
}