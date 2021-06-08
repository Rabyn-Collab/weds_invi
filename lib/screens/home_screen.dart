import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqflite_sample/forms/add_form.dart';
import 'package:sqflite_sample/main.dart';
import 'package:sqflite_sample/providers/data_service.dart';

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
    final data = watch(dataProvider);
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
            Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('images/weddings.jpg')
              ),
            ),
            child:  BackdropFilter(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                  ),
                ),
                filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0)),
          ),
        CustomScrollView(
          slivers: [
            SliverAppBar(
              brightness: Brightness.dark,
              shadowColor: Colors.teal,
              centerTitle: true,
             flexibleSpace: Padding(
               padding: const EdgeInsets.all(1.0),
               child: Text('Wedding Guests List', style: TextStyle(fontFamily: 'Damion', fontSize: 50, color: Colors.white),
                 maxLines: 2,),
             ),
              expandedHeight: 70,
              floating: true,
              backgroundColor: Colors.teal ,
            ),

            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index){
                  return data.length == 0 ? Container()
                      : Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
                      child: Consumer(
                        builder: (context, watch, child){
                          final visible = watch(statusProvider(data[index].id));
                          return Column(
                          children: [
                            Container(
                              child: Card(
                                color: Colors.blueGrey.withOpacity(0.2),
                                child: Column(
                                  children: [
                                Padding(
                                padding: const EdgeInsets.all(5.0),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Icon(Icons.person, size: 27, color: Colors.amber,),
                                  SizedBox(width: 12,),
                                  Text(data[index].name, style: TextStyle(fontFamily:'Poppins',color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16)),
                                ],
                              ),
                              Container(
                                height: 40,
                                child: IconButton(
                                  icon: Icon(Icons.more_horiz_sharp, color: Colors.white, size: 30,),
                                onPressed: (){
                                    showDialog(context: context, builder: (context) => AlertDialog(
                                      title: Text('Customize the profile'),
                                      actions: [
                                        TextButton.icon(onPressed: (){
                                          Navigator.pop(context, false);
                                         Get.to(() => PostForm(guest: data[index], id: data[index].id,));
                                        }, icon: Icon(Icons.edit, color: Colors.pink,), label: Text('Edit')),
                                        SizedBox(width: 20,),
                                        TextButton.icon(onPressed: (){
                                          context.read(dataProvider.notifier).removeData(data[index].id);
                                          Navigator.pop(context);
                                        }, icon: Icon(Icons.delete, color: Colors.black,), label: Text('Remove')),
                                      ],
                                    ));
                                },
                                ),
                              )
                            ],
                          ),
                        ),
                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          textBaseline: TextBaseline.alphabetic,
                                          children: [
                                            Icon(Icons.my_location_rounded, size: 27, color: Color(0xFFaf9fea),),
                                            SizedBox(width: 12,),
                                            Text(data[index].address, style: TextStyle(fontFamily:'FiraSans',color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16)),

                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          textBaseline: TextBaseline.alphabetic,
                                          children: [
                                            Icon(Icons.phone_android_rounded, size: 27, color: Colors.deepOrange,),
                                            SizedBox(width: 12,),
                                            Text(visible ? '9********' : data[index].phone  , style:TextStyle(
                                                color: Colors.white,fontFamily: 'Sansita', fontWeight: FontWeight.w500, fontSize: 16)),
                                            Spacer(),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                              child: InkWell(
                                                  onTap: (){
                                                    context.read(statusProvider(data[index].id).notifier).toggle(context, data[index].id);
                                                  },
                                                  child: Icon(visible ? Icons.visibility_off : Icons.visibility , size: 27, color: Color(0xFFEADDFD),)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          textBaseline: TextBaseline.alphabetic,
                                          children: [
                                            Icon(
                                              data[index].visiting == 1 ? Icons.check : Icons.close,
                                              size: 27, color:data[index].visiting == 1 ? Colors.cyanAccent : Colors.red,),
                                            SizedBox(width: 12,),
                                            Text(data[index].visiting == 1 ?'Visiting': 'NotComing', style: TextStyle(color: Colors.white, fontFamily: 'Oswald', fontWeight: FontWeight.w500, fontSize: 16)),
                                          ],
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ),

                            ),
                          ],
                        );
                     }
                      ),
                    ),
                  );
                },
              childCount: data.length
            ),
            ),

          ],
        ),
          _buildPositioned(context)
        ],
      )),
    );
  }


  Widget _buildPositioned(BuildContext context) {
    return Positioned(
          bottom: 5,
          left: 165,
          child: RawMaterialButton(
            splashColor: Colors.white54,
            onPressed: () {
             Get.to(() => PostForm(), transition: Transition.zoom, duration: Duration(milliseconds: 300));
            },
            elevation: 2.0,
            fillColor: Colors.white.withOpacity(0.7),
            child: Icon(
              Icons.add,
              size: 25.0,
              color: Colors.black,
            ),
            padding: EdgeInsets.all(15.0),
            shape: CircleBorder(),
          )
        );
  }
}
