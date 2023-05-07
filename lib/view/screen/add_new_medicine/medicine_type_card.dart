import 'package:flutter/material.dart';
import 'package:medimate/model/medicine_type.dart';
import 'package:medimate/viewmodel/provider/medicine_provider.dart';
import 'package:provider/provider.dart';

class MedicineTypeCard extends StatelessWidget {
  final MedicineType pillType;
  MedicineTypeCard(this.pillType);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MedicineProvider>(context);

    return Column(
      children: [
        InkWell(
          onTap: () => provider.medicineTypeClick(pillType),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: pillType.isChoose
                  ? Color.fromRGBO(7, 190, 200, 1)
                  : Color.fromARGB(255, 234, 233, 233),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 5.0,
                ),
                Container(width: 50, height: 50.0, child: pillType.image),
                SizedBox(
                  height: 7.0,
                ),
                Container(
                  child: Text(
                    pillType.name,
                    style: TextStyle(
                      color: pillType.isChoose ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
