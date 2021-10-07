import 'package:ask_chad/field.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:http/http.dart' as http;

import 'popup.dart';
import 'text.dart';
import 'colors.dart';

void main() async {
  runApp(const AskChad());
}

final RegExp plainResponseParser =
    RegExp("PlainResponse\\s*\\{\\s*message:\\s*\"(.+)\"\\s*\\}");

class AskChad extends StatelessWidget {
  const AskChad({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const NeumorphicApp(
      debugShowCheckedModeBanner: false,
      title: "Ask Chad",
      themeMode: ThemeMode.light,
      theme: NeumorphicThemeData(
          baseColor: Color(ChadColors.lightBackground),
          lightSource: LightSource.topLeft,
          depth: 10,
          intensity: 0.8),
      darkTheme: NeumorphicThemeData(
          baseColor: Color(ChadColors.darkBackground),
          lightSource: LightSource.topLeft,
          depth: 6,
          intensity: 0.5),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  String question = "";
  double buttonDepth = 8;
  bool buttonDown = false;

  HomeState({
    question = "",
    buttonDepth = 8,
    buttonDown = false,
  });

  void sendRequest() async {
    var response;

    try {
      response = await http.get(Uri.http("10.0.0.44", "/"), headers: {
        "message": question == "" ? "What day was the moon landing?" : question
      });
    } catch (_) {
      showDialog(
          context: context,
          builder: (BuildContext context) =>
              popup(context, 'Client Error', 'Failed to contact server.'));
      buttonDown = false;
      moveButtonUp();
      return;
    }

    if (response.statusCode == 200) {
      RegExpMatch? matchesFirst = plainResponseParser.firstMatch(response.body);
      RegExpMatch matches;
      switch (matchesFirst) {
        case null:
          {
            showDialog(
                context: context,
                builder: (BuildContext context) => popup(
                    context,
                    'Client Error',
                    'Couldn\'t find a good response to your question. Maybe try rephrasing it?'));
            buttonDown = false;
            moveButtonUp();
            return;
          }
        default:
          {
            matches = matchesFirst!;
          }
      }

      showDialog(
          context: context,
          builder: (BuildContext context) =>
              popup(context, 'We have answers!', matches.group(1)!));
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => popup(context, 'Server Error',
              'The server returned an error: ${response.statusCode}'));
    }

    buttonDown = false;
    moveButtonUp();
  }

  void moveButtonDown() async {
    while (buttonDown) {
      setState(() {
        buttonDepth -= (buttonDepth + 4) / 10;
      });

      await Future.delayed(const Duration(milliseconds: 8));
    }
  }

  void moveButtonUp() async {
    while (!buttonDown) {
      setState(() {
        buttonDepth -= (buttonDepth - 4) / 10;
      });

      await Future.delayed(const Duration(milliseconds: 8));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: NeumorphicTheme.baseColor(context),
        body: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
                child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                        margin: const EdgeInsets.only(
                            left: 0, top: 100, right: 0, bottom: 0),
                        child: Column(children: <Widget>[
                          neumorphicH1("Ask Chad"),
                          neumorphicH2("an NLP API"),
                        ])))),
            Container(
                margin: const EdgeInsets.only(
                    left: 0, top: 0, right: 0, bottom: 60),
                child: Column(children: <Widget>[
                  NeumorphicTextField(
                    label: "Question",
                    hint: "What day was the moon landing?",
                    onChanged: (question) {
                      setState(() {
                        this.question = question;
                      });
                    },
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      child: GestureDetector(
                          onTapDown: (_) {
                            setState(() {
                              buttonDown = true;
                            });

                            sendRequest();
                            moveButtonDown();
                          },
                          onTapUp: (_) {
                            setState(() {
                              buttonDown = false;
                            });

                            moveButtonUp();
                          },
                          child: Neumorphic(
                              style: NeumorphicStyle(
                                  depth: buttonDepth,
                                  boxShape: NeumorphicBoxShape.roundRect(
                                      const BorderRadius.all(
                                          Radius.circular(20)))),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 60, vertical: 10),
                              child: Text("Submit",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: NeumorphicTheme.defaultTextColor(
                                          context))))))
                ]))
          ],
        )));
  }
}
