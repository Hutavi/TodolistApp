import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:todolist_app/blocs/tasks/tasks_bloc.dart';
import 'package:todolist_app/constants/colors.dart';
import 'package:todolist_app/models/task_model.dart';
import 'package:todolist_app/screens/detail_task_page/detail_task_page.dart';

class TaskItemView extends StatefulWidget {
  final TaskModel taskModel;
  const TaskItemView({Key? key, required this.taskModel}) : super(key: key);

  @override
  State<TaskItemView> createState() => _TaskItemViewState();
}

class _TaskItemViewState extends State<TaskItemView> {
  bool isUndoing = false;
  String formatDateTimeString(String inputString) {
    DateTime dateTime = DateTime.parse(inputString);
    String formattedDateTime = DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
    return formattedDateTime;
  }

  void _onTaskItemPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailPage(taskModel: widget.taskModel),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _onTaskItemPressed(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: COLOR_BG_ITEM_TASK,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1), // Màu của shadow
              spreadRadius: 1, // Bán kính của shadow
              blurRadius: 0, // Độ mờ của shadow
              offset: const Offset(2, 2), // Độ dịch chuyển của shadow
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: widget.taskModel.completed,
                  onChanged: (value) {
                    setState(() {
                      widget.taskModel.completed = value!;
                    });
                    if (value!) {
                      // Thiết lập biến isUndoing thành true
                      isUndoing = true;

                      // Hiển thị SnackBar để cho phép undo trong 2 giây
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                              'Task marked as completed, the task will be deleted after 2s'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {
                              setState(() {
                                // Đặt lại biến isUndoing thành false khi nhấn Undo
                                isUndoing = false;
                                // Đảo ngược trạng thái đã xong của task
                                widget.taskModel.completed = false;
                              });
                            },
                          ),
                          duration: const Duration(
                              seconds: 2), // Thời gian hiển thị của SnackBar
                        ),
                      );

                      // Đợi 2 giây, sau đó kiểm tra xem có thực hiện xóa không
                      Future.delayed(const Duration(seconds: 2), () {
                        if (isUndoing) {
                          // Nếu người dùng không thực hiện Undo, thực hiện thực sự xóa task
                          context.read<TasksBloc>().add(
                              DeleteTaskEvent(taskModel: widget.taskModel));
                        }
                      });
                    }
                  },
                ),
              ],
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.taskModel.title,
                    style: const TextStyle(
                        color: COLOR_TEXT_MAIN,
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    widget.taskModel.description,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: const TextStyle(
                      color: COLOR_PLACE_HOLDER,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      decoration: BoxDecoration(
                          color: kPrimaryColor.withOpacity(.1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5))),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'lib/assets/svgs/calender.svg',
                            width: 12,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Text(
                              '${widget.taskModel.startDateTime} - ${widget.taskModel.stopDateTime}',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 11),
                            ),
                          )
                        ],
                      )),
                ],
              ),
            ),
            const SizedBox(
              width: 5,
            )
          ],
        ),
      ),
    );
  }
}
