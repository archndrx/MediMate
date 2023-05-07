import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:medimate/helpers/platform_text_button.dart';
import 'package:medimate/model/database/repository.dart';
import 'package:medimate/model/pill.dart';
import 'package:medimate/view/screen/add_new_medicine/form_fields.dart';
import 'package:medimate/view/screen/add_new_medicine/medicine_type_card.dart';
import 'package:medimate/model/services/notifications/notifications.dart';
import 'package:medimate/viewmodel/provider/medicine_provider.dart';
import 'package:provider/provider.dart';

import 'package:timezone/data/latest.dart' as tz;

class AddNewMedicine extends StatefulWidget {
  @override
  _AddNewMedicineState createState() => _AddNewMedicineState();
}

class _AddNewMedicineState extends State<AddNewMedicine> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  //-------------Pill object------------------
  int howManyWeeks = 1;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  //-------------- Database and notifications ------------------
  final Repository _repository = Repository();
  final Notifications _notifications = Notifications();

  //============================================================

  @override
  void initState() {
    super.initState();
    initNotifies();
  }

  //init notifications
  Future initNotifies() async =>
      flutterLocalNotificationsPlugin = await _notifications.initNotif();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MedicineProvider>(context);
    final deviceHeight = MediaQuery.of(context).size.height - 60.0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromRGBO(248, 248, 248, 1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
              left: 20.0, right: 20.0, top: 30.0, bottom: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: deviceHeight * 0.05,
                child: FittedBox(
                  child: InkWell(
                    child: Icon(Icons.arrow_back),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              SizedBox(
                height: deviceHeight * 0.01,
              ),
              Container(
                padding: EdgeInsets.only(left: 15.0),
                height: deviceHeight * 0.05,
                child: FittedBox(
                  child: Text(
                    "Add Pills",
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(
                height: deviceHeight * 0.03,
              ),
              Consumer<MedicineProvider>(
                builder: (context, medicProvider, child) => Container(
                  height: deviceHeight * 0.37,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: FormFields(
                        medicProvider.selectWeight,
                        (value) => medicProvider.setSelectedWeight(value),
                        nameController,
                        amountController),
                  ),
                ),
              ),
              Container(
                height: deviceHeight * 0.035,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: FittedBox(
                    child: Text(
                      "Medicine form",
                      style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: deviceHeight * 0.02,
              ),
              Container(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ...provider.medicineTypes
                        .map((type) => MedicineTypeCard(type))
                  ],
                ),
              ),
              SizedBox(
                height: deviceHeight * 0.03,
              ),
              Container(
                width: double.infinity,
                height: deviceHeight * 0.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        height: double.infinity,
                        child: PlatfromTextButton(
                          handler: () => provider.openTimePicker(context),
                          buttonChild: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                DateFormat.Hm().format(provider.setDate),
                                style: TextStyle(
                                    fontSize: 32.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(width: 5),
                              Icon(
                                Icons.access_time,
                                size: 30,
                                color: Theme.of(context).primaryColor,
                              )
                            ],
                          ),
                          color: Color.fromRGBO(7, 190, 200, 0.1),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Container(
                        height: double.infinity,
                        child: PlatfromTextButton(
                          handler: () => provider.openDatePicker(context),
                          buttonChild: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                DateFormat("dd.MM").format(provider.setDate),
                                style: TextStyle(
                                    fontSize: 32.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(width: 10),
                              Icon(
                                Icons.event,
                                size: 30,
                                color: Theme.of(context).primaryColor,
                              )
                            ],
                          ),
                          color: Color.fromRGBO(7, 190, 200, 0.1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Container(
                height: deviceHeight * 0.09,
                width: double.infinity,
                child: PlatfromTextButton(
                  handler: () async => savePill(),
                  color: Theme.of(context).primaryColor,
                  buttonChild: Text(
                    "Done",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 17.0),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //--------------------------------------SAVE PILL IN DATABASE---------------------------------------
  Future savePill() async {
    final provider = Provider.of<MedicineProvider>(context, listen: false);
    //check if medicine time is lower than actual time
    if (provider.setDate.millisecondsSinceEpoch <=
        DateTime.now().millisecondsSinceEpoch) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Check your medicine time and date"),
        ),
      );
    } else {
      //create pill object
      Pill pill = Pill(
          amount: amountController.text,
          medicineForm: provider
              .medicineTypes[provider.medicineTypes
                  .indexWhere((element) => element.isChoose == true)]
              .name,
          name: nameController.text,
          time: provider.setDate.millisecondsSinceEpoch,
          type: provider.selectWeight,
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
              provider.time,
              pill.notifyId,
              flutterLocalNotificationsPlugin);
          provider.setDate =
              provider.setDate.add(Duration(milliseconds: 604800000));
          pill.time = provider.setDate.millisecondsSinceEpoch;
          pill.notifyId = Random().nextInt(10000000);
        }
      }
      //---------------------------------------------------------------------------------------
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Saved"),
      ));
      Navigator.pop(context);
    }
  }
}
