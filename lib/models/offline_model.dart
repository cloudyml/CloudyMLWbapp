class OfflineModel {
  final int? id;
  final String? topic;
  final String? module;
  final String? course;
  final String? path;
  OfflineModel({
    this.id,
    this.topic,
    this.module,
    this.course,
    this.path,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'topic': topic,
      'module': module,
      'course': course,
      'path': path,
    };
  }
}
