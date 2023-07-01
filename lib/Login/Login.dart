import 'package:blockchain/MyhomePage.dart';
import 'package:blockchain/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late SharedPreferences sharedPreferences;
  
  bool isLoading = false;


  // void _getuser() async {
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   sharedPreferences.remove('id');
  // }


  @override
  void initState() {
    // _getuser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(

      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // status bar color
        statusBarIconBrightness: Brightness.light, // status bar icons' color
        systemNavigationBarIconBrightness: Brightness.light,
      ),

      child: Scaffold(

        backgroundColor: Colors.black,
          body: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: SizedBox(
              height: 300,
              child: Container(
                child: Lottie.network("https://assets5.lottiefiles.com/packages/lf20_VFbCSZv2yr.json",
                    height: 200,
                    width: 350),
              ),
            ),
          ),

          Container(
            child: Text(
              'INR TETHER',
              style: GoogleFonts.getFont('Bebas Neue',
                  fontSize: 35,
              color: Colors.white)
            ),
          ),

          Padding(
            padding:
                const EdgeInsets.only(bottom: 0, top: 0, right: 15, left: 15),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey.shade100),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextField(
                    controller: idController,
                    obscureText: true,
                    decoration: InputDecoration(
                        icon: Icon(Icons.person),
                        border: InputBorder.none,
                        hintText: '  User ID',
                        hintStyle: GoogleFonts.nunito(color: Colors.black)),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding:
            const EdgeInsets.only(bottom: 10, top: 0, right: 15, left: 15),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey.shade100),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        icon: Icon(Icons.lock),
                        border: InputBorder.none,
                        hintText: '  Password',
                        hintStyle: GoogleFonts.nunito(color: Colors.black)),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {

              setState(() {
                isLoading = true;
              });

              String id = idController.text.trim();
              String password = passwordController.text.trim();

              if (id.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("UserID is empty")));
                setState(() {
                  isLoading = false;
                });
              } else if (password.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Password is empty")));
                setState(() {
                  isLoading = false;
                });
              } else {
                QuerySnapshot snapshot = await FirebaseFirestore.instance
                    .collection('users')
                    .where('id', isEqualTo: id)
                    .get();

                try {
                  if (password == snapshot.docs[0]['password']) {
                    print("Success");

                    sharedPreferences = await SharedPreferences.getInstance();

                    sharedPreferences.setString('add', snapshot.docs[0]['SepholiaAcc']);


                    sharedPreferences.setString('id', id).then((_) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MyHomePage(title: 'INR Tether')));
                    });

                    setState(() {
                      isLoading = false;
                    });
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("Wrong Password")));

                    setState(() {
                      isLoading = false;
                    });
                  }
                } catch (e) {
                  String error = "";
                  if (e.toString() ==
                      "RangeError (index): Invalid value: Valid value range is empty: 0") {
                    setState(() {
                      error = "Invalid UserID";
                    });
                  } else {
                    setState(() {
                      error = "Error Occurred!";
                    });
                  }

                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(error)));
                }

                setState(() {
                  isLoading = false;
                });
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(8)
              ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 50,right: 50,top: 8,bottom: 8),
                  child: Text('Log In',
                  style: GoogleFonts.mulish(
                    fontWeight: FontWeight.w600,
                    fontSize: 17
                  ),),
                )),
          ),

          SizedBox(
            height: 80,
          ),


          !isLoading ? Container(
            child: SizedBox(
                height: 100,
                child: Image.asset(
                  'lib/assets/tether_icon.png',
                  height: 50,
                  width: 200,
                  color: Colors.grey,
                )),
          ) : Center(
              child: Shimmer.fromColors(
                  baseColor: Colors.orangeAccent,
                  highlightColor: Colors.white,
                  period: const Duration(
                      milliseconds: 900),
                  child: SizedBox(
                      height: 100,
                      child: Image.asset(
                        'lib/assets/tether_icon.png',
                        height: 50,
                        width: 200,
                      )))
          ),
          
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('CRYPTO TOKEN PEGGED TO INR',
                style: GoogleFonts.getFont('Bebas Neue',
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                    color: Colors.white)
            ),
          )
        
        
        ]),
      )),
    );
  }
}
