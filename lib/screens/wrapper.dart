import 'package:fit_hub_mobile_application/models/user.dart';
import 'package:fit_hub_mobile_application/screens/authenticate.dart';
import 'package:fit_hub_mobile_application/user_admin_interface/admin_interface/admin_navbar_home.dart';
import 'package:fit_hub_mobile_application/user_admin_interface/coach_pages/coach_navbar_home.dart';
import 'package:fit_hub_mobile_application/user_admin_interface/user_interface/user_pages/user_navbar_home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TheUser>(context);

    if(user == null) {
      return Authenticate();
    }else if (user.uid == 'snbWf8iDuBcV7dbacrxGOR9OhQ12'){
      return AdminNavBarHome();
    }else if(user.uid == 'BfDxzd1FXkY198eWZBlbHgRNEsI3' || user.uid == 'ZA4wY5OwwMV1HakzsZofkAcgFFH3'){
      return CoachNavBarHome();
    }else{
      return UserNavBarHome();
    }
  }
}
