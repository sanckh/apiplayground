import 'dart:html' as html; // Make sure you're using dart:html for web-specific functionality
import 'dart:js' as js;
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:async'; // Import dart:async to use StreamSubscription

class MonacoEditorWidget extends StatefulWidget {
  @override
  _MonacoEditorWidgetState createState() => _MonacoEditorWidgetState();
}

class _MonacoEditorWidgetState extends State<MonacoEditorWidget> {
  late StreamSubscription<html.MessageEvent> _messageSubscription; // Corrected type here

  @override
  void initState() {
    super.initState();
    // Correctly initialize the StreamSubscription
    _messageSubscription = html.window.onMessage.listen((event) {
      if (event.data == 'editorReady') {
        // Monaco Editor is ready for interaction
        print('Monaco Editor is ready.');
        // Perform any action you need here, such as enabling editing features
      }
    });
  }

  @override
  void dispose() {
    // Cancel the message subscription when the widget is disposed
    _messageSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ensure the iframe ID is unique if using multiple instances
    final String iframeId = 'monaco-editor-container';

    // Create an IFrameElement
    final html.IFrameElement iframeElement = html.IFrameElement()
      ..src = 'monaco_editor.html'
      ..style.border = 'none';

    // Register the IFrameElement
    // Ensure this is called only once for each unique viewType
    ui.platformViewRegistry.registerViewFactory(
      iframeId,
      (int viewId) => iframeElement,
    );

    return HtmlElementView(viewType: iframeId);
  }
}
