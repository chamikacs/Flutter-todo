import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:todo_app/blocs/todo/todo_event.dart';
import 'package:todo_app/presentation/components/bottom_sheet.dart';
import 'package:todo_app/app_colors.dart';
import 'package:todo_app/blocs/todo/todo_bloc.dart';
import 'package:todo_app/blocs/todo/todo_state.dart';
import 'package:todo_app/text_styles.dart';
import 'package:todo_app/utils.dart';

class DetailTodoScreen extends StatelessWidget {
  final String? todoId;

  DetailTodoScreen({super.key, required this.todoId});

  final _controller = SuperTooltipController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TodoLoaded) {
            final todo = state.todos.any((t) => t.id == todoId)
                ? state.todos.firstWhere((t) => t.id == todoId)
                : null;

            if (todo == null) {
              return const Center(child: Text("Todo not found."));
            }

            Uint8List? imageBytes;
            if (todo.image != null && todo.image!.isNotEmpty) {
              imageBytes = base64Decode(todo.image!);
            }

            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: AppColors.white,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new,
                      color: AppColors.black),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  GestureDetector(
                    onTap: (todo.deadline != null)
                        ? () async {
                            await _controller.showTooltip();
                          }
                        : null, // Disable onTap if there's no deadline
                    child: Opacity(
                      opacity: todo.deadline != null ? 1.0 : 0.7,
                      child: todo.deadline != null
                          ? SuperTooltip(
                              hasShadow: false,
                              showBarrier: true,
                              barrierColor: Colors.transparent,
                              controller: _controller,
                              backgroundColor: AppColors.coral,
                              content: Text(
                                Utils().formatDate(todo.deadline),
                                softWrap: true,
                                style: AppTextStyles.headline6,
                              ),
                              child: Image.asset(
                                'assets/clock-d.png',
                                color: Colors.black,
                              ),
                            )
                          : Image.asset(
                              'assets/clock-d.png',
                              color: Colors.grey,
                            ),
                    ),
                  ),
                  const SizedBox(
                    width: 11,
                  ),
                  IconButton(
                    icon: Image.asset('assets/edit-2.png'),
                    onPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) => AddTodoBottomSheet(todo: todo),
                      );
                    },
                  ),
                  IconButton(
                    icon: Image.asset('assets/trash-2.png'),
                    onPressed: () => _showDeleteConfirmation(context, todo.id),
                  ),
                ],
              ),
              body: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                todo.title,
                                style: AppTextStyles.headline2(Colors.black),
                              ),
                              const SizedBox(height: 30),
                              Text(
                                todo.description,
                                style: AppTextStyles.body1(Colors.black),
                              ),
                              const SizedBox(height: 30),
                              if (todo.image != null && todo.image!.isNotEmpty)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16.0),
                                  child: Image.memory(
                                    imageBytes!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              const Spacer(),
                              const SizedBox(
                                height: 120,
                              ),
                              Center(
                                child: Text(
                                  'Created at ${Utils().formatDate(todo.createdAt)}',
                                  style: AppTextStyles.body2,
                                ),
                              ),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (state is TodoError) {
            return Center(child: Text(state.error));
          }
          return Container();
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String? todoId) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              if (todoId != null) {
                context.read<TodoBloc>().add(DeleteTodo(todoId));
                Navigator.pop(context);
                Navigator.pop(context);
              }
            },
            isDestructiveAction: true,
            child: const Text(
              'Delete TODO',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
