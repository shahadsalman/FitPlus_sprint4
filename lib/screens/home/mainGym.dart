// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitplus/dialog/offer_dialog.dart';
import 'package:fitplus/firebase/fb_auth_controller.dart';
import 'package:fitplus/firebase/fb_firestore.dart';
import 'package:fitplus/firebase/fb_notifications.dart';
import 'package:fitplus/notification/notification.dart';
import 'package:fitplus/src/controller/splash_screens_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../components/ratings_widget.dart';
import '../../components/review_tile.dart';
import '../../models/review_model.dart';
import '../map_picker/map_view_screen.dart';
import '../subscriptions/subscriptions.dart';
import 'editprofile.dart';

class HomePageGym extends StatefulWidget {
  late XFile? _pickedFile;
  late XFile? _pickedFile2;
  int select = 1;

  HomePageGym({super.key});

  @override
  State<HomePageGym> createState() => _HomePageGymState();
}

class _HomePageGymState extends State<HomePageGym> {
  TextEditingController offer = TextEditingController();
  TextEditingController price = TextEditingController();

  int? plan;

  @override
  Widget build(BuildContext context) {
    final gymData = AppController.to.loginMap;
    return Container(
      child: Scaffold(
        drawer: const NavigationDrawer(),
        appBar: AppBar(
          elevation: 20,
          backgroundColor: Color.fromARGB(255, 210, 199, 226),
          title: Text('Gym Profile'),
          centerTitle: true,
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 18),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications_active),
              onPressed: () async {
                print(await FbNotifications.getFcm());
                Get.to(() => NotificationScreen());
              },
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 160,
                width: double.infinity,
                child: Stack(
                  children: [
                    Container(
                      height: 130,
                      width: double.infinity,
                      decoration: BoxDecoration(border: Border.all(color: Color.fromARGB(255, 210, 199, 226))),
                      child: Stack(
                        children: [
                          // widget._pickedFile != null
                          //     ? Center(
                          //         child: Image.file(
                          //           File(widget._pickedFile!.path),
                          //           fit: BoxFit.fill,
                          //           width: double.infinity,
                          //         ),
                          //       ):
                          AppController.to.loginMap['logo2'].isEmpty
                              ? Center(child: Image.asset('assets/white.png'))
                              : Center(
                                  child: Image.network(
                                    AppController.to.loginMap['logo2'],
                                    fit: BoxFit.fill,
                                    width: double.infinity,
                                    errorBuilder: (e, _, __) {
                                      return Image.asset('assets/white.png');
                                    },
                                  ),
                                ),
                          Align(
                            alignment: AlignmentDirectional.bottomEnd,
                            child: Container(
                              height: 20,
                              width: 20,
                              margin: EdgeInsetsDirectional.only(end: 10, bottom: 5),
                              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, border: Border.all(color: Colors.black)),
                              child: Center(
                                  child: GestureDetector(
                                onTap: () {
                                  pickImageAfterSelectForImage2(context: context);
                                },
                                child: Icon(
                                  Icons.edit,
                                  size: 15,
                                ),
                              )),
                            ),
                          )
                        ],
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.bottomStart,
                      child: Container(
                          height: 100,
                          width: 100,
                          clipBehavior: Clip.antiAlias,
                          margin: EdgeInsetsDirectional.only(start: 15),
                          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black), color: Colors.black),
                          child: Container(
                            height: 95,
                            width: 95,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: Color.fromARGB(255, 210, 199, 226)),
                            child: Image.network(
                              AppController.to.loginMap['logo'],
                              height: 100,
                              fit: BoxFit.fill,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(child: CircularProgressIndicator());
                              },
                            ),
                          )),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                             Text(
                          AppController.to.loginMap['nameGym'] ?? "",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(width: 5,),
                        AverageRatingsWidget(gymId: AppController.to.loginMap["gymId"]),
                      ],
                    ),
                    SizedBox(height: 15),
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        Get.to(() => const MapViewScreen(), arguments: {
                          "gymLat": gymData["gymLat"],
                          "gymLng": gymData["gymLng"],
                          "locationGym": gymData["locationGym"],
                          "gymName": gymData["nameGym"],
                        });
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Color(0xff48358e),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          // Expanded(child: Text(gymData['locationGym']))
                          Text(
                            "Gym Location",
                            style: TextStyle(decoration: TextDecoration.underline),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: Color(0xff48358e),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Discription'),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsetsDirectional.all(10),
                      decoration: BoxDecoration(border: Border.all(color: Color.fromARGB(255, 210, 199, 226)), borderRadius: BorderRadius.circular(10)),
                      child: Text(AppController.to.loginMap['descriptionGym']),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                widget.select = 1;
                              });
                            },
                            child: Column(
                              children: [
                                Text(
                                  'About',
                                  style: TextStyle(fontWeight: widget.select == 1 ? FontWeight.bold : FontWeight.normal),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Container(
                                  height: 2,
                                  decoration: BoxDecoration(color: widget.select == 1 ? Color(0xff48358e) : Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                widget.select = 2;
                              });
                            },
                            child: Column(
                              children: [
                                Text(
                                  'offers',
                                  style: TextStyle(fontWeight: widget.select == 2 ? FontWeight.bold : FontWeight.normal),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Container(
                                  height: 2,
                                  decoration: BoxDecoration(color: widget.select == 2 ? Color(0xff48358e) : Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                widget.select = 3;
                              });
                            },
                            child: Column(
                              children: [
                                Text(
                                  'Review',
                                  style: TextStyle(fontWeight: widget.select == 3 ? FontWeight.bold : FontWeight.normal),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Container(
                                  height: 2,
                                  decoration: BoxDecoration(color: widget.select == 3 ? Color(0xff48358e) : Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: widget.select == 1,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text('Photo GYM'),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: 120,
                            width: double.infinity,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: AppController.to.loginMap['images'].length + 1,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return index == 0
                                    ? GestureDetector(
                                        onTap: () {
                                          pickImageAfterSelectForAddImageGym(context: context);
                                        },
                                        child: Container(
                                          height: 120,
                                          width: 120,
                                          decoration: BoxDecoration(border: Border.all()),
                                          margin: EdgeInsetsDirectional.only(end: 10),
                                          child: Center(
                                            child: Icon(Icons.add),
                                          ),
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Material(
                                                  color: Colors.transparent,
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    height: Get.height,
                                                    width: Get.width,
                                                    child: Stack(
                                                      children: [
                                                        Image.network(
                                                          AppController.to.loginMap['images'][index - 1],
                                                          fit: BoxFit.cover,
                                                          width: double.infinity,
                                                        ),
                                                        Positioned(
                                                          left: 5,
                                                          top: 5,
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              color: Colors.black54,
                                                            ),
                                                            child: IconButton(
                                                              onPressed: () async {
                                                                bool? desc = await showDialog(
                                                                    context: context,
                                                                    builder: (context) {
                                                                      return Dialog(
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.all(12.0),
                                                                          child: Column(
                                                                            mainAxisSize: MainAxisSize.min,
                                                                            children: [
                                                                              SizedBox(height: 15),
                                                                              Text("Are you sure you want to delete this image?"),
                                                                              SizedBox(height: 15),
                                                                              Row(
                                                                                children: [
                                                                                  Expanded(
                                                                                    child: ElevatedButton(
                                                                                      onPressed: () {
                                                                                        Navigator.of(context).pop(false);
                                                                                      },
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                                                        child: Text("No"),
                                                                                      ),
                                                                                      style: ButtonStyle(
                                                                                          elevation: MaterialStateProperty.all<double>(10),
                                                                                          backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 210, 202, 221)),
                                                                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                                            borderRadius: BorderRadius.circular(10),
                                                                                          ))),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 10,
                                                                                  ),
                                                                                  Expanded(
                                                                                    child: ElevatedButton(
                                                                                      onPressed: () {
                                                                                        Navigator.of(context).pop(true);
                                                                                      },
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                                                        child: Text("Yes"),
                                                                                      ),
                                                                                      style: ButtonStyle(
                                                                                          elevation: MaterialStateProperty.all<double>(10),
                                                                                          backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 210, 202, 221)),
                                                                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                                            borderRadius: BorderRadius.circular(10),
                                                                                          ))),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      );
                                                                    });
                                                                if (desc == true) {
                                                                  String url = (AppController.to.loginMap['images'] as List).removeAt(index - 1);
                                                                  setState(() {});
                                                                  Navigator.of(context).pop();
                                                                  await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({"images": AppController.to.loginMap['images']});
                                                                  await FbFireStoreController().deleteFileFromFirebaseByUrl(url);
                                                                }
                                                              },
                                                              icon: const Icon(Icons.delete, color: Colors.red),
                                                            ),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          right: 5,
                                                          top: 5,
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              color: Colors.black54,
                                                            ),
                                                            child: IconButton(
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                              },
                                                              icon: const Icon(Icons.close, color: Colors.white),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });
                                        },
                                        child: Container(
                                          height: 120,
                                          width: 120,
                                          margin: EdgeInsetsDirectional.only(end: 10),
                                          child: Image.network(
                                            AppController.to.loginMap['images'][index - 1],
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                          ),
                                        ),
                                      );
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text('Availabilities'),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Container(
                                height: 40,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: AppController.to.loginMap['availableWifi'] ? Colors.green : Colors.red)),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 20),
                                      child: Text('Wifi'),
                                    ),
                                    AppController.to.loginMap['availableWifi']
                                        ? Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                          )
                                        : Icon(
                                            Icons.dangerous,
                                            color: Colors.red,
                                          ),
                                    SizedBox(
                                      width: 10,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Container(
                                height: 40,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: AppController.to.loginMap['availableBarking'] ? Colors.green : Colors.red)),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 20),
                                      child: Text('Parking'),
                                    ),
                                    AppController.to.loginMap['availableBarking']
                                        ? Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                          )
                                        : Icon(
                                            Icons.dangerous,
                                            color: Colors.red,
                                          ),
                                    SizedBox(
                                      width: 10,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text('Working Hours'),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: 40,
                            width: double.infinity,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: AppController.to.loginMap['workingHours'].length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Container(
                                  height: 40,
                                  padding: EdgeInsetsDirectional.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(border: Border.all(color: Color(0xff48358e)), borderRadius: BorderRadius.circular(20)),
                                  margin: EdgeInsetsDirectional.only(end: 10),
                                  child: Center(child: Text('${AppController.to.loginMap['workingHours'][index]['name']} ${AppController.to.loginMap['workingHours'][index]['Time']}')),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Visibility(
                      visible: widget.select == 2,
                      child: GestureDetector(
                        onTap: () {
                          offer.clear();
                          price.clear();
                          plan = null;
                          showDialog(
                              context: context,
                              builder: (context) {
                                Map<String, dynamic> data = AppController.to.loginMap['price'];

                                var sortedKeys = AppController.to.loginMap['price'].keys.toList()..sort((a, b) => int.parse(a).compareTo(int.parse(b)));

                                print('%%%%%%%%% $data $sortedKeys');
                                return StatefulBuilder(builder: (context, state) {
                                  return OfferDialog(
                                    nameController: offer,
                                    priceController: price,
                                    selectedPlan: plan,
                                    onTap: () {
                                      if (offer.text.isEmpty && price.text.isEmpty && plan == null) {
                                      } else {
                                        FbFireStoreController().addOffer(
                                          offerName: offer.text,
                                          month: plan == 0
                                              ? "1 month"
                                              : plan == 1
                                                  ? "3 month"
                                                  : plan == 2
                                                      ? "6 month"
                                                      : "12 month",
                                          price: price.text,
                                          gymName: AppController.to.loginMap['nameGym'],

                                        );
                                        offer.clear();
                                        price.clear();
                                        plan = null;
                                        Navigator.of(context).pop();
                                      }
                                    },
                                    children: List.generate(
                                      sortedKeys.length,
                                      (index) => Container(
                                        // color: Colors.green,
                                        child: FilterChip(
                                          padding: EdgeInsets.zero,
                                          showCheckmark: false,
                                          pressElevation: 0,
                                          selectedColor: plan == index ? Color(0xff48358e) : Colors.grey,
                                          label: Text(
                                            '${sortedKeys[index]} Month',
                                            style: TextStyle(color: plan == index ? Colors.white : Colors.black),
                                          ),
                                          selected: plan == index,
                                          onSelected: (selected) {
                                            state(() {
                                              plan = selected ? index : null;
                                              print('$plan');
                                            });
                                          },
                                          visualDensity: VisualDensity.compact,
                                        ),
                                      ),
                                    ),
                                  );
                                });
                              });
                        },
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_circle),
                              Text('Add offers'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Visibility(
                      visible: widget.select == 2,
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance.collection("offers").where('gymId', isEqualTo: AppController.to.loginMap['gymId']).snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  var data = snapshot.data?.docs[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          border: Border.all(color: Color(0xff48358e)),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  data?['offer_name'],
                                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                                                ),
                                                SizedBox(height: 6),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Month: ",
                                                      style: TextStyle(fontWeight: FontWeight.w500),
                                                    ),
                                                    Text("${data?['month']}"),
                                                  ],
                                                ),
                                                SizedBox(height: 6),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Price: ",
                                                      style: TextStyle(fontWeight: FontWeight.w500),
                                                    ),
                                                    Text("${data?['price']}"),
                                                  ],
                                                ),
                                              ],
                                            )),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    offer.text = data?['offer_name'];
                                                    price.text = data?['price'];
                                                    plan = data?['month'] == "1 month"
                                                        ? 0
                                                        : data?['month'] == "3 month"
                                                            ? 1
                                                            : data?['month'] == "6 month"
                                                                ? 2
                                                                : 3;
                                                    setState(() {});
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          var sortedKeys = AppController.to.loginMap['price'].keys.toList()..sort((a, b) => int.parse(a).compareTo(int.parse(b)));
                                                          return StatefulBuilder(builder: (context, state) {
                                                            return OfferDialog(
                                                              isUpdate: true,
                                                              nameController: offer,
                                                              priceController: price,
                                                              selectedPlan: plan,
                                                              onTap: () {
                                                                if (offer.text.isEmpty && price.text.isEmpty && plan == null) {
                                                                } else {
                                                                  FbFireStoreController().updateOffer(
                                                                    offerName: offer.text,
                                                                    month: plan == 0
                                                                        ? "1 month"
                                                                        : plan == 1
                                                                            ? "3 month"
                                                                            : plan == 2
                                                                                ? "6 month"
                                                                                : "12 month",
                                                                    price: price.text,
                                                                    docId: snapshot.data!.docs[index].id,
                                                                  );
                                                                  offer.clear();
                                                                  price.clear();
                                                                  Navigator.of(context).pop();
                                                                }
                                                              },
                                                              children: List.generate(
                                                                sortedKeys.length,
                                                                (index) => Container(
                                                                  // color: Colors.green,
                                                                  child: FilterChip(
                                                                    padding: EdgeInsets.zero,
                                                                    showCheckmark: false,
                                                                    pressElevation: 0,
                                                                    selectedColor: plan == index ? Color(0xff48358e) : Colors.grey,
                                                                    label: Text(
                                                                      '${sortedKeys[index]} Month',
                                                                      style: TextStyle(color: plan == index ? Colors.white : Colors.black),
                                                                    ),
                                                                    selected: plan == index,
                                                                    onSelected: (selected) {
                                                                      state(() {
                                                                        plan = selected ? index : null;
                                                                        print('$plan');
                                                                      });
                                                                    },
                                                                    visualDensity: VisualDensity.compact,
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          });
                                                        });
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Icon(Icons.edit),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    // offer.text = offers[index];
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return Dialog(
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(12.0),
                                                              child: Column(
                                                                mainAxisSize: MainAxisSize.min,
                                                                children: [
                                                                  SizedBox(height: 15),
                                                                  Text("Are you sure you want to delete this offer?"),
                                                                  SizedBox(height: 15),
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child: ElevatedButton(
                                                                          onPressed: () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                                            child: Text("Cancel"),
                                                                          ),
                                                                          style: ButtonStyle(
                                                                              elevation: MaterialStateProperty.all<double>(10),
                                                                              backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 210, 202, 221)),
                                                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(10),
                                                                              ))),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width: 10,
                                                                      ),
                                                                      Expanded(
                                                                        child: ElevatedButton(
                                                                          onPressed: () {
                                                                            FbFireStoreController().deleteOffer(
                                                                              docId: snapshot.data!.docs[index].id,
                                                                            );
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                                            child: Text("Delete Offer"),
                                                                          ),
                                                                          style: ButtonStyle(
                                                                              elevation: MaterialStateProperty.all<double>(10),
                                                                              backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 210, 202, 221)),
                                                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(10),
                                                                              ))),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        });
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Icon(Icons.delete),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                  );
                                },
                              );
                            } else {
                              return SizedBox();
                            }
                          }),
                    ),
                    Visibility(
                        visible: widget.select == 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                              stream: FbFireStoreController().getGymsReviewStream(gymId: gymData["gymId"]),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(
                                    child: SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation(Colors.black),
                                      ),
                                    ),
                                  );
                                }
                                final List<ReviewModel> reviews = [];
                                if (snapshot.hasData && snapshot.data != null) {
                                  for (var element in snapshot.data!.docs) {
                                    reviews.add(ReviewModel.fromJson(element.data()));
                                  }
                                  reviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
                                }
                                if (reviews.isNotEmpty) {
                                  return Column(
                                    children: [
                                      for (final review in reviews) ReviewTile(review: review),
                                    ],
                                  );
                                }
                                return const Center(
                                  child: Text("No reviews added yet"),
                                );
                              },
                            ),
                            const SizedBox(height: 15),
                          ],
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> pickImageAfterSelectForImage2({required BuildContext context}) async {
    ImagePicker imagePicker = ImagePicker();

    widget._pickedFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 25,
    );
    if (widget._pickedFile != null) {
      setState(() {});

      /// here code upload image to firebase
      File file = File(widget._pickedFile!.path);
      String url = await FbFireStoreController().uploadFile(imageFile: file, fileName: widget._pickedFile!.name);
      await FbFireStoreController().updateUser(data: {'logo2': url});
      setState(() {});
    }
  }

  Future<void> pickImageAfterSelectForAddImageGym({required BuildContext context}) async {
    ImagePicker imagePicker = ImagePicker();

    widget._pickedFile2 = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 25,
    );
    if (widget._pickedFile2 != null) {
      setState(() {});

      /// here code upload image to firebase
      File file = File(widget._pickedFile2!.path);
      String url = await FbFireStoreController().uploadFile(imageFile: file, fileName: widget._pickedFile2!.name);
      List imageList = AppController.to.loginMap['images'];
      imageList.add(url);
      await FbFireStoreController().updateUser(data: {'images': imageList});
      setState(() {});
    }
  }
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildHeader(context),
              builMenuItems(context),
            ],
          ),
        ),
      );

  Widget buildHeader(BuildContext context) => Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        ),
      );

  Widget builMenuItems(BuildContext context) => Column(
        children: [
          ListTile(
            leading: const Icon(
              Icons.list_alt,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            title: const Text(
              'Subscriptions',
            ),
            textColor: Color.fromARGB(255, 0, 0, 0),
            onTap: () {
              Get.back();
              Get.to(() => SubscriptionsPage());
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.supervised_user_circle,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            title: const Text(
              'Edit Profile',
            ),
            textColor: Color.fromARGB(255, 0, 0, 0),
            onTap: () {
              Get.to(EditProfile());
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            title: const Text('Logout'),
            textColor: Color.fromARGB(255, 0, 0, 0),
            onTap: () async {
              showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 15),
                            Text("Are you sure you want to logout?"),
                            SizedBox(height: 15),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text("No"),
                                    ),
                                    style: ButtonStyle(
                                        elevation: MaterialStateProperty.all<double>(10),
                                        backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 210, 202, 221)),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ))),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      FbAuthController().signOut();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text("Yes"),
                                    ),
                                    style: ButtonStyle(
                                        elevation: MaterialStateProperty.all<double>(10),
                                        backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 210, 202, 221)),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ))),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            },
          ),
        ],
      );
}
