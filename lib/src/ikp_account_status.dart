enum IkpAccountStatus {
  couldNotDetermine(0),
  available(1),
  restricted(2),
  noAccount(3),
  temporarilyUnavailable(4),
  unknown(100);

  final int value;
  const IkpAccountStatus(this.value);

  static IkpAccountStatus from(int value) {
    switch (value) {
      case 0:
        return IkpAccountStatus.couldNotDetermine;
      case 1:
        return IkpAccountStatus.available;
      case 2:
        return IkpAccountStatus.restricted;
      case 3:
        return IkpAccountStatus.noAccount;
      case 4:
        return IkpAccountStatus.temporarilyUnavailable;
      default:
        return IkpAccountStatus.unknown;
    }
  }
}
