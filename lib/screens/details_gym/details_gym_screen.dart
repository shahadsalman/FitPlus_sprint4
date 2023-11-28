// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitplus/components/review_tile.dart';
import 'package:fitplus/firebase/fb_firestore.dart';
import 'package:fitplus/firebase/fb_httpNotification.dart';
import 'package:fitplus/src/controller/splash_screens_controller.dart';
import 'package:fitplus/value/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../components/ratings_widget.dart';
import '../../components/review_dialog.dart';
import '../../models/review_model.dart';
import '../map_picker/map_view_screen.dart';

class DetailsGymScreen extends StatefulWidget {
  DetailsGymScreen({super.key, required this.data, this.subscribeUser = false, required this.currentUser, this.onBack});

  Map<String, dynamic>? paymentIntentData;
  final Function? onBack;
  int select = 1;
  late var data;
  final String currentUser;
  late bool subscribeUser;
  int price = 0;
  int month = 0;

  @override
  State<DetailsGymScreen> createState() => _DetailsGymScreenState();
}

class _DetailsGymScreenState extends State<DetailsGymScreen> {
  bool hasOffer = false;
  @override
  Widget build(BuildContext context) {
    final userData = AppController.to.loginMap;
    return Scaffold(
      appBar: AppBar(
      elevation: 20,
      backgroundColor: const Color.fromARGB(255, 210, 199, 226),
      title: const Text('Gym Description'),
      centerTitle: true,
      titleTextStyle: const TextStyle(color: Colors.black, fontSize: 18),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed:() => widget.onBack?.call(),
      ),
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
                    decoration: BoxDecoration(border: Border.all(color: const Color.fromARGB(255, 210, 199, 226))),
                    child: widget.data['logo2'].isEmpty
                        ? Center(child: Image.asset('assets/white.png'))
                        : Center(
                            child: Image.network(
                              widget.data['logo2'],
                              fit: BoxFit.fill,
                              width: double.infinity,
                              errorBuilder: (e, _, __) {
                                return Image.asset('assets/white.png');
                              },
                            ),
                          ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.bottomStart,
                    child: Container(
                        height: 100,
                        width: 100,
                        clipBehavior: Clip.antiAlias,
                        margin: const EdgeInsetsDirectional.only(start: 15),
                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black), color: Colors.black),
                        child: Container(
                          height: 95,
                          width: 95,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Color.fromARGB(255, 210, 199, 226)),
                          child: Image.network(
                            widget.data['logo'],
                            height: 100,
                            fit: BoxFit.fill,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(child: CircularProgressIndicator());
                            },
                          ),
                        )),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.data['nameGym'] ?? "",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 5,),
                      AverageRatingsWidget(gymId: widget.data["gymId"]),
                    ],
                  ),
                  //here abc
                  const SizedBox(height: 15),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                Get.to(() => const MapViewScreen(), arguments: {
                                  "gymLat": widget.data["gymLat"],
                                  "gymLng": widget.data["gymLng"],
                                  "locationGym": widget.data["locationGym"],
                                  "gymName": widget.data["nameGym"],
                                });
                              },
                              child: const Row(
                                children: [
                                  Icon(Icons.location_on, color: Color(0xff48358e)),
                                  SizedBox(width: 10),
                                  // Expanded(child: Text(widget.data['locationGym']))
                                  Text(
                                    "Gym Location",
                                    style: TextStyle(decoration: TextDecoration.underline),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Row(
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
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              //
                              if (!widget.subscribeUser) {
                                showSubscribe(context: context, dataGym: widget.data);
                              }
                            },
                            child: Container(
                              height: 40,
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                color: !widget.subscribeUser ? const Color.fromARGB(255, 186, 173, 205) : Colors.grey,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(child: Text(!widget.subscribeUser ? 'Subscribe Now' : 'subscribed', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsetsDirectional.all(10),
                    decoration: BoxDecoration(border: Border.all(color: const Color.fromARGB(255, 210, 199, 226)), borderRadius: BorderRadius.circular(10)),
                    child: Text(widget.data['descriptionGym']),
                  ),
                  const SizedBox(
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
                              const SizedBox(
                                height: 2,
                              ),
                              Container(
                                height: 2,
                                decoration: BoxDecoration(color: widget.select == 1 ? const Color(0xff48358e) : Colors.white),
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
                              const SizedBox(
                                height: 2,
                              ),
                              Container(
                                height: 2,
                                decoration: BoxDecoration(color: widget.select == 2 ? const Color(0xff48358e) : Colors.white),
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
                              const SizedBox(
                                height: 2,
                              ),
                              Container(
                                height: 2,
                                decoration: BoxDecoration(color: widget.select == 3 ? const Color(0xff48358e) : Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Visibility(
                    visible: widget.select == 1,
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Text('Photo GYM'),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          height: 120,
                          width: double.infinity,
                          child: widget.data['images'].isEmpty
                              ? const SizedBox(
                                  height: 120,
                                  width: 120,
                                  child: Text('Not Any Image For GYM'),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: widget.data['images'].length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return InkWell(
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
                                                        widget.data['images'][index],
                                                        fit: BoxFit.cover,
                                                        width: double.infinity,
                                                      ),
                                                      Positioned(
                                                        right: 5,
                                                        top: 5,
                                                        child: Container(
                                                          decoration: const BoxDecoration(
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
                                        margin: const EdgeInsetsDirectional.only(end: 10),
                                        child: Image.network(
                                          widget.data['images'][index],
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Row(
                          children: [
                            Text('Availabilities'),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Container(
                              height: 40,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: widget.data['availableWifi'] ? Colors.green : Colors.red)),
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    child: Text('Wifi'),
                                  ),
                                  widget.data['availableWifi']
                                      ? const Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                        )
                                      : const Icon(
                                          Icons.dangerous,
                                          color: Colors.red,
                                        ),
                                  const SizedBox(
                                    width: 10,
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Container(
                              height: 40,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: widget.data['availableBarking'] ? Colors.green : Colors.red)),
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    child: Text('Parking'),
                                  ),
                                  widget.data['availableBarking']
                                      ? const Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                        )
                                      : const Icon(
                                          Icons.dangerous,
                                          color: Colors.red,
                                        ),
                                  const SizedBox(
                                    width: 10,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Row(
                          children: [
                            Text('Working Hours'),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          height: 40,
                          width: double.infinity,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: widget.data['workingHours'].length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Container(
                                padding: const EdgeInsetsDirectional.symmetric(vertical: 10, horizontal: 10),
                                decoration: BoxDecoration(border: Border.all(color: const Color(0xff48358e)), borderRadius: BorderRadius.circular(20)),
                                margin: const EdgeInsetsDirectional.only(end: 10),
                                child: Text('${widget.data['workingHours'][index]['name']} ${widget.data['workingHours'][index]['Time']}'),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: widget.select == 2,
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance.collection("offers").where('gymId', isEqualTo: widget.data['gymId']).snapshots(),
                        builder: (context, snapshot) {
                          return !snapshot.hasData
                              ? const SizedBox(
                                  height: 150,
                                  child: Center(child: Text('No offers')),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    var data = snapshot.data?.docs[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            border: Border.all(color: const Color(0xff48358e)),
                                          ),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      data?['offer_name'],
                                                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                                                    ),
                                                    const SizedBox(height: 6),
                                                    Row(
                                                      children: [
                                                        const Text(
                                                          "Month: ",
                                                          style: TextStyle(fontWeight: FontWeight.w500),
                                                        ),
                                                        Text("${data?['month']}"),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 6),
                                                    Row(
                                                      children: [
                                                        const Text(
                                                          "Price: ",
                                                          style: TextStyle(fontWeight: FontWeight.w500),
                                                        ),
                                                        Text("${data?['price']}"),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 0,
                                                child: Align(
                                                  alignment: Alignment.topRight,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      if (!widget.subscribeUser) {
                                                        SVProgressHUD.show();
                                                        makePayment("${data?['price']}", month: int.parse("${data?['month']}".split(" ").first), isOffer: true, offerId: snapshot.data!.docs[index].id, offerName: data!['offer_name']);
                                                      }
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                                      decoration: BoxDecoration(
                                                        color: widget.subscribeUser ? Colors.grey : const Color.fromARGB(255, 186, 173, 205),
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                      child: Text(widget.subscribeUser ? "subscribed" : 'Subscribe Now', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          )),
                                    );
                                  },
                                );
                        }),
                  ),
                  Visibility(
                      visible: widget.select == 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (userData["typeAccount"] == 1)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.dialog(ReviewDialog(
                                      userName: "${userData["FName"]} ${userData["LName"]}",
                                      gymId: widget.data["gymId"],
                                    ));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(7),
                                    decoration: const BoxDecoration(color: kPrimaryColor, shape: BoxShape.circle),
                                    child: const Icon(Icons.add, size: 25, color: Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 20),
                              ],
                            ),
                          const SizedBox(height: 15),
                          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                            stream: FbFireStoreController().getGymsReviewStream(gymId: widget.data["gymId"]),
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
                                child: Text("No review added yet"),
                              );
                            },
                          ),
                          const SizedBox(height: 15),
                        ],
                      )),

                  // Visibility(
                  //   visible: widget.select == 3,
                  //   child: widget.data['reviews'].isEmpty
                  //       ? const SizedBox(
                  //           height: 150,
                  //           child: Center(child: Text('No Review')),
                  //         )
                  //       : ListView.builder(
                  //           physics: const NeverScrollableScrollPhysics(),
                  //           itemCount: widget.data['reviews'].length,
                  //           itemBuilder: (context, index) {
                  //             return Container(
                  //               height: 100,
                  //               color: Colors.red,
                  //             );
                  //           },
                  //         ),
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  showSubscribe({required BuildContext context, required var dataGym}) {
    Map<String, dynamic> data = dataGym['price'];
    var sortedKeys = data.keys.toList()..sort((a, b) => int.parse(a).compareTo(int.parse(b)));
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(20.0), topLeft: Radius.circular(20.0)),
        ),
        builder: (context) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: sortedKeys.length,
                    itemBuilder: (context, index) {
                      var month = sortedKeys[index];
                      var price = data[month.toString()];
                      return GestureDetector(
                        onTap: () {
                          widget.price = int.parse(price.toString());
                          widget.month = int.parse(month.toString());
                          SVProgressHUD.show();
                          Get.back();
                          makePayment(price.toString(), month: widget.month, isOffer: false);
                        },
                        child: Container(
                          height: 40,
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black),
                          ),
                          child: Center(child: Text('Subscribe ${month.toString()} Month in $price SAR')),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<void> makePayment(String amount, {required int month, required bool isOffer, String? offerId, String? offerName}) async {
    try {
      widget.paymentIntentData = await createPaymentIntent(amount, 'SAR'); //json.decode(response.body);
      // print('Response body==>${response.body.toString()}');
      await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(paymentIntentClientSecret: widget.paymentIntentData!['client_secret'], applePay: true, googlePay: true, testEnv: true, style: ThemeMode.dark, merchantCountryCode: 'SA', merchantDisplayName: 'ANNIE'));

      ///now finally display payment sheet
      if (isOffer) {
        displayPaymentSheetForOfferSubscription(price: num.parse(amount), month: month, offerId: offerId, offerName: offerName);
      } else {
        displayPaymentSheet(price: num.parse(amount), month: month);
      }
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet({required num price, required int month}) async {
    SVProgressHUD.dismiss();
    try {
      await Stripe.instance
          .presentPaymentSheet(
              parameters: PresentPaymentSheetParameters(
        clientSecret: widget.paymentIntentData!['client_secret'],
        confirmPayment: true,
      ))
          .then((newValue) {
        saveSubscriberUser(price: price, month: month);
        setState(() {
          widget.subscribeUser = true;
        });

        // print('payment intent'+widget.paymentIntentData!['id'].toString());
        // print('payment intent'+widget.paymentIntentData!['client_secret'].toString());
        // print('payment intent'+widget.paymentIntentData!['amount'].toString());
        // print('payment intent'+widget.paymentIntentData.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "paid successfully",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );

        widget.paymentIntentData = null;
      }).onError((error, stackTrace) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Payment process Incomplete",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );

        print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Exception/DISPLAYPAYMENTSHEET==> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      print('$e');
    }
  }

  displayPaymentSheetForOfferSubscription({required num price, required int month, String? offerId, String? offerName}) async {
    SVProgressHUD.dismiss();
    try {
      await Stripe.instance
          .presentPaymentSheet(
              parameters: PresentPaymentSheetParameters(
        clientSecret: widget.paymentIntentData!['client_secret'],
        confirmPayment: true,
      ))
          .then((newValue) async {
        saveSubscriberUser(offerId: offerId, offerName: offerName, price: price, month: month);
        setState(() {
          widget.subscribeUser = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "paid successfully",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );

        widget.paymentIntentData = null;
      }).onError((error, stackTrace) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Payment process Incomplete",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );

        print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Exception/DISPLAYPAYMENTSHEET==> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      print('$e');
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        // 'amount': '${widget.price.toString()}00',
        'amount': '${amount}00',
        // 'amount': calculateAmount(widget.price.toString()),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      print(body);
      var response = await http.post(Uri.parse('https://api.stripe.com/v1/payment_intents'), body: body, headers: {'Authorization': 'Bearer sk_test_51KeFcDDG7u6dEAF5zPLPSwx75U5njpZxgeGdJoTzypzLMyISXaR0XIiCrPwNAyJjso39mYdyQTYGlMiQcrf3fsYF00BN2wmb7C', 'Content-Type': 'application/x-www-form-urlencoded'});
      print('Create Intent reponse ===> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount));
    return a.toString();
  }

  saveSubscriberUser({required num price, required int month, String? offerId, String? offerName}) {
    // send Notification to gym
    List fcm = [];
    String fcmToken = widget.data['fcm'] ?? '';
    fcm.add(fcmToken);
    FbHttpNotificationRequest().sendNotification('New Subscribe', 'You have New Subscriber', fcm);
    String uid = DateTime.now().microsecondsSinceEpoch.toString();
    // save Notification in FireStore
    var token = FirebaseAuth.instance.currentUser!.uid;
    FbFireStoreController().createDocument(data: {
      'userId': token,
      'gymId': widget.data['gymId'],
      'userName': '${AppController.to.loginMap['FName']} ${AppController.to.loginMap['LName']}',
      'nameGym': widget.data['nameGym'],
      'userEmail': AppController.to.loginMap['email'],
      'gymEmail': widget.data['email'],
      // 'month': widget.month,
      // 'price': widget.price,
      'month': month,
      'price': price,
      'showNotification': false,
      "offerId": offerId,
      "offerName": offerName,
      'orderBy': uid,
      'dateStartSubscriber': DateTime.now().toString().split(' ')[0],
      // 'dateEndSubscriber': DateTime.now().add(Duration(days: (30 * widget.month))).toString().split(' ')[0],
      'dateEndSubscriber': DateTime.now().add(Duration(days: (30 * month))).toString().split(' ')[0],
    }, uid: uid, nameCollection: 'subscribers');
    FbFireStoreController().updateArray(nameCollection: 'users', data: [widget.data['gymId']], nameDoc: token, nameList: 'listSubscribe');
    FbFireStoreController().updateArray(nameCollection: 'users', data: [token], nameDoc: widget.data['gymId'], nameList: 'listSubscribe');
  }
}
