
import 'dart:collection';

import 'package:fit_hub_mobile_application/models/announcement.dart';
import 'package:flutter/cupertino.dart';

class AnnouncementNotifier with ChangeNotifier{
  List<Announcement>_announcementList = [];
  Announcement _currentAnnouncement;

  UnmodifiableListView<Announcement> get announcementList => UnmodifiableListView(_announcementList);

  Announcement get currentAnnouncement => _currentAnnouncement;

  set announcementList(List<Announcement> announcementList){
    _announcementList = announcementList;
    notifyListeners();
  }
  set currentAnnouncement(Announcement announcement){
    _currentAnnouncement = announcement;
    notifyListeners();
  }
  addAnnouncement (Announcement announcement){
    _announcementList.insert(0, announcement);
    notifyListeners();
  }
  deleteAnnouncement(Announcement announcement){
    _announcementList.removeWhere((_announcement) => _announcement.id == announcement.id);
    notifyListeners();
  }
}