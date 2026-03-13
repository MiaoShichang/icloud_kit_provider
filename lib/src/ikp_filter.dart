enum IkpOperator {
  equals("equals"),
  notEquals("notEquals"),
  lessThan("lessThan"),
  lessThanOrEquals("lessThanOrEquals"),
  greaterThan("greaterThan"),
  greaterThanOrEquals("greaterThanOrEquals"),
  contains("contains"),
  notContains("notContains"),
  beginsWith("beginsWith"),
  endsWith("endsWith"),
  inList("inList"),
  notInList("notInList");

  final String value;
  const IkpOperator(this.value);
}

class IkpFilter {
  String field;
  IkpOperator operator;
  dynamic value;

  IkpFilter({required this.field, required this.operator, required this.value});

  bool isValid() {
    return field.isNotEmpty;
  }

  Map<String, dynamic> toJson() {
    return {'field': field, 'operator': operator.value, 'value': value};
  }
}
