import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_app/app_colors.dart';
import 'package:todo_app/blocs/todo/todo_bloc.dart';
import 'package:todo_app/blocs/todo/todo_event.dart';
import 'package:todo_app/models/todo.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:todo_app/text_styles.dart';

class AddTodoBottomSheet extends StatefulWidget {
  final Todo? todo;
  const AddTodoBottomSheet({super.key, this.todo});

  @override
  State<AddTodoBottomSheet> createState() => _AddTodoBottomSheetState();
}

class _AddTodoBottomSheetState extends State<AddTodoBottomSheet> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? selectedDate;
  File? _selectedImage;
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      titleController.text = widget.todo!.title;
      descriptionController.text = widget.todo!.description;
      selectedDate = widget.todo!.deadline;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate =
            DateTime.utc(pickedDate.year, pickedDate.month, pickedDate.day);
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error picking image: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: AppColors.peach,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'Title',
                  hintStyle: AppTextStyles.body1(Colors.white),
                  filled: true,
                  fillColor: const Color(0xFFEAB6A2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter Todo name";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                maxLines: 8,
                decoration: InputDecoration(
                  hintText: 'Description',
                  hintStyle: AppTextStyles.body1(Colors.white),
                  filled: true,
                  fillColor: const Color(0xFFEAB6A2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter Todo description";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: selectedDate == null
                          ? 'Deadline (Optional)'
                          : 'Deadline: ${DateFormat("dd MMMM yyyy").format(selectedDate!)}',
                      labelStyle: AppTextStyles.body1(Colors.white),
                      filled: true,
                      fillColor: const Color(0xFFEAB6A2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon:
                          const Icon(Icons.calendar_today, color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickImageFromGallery,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAB6A2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.image, color: Colors.white),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _selectedImage == null && widget.todo == null
                              ? 'Add Image (Optional)'
                              : _selectedImage != null && widget.todo == null
                                  ? 'Image Selected' // Only image is selected
                                  : widget.todo != null &&
                                          _selectedImage == null
                                      ? 'Update Image' // Todo is not null
                                      : 'Image Updated', // Both are not null
                          style: AppTextStyles.body1(Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    final newTodo = Todo(
                      id: widget.todo?.id,
                      title: titleController.text,
                      description: descriptionController.text,
                      deadline: selectedDate,
                    );

                    if (widget.todo == null) {
                      context
                          .read<TodoBloc>()
                          .add(AddTodo(newTodo, imageFile: _selectedImage));
                    } else {
                      context.read<TodoBloc>().add(EditTodoRequested(newTodo,
                          imageFile: _selectedImage));
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  widget.todo == null ? 'ADD TODO' : 'EDIT TODO',
                  style: AppTextStyles.button(AppColors.peach),
                ),
              ),
              const SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
