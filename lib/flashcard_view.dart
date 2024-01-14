import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart'; 
class FlashcardView extends StatelessWidget {
  final String text;


  const FlashcardView({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Center(
        child: TeXView(
            child: TeXViewColumn(children: [
              TeXViewDocument(text,
                  style:
                      const TeXViewStyle(textAlign: TeXViewTextAlign.center)),]
        ),
        )
      ),
    );
  }
}
