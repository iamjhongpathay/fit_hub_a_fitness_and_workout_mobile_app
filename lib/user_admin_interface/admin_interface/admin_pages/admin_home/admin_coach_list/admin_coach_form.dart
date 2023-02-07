import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fit_hub_mobile_application/api/api.dart';
import 'package:fit_hub_mobile_application/models/coach.dart';
import 'package:fit_hub_mobile_application/notifiers/coach_notifier.dart';
import 'package:fit_hub_mobile_application/shared/constants.dart';
import 'package:fit_hub_mobile_application/user_admin_interface/admin_interface/admin_pages/admin_home/admin_coach_list/admin_coach_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';


class AdminCoachForm extends StatefulWidget {
  final bool isUpdating;
  AdminCoachForm({@required this.isUpdating});
  @override
  _AdminCoachFormState createState() => _AdminCoachFormState();
}

class _AdminCoachFormState extends State<AdminCoachForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List _categoryDetails = [];
  Coach _currentCoach;
  String _imageUrl;
  File _imageFile;
  final _picker = ImagePicker();
  TextEditingController categoryDetailsController = new TextEditingController();
  ProgressDialog pr ;

  @override
  void initState(){
    super.initState();
    CoachNotifier coachNotifier = Provider.of<CoachNotifier>(context, listen: false);

    if(coachNotifier.currentCoach != null){
      _currentCoach = coachNotifier.currentCoach;
    } else {
      _currentCoach = Coach();
    }
    _categoryDetails.addAll(_currentCoach.categoryDetails);
    _imageUrl = _currentCoach.image;
  }

  Widget _showImage() {
    if(_imageFile == null && _imageUrl == null){
      return Icon(Icons.photo, size: 50, color: Colors.grey,);
    } else if (_imageFile != null){
      print('Showing Image from Local File');

      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.file(
            _imageFile,
            fit: BoxFit.cover,
            height: 250,
          ),
          ButtonTheme(
            minWidth: 500.0,
            height: 40.0,
            child: RaisedButton(
              elevation: 0.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular((1)),
              ),
              color: Colors.black87,
              child: Text(
                'CHANGE IMAGE',
                style: TextStyle(color: Colors.white,
                  fontSize: 15.0,
                ),
              ),
              onPressed: () {
                return _getLocalImage();
              },
            ),
          )
        ],
      );
    } else if (_imageUrl != null){
      print('Showing Image from Url');

      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: _imageUrl,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            height: 250,
          ),
          ButtonTheme(
            minWidth: 500.0,
            height: 40.0,
            child: RaisedButton(
              elevation: 0.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular((1)),
              ),
              color: Colors.black87,
              child: Text(
                'CHANGE IMAGE',
                style: TextStyle(color: Colors.white,
                  fontSize: 15.0,
                ),
              ),
              onPressed: () {
                return _getLocalImage();
              },
            ),
          )
        ],
      );
    }
  }

  _getLocalImage() async {
    final imageFile = await _picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );
    if(imageFile != null){
      setState(() {
        _imageFile = File(imageFile.path);
      });
    }
  }

  Widget _buildCoachName() {
    return TextFormField(
      keyboardType: TextInputType.text,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: _currentCoach.coachName,
      maxLength: 15,
      decoration: textInputDecoration.copyWith(labelText: 'Coach / Trainer Name'.toUpperCase()),
      validator: (String value){
        if(value.isEmpty){
          return 'Name is required';
        }
        return null;
      },
      onSaved: (String value) {
        _currentCoach.coachName = value;
      },
    );
  }

  Widget _buildCoachExpertise() {
    return TextFormField(
      keyboardType: TextInputType.text,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: _currentCoach.expertise,
      decoration: textInputDecoration.copyWith(labelText: 'Expertise'.toUpperCase()),
      validator: (String value){
        if(value.isEmpty){
          return 'This field is required';
        }
        if(value.length < 2 || value.length > 100){
          return 'Expertise must be more than 2 and less than 100 characters.';
        }
        return null;
      },
      onSaved: (String value) {
        _currentCoach.expertise = value;
      },
    );
  }

  Widget _buildAboutCoach() {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: _currentCoach.aboutCoach,
      maxLines: null,
      decoration: textInputDecoration.copyWith(labelText: 'About Coach / Instructor'.toUpperCase()),
      validator: (String value){
        if(value.isEmpty){
          return 'This field is required';
        }
        return null;
      },
      onSaved: (String value) {
        _currentCoach.aboutCoach = value;
      },
    );
  }

  Widget _buildCategoryDetailsField() {
    return SizedBox(width: 300,
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: categoryDetailsController,
        decoration: textInputDecoration.copyWith(labelText: 'Details'.toUpperCase()),
      ),
    );
  }

  _onCoachUploaded(Coach coach) {
    CoachNotifier coachNotifier = Provider.of<CoachNotifier>(context, listen: false);
    coachNotifier.addCoach(coach);
    pr.hide();
    Navigator.of(context).pop();
    flushBar(context);
  }

  Widget _addCategory(String text){
    if(text.isNotEmpty){
      setState(() {
        _categoryDetails.add(text.toUpperCase());
      });
      categoryDetailsController.clear();
    }
  }

  _saveCoach() {
    print('saveCoach Called');
    if(!_formKey.currentState.validate()){
      pr.hide();
      return;
    }
    _formKey.currentState.save();
    print('Coach Saved!');
    _currentCoach.categoryDetails = _categoryDetails;

    uploadCoachAndImage(_currentCoach, widget.isUpdating, _imageFile, _onCoachUploaded);

    print('coachName: ${_currentCoach.coachName}');
    print('expertise: ${_currentCoach.expertise}');
    print('categoryDetails: ${_currentCoach.categoryDetails.toString()}');
    print('aboutCoach: ${_currentCoach.aboutCoach}');
    print('_imageFile: ${_imageFile.toString()}');
    print('_imageUrl: ${_imageUrl.toString()}');

    // flushBar(context);
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context ,
      type: ProgressDialogType.Normal,
      isDismissible: false, showLogs: true,
    );

    pr.style(message: '      Uploading . . . ',
      padding: EdgeInsets.all(20.0),
      messageTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 15.0),
      progressWidget: Container(
        padding: EdgeInsets.all(10.0),
        child: CircularProgressIndicator(strokeWidth: 5.0, valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
      ),
      backgroundColor: Colors.white,
      borderRadius: 5.0,
      elevation: 0.0,
      insetAnimCurve: Curves.ease,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          'COACH / TRAINER FORM',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
            fontSize: 25.0,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.black, size: 20),
          onPressed: () => Navigator.of(context).pop(AdminCoachListPage()),
        ),
      ),
      body: OfflineBuilder(
        connectivityBuilder: (BuildContext context,
            ConnectivityResult connectivity, Widget child){
          final bool connected =
              connectivity != ConnectivityResult.none;
          return Stack(
            fit: StackFit.expand,
            children: [
              child,
              Positioned(
                  left: 0.0,
                  right: 0.0,
                  height: 25.0,
                  child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      color: connected ? null : Color(0xFFEE4400),
                      child: connected ? null :
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('No internet connection', style: TextStyle(color: Colors.white),),
                        ],
                      )
                  )
              )
            ],
          );
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Center(
                  child: _showImage(),
                ),
                SizedBox(height: 20.0),
                _imageFile == null && _imageUrl == null
                    ? ButtonTheme(
                  minWidth: 500.0,
                  height: 30.0,
                  child: RaisedButton(
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular((5)),
                    ),
                    color: Colors.black,
                    child: Text(
                      'SELECT IMAGE',
                      style: TextStyle(color: Colors.white,
                        fontSize: 15.0,
                      ),
                    ),
                    onPressed: () {
                      return _getLocalImage();
                    },
                  ),
                )
                    : SizedBox(height: 5),
                Text(
                  widget.isUpdating ? '' : '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                _buildCoachName(),
                SizedBox(height: 10.0),
                _buildCoachExpertise(),
                Divider(height: 45.0, thickness: 1.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _buildCategoryDetailsField(),
                    ButtonTheme(
                      minWidth: 20,
                      height: 50.0,
                      child: RaisedButton(
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular((5)),
                        ),
                        color: Colors.white10,
                        child: Icon(Icons.add_circle,
                          color: Colors.black,
                          size: 30,
                        ),
                        onPressed: () {
                          _addCategory(categoryDetailsController.text);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 2,
                  children: _categoryDetails
                      .map((categories) => Chip(
                    labelPadding: EdgeInsets.only(left: 20, right: 5),
                    backgroundColor: Colors.blueGrey[400],
                    label: Text(categories,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    deleteIconColor: Colors.white,
                    onDeleted: () {
                      setState(() {
                        _categoryDetails.remove(categories);
                      });
                    },
                  ))
                      .toList(),
                ),
                Divider(height: 30.0, thickness: 1.0),
                SizedBox(height: 10,),
                _buildAboutCoach(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(

        child: const Icon(Icons.save, color: Colors.white),
        elevation: 0,
        backgroundColor: Colors.blue.withOpacity(0.7),
        onPressed: () async{
          await pr.show();
          FocusScope.of(context).requestFocus(new FocusNode());
          _saveCoach();
        },
      ),
    );
  }
  void flushBar(BuildContext context){
    Flushbar(
      message: 'Coach ${_currentCoach.coachName.toUpperCase()} Successfully Saved.',
      duration: Duration(seconds: 2),
      flushbarStyle: FlushbarStyle.FLOATING,
    )..show(context);
  }
}
