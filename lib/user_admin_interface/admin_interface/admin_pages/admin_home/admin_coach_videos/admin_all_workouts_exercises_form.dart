import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_hub_mobile_application/models/workoutsExercises.dart';
import 'package:fit_hub_mobile_application/notifiers/workoutsExercises_notifier.dart';
import 'package:fit_hub_mobile_application/shared/constants.dart';
import 'package:fit_hub_mobile_application/shared/video_player_chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:path/path.dart' as path;
import 'package:fit_hub_mobile_application/api/api.dart';

class AdminAllWorkoutsExercisesForm extends StatefulWidget {
  final bool isUpdating;
  AdminAllWorkoutsExercisesForm({@required this.isUpdating});
  @override
  _AdminAllWorkoutsExercisesFormState createState() => _AdminAllWorkoutsExercisesFormState();
}

class _AdminAllWorkoutsExercisesFormState extends State<AdminAllWorkoutsExercisesForm> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String coachNames;
  List _details = [];
  List<String> _competencyLevel = <String>['Beginner', 'Intermediate', 'Advanced', 'Expert'];
  List<String> _category = <String>['Circuit Workout', 'Boxing & Muay Thai', 'CrossFit Workout'];
  WorkoutsExercises _currentWorkoutsExercises;
  String _thumbnailUrl, _videoUrl, _currentCompetencyLevel, _currentCategory;
  File _thumbnailFile, _videoFile;
  String videoName;
  final _picker = ImagePicker();
  TextEditingController detailsController = new TextEditingController();
  ProgressDialog pr ;

  @override
  void initState(){
    super.initState();
    AllWorkoutsExercisesNotifier allWorkoutsExercisesNotifier = Provider.of<AllWorkoutsExercisesNotifier>(context, listen: false);

    if(allWorkoutsExercisesNotifier.currentWorkoutsExercises != null){
    _currentWorkoutsExercises = allWorkoutsExercisesNotifier.currentWorkoutsExercises;
    } else {
      _currentWorkoutsExercises = WorkoutsExercises();
    }
    _details.addAll(_currentWorkoutsExercises.details);
    _thumbnailUrl = _currentWorkoutsExercises.thumbnailUrl;
    _videoUrl = _currentWorkoutsExercises.videoUrl;
    _currentCompetencyLevel = _currentWorkoutsExercises.competencyLevel;
    _currentCategory = _currentWorkoutsExercises.workoutsExercisesCategory;
    // coachNames = _currentWorkoutsExercises.coachName;
  }
  Widget _showVideo() {
    if(_videoFile == null && _videoUrl == null){
      return Icon(Icons.video_collection, size:50, color: Colors.grey);
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
    );
    if(imageFile != null){
      setState(() {
        _thumbnailFile = File(imageFile.path);
      });
    }
  }

  Widget _buildTitle() {
    return TextFormField(
      keyboardType: TextInputType.text,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLength: 50,
      initialValue: _currentWorkoutsExercises.title,
      decoration: textInputDecoration.copyWith(labelText: 'Title'.toUpperCase()),
      validator: (String value){
        if(value.isEmpty){
          return '';
        }
        return null;
      },
      onSaved: (String value) {
        _currentWorkoutsExercises.title = value;
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
      initialValue: _currentWorkoutsExercises.description,
      maxLines: null,
      decoration: textInputDecoration.copyWith(labelText: 'Description'.toUpperCase()),
      validator: (String value){
        if(value.isEmpty){
          return '';
        }
        return null;
      },
      onSaved: (String value) {
        _currentWorkoutsExercises.description = value;
      },
    );
  }
  _onWorkoutsExercisesUploaded(WorkoutsExercises workoutsExercises) {
    WorkoutsExercisesNotifier workoutsExercisesNotifier = Provider.of<WorkoutsExercisesNotifier>(context, listen: false);
    workoutsExercisesNotifier.addWorkoutsExercises(workoutsExercises);
    pr.hide();
    Navigator.of(context).pop();
    flushBar(context);
  }
  _saveWorkoutsExercises() {
    print('saveBoxing Called');
    if(!_formKey.currentState.validate()){
      pr.hide();
      return;
    }
    _formKey.currentState.save();
    print('${_currentWorkoutsExercises.title} Saved!');
    _currentWorkoutsExercises.details = _details;
    _currentWorkoutsExercises.competencyLevel = _currentCompetencyLevel;
    _currentWorkoutsExercises.workoutsExercisesCategory = _currentCategory;
    _currentWorkoutsExercises.coachName = coachNames;



    uploadAllWorkoutsExercisesThumbnailAndVideo(_currentWorkoutsExercises, widget.isUpdating, _thumbnailFile, _videoFile, _onWorkoutsExercisesUploaded);

    print('Title: ${_currentWorkoutsExercises.title}');
    print('Level of Competency: ${_currentWorkoutsExercises.competencyLevel}');
    print('Details: ${_currentWorkoutsExercises.details.toString()}');
    print('Coach Name: ${_currentWorkoutsExercises.coachName}');
    print('Description: ${_currentWorkoutsExercises.description}');
    print('_thumbnailFile: ${_thumbnailFile.toString()}');
    print('_thumbnailUrl: ${_thumbnailUrl.toString()}');
    print('_videoFile: ${_videoFile.toString()}');
    print('_videoUrl: ${_videoUrl.toString()}');

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
          'WORKOUTS EXERCISES FORM',
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
          onPressed: () => Navigator.pop((context)),
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
                      value: coachNames,
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
                SizedBox(height: 15.0),
                DropdownButtonFormField(
                  value: _currentCategory ?? _currentWorkoutsExercises.workoutsExercisesCategory,
                  isExpanded: false,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: textInputDecoration.copyWith(labelText: 'Category'),
                  icon: Icon(Icons.arrow_drop_down),
                  items: _category.map((val) {
                    return DropdownMenuItem(
                      value: val,
                      child: Text(val),
                    );
                  }).toList(),
                  validator: (value) => value == null ? '' : null,
                  onChanged: (val) => setState(() => _currentCategory = val),
                ),
                Divider(height: 40.0, thickness: 1.0),
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
                ),
                _buildTitle(),
                SizedBox(height: 15.0),
                DropdownButtonFormField(
                  value: _currentCompetencyLevel ?? _currentWorkoutsExercises.competencyLevel,
                  isExpanded: false,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: textInputDecoration.copyWith(labelText: 'LEVEL OF COMPETENCY'),
                  icon: Icon(Icons.arrow_drop_down),
                  items: _competencyLevel.map((val) {
                    return DropdownMenuItem(
                      value: val,
                      child: Text(val),
                    );
                  }).toList(),
                  validator: (value) => value == null ? '' : null,
                  onChanged: (val) => setState(() => _currentCompetencyLevel = val),
                ),
                Divider(height: 40.0, thickness: 1.0),
                SizedBox(height: 5.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _buildDetailsField(),
                    ButtonTheme(
                      minWidth: 20,
                      height: 50,
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
                Divider(height: 40.0, thickness: 1.0),
                _buildDescription(),
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
          _saveWorkoutsExercises();
        },
      ),
    );
  }
  void flushBar(BuildContext context){
    Flushbar(
      message: '${_currentWorkoutsExercises.title.toUpperCase()} Successfully Saved.',
      duration: Duration(seconds: 2),
      flushbarStyle: FlushbarStyle.FLOATING,
    )..show(context);
  }
}
