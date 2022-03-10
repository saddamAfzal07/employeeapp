import 'package:employeeapp/model/profile_model/profile_model.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  List<ProfileModel> profileModel = [
    ProfileModel(
      date: '08.05.2021',
      notVerified: true,
      status: 'Not verified yet.',
    ),
    ProfileModel(
      date: '07.05.2021',
      verified: true,
      status: '08:43 - Verified',
    ),
    ProfileModel(
      date: '06.05.2021',
      warning: true,
      status: 'Not Verified +1 Points',
    ),
    ProfileModel(
      date: '07.05.2021',
      verified: true,
      status: '08:43 - Verified',
    ),
    ProfileModel(
      date: '07.05.2021',
      verified: true,
      status: '08:43 - Verified',
    ),
    ProfileModel(
      date: '07.05.2021',
      verified: true,
      status: '08:43 - Verified',
    ),
    ProfileModel(
      date: '07.05.2021',
      verified: true,
      status: '08:43 - Verified',
    ),
  ];

  List<ProfileModel> get getProfileModel => profileModel;

  List<AttendanceModel> attendanceModel = [
    AttendanceModel(
      msg: 'Uncompleted Task +1 Point',
      date: '04.05.2021',
      description:
          'Description section. Purus a facilisi at mollis. Sollicitudin diam feugiat vitae dignissim et egestas rhoncus. Condimentum convallis non dui, eu interdum interdum egestas pellentesque.',
    ),
    AttendanceModel(
      msg: 'Unverified daily attendance +1 Point',
      date: '02.05.2021',
      description:
          'Description section. Purus a facilisi at mollis. Sollicitudin diam feugiat vitae dignissim et egestas rhoncus. Condimentum convallis non dui, eu interdum interdum egestas pellentesque.',
    ),
    AttendanceModel(
      msg: 'Uncompleted Task +1 Point',
      date: '04.05.2021',
      description:
          'Description section. Purus a facilisi at mollis. Sollicitudin diam feugiat vitae dignissim et egestas rhoncus. Condimentum convallis non dui, eu interdum interdum egestas pellentesque.',
    ),
    AttendanceModel(
      msg: 'Uncompleted Task +1 Point',
      date: '04.05.2021',
      description:
          'Description section. Purus a facilisi at mollis. Sollicitudin diam feugiat vitae dignissim et egestas rhoncus. Condimentum convallis non dui, eu interdum interdum egestas pellentesque.',
    ),
    AttendanceModel(
      msg: 'Uncompleted Task +1 Point',
      date: '04.05.2021',
      description:
          'Description section. Purus a facilisi at mollis. Sollicitudin diam feugiat vitae dignissim et egestas rhoncus. Condimentum convallis non dui, eu interdum interdum egestas pellentesque.',
    ),
  ];

  List<AttendanceModel> get getAttendanceModel => attendanceModel;
}
