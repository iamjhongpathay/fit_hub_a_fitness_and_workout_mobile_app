import 'package:fit_hub_mobile_application/api/api.dart';
import 'package:flutter/material.dart';

enum DialogAction {yes, abort}

final AuthService _auth = AuthService();

class Dialogs{
  static Future<DialogAction>yesAbortDialog(
      BuildContext context,
      String title,
      String body,
      )async {
    final action = await showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
          ),
          title: Text(title),
          content: Text(body),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop(DialogAction.abort);
              },
              child: const Text('NO',
                style: TextStyle( fontSize: 18.0),
              ),
            ),
            FlatButton(
              onPressed: () async{
                Navigator.of(context).pop(DialogAction.abort);
                await _auth.signOut();
              },
              child: const Text('YES',
                style: TextStyle( fontSize: 18.0),
              ),
            ),
          ],
        );
      },
    );
    return (action != null) ? action : DialogAction.abort;
  }
}