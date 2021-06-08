import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:sqflite_sample/providers/data_.dart';
import 'package:sqflite_sample/providers/data_service.dart';
import 'package:sqflite_sample/screens/home_screen.dart';




class PostForm extends StatefulWidget {
  final Guest guest;
  final String id;
  PostForm({this.guest, this.id});
  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final _form = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  bool isComing = true;
  AutovalidateMode validate = AutovalidateMode.disabled;
  @override
  void initState() {
 if(widget.guest !=null){
   nameController.text = widget.guest.name;
   addressController.text = widget.guest.address;
   phoneController.text = widget.guest.phone;
   isComing = widget.guest.visiting == 1 ? true : false;
 }
    super.initState();
  }
  
  @override
  void dispose() {
   nameController.dispose();
   addressController.dispose();
   phoneController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
final isEditing = widget.guest != null;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('images/wedd.jpg')
              ),
            ),
            child:  BackdropFilter(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
                filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0)),
          ),
          Container(
            margin:EdgeInsets.only(top: 30, left: 15, right: 15),
            height: 500,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Card(
                color: Colors.white.withOpacity(0.7),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    autovalidateMode: validate,
                    key: _form,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextFormField(
                              controller: nameController,
                              textCapitalization: TextCapitalization.words,
                              textInputAction: TextInputAction.next,
                              validator: (val){
                                if(val.isEmpty){
                                  return 'please provide name';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: 'Full Name',
                                border: InputBorder.none,
                                errorBorder: InputBorder.none,
                                prefixIcon: Icon(Icons.person),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextFormField(
                              controller: addressController,
                              textCapitalization: TextCapitalization.words,
                              textInputAction: TextInputAction.next,
                              validator: (val){
                                if(val.isEmpty){
                                  return 'please provide address';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                errorBorder: InputBorder.none,
                                prefixIcon: Icon(Icons.my_location_rounded),
                                  labelText: 'Address',
                              ),
                            ),
                          ),

                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.all(4),
                            child: TextFormField(
                              controller: phoneController,
                              textInputAction: TextInputAction.done,
                              validator: (val){
                                if(val.isEmpty){
                                  return 'please provide a phone number';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(Icons.phone),
                                labelText: 'Phone No.',
                                errorBorder: InputBorder.none,
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              RadioListTile(
                                activeColor: Colors.brown,
                                title: Text('Come To Party'),
                                  value: true,
                                  groupValue: isComing,
                                  onChanged: (val){
                                  setState(() {
                                    isComing = val;
                                  });

                                  }),
                              RadioListTile(
                                  activeColor: Colors.brown,
                                  title: Text('not Coming'),
                                  value: false,
                                  groupValue: isComing,
                                  onChanged: (val){
                                    setState(() {
                                      isComing = val;
                                    });
                                  }
                              ),
                            ],
                          ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.teal[200]
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      validate = AutovalidateMode.onUserInteraction;
                                    });
                                if(_form.currentState.validate()){
                                  _form.currentState.save();

                                  if(isEditing){

                                    Guest guest = Guest(
                                      name: nameController.text,
                                      address: addressController.text,
                                      phone: phoneController.text,
                                      visiting: isComing == true ? 1 : 2
                                    );
                                    context.read(dataProvider.notifier).updateData(widget.id, guest);
                                    FocusScope.of(context).unfocus();
                                    Get.offAll(() => HomeScreen());
                                    
                                  }else{


                                    if(isComing == true){
                                      context.read(dataProvider.notifier).addPost(
                                          nameController.text.trim(),
                                          addressController.text.trim(),
                                          phoneController.text.trim(),
                                          1
                                      );
                                      FocusScope.of(context).unfocus();
                                      Get.offAll(() => HomeScreen());
                                    }else{
                                      context.read(dataProvider.notifier).addPost(
                                          nameController.text.trim(),
                                          addressController.text.trim(),
                                          phoneController.text.trim(),
                                          2
                                      );
                                      FocusScope.of(context).unfocus();
                                      Get.offAll(() => HomeScreen());
                                    }
                                    
                                    
                                  }
                                  
                                
                                }
                                  }, child: Text('Submit')
                          ),

                        ],
                      ),
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
