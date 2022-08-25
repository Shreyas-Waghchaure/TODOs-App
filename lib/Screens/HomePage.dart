import 'package:flutter/material.dart';
import 'package:letsdoapp/Database_helper.dart';
import 'package:letsdoapp/Screens/TaskPage.dart';
import 'package:letsdoapp/Screens/Widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper _dbhelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f6f6),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 32,
                  bottom: 32.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Image(
                      image: AssetImage('assets/logo.jpg'),
                      width: 60.0,
                    ),
                    Text(
                      "let's do",
                      style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.indigo,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  initialData: const [],
                  future: _dbhelper.getTasks(),
                  builder: (context, AsyncSnapshot snapshot) {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TaskPage(
                                    task: snapshot.data[index],
                                  ),
                                ),
                              ).then((value) {
                                setState(() {});
                              });
                            },
                            child: CardWidget(
                              title: snapshot.data[index].title,
                              desc: snapshot.data[index].description,
                            ),
                          );
                        });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskPage(
                task: null,
              ),
            ),
          ).then((value) {
            setState(() {});
          });
        },
        backgroundColor: Colors.indigo,
        focusColor: Colors.indigo,
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
