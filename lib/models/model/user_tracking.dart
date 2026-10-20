class DetailTracking {
  final double positionLat;
  final double positionLng;
  final String trackingDate;

  DetailTracking({
    required this.positionLat,
    required this.positionLng,
    required this.trackingDate,
  });

  Map<String, dynamic> toMap() => {
        'positionLat': positionLat,
        'positionLng': positionLng,
        'trackingDate': trackingDate,
      };

  Map<String, dynamic> toJson() => toMap();

  factory DetailTracking.fromJson(Map<String, dynamic> json) => DetailTracking(
        positionLat: (json['positionLat'] ?? json['position_lat'] ?? json['positionlat'] ?? 0.0) as double,
        positionLng: (json['positionLng'] ?? json['position_lng'] ?? json['positionlng'] ?? 0.0) as double,
        trackingDate: (json['trackingDate'] ?? json['tracking_date'] ?? '') as String,
      );
}

class UserTracking {
  final int idTrc;
  final String nik;
  final String createDate;
  final String startDate;
  String? endDate;
  final double startLat;
  final double startLng;
  double? endLat;
  double? endLng;
  int trackingStatus;
  List<DetailTracking> listDetailActivity;

  UserTracking({
    required this.idTrc,
    required this.nik,
    required this.createDate,
    required this.startDate,
    this.endDate,
    required this.startLat,
    required this.startLng,
    this.endLat,
    this.endLng,
    this.trackingStatus = 0,
    List<DetailTracking>? listDetailActivity,
  }) : listDetailActivity = listDetailActivity ?? [];

  Map<String, dynamic> toMap() => {
        'idTrc': idTrc,
        'user_create': nik,
        'create_date': createDate,
        'start_date': startDate,
        'finish_date': endDate ?? '',
        'position_start_lat': startLat,
        'position_start_lng': startLng,
        'position_finish_lat': endLat ?? 0.0,
        'position_finish_lng': endLng ?? 0.0,
        'tracking_status': trackingStatus,
      };

  Map<String, dynamic> toJson() => toMap();

  factory UserTracking.fromMap(Map<String, dynamic> map, {List<DetailTracking>? details}) => UserTracking(
        idTrc: (map['idTrc'] ?? map['id_trc'] ?? 0) as int,
        nik: (map['user_create'] ?? map['nik'] ?? '') as String,
        createDate: (map['create_date'] ?? '') as String,
        startDate: (map['start_date'] ?? '') as String,
        endDate: (map['finish_date'] as String?)?.isEmpty == true ? null : map['finish_date'] as String?,
        startLat: ((map['position_start_lat'] ?? 0.0) as num).toDouble(),
        startLng: ((map['position_start_lng'] ?? 0.0) as num).toDouble(),
        endLat: ((map['position_finish_lat'] ?? 0.0) as num).toDouble(),
        endLng: ((map['position_finish_lng'] ?? 0.0) as num).toDouble(),
        trackingStatus: (map['tracking_status'] ?? 0) as int,
        listDetailActivity: details ?? [],
      );

  factory UserTracking.fromJson(Map<String, dynamic> json) => UserTracking.fromMap(json);
}
