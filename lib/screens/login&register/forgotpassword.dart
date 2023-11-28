import 'package:fitplus/firebase/fb_auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:fitplus/value/constant.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();

  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
    );
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Container(

      child: Scaffold(
        appBar: AppBar(
          elevation: 20, backgroundColor: const Color.fromARGB(255, 210, 199, 226),title: const Text('Forget Password'),centerTitle: true,titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20)),

        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column ( 
          children: [
            Container(),
            Container(
              width: 250,
              margin: const EdgeInsets.fromLTRB(80, 150, 85, 0),
              child: Image.asset('assets/logo.png'),
            ),
            
           
               Container(
              
                padding: EdgeInsets.only(
                    top: MediaQuery
                        .of(context)
                        .size
                        .height * 0.1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          TextField(
                            controller: emailController,
                            style: const TextStyle(
                                 color: Colors.black, fontSize: 25),
                            decoration: InputDecoration(
                                fillColor: const Color.fromARGB(255, 210, 202, 221),
                                filled: true,
                                 enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 123, 108, 108),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: "Email",
                                ),
                                
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [

                              CircleAvatar(
                                radius: 30,
                                backgroundColor: const Color.fromARGB(
                                    255, 179, 178, 178),
                                child: IconButton(
                                    color: Colors.white,
                                    onPressed: () async{
                                      if (emailController.text
                                          .trim()
                                          .isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text("Please enter a email"),
                                          backgroundColor: Colors.redAccent,));
                                      } else if (!isValidEmail(
                                          emailController.text.toString())) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text(
                                              "Please enter a valid email"),
                                          backgroundColor: Colors.redAccent,));
                                      } else {
                                        bool state =await FbAuthController().forgetPassword(
                                            context: context,
                                            email: emailController.text);
                                          if(state){
                                               showMaterialDialog_login(
                                                   context, 'A message has been sent to your email');
                                          }
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.arrow_forward,
                                    )),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                          ),

                        ],
                      ),
                    )
                  ],
                ),
              ),
            
            if(isLoading)

              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4)
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.deepPurpleAccent,),
                ),
              )
          ],
          )
        )
      ),
    );
  }
}
