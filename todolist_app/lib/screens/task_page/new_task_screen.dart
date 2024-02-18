import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todolist_app/blocs/tasks/tasks_bloc.dart';
import 'package:todolist_app/constants/colors.dart';
import 'package:todolist_app/constants/font.dart';
import 'package:todolist_app/local_notification.dart';
import 'package:todolist_app/models/task_model.dart';
import 'package:todolist_app/notification.dart';
import 'package:todolist_app/utils/util.dart';
import 'package:todolist_app/widgets/build_text_field.dart';
import 'package:todolist_app/widgets/custom_app_bar.dart';
import 'package:todolist_app/widgets/widgets.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  String? startDateTime;
  String? stopDateTime;
  DateTime now = DateTime.now();
  late String currentTime;

  @override
  void initState() {
    currentTime = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
    initNotifications();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String formatDateTimeString(String inputString) {
    DateTime dateTime = DateTime.parse(inputString);
    String formattedDateTime = DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
    return formattedDateTime;
  }

  DateTime parseDateTime(String dateTimeString) {
    // Loại bỏ bất kỳ ký tự khoảng trắng không nhìn thấy nào từ cuối chuỗi
    String sanitizedDateTimeString = dateTimeString.trim();
    // Loại bỏ khoảng trắng sau số phút trước chuỗi "PM" nếu có
    sanitizedDateTimeString = sanitizedDateTimeString.replaceAll(
        " ", " "); // Loại bỏ khoảng trắng không nhìn thấy
    // Phân tích chuỗi ngày tháng và trả về đối tượng DateTime
    return DateFormat("M/d/yyyy h:mm a").parse(sanitizedDateTimeString);
  }

  showDateTimePicker(Function(String)? onDateTimeSelected) async {
    DateTime? pickedDate = await showOmniDateTimePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1600).subtract(const Duration(days: 3652)),
      lastDate: DateTime.now().add(
        const Duration(days: 3652),
      ),
      is24HourMode: false,
      isShowSeconds: false,
      minutesInterval: 1,
      secondsInterval: 1,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      constraints: const BoxConstraints(
        maxWidth: 350,
        maxHeight: 650,
      ),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1.drive(
            Tween(
              begin: 0,
              end: 1,
            ),
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      selectableDayPredicate: (dateTime) {
        // Disable 25th Feb 2023
        if (dateTime == DateTime(2023, 2, 25)) {
          return false;
        } else {
          return true;
        }
      },
    );

    if (pickedDate != null && onDateTimeSelected != null) {
      String formattedDateTime = DateFormat.yMd().add_jm().format(pickedDate);
      onDateTimeSelected(formattedDateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: kWhiteColor,
        appBar: const CustomAppBar(
          title: 'Create New Task',
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: BlocConsumer<TasksBloc, TasksState>(
              listener: (context, state) {
                if (state is AddTaskFailure) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(getSnackBar(state.error, kRed));
                }
                if (state is AddTasksSuccess) {
                  Navigator.pop(context);
                }
              },
              builder: (BuildContext context, TasksState state) {
                return ListView(
                  children: [
                    buildText('Title', kBlackColor, 14, FontWeight.bold,
                        TextAlign.start, TextOverflow.clip),
                    const SizedBox(
                      height: 10,
                    ),
                    BuildTextField(
                        hint: "Task Title",
                        controller: title,
                        inputType: TextInputType.text,
                        fillColor: kWhiteColor,
                        onChange: (value) {}),
                    const SizedBox(
                      height: 20,
                    ),
                    buildText('Description', kBlackColor, textMedium,
                        FontWeight.bold, TextAlign.start, TextOverflow.clip),
                    const SizedBox(
                      height: 10,
                    ),
                    BuildTextField(
                        hint: "Task Description",
                        controller: description,
                        inputType: TextInputType.multiline,
                        fillColor: kWhiteColor,
                        onChange: (value) {}),
                    const SizedBox(height: 20),
                    buildText('Start Time', kBlackColor, 14, FontWeight.bold,
                        TextAlign.start, TextOverflow.clip),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        showDateTimePicker((String? formattedDateTime) {
                          if (formattedDateTime != null) {
                            setState(() {
                              startDateTime = formattedDateTime;
                            });
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(width: 1, color: kGrey1),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                startDateTime != null &&
                                        startDateTime!.isNotEmpty
                                    ? startDateTime!
                                    : "Select Date",
                                style: TextStyle(
                                  color: startDateTime != null &&
                                          startDateTime!.isNotEmpty
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.calendar_month_rounded),
                              onPressed: () async {
                                showDateTimePicker((String? formattedDateTime) {
                                  if (formattedDateTime != null) {
                                    setState(() {
                                      startDateTime = formattedDateTime;
                                    });
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    buildText('End Time', kBlackColor, 14, FontWeight.bold,
                        TextAlign.start, TextOverflow.clip),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        showDateTimePicker((String? formattedDateTime) {
                          if (formattedDateTime != null) {
                            setState(() {
                              stopDateTime = formattedDateTime;
                            });
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(width: 1, color: kGrey1),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                stopDateTime != null && stopDateTime!.isNotEmpty
                                    ? stopDateTime!
                                    : "Select Date",
                                style: TextStyle(
                                  color: stopDateTime != null &&
                                          stopDateTime!.isNotEmpty
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.calendar_month_rounded),
                              onPressed: () async {
                                showDateTimePicker((String? formattedDateTime) {
                                  if (formattedDateTime != null) {
                                    setState(() {
                                      stopDateTime = formattedDateTime;
                                    });
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        kWhiteColor),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10), // Adjust the radius as needed
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: buildText(
                                    'Cancel',
                                    kBlackColor,
                                    textMedium,
                                    FontWeight.w600,
                                    TextAlign.center,
                                    TextOverflow.clip),
                              )),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: ElevatedButton(
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        kPrimaryColor),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10), // Adjust the radius as needed
                                  ),
                                ),
                              ),
                              onPressed: () {
                                final String taskId = DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString();
                                var taskModel = TaskModel(
                                    id: taskId,
                                    title: title.text,
                                    description: description.text,
                                    startDateTime: startDateTime ?? '',
                                    stopDateTime: stopDateTime ?? '');
                                context
                                    .read<TasksBloc>()
                                    .add(AddNewTaskEvent(taskModel: taskModel));
                                // formatDateTimeString(startDateTime!);
                                DateTime startTime =
                                    parseDateTime(startDateTime!);
                                debugPrint(
                                    'Notification Scheduled for $startTime');
                                NotificationService().scheduleNotification(
                                    title: 'Scheduled Notification',
                                    body: '$startTime',
                                    scheduledNotificationDateTime: startTime);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: buildText(
                                    'Save',
                                    kWhiteColor,
                                    textMedium,
                                    FontWeight.w600,
                                    TextAlign.center,
                                    TextOverflow.clip),
                              )),
                        ),
                      ],
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
