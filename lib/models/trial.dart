import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:studyme/models/phases/phases.dart';
import 'package:studyme/models/task/task.dart';
import 'package:studyme/util/time_of_day_extension.dart';

import './measure/measure.dart';
import 'intervention/intervention.dart';
import 'measure/synced_measure.dart';

part 'trial.g.dart';

@JsonSerializable()
@HiveType(typeId: 200)
class Trial extends HiveObject {
  @HiveField(0)
  int numberOfInterventions;

  @HiveField(1)
  Intervention a;

  @HiveField(2)
  Intervention b;

  @HiveField(3)
  List<Measure> measures;

  @HiveField(4)
  Phases phases;

  @HiveField(5)
  DateTime startDate;

  List<Task> getTasksForDate(DateTime date) {
    DateTime _cleanDate = DateTime(date.year, date.month, date.day);
    List<Task> _tasks = [];

    if (date.isAfter(startDate) && date.isBefore(endDate)) {
      int daysSinceBeginningOfTrial = _cleanDate.difference(startDate).inDays;
      int daysSinceBeginningOfPhase =
          daysSinceBeginningOfTrial % phases.phaseDuration;

      Intervention _intervention = getInterventionForDate(_cleanDate);

      _tasks.addAll(_intervention.getTasksFor(daysSinceBeginningOfPhase));
      measures.forEach((measure) {
        _tasks.addAll(measure.getTasksFor(daysSinceBeginningOfTrial));
      });

      _tasks.sort((a, b) {
        if (a.time.combined < b.time.combined) {
          return -1;
        } else if (a.time.combined > b.time.combined) {
          return 1;
        } else {
          return 0;
        }
      });
    } else {
      print("trial has ended");
    }

    return _tasks;
  }

  List<SyncedMeasure> get syncedMeasures {
    return measures.whereType<SyncedMeasure>().toList();
  }

  Trial() : this.measures = [];

  DateTime get endDate {
    return startDate
        .add(Duration(days: phases.totalDuration))
        .subtract(Duration(seconds: 1));
  }

  int getDayOfStudyFor(DateTime date) {
    return date.differenceInDays(startDate).inDays;
  }

  bool isInStudyTimeframe(DateTime date) {
    return date.isAfter(startDate) && date.isBefore(endDate);
  }

  Intervention getInterventionForDate(DateTime date) {
    final index = getPhaseIndexForDate(date);

    return getInterventionForPhaseIndex(index);
  }

  Intervention getInterventionForPhaseIndex(int index) {
    if (index < 0 || index >= phases.numberOfPhases) {
      print('trial is over or has not begun.');
      return null;
    }
    final interventionLetter = phases.phaseSequence[index];

    if (interventionLetter == 'a')
      return a;
    else if (interventionLetter == 'b')
      return b;
    else
      return null;
  }

  int getPhaseIndexForDate(DateTime date) {
    final test = date.differenceInDays(startDate).inDays;
    return test ~/ phases.phaseDuration;
  }

  factory Trial.fromJson(Map<String, dynamic> json) => _$TrialFromJson(json);
  Map<String, dynamic> toJson() => _$TrialToJson(this);
}

extension DateOnlyCompare on DateTime {
  // needed for models
  Duration differenceInDays(DateTime other) {
    final currentZero = DateTime(year, month, day);
    final otherZero = DateTime(other.year, other.month, other.day);
    return currentZero.difference(otherZero);
  }
}
