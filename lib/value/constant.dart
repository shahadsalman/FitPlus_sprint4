import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

const kPrimaryColor = Color.fromARGB(255, 210, 202, 221);
final BorderRadius kBorderRadius = BorderRadius.circular(5);

hiddenKeyboard(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());
}

showMaterialDialog_login(context, name) {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  AwesomeDialog(
    context: context,
    customHeader: ClipRRect(
      borderRadius: BorderRadius.circular(50.0),
      child: Scaffold(
        key: scaffoldKey,
        body: Center(
          child: Image.asset(
            'assets/logo.png',
            fit: BoxFit.cover,
            width: 70,
          ),
        ),
      ),
    ),
    dialogType: DialogType.SUCCES,
    animType: AnimType.LEFTSLIDE,
    body: Text('\n$name\n'),
  ).show();
}
