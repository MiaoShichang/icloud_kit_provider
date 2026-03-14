class IkpSort {
  final String field;
  final bool asc;

  IkpSort({required this.field, this.asc = true});

  bool isValid() {
    return field.isNotEmpty;
  }

  Map<String, dynamic> toJson() {
    return {'field': field, 'direction': asc ? "asc" : "desc"};
  }
}
