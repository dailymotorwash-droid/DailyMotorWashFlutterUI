import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomRichText extends StatelessWidget {
  final int arrayLength;
  final List<String> textsInOrder;
  final List<TextStyle> textStylesInOrder;
  final List<VoidCallback?> callBacksInOrder;

  const CustomRichText({ 
    super.key,
    required this.arrayLength,
    required this.callBacksInOrder,
    required this.textsInOrder,
    required this.textStylesInOrder,
  });

  @override
  Widget build(BuildContext context){
    List<GestureRecognizer> recognizers = [];

    // Create TapGestureRecognizers for each callback
    for(int index = 0; index < arrayLength ; index++) {
      if(callBacksInOrder[index]!=null) {
        recognizers.add(TapGestureRecognizer()..onTap = callBacksInOrder[index]);
      } else {
        recognizers.add(TapGestureRecognizer());
      }
    }

    return RichText(
      text: TextSpan(
        children: [
          for(int index=0 ; index<arrayLength ; index++)
            TextSpan(
              text: textsInOrder[index],
              style: textStylesInOrder[index],
              recognizer: recognizers[index],
            )
        ]
      ) 
    );
  }
}