import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todolist_app/constants/colors.dart';
import 'package:todolist_app/models/task_model.dart';
import 'package:todolist_app/widgets/custom_app_bar.dart';

class TaskDetailPage extends StatefulWidget {
  final TaskModel taskModel;

  const TaskDetailPage({Key? key, required this.taskModel}) : super(key: key);

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final DateTime _focusedDay = DateTime.now();
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {

    // Định dạng cho việc phân tích chuỗi ngày tháng
    DateFormat dateFormat = DateFormat('M/d/yyyy');

    // Phân tích và chuyển đổi chuỗi ngày tháng thành đối tượng DateTime
    _rangeStart = dateFormat.parse(widget.taskModel.startDateTime);
    _rangeEnd = dateFormat.parse(widget.taskModel.stopDateTime);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Detail Task',
      ),
      body: Column(
        children: [
          TableCalendar(
            calendarFormat: _calendarFormat,
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2023, 1, 1),
            lastDay: DateTime.utc(2030, 1, 1),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
          ),
          Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Title: ',
                      style: TextStyle(
                          color: kBlackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      widget.taskModel.title,
                      style: const TextStyle(
                          color: kBlackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Text(
                      'Description: ',
                      style: TextStyle(
                          color: kBlackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      widget.taskModel.description,
                      style: const TextStyle(
                          color: kBlackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: kGrey3),
                        height: 45,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(Icons.calendar_month_rounded),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(
                                  '${widget.taskModel.startDateTime} -> ${widget.taskModel.stopDateTime}',
                                  style: const TextStyle(fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Hiển thị các thông tin khác về taskModel
        ],
      ),
    );
  }
}
