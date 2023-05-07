import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medimate/model/calendar_day_model.dart';
import 'package:medimate/model/database/repository.dart';
import 'package:medimate/model/pill.dart';
import 'package:medimate/model/services/notifications/notifications.dart';

class HomePageProvider extends ChangeNotifier {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final Notifications _notifications = Notifications();
  final Repository _repository = Repository();
  List<Pill> allListOfPills = [];
  List<Pill> dailyPills = [];
  List<CalendarDayModel> _daysList = [];
  int _lastChooseDay = 0;

  List<CalendarDayModel> get daysList => _daysList;

  void init() {
    initNotifies();
    setData();
    _daysList = CalendarDayModel().getCurrentDays();
  }

  Future initNotifies() async =>
      flutterLocalNotificationsPlugin = await _notifications.initNotif();

  Future setData() async {
    allListOfPills.clear();
    (await _repository.getAllData("Pills"))?.forEach(
      (pillMap) {
        allListOfPills.add(
          Pill().pillMapToObject(pillMap),
        );
      },
    );
    chooseDay(_daysList[_lastChooseDay]);
  }

  void chooseDay(CalendarDayModel clickedDay) {
    _lastChooseDay = _daysList.indexOf(clickedDay);
    _daysList.forEach((day) => day.isChecked = false);
    CalendarDayModel chooseDay = _daysList[_daysList.indexOf(clickedDay)];
    chooseDay.isChecked = true;
    dailyPills.clear();
    allListOfPills.forEach((pill) {
      DateTime pillDate =
          DateTime.fromMicrosecondsSinceEpoch(pill.time * (1000));
      if (chooseDay.dayNumber == pillDate.day &&
          chooseDay.month == pillDate.month &&
          chooseDay.year == pillDate.year) {
        dailyPills.add(pill);
      }
    });
    dailyPills.sort((pill1, pill2) => pill1.time.compareTo(pill2.time));
    notifyListeners();
  }
}
