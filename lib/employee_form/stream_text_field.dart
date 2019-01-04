import 'dart:async';

import 'package:flutter/material.dart';

class StreamTextField extends StatefulWidget {
  final String labelText;
  final Stream stream;
  final Function(String) onChanged;
  final Icon prefixIcon;
  final FocusNode focusNode, giveFocusTo;
  final TextInputType keyboardType;
  final int maxLength;

  StreamTextField({
    BuildContext context,
    @required this.stream,
    @required this.onChanged,
    @required this.focusNode,
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
      // initialData: widget.stream.first,
      stream: widget.stream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (isFirstRender) {
          if (snapshot.hasData) textFieldController.text = snapshot.data;
          isFirstRender = false;
        }

        return TextField(
          onChanged: widget.onChanged,
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
