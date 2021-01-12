import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:studyme/models/intervention/abstract_intervention.dart';
import 'package:studyme/models/intervention/intervention.dart';
import 'package:studyme/models/intervention/null_intervention.dart';
import 'package:studyme/widgets/intervention_editor.dart';

class InterventionEditorScreen extends StatefulWidget {
  final bool isA;
  final AbstractIntervention intervention;

  const InterventionEditorScreen(
      {@required this.isA, @required this.intervention});

  @override
  _InterventionEditorScreenState createState() =>
      _InterventionEditorScreenState();
}

class _InterventionEditorScreenState extends State<InterventionEditorScreen> {
  AbstractIntervention _intervention;

  @override
  initState() {
    _intervention = widget.intervention.clone();
    print(_intervention.runtimeType);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.isA ? "Set A" : "Set B"),
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              if (!widget.isA)
                ToggleButtons(
                  children: <Widget>[
                    Padding(
                      child: Text("No Intervention"),
                      padding: const EdgeInsets.all(10.0),
                    ),
                    Padding(
                      child: Text("Intervention"),
                      padding: const EdgeInsets.all(10.0),
                    ),
                  ],
                  onPressed: _changeInterventionType,
                  isSelected: [_isNullIntervention(), !_isNullIntervention()],
                ),
              if (!_isNullIntervention())
                InterventionEditor(intervention: _intervention),
              OutlineButton(
                child: Text('Ok'),
                onPressed: () => Navigator.pop(context, _intervention),
              ),
            ],
          ),
        ));
  }

  _changeInterventionType(int index) {
    setState(() {
      if (index == 0) {
        _intervention = NullIntervention();
      } else if (index != 0) {
        _intervention = Intervention();
      }
    });
  }

  _isNullIntervention() {
    return _intervention is NullIntervention;
  }
}