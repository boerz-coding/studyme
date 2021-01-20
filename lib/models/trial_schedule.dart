import 'package:hive/hive.dart';

part 'trial_schedule.g.dart';

@HiveType(typeId: 201)
class TrialSchedule extends HiveObject {
  @HiveField(0)
  PhaseOrder phaseOrder;

  @HiveField(1)
  int phaseDuration;

  @HiveField(2)
  List<String> phaseSequence;

  @HiveField(3)
  int numberOfCycles;

  TrialSchedule({this.phaseOrder, this.phaseDuration, this.numberOfCycles}) {
    _updatePhaseSequence();
  }

  TrialSchedule.clone(TrialSchedule schedule)
      : phaseOrder = schedule.phaseOrder,
        phaseDuration = schedule.phaseDuration,
        phaseSequence = schedule.phaseSequence,
        numberOfCycles = schedule.numberOfCycles;

  clone() {
    return TrialSchedule.clone(this);
  }

  int get duration => phaseDuration * phaseSequence.length;

  updatePhaseOrder(PhaseOrder newPhaseOrder) {
    phaseOrder = newPhaseOrder;
    _updatePhaseSequence();
  }

  updateNumberOfCycles(int newNumberOfCycles) {
    numberOfCycles = newNumberOfCycles;
    _updatePhaseSequence();
  }

  _updatePhaseSequence() {
    List<String> pair = ['a', 'b'];
    List<String> newPhaseSequence = [];

    for (int i = 0; i < numberOfCycles; i++) {
      newPhaseSequence.addAll(pair);
      if (phaseOrder == PhaseOrder.counterbalanced) {
        pair = pair.reversed.toList();
      }
    }
    phaseSequence = newPhaseSequence;
  }
}

@HiveType(typeId: 202)
enum PhaseOrder {
  @HiveField(0)
  alternating,
  @HiveField(1)
  counterbalanced
}

extension PhaseOrderExtension on PhaseOrder {
  String get humanReadable {
    switch (this) {
      case PhaseOrder.alternating:
        return 'Alternating';
      case PhaseOrder.counterbalanced:
        return 'Counterbalanced';
      default:
        return '';
    }
  }
}