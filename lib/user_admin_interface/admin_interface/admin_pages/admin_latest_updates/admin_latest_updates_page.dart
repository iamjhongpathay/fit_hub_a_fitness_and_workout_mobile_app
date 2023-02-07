import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_hub_mobile_application/api/api.dart';
import 'package:fit_hub_mobile_application/models/announcement.dart';
import 'package:fit_hub_mobile_application/notifiers/announcement_notifier.dart';
import 'package:fit_hub_mobile_application/user_admin_interface/admin_interface/admin_pages/admin_latest_updates/admin_announcement_delete_form.dart';
import 'package:fit_hub_mobile_application/user_admin_interface/admin_interface/admin_pages/admin_latest_updates/admin_announcement_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'admin_firebase_messaging.dart';
import 'admin_notification_form.dart';

class AdminLatestUpdatesPage extends StatefulWidget {
  AdminLatestUpdatesPage ({Key key}) : super(key: key);
  @override
  _AdminLatestUpdatesPageState createState() => _AdminLatestUpdatesPageState();
}

class _AdminLatestUpdatesPageState extends State<AdminLatestUpdatesPage> {
  String formatTimeStamp(Timestamp timestampe){
    var format = new DateFormat('(EEE)'' MMMM d, y'' - ''h:mm a' );
    return format.format(timestampe.toDate());
  }
  @override
  void initState(){
    AnnouncementNotifier announcementNotifier = Provider.of<AnnouncementNotifier>(context, listen: false);
    getAnnouncement(announcementNotifier);
    super.initState();
  }

  // final GlobalKey<ExpansionTileCardState> cardA = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    AnnouncementNotifier announcementNotifier = Provider.of<AnnouncementNotifier>(context);

    Future<void>_refreshList() async{
      await Future.delayed(Duration(seconds: 1));
      getAnnouncement(announcementNotifier);
    }
    _onAnnouncementDeleted(Announcement announcement){
      Navigator.pop(context);
      announcementNotifier.deleteAnnouncement(announcement);
      flushBar(context);
    }


    void _showSendNotificationPanel() {
      showModalBottomSheet(context: context, builder: (context){
        return Container(
          color: Color(0xFF737373),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(10),
                topRight: const Radius.circular(10),
              )
            ),
            child: AdminFirebaseMessaging(),
          ),
        );
      });
    }
    void _showAnnouncementPanel() {
      showModalBottomSheet(context: context, builder: (context){

        return Container(
          color: Color(0xFF737373),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                )
            ),
            child: AdminAnnouncementForm(isUpdating: false),
          ),
        );
      });
    }
    void _showAnnouncementEditPanel() {
      showModalBottomSheet(context: context,
          isScrollControlled: true,
          builder: (context){
        return Container(
          color: Color(0xFF737373),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.75,
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                )
            ),
            child: AdminAnnouncementForm(isUpdating: true),
          ),
        );
      });
    }
    void _showAnnouncementDeletePanel() {
      showModalBottomSheet(context: context,
          isScrollControlled: true,
          builder: (context){
            return Container(
              color: Color(0xFF737373),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.75,
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(10),
                      topRight: const Radius.circular(10),
                    )
                ),
                child: AdminAnnouncementDelete(),
              ),
            );
          });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Text('LATEST & UPDATES',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              fontSize: 25.0,
            ),
          ),
          centerTitle: true
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
        child: RefreshIndicator(
          onRefresh: _refreshList,
          color: Colors.black,
          strokeWidth: 3,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: announcementNotifier.announcementList.length,
            itemBuilder: (BuildContext context, int index){

              // DateTime createdAt = announcementNotifier.announcementList[index].createdAt?.toDate();
              return Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 5),
                child: Column(
                  children: [
                    ExpansionTileCard(
                      baseColor: Colors.grey[200],
                      expandedColor: Colors.grey[300],
                      leading: CircleAvatar(backgroundColor: Colors.black,child: Icon(Icons.announcement_sharp, color: Colors.white,)),
                      title: Text(announcementNotifier.announcementList[index].title,
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
                      ),
                      subtitle: Text(announcementNotifier.announcementList[index].subtitle,
                      style: TextStyle(color: Colors.black),
                      ),
                      children: <Widget>[
                        Divider(
                          thickness: 1.0,
                          height: 1.0,
                        ),
                        CachedNetworkImage(
                            imageUrl: announcementNotifier.announcementList[index].thumbnailUrl != null
                          ? announcementNotifier.announcementList[index].thumbnailUrl
                        :'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Container(
                                height: 100,
                                width: double.infinity,
                                color: Color(0x00000000),
                                child: Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                    )),
                              ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                            // loadingBuilder: (BuildContext context, Widget child,
                            //     ImageChunkEvent loadingProgress){
                            //   if(loadingProgress == null) return child;
                            //   return Container(
                            //     height: 115,
                            //     width: double.infinity,
                            //     color: Colors.grey[100],
                            //     child: Center(
                            //       child:  CircularProgressIndicator(
                            //         value: loadingProgress.expectedTotalBytes != null
                            //             ? loadingProgress.cumulativeBytesLoaded /
                            //             loadingProgress.expectedTotalBytes
                            //             : null,
                            //         valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                            //       ),
                            //     ),
                            //   );
                            // }
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                            padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                        ),
                              child: Text(announcementNotifier.announcementList[index].description,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(fontSize: 16),
                              ),
                            ),
                        ),
                        Divider(
                          thickness: 1.0,
                          height: 1.0,
                        ),
                        ButtonBar(
                          alignment: MainAxisAlignment.spaceAround,
                          buttonHeight: 30.0,
                          buttonMinWidth: 90.0,
                          children: <Widget>[
                            FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0)),
                              onPressed: () {
                                announcementNotifier.currentAnnouncement = announcementNotifier.announcementList[index];
                                _showAnnouncementEditPanel();
                              },
                              child: Column(
                                children: <Widget>[
                                  Icon(Icons.edit_outlined),

                                ],
                              ),
                            ),
                            FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0)),
                              onPressed: () {
                                announcementNotifier.currentAnnouncement = announcementNotifier.announcementList[index];
                                _showAnnouncementDeletePanel();
                              },
                              child: Column(
                                children: <Widget>[
                                  Icon(CupertinoIcons.delete),

                                ],
                              ),
                            ),
                          ],
                        )
                      ]
                    ),
                    SizedBox(height: 5),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(formatTimeStamp(announcementNotifier.announcementList[index].createdAt),
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      ),
                  ],
                ),
              );
            }

          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
      FloatingActionButton(
      heroTag: 'button1',
        onPressed: ()  => _showSendNotificationPanel(),

        child: const Icon(Icons.notifications_active_outlined, color: Colors.white),
        elevation: 0,
        backgroundColor: Colors.blue.withOpacity(0.7),
      ),
      SizedBox(height: 15),
      FloatingActionButton(
        heroTag: 'button2',
        onPressed: () {
          announcementNotifier.currentAnnouncement = null;
          _showAnnouncementPanel();
        },

        child: const Icon(CupertinoIcons.add, color: Colors.white),
        elevation: 0,
        backgroundColor: Colors.blue.withOpacity(0.7),
      ),
      ],
      ),
    );
  }
  void flushBar(BuildContext context){
    Flushbar(
      message: 'Coach / Instructor Data Successfully Deleted.',
      duration: Duration(seconds: 2),
      flushbarStyle: FlushbarStyle.FLOATING,
    )..show(context);
  }
}