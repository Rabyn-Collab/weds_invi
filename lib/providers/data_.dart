
class Guest{

   String name;
   String address;
   String id;
   String phone;
   int visiting;
  Guest({this.address, this.id, this.name, this.phone, this.visiting});

}

class Guests {

  List<Guest> guests;


Guests({this.guests});
  Guests.initial()
      :
      guests = [];

  Guests copyWith({List<Guest> guests}) {
    return Guests(
       guests:  guests ?? this.guests,
    );
  }


}

