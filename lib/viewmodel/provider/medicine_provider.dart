import 'package:flutter/material.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:medimate/model/medicine_type.dart';

class MedicineProvider extends ChangeNotifier {
  DateTime setDate = DateTime.now();

  final List<String> weightValues = ["pills", "ml", "mg"];
  String selectWeight;

  MedicineProvider() {
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
}
