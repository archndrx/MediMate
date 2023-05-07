import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medimate/model/database/repository.dart';
import 'package:medimate/model/pill.dart';
import 'package:medimate/model/medicine_type.dart';
import 'package:medimate/model/services/notifications/notifications.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class MedicineProvider extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final Notifications _notifications = Notifications();
  Future initNotifies() async =>
      flutterLocalNotificationsPlugin = await _notifications.initNotif();

  final Repository _repository = Repository();

  int howManyWeeks = 1;
  DateTime setDate = DateTime.now();

  final List<String> weightValues = ["pills", "ml", "mg"];
  String selectWeight;

  void init() {
    initNotifies();
    selectWeight = weightValues[0];
  }

  final List<MedicineType> _medicineTypes = [
    MedicineType("Syrup", Image.asset("assets/images/syrup.png"), true),
    MedicineType("Pill", Image.asset("assets/images/pills.png"), false),
    MedicineType("Capsule", Image.asset("assets/images/capsule.png"), false),
  ];

  List<MedicineType> get medicineTypes => _medicineTypes;
  int get time =>
      setDate.millisecondsSinceEpoch -
      tz.TZDateTime.now(tz.local).millisecondsSinceEpoch;

  Future<void> openTimePicker(BuildContext context) async {
    await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
            helpText: "Choose Time")
        .then((value) {
      DateTime newDate = DateTime(
          setDate.year,
          setDate.month,
          setDate.day,
          value != null ? value.hour : setDate.hour,
          value != null ? value.minute : setDate.minute);
      setDate = newDate;
      print(newDate.hour);
      print(newDate.minute);
      notifyListeners();
    });
  }

  Future<void> openDatePicker(BuildContext context) async {
    await showDatePicker(
            context: context,
            initialDate: setDate,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(Duration(days: 100000)))
        .then((value) {
      DateTime newDate = DateTime(
          value != null ? value.year : setDate.year,
          value != null ? value.month : setDate.month,
          value != null ? value.day : setDate.day,
          setDate.hour,
          setDate.minute);
      setDate = newDate;
      print(setDate.day);
      print(setDate.month);
      print(setDate.year);
      notifyListeners();
    });
  }

  void medicineTypeClick(MedicineType medicine) {
    medicineTypes.forEach((medicineType) => medicineType.isChoose = false);
    medicineTypes[medicineTypes.indexOf(medicine)].isChoose = true;
    notifyListeners();
  }

  void setSelectedWeight(String value) {
    selectWeight = value;
    notifyListeners();
  }

  Future savePill(BuildContext context) async {
    //check if medicine time is lower than actual time
    if (setDate.millisecondsSinceEpoch <=
        DateTime.now().millisecondsSinceEpoch) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Check your medicine time and date"),
        ),
      );
    }
    if (amountController.text.isEmpty || nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Form Field can't be empty"),
        ),
      );
      return;
    } else {
      //create pill object
      Pill pill = Pill(
          amount: amountController.text,
          medicineForm: medicineTypes[medicineTypes
                  .indexWhere((element) => element.isChoose == true)]
              .name,
          name: nameController.text,
          time: setDate.millisecondsSinceEpoch,
          type: selectWeight,
          notifyId: Random().nextInt(10000000));

      //---------------------| Save as many medicines as many user checks |----------------------
      for (int i = 0; i < howManyWeeks; i++) {
        dynamic result = await _repository.insertData(pill.pillToMap());
        if (result == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Something went wrong"),
            ),
          );
          return;
        } else {
          //set the notification schneudele
          tz.initializeTimeZones();
          await _notifications.showNotification(
              pill.name,
              pill.amount + " " + pill.type + " " + pill.medicineForm,
              time,
              pill.notifyId,
              flutterLocalNotificationsPlugin);
          setDate = setDate.add(Duration(milliseconds: 604800000));
          pill.time = setDate.millisecondsSinceEpoch;
          pill.notifyId = Random().nextInt(10000000);
        }
      }
      //---------------------------------------------------------------------------------------
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Saved"),
        ),
      );
      Navigator.pop(context);
    }
    nameController.clear();
    amountController.clear();
    notifyListeners();
  }
}
