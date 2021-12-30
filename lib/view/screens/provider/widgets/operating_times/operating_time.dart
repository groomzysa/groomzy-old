import 'package:flutter/material.dart';
import 'package:groomzy/view/screens/provider/widgets/operating_times/delete_operating_time.dart';
import 'package:groomzy/view/screens/provider/widgets/operating_times/edit_operating_times.dart';


class OperatingTime extends StatelessWidget {
  final int dayTimeId;
  final String day;
  final String startTime;
  final String endTime;

  const OperatingTime({
    required this.dayTimeId,
    required this.day,
    required this.startTime,
    required this.endTime,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade50,
      elevation: 0.5,
      child: Column(
        children: [
          const Divider(height: 0.0,),
          Container(
            margin: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0,),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              subtitle: Table(
                children: [
                  const TableRow(children: [
                    TableCell(
                      child: Text(
                        'Day',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        'Start time',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        'End time',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                    ),
                  ]),
                  const TableRow(children: [
                    TableCell(
                      child: Divider(),
                    ),
                    TableCell(
                      child: Divider(),
                    ),
                    TableCell(
                      child: Divider(),
                    ),
                  ]),
                  TableRow(children: [
                    TableCell(
                      child: Text(
                        day,
                      ),
                    ),
                    TableCell(
                      child: Text(
                        startTime,
                      ),
                    ),
                    TableCell(
                      child: Text(
                        endTime,
                      ),
                    ),
                  ])
                ],
              ),
              trailing: Container(
                padding: const EdgeInsets.only(top: 10.0),
                width: 70.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: EditOperatingTime(
                                dayTimeId: dayTimeId,
                                day: day,
                                startTime: startTime,
                                endTime: endTime,
                              ),
                            );
                          },
                        );
                      },
                      child: const Icon(
                        Icons.edit_outlined,
                        color: Colors.amber,
                      ),
                    ),
                    const VerticalDivider(),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return DeleteOperatingTime(
                              dayTimeId: dayTimeId,
                            );
                          },
                        );
                      },
                      child: const Icon(
                        Icons.delete_forever_outlined,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10.0,)
        ],
      ),
    );
  }
}
