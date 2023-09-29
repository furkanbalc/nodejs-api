import 'dart:convert';

import 'package:demo_todo_app/service/config.dart';
import 'package:demo_todo_app/product/constants/app_color_constants.dart';
import 'package:demo_todo_app/product/constants/app_languages_constants.dart';
import 'package:demo_todo_app/product/constants/app_padding_constants.dart';
import 'package:demo_todo_app/widgets/centered_shimmer.dart';
import 'package:demo_todo_app/widgets/custom_appbar.dart';
import 'package:demo_todo_app/widgets/custom_title_column.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    getTodoList();
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priorityController = TextEditingController();

  List? todos;

  void addTodo() async {
    var regBody = {
      "title": _titleController.text,
      "desc": _descController.text,
      "priority": int.parse(_priorityController.text),
    };
    try {
      final response = await http.post(
        Uri.parse(createTodo),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(regBody),
      );

      if (response.statusCode == 201) {
        setState(() {
          _titleController.clear();
          _descController.clear();
          _priorityController.clear();
          getTodoList();
        });
      } else {
        debugPrint('ToDo eklenemedi');
      }
    } catch (e) {
      debugPrint('ToDo eklenirken hata oluştu: $e');
    }
  }

  void getTodoList() async {
    try {
      final response = await http.get(
        Uri.parse(getTodos),
        headers: {"Content-Type": "application/json"},
      );
      var jsonResponse = jsonDecode(response.body);
      todos = jsonResponse;
      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void deleteItem(id) async {
    try {
      final response = await http.delete(
        Uri.parse("$deleteTodo/$id"),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        getTodoList();
      } else {
        debugPrint("Silme işlemi başarısız");
      }
    } catch (e) {
      debugPrint("Silme işlemi sırasında hata oluştu: $e");
    }
  }

  void updateItem(id, String title, String desc, int priority) async {
    final response = await http.put(
      Uri.parse('$updateTodo/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{"title": title, "desc": desc, "priority": priority}),
    );

    if (response.statusCode == 200) {
      setState(() {
        _titleController.clear();
        _descController.clear();
        _priorityController.clear();
        getTodoList();
      });
    } else {
      throw Exception('Todo güncellenirken hata oluştu.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      // klavye açılınca ekran yukarı kaymasın
      resizeToAvoidBottomInset: false,
      appBar: customAppBar(context),
      body: Padding(
        padding: AppPaddingConstants.allPadding2x,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  customTitleColumn(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text('Todo : ${todos?.length ?? 0}'),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 8,
              child: todos == null
                  ? const CenteredShimmer()
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            padding: AppPaddingConstants.symmetricPadding,
                            itemCount: todos!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: AppPaddingConstants.bottom10Padding,
                                child: Slidable(
                                  key: const ValueKey(0),
                                  endActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        backgroundColor: const Color(0xFFFE4A49),
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete,
                                        label: 'Delete',
                                        onPressed: (BuildContext context) {
                                          deleteItem('${todos![index]['_id']}');
                                        },
                                      ),
                                    ],
                                  ),
                                  child: InkWell(
                                    onLongPress: () {
                                      _updateTodoDialog(
                                        context,
                                        id: todos![index]['_id'],
                                        title: todos![index]['title'],
                                        desc: todos![index]['desc'],
                                        priority: todos![index]['priority'],
                                      );
                                    },
                                    child: Card(
                                      elevation: 5,
                                      child: ListTile(
                                        leading: const Icon(
                                          Icons.task,
                                          size: 24,
                                        ),
                                        title: Text('${todos![index]['title']}'),
                                        subtitle: Text('${todos![index]['desc']}'),
                                        trailing: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.arrow_back_ios),
                                            Icon(Icons.delete),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayTextInputDialog(context),
        tooltip: AppLanguagesConstants.appAddItem,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add - Todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: AppLanguagesConstants.labelTitle,
                  hintStyle: TextStyle(
                    color: AppColorConstants.textColor,
                  ),
                  border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                minLines: 1,
                maxLines: 2,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                controller: _descController,
                decoration: InputDecoration(
                  labelText: AppLanguagesConstants.labelDesc,
                  hintStyle: TextStyle(
                    color: AppColorConstants.textColor,
                  ),
                  border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                controller: _priorityController,
                decoration: InputDecoration(
                  labelText: AppLanguagesConstants.labelPriority,
                  hintStyle: TextStyle(
                    color: AppColorConstants.textColor,
                  ),
                  border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_titleController.text.isNotEmpty &&
                      _descController.text.isNotEmpty &&
                      _priorityController.text.isNotEmpty) {
                    addTodo();
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.red,
                        content: Text('Error! Cannot be passed empty'),
                      ),
                    );
                  }
                },
                child: const Text(AppLanguagesConstants.appAddItem),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _updateTodoDialog(
    BuildContext context, {
    required String id,
    required String title,
    required String desc,
    required int priority,
  }) async {
    _titleController.text = title;
    _descController.text = desc;
    _priorityController.text = priority.toString();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update - Todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: AppLanguagesConstants.labelTitle,
                  hintStyle: TextStyle(
                    color: AppColorConstants.textColor,
                  ),
                  border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                minLines: 1,
                maxLines: 2,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                controller: _descController,
                decoration: InputDecoration(
                  labelText: AppLanguagesConstants.labelDesc,
                  hintStyle: TextStyle(
                    color: AppColorConstants.textColor,
                  ),
                  border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                controller: _priorityController,
                decoration: InputDecoration(
                  labelText: AppLanguagesConstants.labelPriority,
                  hintStyle: TextStyle(
                    color: AppColorConstants.textColor,
                  ),
                  border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  updateItem(id, _titleController.text, _descController.text, int.parse(_priorityController.text));
                  Navigator.pop(context);
                },
                child: const Text(AppLanguagesConstants.saveItem),
              ),
            ],
          ),
        );
      },
    );
  }
}
