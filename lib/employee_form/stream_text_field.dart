import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class StreamTextField extends StatefulWidget {
  final String labelText;
  final Stream subjectStream;
  final Function(String) subjectSink;
  final Stream<bool> toggleStream;
  final Icon prefixIcon;
  final FocusNode focusNode, giveFocusTo;
  final TextInputType keyboardType;
  final int maxLength;

  

  StreamTextField({
    BuildContext context,
    @required this.subjectStream,
    @required this.subjectSink,
    @required this.focusNode,
    this.toggleStream,
    this.giveFocusTo,
    this.labelText,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.maxLength,
  });

  @override
  _StreamTextFieldState createState() => _StreamTextFieldState();
}

class _StreamTextFieldState extends State<StreamTextField> {
  var textFieldController = TextEditingController();
  bool isFirstRender = true;

  @override
  void dispose() {
    textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: ,
      stream: widget.subjectStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (isFirstRender) {
          if (snapshot.hasData) textFieldController.text = snapshot.data;
          isFirstRender = false;
        }

        return TextField(
          onChanged: widget.subjectSink,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: widget.giveFocusTo != null
              ? TextInputAction.next
              : TextInputAction.done,
          onEditingComplete: () => !snapshot.hasError &&
                  widget.giveFocusTo != null &&
                  snapshot
                      .hasData //TODO: Update empty field validation for required fields.
              ? FocusScope.of(context).requestFocus(widget.giveFocusTo)
              : snapshot.hasData ? widget.focusNode.unfocus() : null,
          focusNode: widget.focusNode,
          decoration: InputDecoration(
            labelText: widget.labelText,
            prefixIcon: widget.prefixIcon,
            errorText: snapshot.error,
          ),
          controller: textFieldController,
          maxLength: widget.maxLength,
        );
      },
    );
  }
}
