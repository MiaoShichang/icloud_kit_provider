enum IkpSortDirection {
  ascending("asc"),
  descending("desc");

  final String value;
  const IkpSortDirection(this.value);
}

class IkpSort {
  final String field;
  final IkpSortDirection direction;

  IkpSort({required this.field, this.direction = IkpSortDirection.ascending});

  bool isValid() {
    return field.isNotEmpty;
  }

  Map<String, dynamic> toJson() {
    return {'field': field, 'direction': direction.value};
  }
}
