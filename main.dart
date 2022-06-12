import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'advanced_expression_form.dart';
import 'custom_expression_form.dart';
import 'simple_submit_form.dart';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key? key}) : super(key: key);

  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SimpleSubmitForm(),
                    ),
                  );
                },
                child: Text('Simple Submit Form'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomExpressionForm(),
                    ),
                  );
                },
                child: Text('Custom Expression Form'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdvancedExpressionForm(),
                    ),
                  );
                },
                child: Text('Advanced Expression Form'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
