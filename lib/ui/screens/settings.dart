import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studyme/models/app_state/app_data.dart';
import 'package:studyme/models/app_state/app_state.dart';
import 'package:studyme/util/debug_functions.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:studyme/util/util.dart';

import '../../routes.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          ButtonBar(
            children: [
              OutlinedButton.icon(
                icon: Icon(Icons.edit),
                label: Text("Edit Experiment"),
                onPressed: () => _editTrial(context),
              ),
              OutlinedButton.icon(
                icon: Icon(Icons.cancel),
                label: Text("Cancel Experiment"),
                onPressed: () => _cancelTrial(context),
              )
            ],
          ),
          SizedBox(height: 50),
          ButtonBar(
            children: [
              OutlinedButton.icon(
                icon: Icon(Icons.share),
                label: Text("Export Trial Info"),
                onPressed: () => _exportTrialInfo(context),
              ),
            ],
          )
        ],
      ),
    );
  }

  _editTrial(BuildContext context) async {
    Provider.of<AppData>(context, listen: false).cancelAllNotifications();
    deleteLogs(Provider.of<AppData>(context, listen: false).trial);
    Provider.of<AppData>(context, listen: false)
        .saveAppState(AppState.CREATING_DETAILS);
    Navigator.pushReplacementNamed(context, Routes.creator);
  }

  _cancelTrial(BuildContext context) async {
    bool _confirmed = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Cancel Experiment"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel")),
                TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text("Confirm"))
              ],
            ));

    if (_confirmed != null && _confirmed) {
      Provider.of<AppData>(context, listen: false).cancelAllNotifications();
      deleteLogs(Provider.of<AppData>(context, listen: false).trial);
      Provider.of<AppData>(context, listen: false)
          .saveAppState(AppState.ONBOARDING);
      Provider.of<AppData>(context, listen: false).createNewTrial();
      Navigator.pushReplacementNamed(context, Routes.onboarding);
    }
  }

  _exportTrialInfo(BuildContext context) {
    Clipboard.setData(new ClipboardData(
        text: json.encode(Provider.of<AppData>(context).trial.toJson())));
    toast(context, "Data copied to clipboard. Please share as instructed.");
  }
}
