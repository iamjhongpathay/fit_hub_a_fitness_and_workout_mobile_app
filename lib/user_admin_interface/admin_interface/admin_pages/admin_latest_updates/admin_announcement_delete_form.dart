import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fit_hub_mobile_application/api/api.dart';
import 'package:fit_hub_mobile_application/models/announcement.dart';
import 'package:fit_hub_mobile_application/notifiers/announcement_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminAnnouncementDelete extends StatefulWidget {
  @override
  _AdminAnnouncementDeleteState createState() => _AdminAnnouncementDeleteState();
}

class _AdminAnnouncementDeleteState extends State<AdminAnnouncementDelete> {
  @override
  Widget build(BuildContext context) {
    AnnouncementNotifier announcementNotifier = Provider.of<AnnouncementNotifier>(context);

    _onAnnouncementDeleted(Announcement announcement){
      Navigator.pop(context);
      announcementNotifier.deleteAnnouncement(announcement);
      flushBar(context);
    }

    void _deleteDialog(){
      showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('ARE YOU SURE?',
              style: TextStyle(
                fontFamily: 'Nexa',
                fontWeight: FontWeight.bold,
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            content: Text('Do you really want to delete these records? This process cannot be undone.'),
            actions: <Widget>[
              FlatButton(
                child: Text('CANCEL',
                    style: TextStyle( fontSize: 18.0,
                        color: Colors.black
                    )
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(

                child: Text('DELETE',
                    style: TextStyle( fontSize: 18.0,
                        color: Colors.red
                    )
                ),
                onPressed: () {
                  deleteAnnouncement(announcementNotifier.currentAnnouncement, _onAnnouncementDeleted);
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text('DELETE',
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
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate([
                Column(
                  children: <Widget>[
                    Container(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: CachedNetworkImage(imageUrl: announcementNotifier.currentAnnouncement.thumbnailUrl != null
                              ?announcementNotifier.currentAnnouncement.thumbnailUrl
                              :'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('${announcementNotifier.currentAnnouncement.title.toUpperCase()}',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                            ),),
                          Text('${announcementNotifier.currentAnnouncement.subtitle.toUpperCase()}',
                            style: TextStyle(
                            ),),
                          Divider(height: 40.0, thickness: 1.0),
                          Text('${announcementNotifier.currentAnnouncement.description.toUpperCase()}',
                            style: TextStyle(
                              color: Colors.black,
                            ),),
                          SizedBox(height: 5),
                        ],
                      ),
                    )
                  ],
                )
              ]
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'button2',
        onPressed: () {
          _deleteDialog();
        },

        child: const Icon(CupertinoIcons.delete, color: Colors.white),
        elevation: 0,
        backgroundColor: Colors.blue.withOpacity(0.7),
      ),
    );
  }
  void flushBar(BuildContext context){
    Flushbar(
      message: 'Data Successfully Deleted.',
      duration: Duration(seconds: 2),
      flushbarStyle: FlushbarStyle.FLOATING,
    )..show(context);
  }
}
