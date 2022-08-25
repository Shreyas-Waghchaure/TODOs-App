
import 'package:flutter/material.dart';
import 'package:letsdoapp/Database_helper.dart';
import 'package:letsdoapp/Models/todo.dart';
import 'package:letsdoapp/Screens/Widget.dart';
import '../Models/Task.dart';

class TaskPage extends StatefulWidget {
  final Task? task;
  TaskPage({@required this.task});

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  DatabaseHelper _dbhelper = DatabaseHelper();
  int _taskId =0;
  String? _tasktitle = "";
  String? _taskdesc = "";

  late FocusNode _titleFocus;
  late FocusNode _descriptionFocus;
  late FocusNode _todoFocus;
  bool _containtvisible = false;
  @override
  void initState() {
    if (widget.task != null) {
      _containtvisible =true;
      _tasktitle = widget.task?.title;
      _taskdesc = widget.task?.description;
      _taskId = widget.task!.id!;
    }
    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();

    super.initState();
  }
  @override
  void dispose() {
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _todoFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 24.0, bottom: 6.0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Image(
                          image: AssetImage('assets/Back.jpg'),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        focusNode: _titleFocus,
                        onSubmitted: (value) async {
                          // check for field is not empty
                          if (value != "") {
                            // check for todos is not empty
                            if (widget.task == null) {
                              Task _newtask = Task(title: value);
                              _taskId = await _dbhelper.insertTask(_newtask);
                              setState(() {
                                _containtvisible = true;
                                _tasktitle = value;
                              });
                              print("new task id : $_taskId");
                            } else {
                              await _dbhelper.updatetasktitle(_taskId, value);
                              print("existing title updated");
                            }
                            _descriptionFocus.requestFocus();
                          }
                        },
                        controller: TextEditingController()..text = _tasktitle!,
                        decoration: const InputDecoration(
                          hintText: "Enter Title",
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
               Visibility(
                 visible: _containtvisible,
                 child: Padding(
                  padding: EdgeInsets.only(bottom: 12.0),
                  child: TextField(
                    focusNode: _descriptionFocus,
                    // controller: TextEditingController()..text = _taskdesc?,
                    onSubmitted: (value) async {
                      if(value !=""){
                        if(_taskId != 0 ) {
                         await _dbhelper.updatetaskdesc(_taskId, value);
                         _taskdesc = value;

                          }
                      }
                      _todoFocus.requestFocus();

                      },

                    decoration: InputDecoration(
                      hintText: "Enter Task Description.....",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 24.0),
                    ),
                  ),
              ),
               ),
              Visibility(
                visible: _containtvisible,
                child: FutureBuilder(
                  initialData: const [],
                  future: _dbhelper.getTodo(_taskId),
                  builder: (context, AsyncSnapshot snapshot) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                             if(snapshot.data[index].isDone == 0){
                               await _dbhelper.updateTodoDone(snapshot.data[index].id, 1);

                             }else{
                               await _dbhelper.updateTodoDone(snapshot.data[index].id, 0);
                             }
                             setState(() {});

                            },
                            child: TodoWidget(
                              text: snapshot.data[index].title,
                              isDone: snapshot.data[index].isDone ==0 ? false : true ,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              Visibility(
                visible: _containtvisible,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    children: [
                      Container(
                        width: 20.0,
                        height: 20.0,
                        margin: EdgeInsets.only(right: 12.0),
                        child: const Image(
                          image: AssetImage('assets/TCheckboc.jpg'),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          focusNode: _todoFocus,
                          controller: TextEditingController()..text="",
                          onSubmitted: (value) async {
                            // check for field is not empty
                            if (value!= "") {
                              // check for todos is not empty
                              if (_taskId != 0) {
                                DatabaseHelper _dbhelper = DatabaseHelper();
                                todo _newtodo = todo(
                                  title: value,
                                  isDone: 0,
                                 taskId: _taskId,
                                );
                                await _dbhelper.insertTodo(_newtodo);
                                setState(
                                        () {}
                                );
                                _todoFocus.requestFocus();
                              } else {
                                print("update existing todo");
                              }
                            }
                          },
                          decoration: const InputDecoration(
                            hintText: "Enter Todo Item...",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: Visibility(

        visible: _containtvisible,
        child: FloatingActionButton(
          onPressed: () async{
              if(_taskId !=0){
                await _dbhelper.deletetask(_taskId);
                Navigator.pop(context);
              }
          },
          backgroundColor: Colors.red[600],
          focusColor: Colors.red[600],
          elevation: 10.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: const Icon(Icons.delete_forever),
        ),
      ),
    );
  }
}
