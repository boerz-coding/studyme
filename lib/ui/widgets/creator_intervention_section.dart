import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:studyme/models/app_state/app_data.dart';
import 'package:studyme/models/intervention/intervention.dart';
import 'package:studyme/models/intervention/no_intervention.dart';
import 'package:studyme/ui/screens/intervention_creator_name.dart';
import 'package:studyme/ui/screens/intervention_creator_type.dart';
import 'package:studyme/ui/widgets/intervention_card.dart';
import 'package:studyme/ui/widgets/section_title.dart';

import '../screens/intervention_overview.dart';
import '../screens/intervention_creator_type.dart';

class CreatorInterventionSection extends StatelessWidget {
  final AppData model;

  CreatorInterventionSection(this.model);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          'Interventions',
          action: _buildNextAction(context),
        ),
        if (model.trial.a != null)
          InterventionCard(
              showSchedule: true,
              intervention: model.trial.a,
              onTap: () {
                _viewIntervention(context, true);
              }),
        if (model.trial.b != null)
          InterventionCard(
              showSchedule: true,
              intervention: model.trial.b,
              onTap: () {
                _viewIntervention(context, false);
              }),
      ],
    );
  }

  _addIntervention(context, isA) {
    Function setter = isA ? model.setInterventionA : model.setInterventionB;
    Function saveFunction = (Intervention intervention) {
      setter(intervention);
      Navigator.pushReplacementNamed(context, '/creator');
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => isA
            ? InterventionCreatorName(
                title: "Intervention A",
                intervention: Intervention(),
                onSave: saveFunction,
                save: false)
            : InterventionCreatorType(
                title: "Intervention B",
                intervention: NoIntervention(),
                onSave: saveFunction),
      ),
    );
  }

  _viewIntervention(context, isA) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InterventionOverview(isA: isA),
      ),
    );
  }

  Widget _buildNextAction(context) {
    if (model.trial.a == null) {
      return IconButton(
        icon: Icon(
          Icons.add,
        ),
        onPressed: () {
          _addIntervention(context, true);
        },
      );
    } else if (model.trial.b == null) {
      return IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          _addIntervention(context, false);
        },
      );
    } else {
      return null;
    }
  }
}
