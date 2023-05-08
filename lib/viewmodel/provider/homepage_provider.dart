import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medimate/model/calendar_day_model.dart';
import 'package:medimate/model/database/repository.dart';
import 'package:medimate/model/pill.dart';
import 'package:medimate/model/services/notifications/notifications.dart';

class HomePageProvider extends ChangeNotifier {
  // notifications
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final Notifications _notifications = Notifications();
  Future initNotifies() async =>
      flutterLocalNotificationsPlugin = await _notifications.initNotif();

  // list pill from database
  final Repository _repository = Repository();
  List<Pill> allListOfPills = [];
  List<Pill> dailyPills = [];

  // calendar days
  List<CalendarDayModel> _daysList = [];
  int _lastChooseDay = 0;

// getter
  List<CalendarDayModel> get daysList => _daysList;

  void init() {
    initNotifies();
    setData();
    _daysList = CalendarDayModel().getCurrentDays();
  }

//--------------------GET DATA FROM DATABASE---------------------
  Future setData() async {
    allListOfPills.clear();
    (await _repository.getAllData("Pills")).forEach(
      (pillMap) {
        allListOfPills.add(
          Pill().pillMapToObject(pillMap),
        );
      },
    );
  }

  //-------------------------| Click on calendar day |-------------------------
  void chooseDay(CalendarDayModel clickedDay) {
    _lastChooseDay = _daysList.indexOf(clickedDay);
    _daysList.forEach((day) => day.isChecked = false);
    CalendarDayModel dayChoosed = _daysList[_lastChooseDay];
    dayChoosed.isChecked = true;
    dailyPills.clear();
    allListOfPills.forEach((pill) {
      DateTime pillDate = DateTime.fromMillisecondsSinceEpoch(pill.time);
      if (dayChoosed.dayNumber == pillDate.day &&
          dayChoosed.month == pillDate.month &&
          dayChoosed.year == pillDate.year) {
        dailyPills.add(pill);
      }
    });
    dailyPills.sort((pill1, pill2) => pill1.time.compareTo(pill2.time));
    notifyListeners();
  }
}
