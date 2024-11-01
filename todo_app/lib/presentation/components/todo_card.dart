import 'package:flutter/material.dart';
import 'package:todo_app/blocs/todo/todo_bloc.dart';
import 'package:todo_app/blocs/todo/todo_event.dart';
import 'package:todo_app/presentation/screens/todo/details_todo_screen.dart';
import 'package:todo_app/app_colors.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/text_styles.dart';
import 'package:todo_app/utils.dart';

class TodoCard extends StatelessWidget {
  final Todo todo;
  final String filterOption;
  final TodoBloc todoBloc;
  const TodoCard(
      {super.key,
      required this.todo,
      required this.filterOption,
      required this.todoBloc});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor() {
      if (todo.deadline == null) {
        return AppColors.peach;
      }
      return AppColors.coral;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailTodoScreen(
              todoId: todo.id,
            ),
          ),
        ).then((_) {
          todoBloc.add(LoadTodos(filterOption));
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor(),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  todo.title,
                  style: AppTextStyles.headline5,
                ),
                if (todo.deadline != null)
                  IconButton(
                    icon: Image.asset(
                      'assets/clock.png',
                    ),
                    onPressed: () {},
                  ),
              ],
            ),
            // const SizedBox(height: 8),
            Text(
              todo.description,
              style: AppTextStyles.body1(Colors.white),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 30),
            Text(
              'Created at ${Utils().formatDate(todo.createdAt)}',
              style: AppTextStyles.small,
            ),
          ],
        ),
      ),
    );
  }
}
