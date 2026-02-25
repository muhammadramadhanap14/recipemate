class ModelThreeColumn {
  String column1;
  String column2;
  String column3;

  ModelThreeColumn({
    required this.column1,
    required this.column2,
    required this.column3
  });

  Map<String, dynamic> toMap() {
    return {
      'column1': column1,
      'column2': column2,
      'column3': column3
    };
  }

  factory ModelThreeColumn.fromMap(Map<String, dynamic> map) => ModelThreeColumn(
      column1: map['column1'] as String? ?? '',
      column2: map['column2'] as String? ?? '',
      column3: map['column3'] as String? ?? '');

  Map<String, dynamic> toJson() {
    return {
      'column1': column1,
      'column2': column2,
      'column3': column3,
    };
  }

  factory ModelThreeColumn.fromJson(Map<String, dynamic> json) {
    return ModelThreeColumn(
      column1: json['column1'] as String,
      column2: json['column2'] as String,
      column3: json['column3'] as String,
    );
  }
}