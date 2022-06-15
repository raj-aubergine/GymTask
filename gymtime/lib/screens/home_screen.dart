import 'package:flutter/material.dart';
import 'package:gymtime/helpers/database.dart';
import 'package:gymtime/widgets/timercard.dart';
import 'package:provider/provider.dart';

import '../providers/provider.dart';
import '../models/exercise.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController editnameController = TextEditingController();
  TextEditingController edittimeController = TextEditingController();
  int? selectedId;

  @override
  void dispose() {
    nameController.dispose();
    timeController.dispose();
    edittimeController.dispose();
    super.dispose();
  }

  // var getex;
  // @override
  // initState() {
  //   getex = DatabaseHelper.instance.getExercise();
  //   super.initState();
  // }

  // void callsetstate() {
  //   setState(() {
  //     getex = DatabaseHelper.instance.getExercise();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text("GYM TIME"),
          actions: [
            IconButton(
                onPressed: () {
                  showModalBottomSheetWidget();
                },
                icon: const Icon(Icons.add)),
          ],
        ),
        body: SingleChildScrollView(
          child: FutureBuilder<List<Exercise>>(
              future: DatabaseHelper.instance.getExercise(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Exercise>> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return snapshot.data!.isEmpty
                    ? const Center(
                        child: Text('No Data Found'),
                      )
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final ex = snapshot.data![index];
                          return InkWell(
                            onTap: () {
                              showModalBottomSheetForUpdateWidget(ex);

                              // showDialog(
                              //     context: context,
                              //     builder: (context) => AlertDialog(
                              //           title: Text(ex.name ?? ''),
                              //           content: TextField(
                              //             decoration:
                              //                 InputDecoration(hintText: 'time'),
                              //             controller: edittimeController,
                              //           ),
                              //           actions: [
                              //             TextButton(
                              //               child: Text('update'),
                              //               onPressed: () async {
                              //                 Navigator.pop(context);
                              //                 setState(() {
                              //                   DatabaseHelper.instance.update(
                              //                       Exercise(
                              //                           id: ex.id,
                              //                           name: ex.name,
                              //                           time: int.parse(
                              //                               edittimeController
                              //                                   .text)));
                              //                 });

                              //                 //callsetstate();
                              //               },
                              //             )
                              //           ],
                              //         ));
                            },
                            child: TimerCard(
                              exercise: ex,
                            ),
                          );
                        });
              }),
        ));
  }

  Future showModalBottomSheetWidget() {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: AnimatedPadding(
              padding: MediaQuery.of(context).viewInsets,
              duration: const Duration(milliseconds: 100),
              curve: Curves.decelerate,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text(
                      "Add New Excercise",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Name',
                      ),
                      controller: nameController,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Time',
                      ),
                      keyboardType: TextInputType.number,
                      controller: timeController,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                        onPressed: () async {
                          await DatabaseHelper.instance.add(Exercise(
                              name: nameController.text,
                              time: int.parse(timeController.text)));

                          setState(() {
                            nameController.clear();
                            timeController.clear();
                            Navigator.pop(context);
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text(
                            'SAVE',
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                        ),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ))))
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future showModalBottomSheetForUpdateWidget(Exercise exercise) {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: AnimatedPadding(
              padding: MediaQuery.of(context).viewInsets,
              duration: const Duration(milliseconds: 100),
              curve: Curves.decelerate,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text(
                      "Update Exercise",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      initialValue: exercise.name,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                      ),
                      readOnly: true,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Time',
                      ),
                      keyboardType: TextInputType.number,
                      controller: edittimeController,
                    ),
                    const SizedBox(height: 30),
                    Consumer<Update>(builder: (context, provider, child) {
                      return ElevatedButton(
                          onPressed: () async {
                            await DatabaseHelper.instance.update(Exercise(
                                id: exercise.id,
                                name: exercise.name,
                                time: int.parse(edittimeController.text)));

                            setState(() {
                              edittimeController.clear();
                              Navigator.pop(context);
                              provider.setUpdate(true);
                            });
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Text(
                              'UPDATE',
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                          ),
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ))));
                    })
                  ],
                ),
              ),
            ),
          );
        });
  }
}
