class VideoDetails {
  String _videoId;
  String _videoTitle;
  bool _canSaveOffline;
  String _serialNo;
  String _type;
  String _videoUrl;

  VideoDetails({
    required String videoId,
    required String videoTitle,
    required String videoUrl,
    required bool canSaveOffline,
    required String serialNo,
    required String type,
  })  : _videoId = videoId,
        _canSaveOffline = canSaveOffline,
        _serialNo = serialNo,
        _type = type,
        _videoUrl = videoUrl,
        _videoTitle = videoTitle;

  String get videoId => _videoId;
  String get serialNo => _serialNo;
  String get videoUrl => _videoUrl;
  String get videoTitle => _videoTitle;
  bool get canSaveOffline => _canSaveOffline;
  String get type => _type;
}
