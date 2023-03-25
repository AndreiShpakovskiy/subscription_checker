enum SubscriptionStatus {
  active("active"),
  expired("expired"),
  notFound("not_found");

  final String _rawName;

  const SubscriptionStatus(String name) : _rawName = name;

  factory SubscriptionStatus.named(String name) => SubscriptionStatus.values
      .firstWhere((element) => element._rawName == name);
}
