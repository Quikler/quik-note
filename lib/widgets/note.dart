import 'package:flutter/material.dart';

class NoteWidget extends StatefulWidget {
  const NoteWidget({
    super.key,
    required this.id,
    required this.title,
    required this.content,
    required this.creationTime,
    required this.onNoteDelete,
  });

  final int? id;
  final String title;
  final String? content;
  final DateTime creationTime;
  final Function(int? id) onNoteDelete;

  @override
  State<StatefulWidget> createState() {
    return _NoteWidgetState();
  }
}

class _NoteWidgetState extends State<NoteWidget> {
  bool _isVisible = false;

  void _handleTap() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  void _handleDelete() {
    widget.onNoteDelete(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.lightBlue),
      ),
      child: GestureDetector(
        onTap: _handleTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Title: ${widget.title}",
                        textAlign: TextAlign.start,
                      ),
                      Text("Creation time: ${widget.creationTime}"),
                    ],
                  ),
                ),
                IconButton(
                  hoverColor: Colors.greenAccent,
                  onPressed: _handleDelete,
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
            Visibility(
              visible: _isVisible,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 2.0, color: Colors.blueAccent),
                ),
                child: Text(widget.content ?? ""),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
