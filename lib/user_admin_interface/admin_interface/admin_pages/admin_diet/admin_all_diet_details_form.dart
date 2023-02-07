import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fit_hub_mobile_application/api/api.dart';
import 'package:fit_hub_mobile_application/models/diet.dart';
import 'package:fit_hub_mobile_application/notifiers/diet_notifier.dart';
import 'package:fit_hub_mobile_application/shared/constants.dart';
import 'package:fit_hub_mobile_application/shared/video_player_chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:path/path.dart' as path;

class AdminAllDietDetailsForm extends StatefulWidget {
  final bool isUpdating;
  AdminAllDietDetailsForm({@required this.isUpdating});
  @override
  _AdminAllDietDetailsFormState createState() => _AdminAllDietDetailsFormState();
}

class _AdminAllDietDetailsFormState extends State<AdminAllDietDetailsForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List _nutritionPerServing = [], _ingredients = [], _procedure = [];
  List<String> _category = <String>['Meats & Proteins', 'Grains & Cereals', 'Fruits & Veggies'];
  DietDetails _currentDietDetails;
  String _thumbnailUrl, _videoUrl, _currentCategory;
  File _thumbnailFile, _videoFile;
  String videoName;
  final _picker = ImagePicker();
  TextEditingController nutritionPerServingController = new TextEditingController(),
      ingredientsController = new TextEditingController(),
      procedureController = new TextEditingController();
  ProgressDialog pr ;

  @override
  void initState(){
    super.initState();
    AllDietDetailsNotifier allDietDetailsNotifier = Provider.of<AllDietDetailsNotifier>(context, listen: false);

    if(allDietDetailsNotifier.currentDietDetails != null){
      _currentDietDetails = allDietDetailsNotifier.currentDietDetails;
    } else {
      _currentDietDetails = DietDetails();
    }
    _nutritionPerServing.addAll(_currentDietDetails.nutritionList);
    _ingredients.addAll(_currentDietDetails.ingredients);
    _procedure.addAll(_currentDietDetails.stepByStep);
    _thumbnailUrl = _currentDietDetails.thumbnailUrl;
    _videoUrl = _currentDietDetails.videoUrl;
    _currentCategory = _currentDietDetails.category;
  }


  // Widget _showVideo() {
  //   if(_videoFile == null && _videoUrl == null){
  //     return Icon(Icons.video_collection, size:50, color: Colors.grey);
  //   } else if (_videoFile != null){
  //     print('Showing Video Name from Local File');
  //     return Center(
  //       child: Column(
  //         children: <Widget>[
  //           Text('Video File Name:',
  //             style: TextStyle(fontWeight: FontWeight.bold),
  //           ),
  //           Text(videoName),
  //         ],
  //       ),
  //     );
  //   } else if (_videoUrl != null){
  //     print('Showing Image from Url');
  //     return Center(
  //       child: Column(
  //         children: <Widget>[
  //           AspectRatio(
  //             aspectRatio: 16/9,
  //             child: VideoPlayerChewie(
  //               videoPlayerController: VideoPlayerController.network(
  //                   _videoUrl
  //               ),
  //               looping: true,
  //             ),
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  // }
  // _getLocalVideo() async{
  //   final videoFile = await _picker.getVideo(
  //     source: ImageSource.gallery,
  //   );
  //   if(videoFile != null){
  //     setState(() {
  //       _videoFile = File(videoFile.path);
  //       videoName = path.basename(videoFile.path);
  //     });
  //   }
  // }

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
      initialValue: _currentDietDetails.title,
      maxLength: 50,
      decoration: textInputDecoration.copyWith(labelText: 'Title'.toUpperCase()),
      validator: (String value){
        if(value.isEmpty){
          return '';
        }
        return null;
      },
      onSaved: (String value) {
        _currentDietDetails.title = value;
      },
    );
  }
  Widget _buildKcal() {
    return SizedBox(width: 185,
      child: TextFormField(
        keyboardType: TextInputType.text,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        initialValue: _currentDietDetails.kcal,
        decoration: textInputDecoration.copyWith(labelText: 'CALORIES (CAL)'.toUpperCase()),
        validator: (String value){
          if(value.isEmpty){
            return '';
          }
          return null;
        },
        onSaved: (String value) {
          _currentDietDetails.kcal = value;
        },
      ),
    );
  }

  Widget _buildDifficulty() {
    return SizedBox(width: 185,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.text,
        initialValue: _currentDietDetails.levelToDo,
        decoration: textInputDecoration.copyWith(labelText: 'DIFFICULTY TO MAKE'.toUpperCase()),
        validator: (String value){
          if(value.isEmpty){
            return '';
          }
          return null;
        },
        onSaved: (String value) {
          _currentDietDetails.levelToDo = value;
        },
      ),
    );
  }

  Widget _buildDescription() {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: _currentDietDetails.description,
      maxLines: null,
      decoration: textInputDecoration.copyWith(labelText: 'Description'.toUpperCase()),
      validator: (String value){
        if(value.isEmpty){
          return '';
        }
        return null;
      },
      onSaved: (String value) {
        _currentDietDetails.description = value;
      },
    );
  }
  Widget _buildNutritionPerServingField() {
    return SizedBox(width: 300,
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: nutritionPerServingController,
        decoration: textInputDecoration.copyWith(labelText: 'Nutrition Per Serving'.toUpperCase()),
      ),
    );
  }

  Widget _addNutritionPerServing (String text){
    if(text.isNotEmpty){
      setState(() {
        _nutritionPerServing.add(text.toUpperCase());
      });
      nutritionPerServingController.clear();
    }
  }
  Widget _buildIngredeintsField() {
    return SizedBox(width: 300,
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: ingredientsController,
        decoration: textInputDecoration.copyWith(labelText: 'Ingredients'.toUpperCase()),
      ),
    );
  }

  Widget _addIngridients (String text){
    if(text.isNotEmpty){
      setState(() {
        _ingredients.add(text.toUpperCase());
      });
      ingredientsController.clear();
    }
  }

  Widget _buildProcedureField() {
    return SizedBox(width: 300,
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: procedureController,
        decoration: textInputDecoration.copyWith(labelText: 'Procedures'.toUpperCase()),
      ),
    );
  }

  Widget _addProcedure (String text){
    if(text.isNotEmpty){
      setState(() {
        _procedure.add(text.toUpperCase());
      });
      procedureController.clear();
    }
  }

  _onDietDetailsUploaded(DietDetails dietDetails) {
    DietDetailsNotifier dietDetailsNotifier = Provider.of<DietDetailsNotifier>(context, listen: false);
    dietDetailsNotifier.addDietDetails(dietDetails);
    pr.hide();
    Navigator.pop(context);
    flushBar(context);
  }

  _saveMeatsProteins() {
    print('saveMeatProteins Called');
    if(!_formKey.currentState.validate()){
      pr.hide();
      return;
    }
    _formKey.currentState.save();
    print('${_currentDietDetails.title} Saved!');
    _currentDietDetails.nutritionList = _nutritionPerServing;
    _currentDietDetails.ingredients = _ingredients;
    _currentDietDetails.stepByStep = _procedure;
    _currentDietDetails.category = _currentCategory;

    uploadAllDietDetailsThumbnailAndVideo(_currentDietDetails, widget.isUpdating, _thumbnailFile, _videoFile, _onDietDetailsUploaded);

    print('Title: ${_currentDietDetails.title}');
    print('Kcal: ${_currentDietDetails.kcal}');
    print('Difficulty to Make: ${_currentDietDetails.levelToDo}');
    print('Details: ${_currentDietDetails.nutritionList.toString()}');
    print('Description: ${_currentDietDetails.description}');
    print('Ingredients: ${_currentDietDetails.ingredients.toString()}');
    print('Procedures: ${_currentDietDetails.stepByStep.toString()}');
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
          'FOOD RECIPES FORM',
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
            // autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: <Widget>[
                DropdownButtonFormField(
                  value: _currentCategory ?? _currentDietDetails.category,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: textInputDecoration.copyWith(labelText: 'SELECT CATEGORY'),
                  icon: Icon(Icons.arrow_drop_down),
                  items: _category.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  validator: (value) => value == null ? '' : null,
                  onChanged: (val) => setState(() => _currentCategory = val),
                ),
                Divider(height: 40.0, thickness: 1.0),
                // Center(
                //   child: _showVideo(),
                // ),
                // SizedBox(height: 5.0),
                // ButtonTheme(
                //   minWidth: 500.0,
                //   height: 30.0,
                //   child: RaisedButton(
                //     elevation: 0.0,
                //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular((5)),
                //     ),
                //     color: Colors.black,
                //     child: Text(
                //       'SELECT VIDEO',
                //       style: TextStyle(color: Colors.white,
                //         fontSize: 15.0,
                //       ),
                //     ),
                //     onPressed: () {
                //       return _getLocalVideo();
                //     },
                //   ),
                // ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Card(
                      // color: Colors.grey,
                      semanticContainer: true,
                      elevation: 0,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Column(
                        children: <Widget>[
                          Image.asset('assets/kcal_icon.png', height: 35, width: 35),
                          SizedBox(height: 5),
                          _buildKcal(),
                        ],
                      ),
                    ),
                    Container(height: 30, child: VerticalDivider(color: Colors.grey[300], thickness: 1.0,)),
                    Card(
                      // color: Colors.grey,
                      semanticContainer: true,
                      elevation: 0,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Column(
                        children: <Widget>[
                          Image.asset('assets/level_gauge_icon.png', height: 35, width: 35),
                          SizedBox(height: 5),
                          _buildDifficulty(),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(height: 40.0, thickness: 1.0),
                _buildDescription(),
                Divider(height: 40.0, thickness: 1.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _buildNutritionPerServingField(),
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
                          _addNutritionPerServing(nutritionPerServingController.text);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 2,
                  children: _nutritionPerServing
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
                        _nutritionPerServing.remove(details);
                      });
                    },
                  ))
                      .toList(),
                ),
                Divider(height: 40.0, thickness: 1.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _buildIngredeintsField(),
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
                          _addIngridients(ingredientsController.text);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Column(
                  children: <Widget>[
                    Material(
                      elevation: 1,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      child: Container(
                        height: 300,
                        padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                        decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: ListView(
                          // physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: _ingredients
                              .map((ingredients) => Card(
                            color: Colors.grey[100],
                            elevation: 0,
                            child: ListTile(
                              title: Text(ingredients),
                              trailing: IconButton(
                                icon: Icon(Icons.remove_circle, color: Colors.red,),
                                onPressed: () {
                                  setState(() {
                                    _ingredients.remove(ingredients);
                                  });
                                },
                              ),
                            ),
                          )).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(height: 40.0, thickness: 1.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _buildProcedureField(),
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
                          _addProcedure(procedureController.text);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Column(
                  children: <Widget>[
                    Material(
                      elevation: 1,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      child: Container(
                        height: 300,
                        padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                        decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: ListView(
                          // physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: _procedure
                              .map((procedure) => Card(
                            color: Colors.grey[100],
                            elevation: 0,
                            child: ListTile(
                              title: Text(procedure),
                              trailing: IconButton(
                                icon: Icon(Icons.remove_circle, color: Colors.red,),
                                onPressed: () {
                                  setState(() {
                                    _procedure.remove(procedure);
                                  });
                                },
                              ),
                            ),
                          )).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
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
          _saveMeatsProteins();
        },
      ),
    );
  }
  void flushBar(BuildContext context){
    Flushbar(
      message: '${_currentDietDetails.title.toUpperCase()} Successfully Saved.',
      duration: Duration(seconds: 2),
      flushbarStyle: FlushbarStyle.FLOATING,
    )..show(context);
  }
}
