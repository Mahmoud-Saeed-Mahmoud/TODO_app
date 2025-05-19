import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/models/task.dart';
import 'package:todo/ui/theme.dart';
import 'package:todo/ui/widgets/button.dart';
import 'package:todo/ui/widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime =
      DateFormat(
        'hh:mm a',
      ).format(DateTime.now().add(const Duration(minutes: 15))).toString();

  int _selectedReminder = 5;
  List<int> reminderList = [5, 10, 15, 20];

  String _selectedRepeat = 'None';
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];

  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.surface,
      appBar: _appBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('Add Task', style: headingStyle),
              InputField(
                controller: _titleController,
                title: 'title',
                hint: 'Enter Title Here',
              ),
              InputField(
                controller: _noteController,
                title: 'Note',
                hint: 'Enter Note Here',
              ),
              InputField(
                title: 'Date',
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  onPressed: () => _getDateFromUser(),
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: 'Start time',
                      hint: _startTime,
                      widget: IconButton(
                        onPressed: () => _getTimeFromUser(isStartTime: true),
                        icon: const Icon(
                          Icons.access_time_outlined,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InputField(
                      title: 'End time',
                      hint: _endTime,
                      widget: IconButton(
                        onPressed: () => _getTimeFromUser(isStartTime: false),
                        icon: const Icon(
                          Icons.access_time_outlined,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              InputField(
                title: 'Remind',
                hint: '$_selectedReminder minutes early',
                widget: DropdownButton<int>(
                  borderRadius: BorderRadius.circular(20),
                  dropdownColor: Colors.blueGrey,
                  items:
                      reminderList
                          .map(
                            (value) => DropdownMenuItem(
                              value: value,
                              child: Text(
                                '$value',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                          .toList(),
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  underline: Container(height: 0),
                  style: subTitleStyle,
                  onChanged: (newIndex) {
                    setState(() {
                      _selectedReminder = newIndex!;
                    });
                  },
                ),
              ),
              InputField(
                title: 'Repeat',
                hint: _selectedRepeat,
                widget: DropdownButton<String>(
                  borderRadius: BorderRadius.circular(20),
                  dropdownColor: Colors.blueGrey,
                  items:
                      repeatList
                          .map(
                            (value) => DropdownMenuItem(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                          .toList(),
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  underline: Container(height: 0),
                  style: subTitleStyle,
                  onChanged: (newIndex) {
                    setState(() {
                      _selectedRepeat = newIndex!;
                    });
                  },
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPalette(),
                  MyButton(label: 'Add Task', onTap: () => _validateData()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _addTasksToDb() async {
    int value = await _taskController.addTask(
      task: Task(
        title: _titleController.text,
        note: _noteController.text,
        isCompleted: 0,
        date: DateFormat.yMd().format(_selectedDate),
        startTime: _startTime,
        endTime: _endTime,
        color: _selectedColor,
        remind: _selectedReminder,
        repeat: _selectedRepeat,
      ),
    );
    debugPrint('$value');
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 24,
          color: primaryClr,
        ),
      ),
      backgroundColor: context.theme.colorScheme.surface,
      actions: const [
        CircleAvatar(
          backgroundImage: AssetImage('images/person.jpeg'),
          radius: 18,
        ),
        SizedBox(width: 20),
      ],
    );
  }

  Column _colorPalette() {
    return Column(
      children: [
        Text('Color', style: titleStyle),
        const SizedBox(height: 8),
        Wrap(
          direction: Axis.horizontal,
          children: List.generate(
            3,
            (index) => GestureDetector(
              onTap: () => setState(() => _selectedColor = index),
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor:
                      index == 0
                          ? primaryClr
                          : index == 1
                          ? pinkClr
                          : orangeClr,
                  child:
                      _selectedColor == index
                          ? const Icon(
                            Icons.done_rounded,
                            size: 16,
                            color: Colors.white,
                          )
                          : null,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2030),
    );
    setState(() {
      _selectedDate = pickedDate ?? _selectedDate;
    });
  }

  _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime:
          isStartTime
              ? TimeOfDay.fromDateTime(DateTime.now())
              : TimeOfDay.fromDateTime(
                DateTime.now().add(const Duration(minutes: 15)),
              ),
    );
    setState(() {
      try {
        isStartTime
            ? _startTime = pickedTime!.format(context)
            : _endTime = pickedTime!.format(context);
      } catch (e) {
        Get.snackbar(
          'warning',
          'You didn\'t pick time',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }
    });
  }

  _validateData() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTasksToDb();
      Get.back();
    } else {
      Get.snackbar(
        'required',
        'All fields are required!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: pinkClr,
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.red),
      );
    }
  }
}
