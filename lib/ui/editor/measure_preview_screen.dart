import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:studyme/models/measure/choice_measure.dart';
import 'package:studyme/models/measure/free_measure.dart';
import 'package:studyme/models/measure/measure.dart';
import 'package:studyme/models/measure/scale_measure.dart';
import 'package:studyme/widgets/choice_measure_widget.dart';
import 'package:studyme/widgets/free_measure_widget.dart';
import 'package:studyme/widgets/scale_measure_widget.dart';

class MeasurePreviewScreen extends StatefulWidget {
  final Measure measure;

  const MeasurePreviewScreen({@required this.measure});

  @override
  _MeasurePreviewScreenState createState() => _MeasurePreviewScreenState();
}

class _MeasurePreviewScreenState extends State<MeasurePreviewScreen> {
  Measure _measure;

  @override
  initState() {
    _measure = widget.measure.clone();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text("Preview Measure"),
            ],
          ),
        ),
        body: Column(
          children: [
            SizedBox(height: 10),
            if (_measure.isDefault) Text("(Default Measure)"),
            Card(child: _buildPreviewView()),
            OutlineButton.icon(
                icon: Icon(Icons.add),
                label: Text("Add to trial"),
                onPressed: () {
                  Navigator.pop(context, _measure);
                })
          ],
        ));
  }

  _buildPreviewView() {
    Widget _preview;
    switch (_measure.runtimeType) {
      case FreeMeasure:
        _preview = FreeMeasureWidget(_measure, null);
        break;
      case ChoiceMeasure:
        _preview = ChoiceMeasureWidget(_measure, null);
        break;
      case ScaleMeasure:
        _preview = ScaleMeasureWidget(_measure, null);
        break;
      default:
        return null;
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(children: [
        if (_measure.name != null && _measure.name.length > 0)
          Text(_measure.name),
        if (_measure.description != null && _measure.description.length > 0)
          Text(_measure.description),
        if (_preview != null) _preview,
      ]),
    );
  }
}
