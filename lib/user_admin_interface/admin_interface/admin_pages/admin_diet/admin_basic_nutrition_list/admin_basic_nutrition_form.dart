import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_hub_mobile_application/api/api.dart';
import 'package:fit_hub_mobile_application/models/basicNutrition.dart';
import 'package:fit_hub_mobile_application/notifiers/basicNutrition_notifier.dart';
import 'package:fit_hub_mobile_application/shared/constants.dart';
import 'package:fit_hub_mobile_application/shared/video_player_chewie.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:path/path.dart' as path;
import 'admin_basic_nutrition_list_page.dart';

class AdminBasicNutritionFormPage extends StatefulWidget {
  final bool isUpdating;
  AdminBasicNutritionFormPage({@required this.isUpdating});
  @override
  _AdminBasicNutritionFormPageState createState() => _AdminBasicNutritionFormPageState();
}

class _AdminBasicNutritionFormPageState extends State<AdminBasicNutritionFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String coachNames;
  List _details = [];
  BasicNutrition _currentBasicNutrition;
  String _thumbnailUrl, _videoUrl;
  File _thumbnailFile, _videoFile;
  String videoName;
  final _picker = ImagePicker();
  TextEditingController detailsController = new TextEditingController();
  ProgressDialog pr ;

  @override
  void initState(){
    super.initState();
    BasicNutritionNotifier basicNutritionNotifier = Provider.of<BasicNutritionNotifier>(context, listen: false);

    if(basicNutritionNotifier.currentBasicNutrition != null){
      _currentBasicNutrition = basicNutritionNotifier.currentBasicNutrition;
    } else {
      _currentBasicNutrition = BasicNutrition();
    }
    _details.addAll(_currentBasicNutrition.details);
    _thumbnailUrl = _currentBasicNutrition.thumbnail;
    _videoUrl = _currentBasicNutrition.videoUrl;
    // coachNames = _currentBasicNutrition.coachName;
  }

  Widget _showThumbnail() {
    if(_thumbnailFile == null && _thumbnailUrl == null){
      return Icon(Icons.photo, size: 50, color: Colors.grey);
    } else if (_thumbnailFile != null){
      print('Showing Image from Local File');
      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.file(
            _thumbnailFile,
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
                'CHANGE THUMBNAIL',
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
          Image.network(
            _thumbnailUrl,
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
                'CHANGE THUMBNAIL',
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
      maxWidth: 400,
    );
    if(imageFile != null){
      setState(() {
        _thumbnailFile = File(imageFile.path);
      });
    }
  }

  Widget _showVideo() {
    if(_videoFile == null && _videoUrl == null){
      return Icon(Icons.video_collection, size: 50, color: Colors.grey);
    } else if (_videoFile != null){
      print('Showing Video Name from Local File');
      return Center(
        child: Column(
          children: <Widget>[
            Text('Video File Name:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(videoName),
          ],
        ),
      );
    } else if (_videoUrl != null){
      print('Showing Image from Url');
      return Center(
        child: Column(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 16/9,
              child: VideoPlayerChewie(
                videoPlayerController: VideoPlayerController.network(
                    _videoUrl
                ),
                looping: true,
              ),
            ),
          ],
        ),
      );
    }
  }

  _getLocalVideo() async{
    final videoFile = await _picker.getVideo(
      source: ImageSource.gallery,
    );
    if(videoFile != null){
      setState(() {
        _videoFile = File(videoFile.path);
        videoName = path.basename(videoFile.path);
      });
    }
  }

  Widget _buildTitle() {
    return TextFormField(
      keyboardType: TextInputType.text,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: _currentBasicNutrition.title,
      maxLength: 50,
      decoration: textInputDecoration.copyWith(labelText: 'Title'.toUpperCase()),
      validator: (String value){
        if(value.isEmpty){
          return '';
        }
        return null;
      },
      onSaved: (String value) {
        _currentBasicNutrition.title = value;
      },
    );
  }

  Widget _buildDetailsField() {
    return SizedBox(width: 300,
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: detailsController,
        decoration: textInputDecoration.copyWith(labelText: 'Details'.toUpperCase()),
      ),
    );
  }

  Widget _addDetails (String text){
    if(text.isNotEmpty){
      setState(() {
        _details.add(text.toUpperCase());
      });
      detailsController.clear();
    }
  }

  Widget _buildDescription() {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: _currentBasicNutrition.description,
      maxLines: null,
      decoration: textInputDecoration.copyWith(labelText: 'Description'.toUpperCase()),
      validator: (String value){
        if(value.isEmpty){
          return 'This field is required';
        }
        return null;
      },
      onSaved: (String value) {
        _currentBasicNutrition.description = value;
      },
    );
  }

  _onBasicNutritionUploaded(BasicNutrition basicNutrition) {
    BasicNutritionNotifier basicNutritionNotifier = Provider.of<BasicNutritionNotifier>(context, listen: false);
    basicNutritionNotifier.addBasicNutrition(basicNutrition);
    pr.hide();
    Navigator.pop(context);
    flushBar(context);

  }

  _saveBasicNutrition() {
    print('saveBasicNutrition Called');
    if(!_formKey.currentState.validate()){
      pr.hide();
      return;
    }
    _formKey.currentState.save();
    print('${_currentBasicNutrition.title} Saved!');
    _currentBasicNutrition.details = _details;
    _currentBasicNutrition.coachName = coachNames;

    uploadBasicNutritionThumbnailAndVideo(_currentBasicNutrition, widget.isUpdating, _thumbnailFile, _videoFile, _onBasicNutritionUploaded);

    print('Title: ${_currentBasicNutrition.title}');
    print('Coach Name: ${_currentBasicNutrition.coachName}');
    print('Details: ${_currentBasicNutrition.details.toString()}');
    print('Description: ${_currentBasicNutrition.description}');
    print('_thumbnailFile: ${_thumbnailFile.toString()}');
    print('_thumbnailUrl: ${_thumbnailUrl.toString()}');
    print('_videoFile: ${_videoFile.toString()}');
    print('_videoUrl: ${_videoUrl.toString()}');

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
          'BASIC NUTRITION FORM',
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
          onPressed: () => Navigator.of(context).pop(AdminBasicNutritionListPage()),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('coachesDetails').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                  if (!snapshot.hasData) {
                    return Text('Loading . . .');
                  }
                  return DropdownButtonFormField(
                    decoration: textInputDecoration.copyWith(labelText: 'SELECT FIT HUB COACH'),
                    isExpanded: false,
                    value: coachNames ,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    items: snapshot.data.docs.map((value){
                      return DropdownMenuItem(
                        value: value.get('coachName'),
                        child: Text('${value.get('coachName')}'),
                      );
                    }).toList(),
                    validator: (value) => value == null ? '' : null,
                    onChanged: (val) {
                      setState(() => coachNames = val);
                    },
                  );
                },
              ),
              SizedBox(height: 20),
              Center(
                child: _showVideo(),
              ),
              SizedBox(height: 5.0),
              ButtonTheme(
                minWidth: 500.0,
                height: 30.0,
                child: RaisedButton(
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular((5)),
                  ),
                  color: Colors.black,
                  child: Text(
                    'SELECT VIDEO',
                    style: TextStyle(color: Colors.white,
                      fontSize: 15.0,
                    ),
                  ),
                  onPressed: () {
                    return _getLocalVideo();
                  },
                ),
              ),
              SizedBox(height: 15.0),
              Center(
                child: _showThumbnail(),
              ),
              SizedBox(height: 15.0),
              _thumbnailFile == null && _thumbnailUrl == null
                  ? ButtonTheme(
                minWidth: 500.0,
                height: 30.0,
                child: RaisedButton(
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular((5)),
                  ),
                  color: Colors.black,
                  child: Text(
                    'SELECT THUMBNAIL',
                    style: TextStyle(color: Colors.white,
                      fontSize: 15.0,
                    ),
                  ),
                  onPressed: () {
                    return _getLocalImage();
                  },
                ),
              )
                  : SizedBox(height: 5.0),
              Text(
                widget.isUpdating ? '' : '',
                textAlign: TextAlign.center,
                // style: TextStyle(
                //   color: Colors.black,
                //   fontWeight: FontWeight.bold,
                //   fontSize: 20.0,
                // ),
              ),
              _buildTitle(),
              Divider(height: 45.0, thickness: 1.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _buildDetailsField(),
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
                        _addDetails(detailsController.text);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 2,
                children: _details
                    .map((details) => Chip(
                  labelPadding: EdgeInsets.only(left: 20, right: 5),
                  backgroundColor: Colors.blueGrey[400],
                  label: Text(details,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  deleteIconColor: Colors.white,
                  onDeleted: () {
                    setState(() {
                      _details.remove(details);
                    });
                  },
                ))
                    .toList(),
              ),
              Divider(height: 30.0, thickness: 1.0),
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
          _saveBasicNutrition();
        },
      ),
    );
  }
  void flushBar(BuildContext context){
    Flushbar(
      message: '${_currentBasicNutrition.title.toUpperCase()} Successfully Saved.',
      duration: Duration(seconds: 2),
      flushbarStyle: FlushbarStyle.FLOATING,
    )..show(context);
  }
}
