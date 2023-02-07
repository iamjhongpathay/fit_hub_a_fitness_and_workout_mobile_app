import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fit_hub_mobile_application/api/push_notification_api.dart';
import 'package:fit_hub_mobile_application/models/announcement.dart';
import 'package:fit_hub_mobile_application/notifiers/announcement_notifier.dart';
import 'package:fit_hub_mobile_application/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:fit_hub_mobile_application/api/api.dart';

class AdminAnnouncementForm extends StatefulWidget {
  final bool isUpdating;
  AdminAnnouncementForm({@required this.isUpdating});
  @override
  _AdminAnnouncementFormState createState() => _AdminAnnouncementFormState();
}

class _AdminAnnouncementFormState extends State<AdminAnnouncementForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Announcement _currentAnnouncement;
  String _thumbnailUrl;
  File _imageFile;
  final _picker = ImagePicker();
  ProgressDialog pr;

  @override
  void initState(){
    super.initState();
    AnnouncementNotifier announcementNotifier = Provider.of<AnnouncementNotifier>(context, listen: false);

    if(announcementNotifier.currentAnnouncement != null){
      _currentAnnouncement = announcementNotifier.currentAnnouncement;
    } else {
      _currentAnnouncement = Announcement();
    }
    _thumbnailUrl = _currentAnnouncement.thumbnailUrl;
  }

  Widget _showImage() {
    if(_imageFile == null && _thumbnailUrl == null){
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
    } else if (_thumbnailUrl != null){
      print('Showing Image from Url');

      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: _thumbnailUrl,
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

  Widget _buildTitle() {
    return TextFormField(
      keyboardType: TextInputType.text,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: _currentAnnouncement.title,
      decoration: textInputDecoration.copyWith(labelText: 'TITLE'.toUpperCase()),
      validator: (String value){
        if(value.isEmpty){
          return 'This field is required';
        }
        return null;
      },
      onSaved: (String value) {
        _currentAnnouncement.title = value;
      },
    );
  }
  Widget _buildSubTitle() {
    return TextFormField(
      keyboardType: TextInputType.text,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: _currentAnnouncement.subtitle,
      decoration: textInputDecoration.copyWith(labelText: 'SUBTITLE'.toUpperCase()),
      validator: (String value){
        if(value.isEmpty){
          return 'This field is required';
        }
        return null;
      },
      onSaved: (String value) {
        _currentAnnouncement.subtitle = value;
      },
    );
  }

  Widget _buildDescription() {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: _currentAnnouncement.description,
      maxLines: null,
      decoration: textInputDecoration.copyWith(labelText: 'DESCRIPTION'.toUpperCase()),
      validator: (String value){
        if(value.isEmpty){
          return 'This field is required';
        }
        return null;
      },
      onSaved: (String value) {
        _currentAnnouncement.description = value;
      },
    );
  }

  _onAnnouncementUploaded(Announcement announcement) {
    AnnouncementNotifier announcementNotifier = Provider.of<AnnouncementNotifier>(context, listen: false);
    announcementNotifier.addAnnouncement(announcement);
    pr.hide();
    Navigator.of(context).pop();
    flushBar(context);
    sendNotification();
  }

  _saveAnnouncement() {
    print('saveAnnouncement Called');
    if(!_formKey.currentState.validate()){
      pr.hide();
      return;
    }
    _formKey.currentState.save();
    print('Announcement Saved!');

    uploadAnnouncementAndImage(_currentAnnouncement, widget.isUpdating, _imageFile, _onAnnouncementUploaded);

    print('title: ${_currentAnnouncement.title}');
    print('subtitle: ${_currentAnnouncement.subtitle}');
    print('description: ${_currentAnnouncement.description}');
    print('_imageFile: ${_imageFile.toString()}');
    print('_imageUrl: ${_thumbnailUrl.toString()}');


    // flushBar(context);
  }

  Future sendNotification() async {
    final response = await Messaging.sendToAll(
      title: '${_currentAnnouncement.title} : ${_currentAnnouncement.subtitle}',
      body: _currentAnnouncement.description,
    );

    if (response.statusCode != 200) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content:
        Text('[${response.statusCode}] Error message: ${response.body}'),
      ));
    }
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
          'LATEST & UPDATES FORM',
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
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Center(
                child: _showImage(),
              ),
              SizedBox(height: 20.0),
              _imageFile == null && _thumbnailUrl == null
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
              _buildTitle(),
              SizedBox(height: 10.0),
              _buildSubTitle(),
              Divider(height: 45.0, thickness: 1.0),
              SizedBox(height: 10,),
              _buildDescription(),
            ],
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
          _saveAnnouncement();
        },
      ),
    );
  }
  void flushBar(BuildContext context){
    Flushbar(
      message: 'Successfully Saved.',
      duration: Duration(seconds: 2),
      flushbarStyle: FlushbarStyle.FLOATING,
    )..show(context);
  }
}
