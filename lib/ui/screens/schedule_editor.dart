import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studyme/models/app_state/app_state.dart';
import 'package:studyme/models/trial_schedule.dart';
import 'package:studyme/ui/widgets/save_button.dart';
import 'package:studyme/ui/widgets/schedule_widget.dart';

class ScheduleEditor extends StatefulWidget {
  @override
  _ScheduleEditorState createState() => _ScheduleEditorState();
}

class _ScheduleEditorState extends State<ScheduleEditor> {
  TrialSchedule _schedule;

  @override
  void initState() {
    final trial = Provider.of<AppState>(context, listen: false).trial;
    _schedule = trial.schedule.clone();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Schedule'),
          actions: <Widget>[
            SaveButton(canPress: _canSubmit(), onPressed: _save)
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Consumer<AppState>(builder: (context, model, child) {
            return Column(
              children: [
                ScheduleWidget(_schedule),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: _schedule.phaseDuration.toString(),
                  keyboardType: TextInputType.number,
                  onFieldSubmitted: _updatePhaseDuration,
                  decoration: InputDecoration(labelText: 'Phase Duration'),
                ),
                TextFormField(
                  initialValue: _schedule.numberOfCycles.toString(),
                  keyboardType: TextInputType.number,
                  onFieldSubmitted: _updateNumberOfCycles,
                  decoration: InputDecoration(labelText: 'Number of Cycles'),
                ),
                DropdownButtonFormField<PhaseOrder>(
                  decoration: InputDecoration(labelText: 'Phase Order'),
                  value: _schedule.phaseOrder,
                  onChanged: _updatePhaseOrder,
                  items: [PhaseOrder.alternating, PhaseOrder.counterbalanced]
                      .map<DropdownMenuItem<PhaseOrder>>((value) {
                    return DropdownMenuItem<PhaseOrder>(
                      value: value,
                      child: Text(value.humanReadable),
                    );
                  }).toList(),
                )
              ],
            );
          }),
        ));
  }

  _canSubmit() {
    return _schedule.duration != 0;
  }

  _updateNumberOfCycles(text) {
    setState(() {
      _schedule.updateNumberOfCycles(int.parse(text));
    });
  }

  _updatePhaseDuration(text) {
    setState(() {
      _schedule.phaseDuration = int.parse(text);
    });
  }

  _updatePhaseOrder(phaseOrder) {
    setState(() {
      _schedule.updatePhaseOrder(phaseOrder);
    });
  }

  _save() {
    Provider.of<AppState>(context, listen: false).updateSchedule(_schedule);
    Navigator.pop(context);
  }
}