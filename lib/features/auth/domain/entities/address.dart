class Address {
  final String? country;
  final String? city;
  final String? street;
  final String? postalCode;
  final String? houseNumber;
  final String? apartmentNumber;

  const Address({
    this.country,
    this.city,
    this.street,
    this.postalCode,
    this.houseNumber,
    this.apartmentNumber,
  });

  String get fullAddress {
    final components = [
      if (street != null) street,
      if (houseNumber != null) houseNumber,
      if (apartmentNumber != null) 'Apt $apartmentNumber',
      if (city != null) city,
      if (postalCode != null) postalCode,
      if (country != null) country,
    ];
    return components.join(', ');
  }
}
