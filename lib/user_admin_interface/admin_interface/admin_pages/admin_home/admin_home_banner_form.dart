import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fit_hub_mobile_application/api/api.dart';
import 'package:fit_hub_mobile_application/models/home_banner.dart';
import 'package:fit_hub_mobile_application/notifiers/homeBanner_notifier.dart';
import 'package:fit_hub_mobile_application/shared/constants.dart';
import 'package:fit_hub_mobile_application/user_admin_interface/admin_interface/admin_pages/admin_home/admin_home_banner_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class AdminHomeBannerForm extends StatefulWidget {
  final bool isUpdating;
  AdminHomeBannerForm({@required this.isUpdating});
  @override
  _AdminHomeBannerFormState createState() => _AdminHomeBannerFormState();
}

class _AdminHomeBannerFormState extends State<AdminHomeBannerForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  HomeBanner _currentHomeBanner;
  String _imageUrl;
  File _imageFile;
  final _picker = ImagePicker();
  ProgressDialog pr ;

  @override
  void initState(){
    super.initState();
    HomeBannerNotifier homeBannerNotifier = Provider.of<HomeBannerNotifier>(context, listen: false);

    if(homeBannerNotifier.currentHomeBanner != null){
      _currentHomeBanner = homeBannerNotifier.currentHomeBanner;
    } else {
      _currentHomeBanner = HomeBanner();
    }
    _imageUrl = _currentHomeBanner.thumbnailUrl;
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

  Widget _buildTitle() {
    return TextFormField(
      keyboardType: TextInputType.text,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: _currentHomeBanner.title,
      decoration: textInputDecoration.copyWith(labelText: 'TITLE'.toUpperCase()),
      validator: (String value){
        if(value.isEmpty){
          return 'This field is required';
        }
        return null;
      },
      onSaved: (String value) {
        _currentHomeBanner.title = value;
      },
    );
  }

  Widget _buildDescription() {
    return TextFormField(

      keyboardType: TextInputType.multiline,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: _currentHomeBanner.description,
      maxLines: null,
      decoration: textInputDecoration.copyWith(labelText: 'DESCRIPTION'.toUpperCase()),
      validator: (String value){
        if(value.isEmpty){
          return 'This field is required';
        }
        return null;
      },
      onSaved: (String value) {
        _currentHomeBanner.description = value;
      },
    );
  }

  _onHomeBannerUploaded(HomeBanner homeBanner) {
    HomeBannerNotifier homeBannerNotifier = Provider.of<HomeBannerNotifier>(context, listen: false);
    homeBannerNotifier.addHomeBanner(homeBanner);
    pr.hide();
    Navigator.of(context).pop();
    flushBar(context);
  }
  _saveHomeBanner() {
    print('saveHomeBanner Called');
    if(!_formKey.currentState.validate()){
      pr.hide();
      return;
    }
    _formKey.currentState.save();
    print('Coach Saved!');

    uploadHomeBannerThumbnail(_currentHomeBanner, widget.isUpdating, _imageFile, _onHomeBannerUploaded);

    print('title: ${_currentHomeBanner.title}');
    print('description: ${_currentHomeBanner.description}');
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
          'HOME BANNER FORM',
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
          onPressed: () => Navigator.of(context).pop(AdminHomeBannerPage()),
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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
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
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      _buildTitle(),
                      SizedBox(height: 20,),
                      _buildDescription()
                    ],
                  ),
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
          _saveHomeBanner();
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
