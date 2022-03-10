import 'dart:async';
import 'dart:convert';

import 'dart:ui';
import 'dart:ffi';

import 'dart:io';

import 'package:employeeapp/controller/login/logincontrolller.dart';
import 'package:employeeapp/model/Loginmodel/userdatamodel.dart';
import 'package:employeeapp/model/tasks_model/cpmpletedtask.dart';
import 'package:employeeapp/model/tasks_model/pendingapproval.dart';
import 'package:employeeapp/model/tasks_model/taskmodel.dart';
import 'package:employeeapp/model/tasks_model/uncompleted_model.dart';
import 'package:employeeapp/view/constant/constant.dart';
import 'package:employeeapp/view/widget/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:get/get.dart';
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

  var completedcount = 0;
  var uncompletedcount = 0;
  var pendingcount = 0;

  var taskcount;

  DateTime now =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  var id = Usererdatalist.userid;
  var token = Usererdatalist.usertoken;

  var url =
      "https://thepointsystemapp.com/employee/public/api/employee/dailyTask";

  List<Tasksss> category = [];
  fetchapi() async {
    var response = await http.post(Uri.parse(url), headers: {
      'Authorization': 'Bearer $token',
    }, body: {
      'date': selecteddate.toString(),
      'employee_id': id,
    });
    Map data = jsonDecode(response.body);
    print(response.body);
    // setState(() {
    //   taskcount = data["count"];
    //   completedcount = data["completedCount"];
    //   uncompletedcount = data["unCompletedCount"];
    //   pendingcount = data["pedningApprovalCount"];
    // });
    // print(response.body);
    // print(completedcount);
    // print(uncompletedcount);
    // print(pendingcount);

    if (response.statusCode == 200) {
      if (data["count"] == 0) {
        setState(() {
          isloadingwaiting = false;
        });
      }
      setState(() {
        taskcount = data["count"];
        completedcount = data["completedCount"];
        uncompletedcount = data["unCompletedCount"];
        pendingcount = data["pedningApprovalCount"];
        isloadingwaiting = false;
      });
      // print(response.body);
      // print(completedcount);
      // print(uncompletedcount);
      // print(pendingcount);

      for (int i = 0; i < data["tasks"].length; i++) {
        Map obj = data["tasks"][i];
        Tasksss pos = Tasksss();
        pos = Tasksss.fromJson(obj);
        category.add(pos);
        // print(category);

      }
      setState(() {
        isloadingwaiting = false;
      });

      // shift();

    } else {
      setState(() {
        isloadingwaiting = false;
      });
    }
  }

  taskcall() async {
    controller.Tasks(now, id);
  }

  void checkForNewSharedLists() {
    // do request here
    setState(() {
      taskcall();
      // category = [];
      // fetchapi();
    });
  }

  var fname = Usererdatalist.F_NAME;

  Timer? timer;
  @override
  void initState() {
    super.initState();

    fetchapi();
    timer = Timer.periodic(
        Duration(seconds: 2), (Timer t) => checkForNewSharedLists());

    // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
    //   _refreshIndicaorkey.currentState!.toString();
    // });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  late StreamController _streamController;
  late Stream _stream;
  LoginController controller = Get.put(LoginController());
  var initial = 0;
  // File? image;
  var pick;

  final _picker = ImagePicker();
  Future getimage(int i) async {
    final pickedfile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedfile != null) {
      setState(() {
        // for (int i = 0; i < category.length; i++) {
        category[i].image = File(pickedfile.path);
        // }
      });
    } else {
      print("Not any image is selected");
    }
  }

  apirecall() async {
    Future.delayed(Duration(milliseconds: 100), () {
      category = [];
      fetchapi();

      // Do something
    });
  }

  bool imagesubmit = false;
  uploadImage(int index) async {
    // print('token' + Usererdatalist.usertoken.toString());

    // ignore: unused_local_variable
    var token = Usererdatalist.usertoken;
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    // ignore: unnecessary_new
    final multipartRequest = new http.MultipartRequest(
        "POST",
        Uri.parse(
            "https://thepointsystemapp.com/employee/public/api/employee/send-task"));
    multipartRequest.headers.addAll(headers);

    multipartRequest.fields.addAll({
      "employee_id": Usererdatalist.userid,
      'task_id': category[index].id.toString()
    });

    multipartRequest.files.add(await http.MultipartFile.fromPath(
        'task_image', category[index].image!.path));
    http.StreamedResponse response = await multipartRequest.send();

    var responseString = await response.stream.bytesToString();
    //  var responseString = String.fromCharCodes(responseString.toString());

    // print(response.toString());

    if (response.statusCode == 200) {
      setState(() {
        imagesubmit = true;
      });
      print("Done");
      Get.snackbar(
        "Image upload Successfully",
        "",
        colorText: Colors.white,
        backgroundColor: Colors.greenAccent,
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

  List<RejectedTasks> uncmplete = [];
  uncompleteapi() async {
    var response = await http.get(
        Uri.parse(
            "https://thepointsystemapp.com/employee/public/api/employee/un-approved/tasks?date=$selecteddate&&employee_id=$id"),
        headers: {
          'Authorization': 'Bearer $token',
        });
    Map data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      setState(() {});
      for (int i = 0; i < data["rejectedTasks"].length; i++) {
        Map obj = data["rejectedTasks"][i];
        RejectedTasks pos = new RejectedTasks();
        pos = RejectedTasks.fromJson(obj);
        uncmplete.add(pos);
        print("uncomplete");
        print(uncmplete);
      }
      setState(() {
        isloadinguncomplete = false;
      });
    } else {
      setState(() {
        isloadinguncomplete = false;
      });
    }
  }

  List<CompletedTask> complete = [];
  completeapi() async {
    var response = await http.get(
        Uri.parse(
            "https://thepointsystemapp.com/employee/public/api/employee/completed/tasks?date=$selecteddate&employee_id=$id"),
        headers: {
          'Authorization': 'Bearer $token',
        });
    Map data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        isloadingcomplete = false;
      });
      for (int i = 0; i < data["completedTask"].length; i++) {
        Map obj = data["completedTask"][i];
        CompletedTask pos = new CompletedTask();
        pos = CompletedTask.fromJson(obj);
        complete.add(pos);
        print("uncomplete");
        print(complete);
      }
    } else {
      setState(() {
        isloadingcomplete = false;
      });
    }
  }

  List<PedningApprovalTasks> pending = [];
  pendingapi() async {
    var response = await http.post(
        Uri.parse(
            "https://thepointsystemapp.com/employee/public/api/employee/pending-for-approval/tasks"),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          'date': selecteddate.toString(),
          'employee_id': id,
        });
    Map data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        isloadingcomplete = false;
      });
      for (int i = 0; i < data["pedningApprovalTasks"].length; i++) {
        Map obj = data["pedningApprovalTasks"][i];
        PedningApprovalTasks pos = new PedningApprovalTasks();
        pos = PedningApprovalTasks.fromJson(obj);
        pending.add(pos);
        print("uncomplete");
        print(complete);
      }
    } else {
      setState(() {
        isloadingcomplete = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          Center(
            child: MyText(
              text: '2',
              size: 18,
              weight: FontWeight.w700,
              color: kSecondaryColor,
            ),
          ),
          const SizedBox(
            width: 12.0,
          ),
          Center(
            child: Image.asset(
              'assets/images/Vector (4).png',
              height: 20,
              color: kSecondaryColor,
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
                          trailing: Text(
                            controller.taskcount.value,
                            style: TextStyle(fontSize: 30, color: Colors.white),
                          ),
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
                              // splashColor: Colors.black45,
                              onTap: () {
                                isloadingcomplete = true;
                                complete = [];

                                setState(() {
                                  visibleuncompleted = false;
                                  visiblecompleted = true;
                                  visiblewaiting = false;
                                  visiblepending = false;
                                });
                              },
                              child: Container(
                                // color: Colors.orange,
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
                                    MyText(
                                      text: completedcount,
                                      size: 22,
                                      color: visiblecompleted
                                          ? kSecondaryColor
                                          : kGreenColor,
                                      weight: FontWeight.w700,
                                    ),
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
                                // color: Colors.yellow,
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
                                    MyText(
                                      text: uncompletedcount,
                                      size: 22,
                                      color: visibleuncompleted
                                          ? kSecondaryColor
                                          : kTertiaryColor,
                                      weight: FontWeight.w700,
                                    ),
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
                                // color: Colors.green,
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
                                    MyText(
                                      text: controller.taskcount,
                                      size: 22,
                                      color: visiblewaiting
                                          ? kSecondaryColor
                                          : Colors.purple,
                                      weight: FontWeight.w700,
                                    ),
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
                                // color: Colors.purple,
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
                                    MyText(
                                      text: pendingcount,
                                      size: 22,
                                      color: visiblepending
                                          ? kSecondaryColor
                                          : Colors.grey,
                                      weight: FontWeight.w700,
                                    ),
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
          //   ),
          // ),

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
                : Expanded(
                    flex: 5,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: category.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              border: Border.all(color: kGreenColor),
                            ),
                            child: ListTile(
                              leading: Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(bottom: 10),
                                height: 60,
                                width: 60,
                                // color: Colors.green,
                                child: category[index].image == null
                                    ? Image.network(
                                        'https://static.thenounproject.com/png/2413564-200.png',
                                        // fit: BoxFit.cover,
                                        height: 30,
                                        width: 30,
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        child: Image.file(
                                          File(category[index].image!.path)
                                              .absolute,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                              ),
                              title: Text(category[index].taskTitle!),
                              subtitle: Text(category[index].taskDate!),
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
                                  : TextButton(
                                      onPressed: () {
                                        uploadImage(index);
                                      },
                                      child: Text("Submit"),
                                    ),
                            ),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/Vector (9).png',
                                      height: 20,
                                    ),
                                  ],
                                ),
                                title: Text(uncmplete[index].taskTitle!),
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
            child:

                // isloadingcomplete
                //     ? Center(
                //         child: CircularProgressIndicator(),
                //       )
                //     :

                Expanded(
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
                              border: Border.all(color: kGreenColor),
                            ),
                            child: ListTile(
                                leading: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/Vector (8).png',
                                      height: 20,
                                    ),
                                  ],
                                ),
                                title: Text(uncmplete[index].taskTitle!),
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
            child:

                // isloadingcomplete
                //     ? Center(
                //         child: CircularProgressIndicator(),
                //       )
                //     :

                Expanded(
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/Vector (10).png',
                                      height: 25,
                                    ),
                                  ],
                                ),
                                title: Text(pending[index].taskTitle!),
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
