class ProfileModel {
  bool? warning, verified, notVerified;
  var date, status;

  ProfileModel({
    this.date,
    this.status,
    this.warning = false,
    this.verified = false,
    this.notVerified = false,
  });
}

class AttendanceModel {
  var msg, date, description;

  AttendanceModel({
    this.msg,
    this.date,
    this.description,
  });
}
