class GrantType{
  const GrantType._(this.value);
  final String value;

  static const GrantType renew = GrantType._("renew");

}