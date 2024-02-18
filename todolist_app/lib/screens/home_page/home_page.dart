// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist_app/blocs/tasks/tasks_bloc.dart';
import 'package:todolist_app/constants/colors.dart';
import 'package:todolist_app/constants/font.dart';
import 'package:todolist_app/screens/task_page/new_task_screen.dart';
import 'package:todolist_app/utils/util.dart';
import 'package:todolist_app/widgets/build_text_field.dart';
import 'package:todolist_app/widgets/custom_app_bar.dart';
import 'package:todolist_app/widgets/item_task.dart';
import 'package:todolist_app/widgets/widgets.dart';

class HomePage extends StatefulWidget {
  final int initialTab;
  const HomePage({
    Key? key,
    required this.initialTab,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    context.read<TasksBloc>().add(FetchTaskEvent());
    super.initState();
  }

  void clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  void printAllSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Set<String> keys = prefs.getKeys();
    for (String key in keys) {
      print("$key: ${prefs.get(key)}");
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: ScaffoldMessenger(
        child: Scaffold(
          backgroundColor: kWhiteColor,
          appBar: CustomAppBar(
            title: "Hi Vinh",
            showBackArrow: false,
            actionWidgets: [
              PopupMenuButton<int>(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 1,
                onSelected: (value) {
                  switch (value) {
                    case 0:
                      {
                        context
                            .read<TasksBloc>()
                            .add(SortTaskEvent(sortOption: 0));
                        break;
                      }
                    case 1:
                      {
                        context
                            .read<TasksBloc>()
                            .add(SortTaskEvent(sortOption: 1));
                        break;
                      }
                    case 2:
                      {
                        context
                            .read<TasksBloc>()
                            .add(SortTaskEvent(sortOption: 2));
                        break;
                      }
                    case 3:
                      {
                        context
                            .read<TasksBloc>()
                            .add(SortTaskEvent(sortOption: 3));
                        break;
                      }
                    case 4:
                      {
                        context
                            .read<TasksBloc>()
                            .add(SortTaskEvent(sortOption: 4));
                        break;
                      }
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<int>(
                      value: 3,
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'lib/assets/svgs/today.svg',
                            width: 15,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          buildText(
                              'Today',
                              kBlackColor,
                              textSmall,
                              FontWeight.normal,
                              TextAlign.start,
                              TextOverflow.clip)
                        ],
                      ),
                    ),
                    PopupMenuItem<int>(
                      value: 4,
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'lib/assets/svgs/all_tasks.svg',
                            width: 15,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          buildText(
                              'All Tasks',
                              kBlackColor,
                              textSmall,
                              FontWeight.normal,
                              TextAlign.start,
                              TextOverflow.clip)
                        ],
                      ),
                    ),
                    PopupMenuItem<int>(
                      value: 0,
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'lib/assets/svgs/calender.svg',
                            width: 15,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          buildText(
                              'Sort by date',
                              kBlackColor,
                              textSmall,
                              FontWeight.normal,
                              TextAlign.start,
                              TextOverflow.clip)
                        ],
                      ),
                    ),
                    PopupMenuItem<int>(
                      value: 1,
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'lib/assets/svgs/task_checked.svg',
                            width: 15,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          buildText(
                              'Completed tasks',
                              kBlackColor,
                              textSmall,
                              FontWeight.normal,
                              TextAlign.start,
                              TextOverflow.clip)
                        ],
                      ),
                    ),
                    PopupMenuItem<int>(
                      value: 2,
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'lib/assets/svgs/task.svg',
                            width: 15,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          buildText(
                              'Pending tasks',
                              kBlackColor,
                              textSmall,
                              FontWeight.normal,
                              TextAlign.start,
                              TextOverflow.clip)
                        ],
                      ),
                    ),
                  ];
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: SvgPicture.asset('lib/assets/svgs/filter.svg'),
                ),
              )
            ],
          ),
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => FocusScope.of(context).unfocus(),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: BlocConsumer<TasksBloc, TasksState>(
                listener: (context, state) {
                  if (state is LoadTaskFailure) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(getSnackBar(state.error, kRed));
                  }

                  if (state is AddTaskFailure || state is UpdateTaskFailure) {
                    context.read<TasksBloc>().add(FetchTaskEvent());
                  }
                },
                builder: (context, state) {
                  if (state is TasksLoading) {
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }
                  if (state is LoadTaskFailure) {
                    return Center(
                      child: buildText(
                          state.error,
                          kBlackColor,
                          textMedium,
                          FontWeight.normal,
                          TextAlign.center,
                          TextOverflow.clip),
                    );
                  }

                  if (state is FetchTasksSuccess) {
                    return state.tasks.isNotEmpty || state.isSearching
                        ? Column(
                            children: [
                              BuildTextField(
                                  hint: "Search recent task",
                                  controller: searchController,
                                  inputType: TextInputType.text,
                                  prefixIcon: const Icon(
                                    Icons.search,
                                    color: kGrey2,
                                  ),
                                  fillColor: kWhiteColor,
                                  onChange: (value) {
                                    context
                                        .read<TasksBloc>()
                                        .add(SearchTaskEvent(keywords: value));
                                  }),
                              const SizedBox(
                                height: 20,
                              ),
                              Expanded(
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: state.tasks.length,
                                  itemBuilder: (context, index) {
                                    return TaskItemView(
                                        taskModel: state.tasks[index]);
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return const Divider(
                                      color: kGrey3,
                                    );
                                  },
                                ),
                              ),
                            ],
                          )
                        : Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'lib/assets/svgs/tasks.svg',
                                  height: size.height * .20,
                                  width: size.width,
                                ),
                                const SizedBox(
                                  height: 50,
                                ),
                                buildText(
                                    'Schedule your tasks',
                                    kBlackColor,
                                    textBold,
                                    FontWeight.w600,
                                    TextAlign.center,
                                    TextOverflow.clip),
                                buildText(
                                    'Manage your task schedule easily\nand efficiently',
                                    kBlackColor.withOpacity(.5),
                                    textSmall,
                                    FontWeight.normal,
                                    TextAlign.center,
                                    TextOverflow.clip),
                              ],
                            ),
                          );
                  }
                  return Container();
                },
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
              child: const Icon(
                Icons.add_circle,
                color: kPrimaryColor,
              ),
              onPressed: () {
                // clearSharedPreferences();
                // printAllSharedPreferences();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NewTaskScreen()),
                );
              }),
        ),
      ),
    );
  }
}
