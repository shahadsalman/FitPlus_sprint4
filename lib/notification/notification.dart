import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitplus/firebase/fb_firestore.dart';
import 'package:fitplus/src/controller/splash_screens_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/subscriptions/subscriptions.dart';
//import 'package:gap/gap.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(elevation: 20, backgroundColor: const Color.fromARGB(255, 210, 199, 226), title: const Text('Notification'), centerTitle: true, titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20)),
        body: StreamBuilder<QuerySnapshot>(
          stream: FbFireStoreController().read(nameCollection: 'subscribers', descending: true, orderBy: 'orderBy'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              List<QueryDocumentSnapshot> data = snapshot.data!.docs;
              List<QueryDocumentSnapshot> listSubscriptions = [];
              if (AppController.to.loginMap['typeAccount'] == 2) {
                /// list subscribers gym
                for (var item in data) {
                  if (item['gymEmail'] == AppController.to.loginMap['email']) {
                    listSubscriptions.add(item);
                  }
                }
              } else {
                /// list subscribers user
                for (var item in data) {
                  if (item['userEmail'] == AppController.to.loginMap['email']) {
                    listSubscriptions.add(item);
                  }
                }
              }
              return ListView.separated(
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => const SubscriptionsPage());
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.notifications_active,
                              color: Colors.black,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text('You have New Subscriber'),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              '( ${listSubscriptions[index]['userName']} )',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Container(
                      height: 2,
                      color: const Color(0xff48358e),
                    );
                  },
                  itemCount: listSubscriptions.length);
            } else {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.warning, size: 85, color: Colors.grey.shade500),
                    Text(
                      'Empty',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'TimesNewRoman',
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ),
      );
}
