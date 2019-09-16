import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:innafor/model/user.dart';

enum ReportType { comment, post }

class ReportDialogInfo {
  ReportType reportType;
  User reportedUser;
  User reportedByUser;
  String id;
  String typeString;

  ReportDialogInfo({
    this.reportType,
    this.reportedByUser,
    this.reportedUser,
    this.id,
  }) {
    this.typeString = getTypeString();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      "reported_id": this.reportedUser.id,
      "reported_by_id": this.reportedByUser.id,
      "timestamp": DateTime.now(),
    };
  }

  Future<void> pushReport() async {
    await Firestore.instance
        .collection("${this.typeString}" + "_report")
        .document(this.reportedByUser.id)
        .setData(this.toJson());
    return;
  }

  String getTypeString() {
    switch (reportType) {
      case ReportType.comment:
        return "comment";

        break;
      case ReportType.post:
        return "post";

      default:
        return "report_type_empty";
    }
  }
}
