import 'package:flutter/material.dart';
import 'package:todolist_app/constants/colors.dart';
import 'package:todolist_app/widgets/widgets.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Function? onBackTap;
  final bool showBackArrow;
  final Color? backgroundColor;
  final List<Widget>? actionWidgets;

  const CustomAppBar(
      {super.key,
      required this.title,
      this.onBackTap,
      this.showBackArrow = true,
      this.backgroundColor = kWhiteColor,
      this.actionWidgets});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      automaticallyImplyLeading: true,
      elevation: 0,
      actions: actionWidgets,
      title: Row(
        children: [
          buildText(title, kBlackColor, 16, FontWeight.w500, TextAlign.start,
              TextOverflow.clip),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
