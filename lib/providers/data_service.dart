import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite_sample/db_helper/database_helper.dart';
import 'package:sqflite_sample/providers/data_.dart';

class GuestsState extends StateNotifier<List<Guest>> {
  GuestsState() : super( []) {
    getData();
  }


  Future<void> getData() async {
    try {
      final dataList = await DBHelper.getData('user_guests');
      List<Guest> guests = dataList.map((item) => Guest(
        id: item['id'],
        name: item['name'],
        address: item['address'],
        phone: item['phone'],
        visiting: item['visiting']
      )).toList();
      state = [...state, ...guests];
    } catch (err) {
      print(err);
    }
  }


  void addPost(String name, String address, String phone, int visiting){
    final newGuest = Guest(
        id: DateTime.now().toIso8601String(),
        name: name,
      address: address,
      phone: phone,
      visiting: visiting
    );

    state = [...state, newGuest];

    DBHelper.insert('user_guests', {
      'id': newGuest.id,
      'name': newGuest.name,
      'address': newGuest.address,
      'phone': newGuest.phone,
      'visiting': newGuest.visiting
    });


  }


  void updateData(String id, Guest newGuest){
    state = [
      for (final guest in state)
        if (guest.id == id)
          Guest(
            id: guest.id,
            name: newGuest.name,
            address: newGuest.address,
            phone: newGuest.phone,
            visiting: newGuest.visiting
          )
        else
          guest,
    ];

    DBHelper.updateData('user_guests', {
      'id': id,
      'name': newGuest.name,
      'address': newGuest.address,
      'phone': newGuest.phone,
      'visiting': newGuest.visiting
    });

  }



  void removeData(String id){
    state = state.where((guest) => guest.id != id).toList();
    DBHelper.removeData('user_guests', id);

  }


}





final dataProvider = StateNotifierProvider<GuestsState, List<Guest>>((ref) => GuestsState());