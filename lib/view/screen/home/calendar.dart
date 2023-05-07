import 'package:flutter/material.dart';
import 'package:medimate/model/calendar_day_model.dart';

class Calendar extends StatefulWidget {
  final Function chooseDay;
  final List<CalendarDayModel> _daysList;
  Calendar(this.chooseDay, this._daysList);
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return Container(
      height: deviceHeight * 0.11,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ...widget._daysList.map((day) {
            return LayoutBuilder(
              builder: (context, constrains) => Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    day.dayLetter,
                    style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 17.0,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: constrains.maxHeight * 0.1,
                  ),
                  GestureDetector(
                    onTap: () => widget.chooseDay(day),
                    child: CircleAvatar(
                      radius: constrains.maxHeight * 0.25,
                      backgroundColor: day.isChecked
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          day.dayNumber.toString(),
                          style: TextStyle(
                              color:
                                  day.isChecked ? Colors.white : Colors.black,
                              fontSize: 22.0,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
