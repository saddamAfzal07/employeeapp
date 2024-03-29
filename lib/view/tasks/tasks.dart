import 'dart:async';
import 'dart:convert';

import 'dart:io';

import 'package:employeeapp/controller/login/logincontrolller.dart';
import 'package:employeeapp/model/Loginmodel/userdatamodel.dart';
import 'package:employeeapp/model/tasks_model/cpmpletedtask.dart';
import 'package:employeeapp/model/tasks_model/pendingapproval.dart';
import 'package:employeeapp/model/tasks_model/taskmodel.dart';
import 'package:employeeapp/model/tasks_model/uncompleted_model.dart';
import 'package:employeeapp/view/constant/constant.dart';
import 'package:employeeapp/view/notifications/notifications.dart';
import 'package:employeeapp/view/widget/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:image_picker/image_picker.dart';

class Tasks extends StatefulWidget {
  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  final GlobalKey _refreshIndicaorkey = new GlobalKey();

  DateTime selecteddate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  chosedate() async {
    final pickdate = await showDatePicker(
        context: context,
        initialDate: selecteddate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2040));
    if (pickdate != null && pickdate != selecteddate) {
      setState(() {
        selecteddate = pickdate;
        isloadingcomplete = true;
        isloadinguncomplete = true;
        isloadingwaiting = true;
      });

      category = [];
      fetchapi();
      uncmplete = [];

      uncompleteapi();
      complete = [];

      completeapi();
      pending = [];
      pendingapi();
    }
  }

  DateTime now =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  var id = Usererdatalist.userid;
  var token = Usererdatalist.usertoken;

  List<DailyTasks> category = [];
  bool notext = false;
  fetchapi() async {
    print(token);
    category = [];
    print(selecteddate);

    var response = await http.get(
      Uri.parse("${Api.baseurl}task/assigned?date=$selecteddate"),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    Map data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      isloadingwaiting = false;
      if (data["daily_tasks"].isEmpty) {
        print("Not any task available");
        if (mounted) {
          setState(() {
            notext = true;
          });
        }
      } else {
        print("task available");
        for (int i = 0; i < data["daily_tasks"].length; i++) {
          Map obj = data["daily_tasks"][i];
          DailyTasks pos = DailyTasks();
          pos = DailyTasks.fromJson(obj);
          category.add(pos);
        }
      }
    } else {
      if (mounted) {
        setState(() {
          isloadingwaiting = false;
        });
      }
    }
  }

  taskcall() async {}

  void checkForNewSharedLists() {
    setState(() {
      taskcall();
      category = [];
      fetchapi();
    });
  }

  LoginController controller = Get.put(LoginController());
  var fname = Usererdatalist.F_NAME;

  Timer? timer;
  @override
  void initState() {
    super.initState();
    controller.employeTaskCount();

    fetchapi();
    timer = Timer.periodic(Duration(seconds: 2), (Timer t) {
      controller.employeTaskCount();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  var initial = 0;
  var pick;

  final _picker = ImagePicker();
  Future getimage(int i) async {
    final pickedfile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedfile != null) {
      setState(() {
        category[i].image = File(pickedfile.path);
      });
    } else {
      print("Not any image is selected");
    }
  }

  apirecall() async {
    Future.delayed(Duration(milliseconds: 100), () {
      category = [];
      fetchapi();
    });
  }

  bool imagesubmit = false;
  bool isLoadSubmit = false;
  uploadImage(int index) async {
    setState(() {
      isLoadSubmit = true;
    });

    var token = Usererdatalist.usertoken;
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    // ignore: unnecessary_new
    final multipartRequest = new http.MultipartRequest(
        "POST", Uri.parse("${Api.baseurl}task/assigned-submit"));
    multipartRequest.headers.addAll(headers);

    multipartRequest.fields.addAll({
      "assigned_task_specific_id": category[index].id.toString(),
    });

    multipartRequest.files.add(await http.MultipartFile.fromPath(
        'image', category[index].image!.path));
    http.StreamedResponse response = await multipartRequest.send();

    var responseString = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      setState(() {
        imagesubmit = true;
        isLoadSubmit = false;
      });
      print("Done");

      Get.snackbar(
        "Task submit Successfully",
        "",
        colorText: Colors.white,
        backgroundColor: Colors.blue,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 10,
        borderWidth: 2,
      );

      apirecall();

      print(responseString);
    } else {}
  }

  bool visiblewaiting = true;
  bool visibleuncompleted = false;
  bool visiblecompleted = false;
  bool visiblepending = false;
  bool isloadingwaiting = true;
  bool isloadinguncomplete = true;
  bool isloadingcomplete = true;

  bool load = false;

  List<RejectedTasks> uncmplete = [];
  uncompleteapi() async {
    setState(() {
      load = true;
    });
    var response = await http
        .get(Uri.parse("${Api.baseurl}employee/un-approved/tasks"), headers: {
      'Authorization': 'Bearer $token',
    });
    Map data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      setState(() {});
      if (data["error"] == "No Un-Compeleted Task Found") {
        setState(() {
          notext = true;
        });
      } else {
        setState(() {
          notext = false;
        });
        for (int i = 0; i < data["rejectedTasks"].length; i++) {
          Map obj = data["rejectedTasks"][i];
          RejectedTasks pos = RejectedTasks();
          pos = RejectedTasks.fromJson(obj);
          uncmplete.add(pos);
        }
      }
      setState(() {
        isloadinguncomplete = false;
      });
    } else {
      setState(() {
        notext = false;
        isloadinguncomplete = false;
      });
    }
  }

  List<CompletedTask> complete = [];
  completeapi() async {
    setState(() {
      load = true;
    });
    var response = await http
        .get(Uri.parse("${Api.baseurl}employee/completed/tasks"), headers: {
      'Authorization': 'Bearer $token',
    });
    Map data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        isloadingcomplete = false;
      });
      if (data["error"] == "No Compeleted Task Found") {
        setState(() {
          notext = true;
        });
      } else {
        setState(() {
          notext = false;
        });

        for (int i = 0; i < data["completedTask"].length; i++) {
          Map obj = data["completedTask"][i];
          CompletedTask pos = CompletedTask();
          pos = CompletedTask.fromJson(obj);
          complete.add(pos);
        }
      }
      setState(() {
        isloadingcomplete = false;
      });
    } else {
      setState(() {
        isloadingcomplete = false;
      });
    }
  }

  List<Pending> pending = [];
  pendingapi() async {
    setState(() {
      load = true;
    });
    var response = await http.get(
      Uri.parse("${Api.baseurl}employee/pending-for-approval/tasks"),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    Map data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        load = false;
      });

      if (data["error"] == "No Pending For Approval Task  Found") {
        setState(() {
          notext = true;
        });
      } else {
        setState(() {
          notext = false;
        });
        for (int i = 0; i < data["completedTask"].length; i++) {
          Map obj = data["completedTask"][i];
          Pending pos = Pending();
          pos = Pending.fromJson(obj);
          pending.add(pos);
        }
      }
      setState(() {
        load = false;
        // print(load);
      });
    } else {
      setState(() {
        notext = true;
        isloadingcomplete = false;
      });
    }
  }

  String circular = "true";
  withOutPic(int index) async {
    final bodyy = {
      'assigned_task_specific_id': category[index].id.toString(),
      'image': Usererdatalist.userid,
    };

    http.Response response = await http.post(
      Uri.parse("${Api.baseurl}task/assigned-submit"),
      body: jsonEncode(bodyy),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    print(response.body);
    if (response.statusCode == 200) {
      Get.snackbar(
        "Task submit Successfully",
        "",
        colorText: Colors.white,
        backgroundColor: Colors.blue,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 10,
        borderWidth: 2,
      );

      apirecall();
    } else {}

    //     // ignore: avoid_single_cascade_in_expression_statements
  }

  @override
  Widget build(BuildContext context) {
    LoginController loginCotroller = Get.find();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          padding: EdgeInsets.zero,
          onPressed: () => Get.back(),
          icon: Image.asset(
            'assets/images/Vector (11).png',
            height: 18,
            color: kSecondaryColor,
          ),
        ),
        title: MyText(
          text: 'Tasks',
          size: 20,
          color: kSecondaryColor,
          weight: FontWeight.w500,
        ),
        actions: [
          IconButton(
              onPressed: () {
                category = [];
                fetchapi();
              },
              icon: Icon(
                Icons.refresh,
                color: Colors.blue,
              )),
          const SizedBox(
            width: 12.0,
          ),
          InkWell(
            onTap: () => Get.to(() => Notifications()),
            child: Center(
              child: Image.asset(
                'assets/images/Vector (4).png',
                height: 20,
                color: kSecondaryColor,
              ),
            ),
          ),
          const SizedBox(
            width: 15.0,
          ),
        ],
      ),
      body: Column(
        children: [
          Column(
            children: [
              Container(
                height: 150,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: kSecondaryColor,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Column(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Center(
                        child: ListTile(
                          title: MyText(
                            text: 'Today’s Tasks',
                            size: 20,
                            weight: FontWeight.w500,
                            color: kPrimaryColor,
                          ),
                          trailing: Obx(() {
                            return Text(
                              controller.taskcount.value.toString(),
                              style:
                                  TextStyle(fontSize: 30, color: Colors.white),
                            );
                          }),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        decoration: const BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(9),
                            bottomRight: Radius.circular(9),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                isloadingcomplete = true;
                                complete = [];
                                completeapi();
                                setState(() {
                                  visibleuncompleted = false;
                                  visiblecompleted = true;
                                  visiblewaiting = false;
                                  visiblepending = false;
                                });
                              },
                              child: Container(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    MyText(
                                      text: 'Completed',
                                      size: 14,
                                      color: visiblecompleted
                                          ? kSecondaryColor
                                          : kGreenColor,
                                      weight: FontWeight.w500,
                                    ),
                                    Obx(() {
                                      return MyText(
                                        text: loginCotroller.complete.value
                                            .toString(),
                                        size: 22,
                                        color: visiblewaiting
                                            ? kSecondaryColor
                                            : kGreenColor,
                                        weight: FontWeight.w700,
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              splashColor: Colors.black,
                              onTap: () {
                                isloadinguncomplete = true;
                                uncmplete = [];
                                uncompleteapi();
                                setState(() {
                                  visibleuncompleted = true;
                                  visiblecompleted = false;
                                  visiblewaiting = false;
                                  visiblepending = false;
                                });
                              },
                              child: Container(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    MyText(
                                      text: 'Uncompleted',
                                      size: 14,
                                      color: visibleuncompleted
                                          ? kSecondaryColor
                                          : kTertiaryColor,
                                      weight: FontWeight.w500,
                                    ),
                                    Obx(() {
                                      return MyText(
                                        text: loginCotroller.uncomplete.value
                                            .toString(),
                                        size: 22,
                                        color: visiblewaiting
                                            ? kSecondaryColor
                                            : kTertiaryColor,
                                        weight: FontWeight.w700,
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                isloadingwaiting = true;
                                category = [];
                                fetchapi();
                                setState(() {
                                  visibleuncompleted = false;
                                  visiblecompleted = false;
                                  visiblewaiting = true;
                                  visiblepending = false;
                                });
                              },
                              child: Container(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    MyText(
                                      text: 'Waiting',
                                      size: 14,
                                      color: visiblewaiting
                                          ? kSecondaryColor
                                          : Colors.purple,
                                      weight: FontWeight.w500,
                                    ),
                                    Obx(() {
                                      return MyText(
                                        text: loginCotroller.taskcount.value
                                            .toString(),
                                        size: 22,
                                        color: visiblewaiting
                                            ? kSecondaryColor
                                            : Colors.purple,
                                        weight: FontWeight.w700,
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                pending = [];
                                pendingapi();
                                setState(() {
                                  visibleuncompleted = false;
                                  visiblecompleted = false;
                                  visiblewaiting = false;
                                  visiblepending = true;
                                });
                              },
                              child: Container(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    MyText(
                                      text: 'Pending',
                                      size: 14,
                                      color: visiblepending
                                          ? kSecondaryColor
                                          : Colors.grey,
                                      weight: FontWeight.w500,
                                    ),
                                    Obx(() {
                                      return MyText(
                                        text: loginCotroller.pending.value
                                            .toString(),
                                        size: 22,
                                        color: visiblewaiting
                                            ? kSecondaryColor
                                            : Colors.grey,
                                        weight: FontWeight.w700,
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(
            height: 10,
          ),

          Padding(
            padding:
                const EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  onTap: () {
                    setState(() {
                      chosedate();
                    });
                  },
                  leading: Icon(
                    Icons.calendar_today_rounded,
                    color: Colors.blue,
                  ),
                  trailing: Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                  title: Text(
                      DateFormat.yMMMMEEEEd().format(selecteddate).toString()),
                ),
              ),
            ),
          ),

          ////Waiting
          Visibility(
            visible: visiblewaiting,
            child: isloadingwaiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : notext
                    ? Center(
                        child: Padding(
                        padding: const EdgeInsets.only(top: 170),
                        child: Text("There is not any Task"),
                      ))
                    : Expanded(
                        flex: 5,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: category.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                  bottom: 15,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                  border: Border.all(color: kSecondaryColor),
                                ),
                                child: category[index].task![0].imageRequired ==
                                        "0"
                                    ? ListTile(
                                        title: Text(category[index]
                                            .task![0]
                                            .taskTitle
                                            .toString()),
                                        subtitle: Text(category[index]
                                            .task![0]
                                            .taskDescription
                                            .toString()),
                                        trailing: category[index].load == "true"
                                            ? Container(
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            : GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    category[index].load =
                                                        circular;
                                                  });
                                                  withOutPic(index);
                                                },
                                                child: Icon(
                                                  Icons.send,
                                                  color: kSecondaryColor,
                                                )),
                                      )
                                    : ListTile(
                                        minLeadingWidth: 10,
                                        leading: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 40,
                                          width: 40,
                                          child: category[index].image == null
                                              ? Image.asset(
                                                  "assets/images/pic.png",
                                                  fit: BoxFit.cover,
                                                )
                                              : Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 4),
                                                  child: Image.file(
                                                    File(category[index]
                                                            .image!
                                                            .path)
                                                        .absolute,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                        ),
                                        title: Text(category[index]
                                            .task![0]
                                            .taskTitle
                                            .toString()),
                                        subtitle: Text(category[index]
                                            .task![0]
                                            .taskDescription
                                            .toString()),
                                        trailing: category[index].image == null
                                            ? GestureDetector(
                                                onTap: () {
                                                  getimage(index);
                                                },
                                                child: Image.asset(
                                                  'assets/images/Vector (7).png',
                                                  height: 24,
                                                  width: 24,
                                                ),
                                              )
                                            : isLoadSubmit
                                                ? Container(
                                                    child:
                                                        CircularProgressIndicator(
                                                    color: kSecondaryColor,
                                                  ))
                                                : GestureDetector(
                                                    onTap: () {
                                                      uploadImage(index);
                                                    },
                                                    child: Icon(
                                                      Icons.send,
                                                      color: kSecondaryColor,
                                                    ))),
                              );
                            })),
          ),

          /////uncompleted
          Visibility(
            visible: visibleuncompleted,
            child: isloadinguncomplete
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : notext
                    ? Center(
                        child: Padding(
                        padding: const EdgeInsets.only(top: 170),
                        child: Text("There is not any uncompleted task"),
                      ))
                    : Expanded(
                        flex: 5,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: uncmplete.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                  border: Border.all(color: kTertiaryColor),
                                ),
                                child: ListTile(
                                    leading: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/Vector (9).png',
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                    title: Text(uncmplete[index]
                                        .task![0]
                                        .taskTitle
                                        .toString()),
                                    subtitle: Text(
                                      "Not verified +1 points",
                                      style: TextStyle(color: Colors.red),
                                    )),
                              );
                            })),
          ),

          ////complete
          Visibility(
            visible: visiblecompleted,
            child: isloadingcomplete
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : notext
                    ? Center(
                        child: Padding(
                        padding: const EdgeInsets.only(top: 170),
                        child: Text("There is not any completed task"),
                      ))
                    : Expanded(
                        flex: 5,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: complete.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                  border: Border.all(color: kGreenColor),
                                ),
                                child: ListTile(
                                    leading: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/Vector (8).png',
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                    title: Text(complete[index]
                                        .task![0]
                                        .taskTitle
                                        .toString()),
                                    subtitle: Text(
                                      "Verified",
                                      style: TextStyle(color: kGreenColor),
                                    )),
                              );
                            })),
          ),

          ////pending
          Visibility(
            visible: visiblepending,
            child: load
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : notext
                    ? Center(
                        child: Padding(
                        padding: const EdgeInsets.only(top: 170),
                        child: Text("There is not any Pending task"),
                      ))
                    : Expanded(
                        flex: 5,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: pending.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: ListTile(
                                    leading: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/Vector (10).png',
                                          height: 25,
                                        ),
                                      ],
                                    ),
                                    title: Text(pending[index]
                                        .task![0]
                                        .taskTitle
                                        .toString()),
                                    subtitle: Text(
                                      "Pending",
                                      style: TextStyle(color: Colors.grey),
                                    )),
                              );
                            })),
          ),
        ],
      ),
    );
  }
}
