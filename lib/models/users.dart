import 'package:firebase_database/firebase_database.dart';

class Users {
  String? id;
  String? email;
  String? name;
  String? phone;
  String? corporateId;
  int? miles;

  Users({this.id, this.email, this.name, this.phone, this.corporateId,this.miles});

  Users.fromSnapshot(DataSnapshot dataSnapshot) {
    Map json = dataSnapshot.value as Map;
    id = dataSnapshot.key!;
    email = json['email'];
    name = json['name'];
    phone = json['phone'];
    corporateId = json['corporateId'];
    miles=json['miles'];
  }
}
