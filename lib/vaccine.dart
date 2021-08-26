class Vaccine {
  String name = "";
  String address = "";
  int rem = 0;
  String vaccinetType = "";
  String price = "";
  int age = 0;
  String time = "";
  int pincode = 0;

  Vaccine(
      {this.name,
      this.address,
      this.rem,
      this.vaccinetType,
      this.price,
      this.age,
      this.time,
      this.pincode});

  factory Vaccine.fromJson(Map<String, dynamic> json) {
    return Vaccine(
        name: json['name'],
        address:
            "${json['address']} - (${json['pincode']} ${json['block_name']})",
        price: json['fee'],
        age: json["min_age_limit"],
        rem: json['available_capacity'],
        time: json['date'],
        pincode: json['pincode'],
        vaccinetType: json['vaccine']);
  }
}
