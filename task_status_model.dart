class TaskStatusCountModel {
  String? sId;
  int? sum;

  TaskStatusCountModel({this.sId, this.sum});

  TaskStatusCountModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    sum = json['sum'];
  }

}