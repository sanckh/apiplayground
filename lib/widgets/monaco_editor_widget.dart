import 'dart:js' as js;
import 'package:flutter/material.dart';

class MonacoEditorWidget extends StatefulWidget {
  @override
  _MonacoEditorWidgetState createState() => _MonacoEditorWidgetState();
}

class _MonacoEditorWidgetState extends State<MonacoEditorWidget> {
  @override
  void initState() {
    super.initState();
    // Invoke the editor creation after the widget is built and rendered.
    WidgetsBinding.instance.addPostFrameCallback((_) => triggerEditorCreation());
  }

  void triggerEditorCreation() {
    // Call the JavaScript function 'createEditor' that initializes the Monaco Editor.
    js.context.callMethod('createEditor');
  }

  @override
  Widget build(BuildContext context) {
    // This widget acts as a container for the Monaco Editor.
    return HtmlElementView(viewType: 'editor-div');
  }
}
