import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class NeumorphicTextField extends StatefulWidget {
  late final String label;
  late final String hint;

  late final ValueChanged<String>? onChanged;

  NeumorphicTextField(
      {Key? key, required this.label, required this.hint, this.onChanged})
      : super(key: key);

  @override
  NeumorphicTextFieldState createState() => NeumorphicTextFieldState();
}

class NeumorphicTextFieldState extends State<NeumorphicTextField> {
  TextEditingController? controller;

  @override
  void initState() {
    controller = TextEditingController(text: widget.hint);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(widget.label,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: NeumorphicTheme.defaultTextColor(context)))),
        Neumorphic(
          margin: const EdgeInsets.only(left: 18, right: 18, top: 8, bottom: 4),
          style: NeumorphicStyle(
              depth: NeumorphicTheme.embossDepth(context),
              boxShape: NeumorphicBoxShape.roundRect(
                  const BorderRadius.all(Radius.circular(20)))),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
          child: SizedBox(
            height: 60,
            child: TextField(
                onChanged: widget.onChanged,
                controller: controller,
                decoration: InputDecoration.collapsed(hintText: widget.hint)),
          ),
        ),
      ],
    );
  }
}
