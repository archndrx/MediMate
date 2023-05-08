import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medimate/helpers/platform_elevated_button.dart';
import 'package:medimate/view/screen/add_new_medicine/form_fields.dart';
import 'package:medimate/view/screen/add_new_medicine/medicine_type_card.dart';
import 'package:medimate/viewmodel/provider/medicine_provider.dart';
import 'package:provider/provider.dart';

class AddNewMedicine extends StatefulWidget {
  @override
  _AddNewMedicineState createState() => _AddNewMedicineState();
}

class _AddNewMedicineState extends State<AddNewMedicine> {
  @override
  void initState() {
    super.initState();
    Provider.of<MedicineProvider>(context, listen: false).init();
  }

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
                      provider.amountController.clear();
                      provider.nameController.clear();
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
                        medicProvider.selectType,
                        (value) => medicProvider.setSelectedType(value),
                        medicProvider.nameController,
                        medicProvider.amountController),
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
                    ...provider.medicineForms
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
                        child: PlatformElevatedButton(
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
                        child: PlatformElevatedButton(
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
                child: PlatformElevatedButton(
                  handler: () async =>
                      Provider.of<MedicineProvider>(context, listen: false)
                          .savePill(context),
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
}
