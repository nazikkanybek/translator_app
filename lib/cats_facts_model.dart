class CatsFactsModel {
  String? fact;
  int? length;

  CatsFactsModel({this.fact, this.length});

  CatsFactsModel.fromJson(Map<String, dynamic> json) {
    fact = json['fact'];
    length = json['length'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fact'] = fact;
    data['length'] = length;
    return data;
  }
}
