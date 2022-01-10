import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:wheel_date_picker/wheel_date_picker.dart';
import 'package:rootally_ai/wheel_slider.dart';
import 'package:rootally_ai/src/pointer_config.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  //double _value=0;
  // final PointerConfig config;
  // final ValueChanged<int> onChanged;

  _MyHomePageState();

  @override
  Widget build(BuildContext context) {

    late final _dbRef = FirebaseDatabase.instance.ref().child("sliderID");
    late DatabaseReference databaseReference;

    getData(int index){
      _dbRef.once().then((snapshot)async{
        print("${_dbRef.orderByChild("id").equalTo(index)}");
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xffb7f2ec),//a1eee4
      resizeToAvoidBottomInset: false,
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: SafeArea(
        child: Align(
          widthFactor: double.infinity,
          heightFactor: double.infinity,
          alignment: Alignment.topCenter,
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 150,top: 10),
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffa1eee4)),
              ),//center_small_circle
              Container(
                margin: const EdgeInsets.only(left:280,top: 40),
                width: 150,
                height: 130,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(70), bottomLeft: Radius.circular(70),topRight: Radius.circular(60),bottomRight: Radius.circular(50)),
                    color: Color(0xffa1eee4)),
              ),//right_circle
              Container(
                margin: const EdgeInsets.only(top: 60),
                width: 140,
                height: 140,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(70)),
                    color: Color(0xffa1eee4)),
              ),//left_circle
              Positioned(
                  child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_back, color: Colors.black,))),//back_button
              Container(
                margin: const EdgeInsets.only(top: 65, left: 30),
                  width: 180,
                  height: 60,
                  child: const Text("You have 2 more sessions today", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),)),//Text_Msg
              Container(
                width: double.infinity,
                height: double.maxFinite,
                margin: const EdgeInsets.only(top: 135),
                decoration: const BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(20)),color: Colors.white),//horizontal(right: Radius.circular(20),left: Radius.circular(20)
                child: Padding(
                  padding: const EdgeInsets.only(top: 75.0, ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("Pain score",style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),),
                            Text("How does your knee feel now ?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),],
                        ),
                      ),//Pain_Score_Text
                      Container(
                        //color: Colors.red,
                        margin: const EdgeInsets.only(top: 100),
                        height: 250,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              //https://www.youtube.com/watch?v=SyTsLE9L2YM
                              ElevatedButton(child: const Text("Get Data"), onPressed: (){},),
                              WheelSlider(config: PointerConfig(color: const Color(0xffcccad8)),onChanged: (_){},),
                              const Text("Discomfort", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
                            ],
                          ),
                        ),
              ),
              // WheelDatePickerSlider(
              //   onChanged: (_) {},
              //   initialDate: 0,
              //   config: PointerConfig(color: const Color(0xffcccad8)),
              // ),
            ],
          ),
        ),
      ),
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 550),
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50))),
                  child: TextButton(
                    onPressed: (){
                      getData(1);
                    },
                    child: const Text("Submit",style: TextStyle(fontSize: 18),),
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.only(left:120, right:120, top: 10, bottom: 10)
                        ),
                        backgroundColor: MaterialStateProperty.all(Colors.white),
                        foregroundColor: MaterialStateProperty.all(Colors.black),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50),side: const BorderSide(color: Colors.black,width: 3)))),
                  ),
                ),
              ),
              FirebaseAnimatedList(
                  query: _dbRef
                  .orderByChild("id")
                  .equalTo(5),
                  itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index){
                    return Text(snapshot.value!["emoji"]);
                  })// This trailing comma makes auto-formatting nicer for build methods.
    ],

    ),
    ),
    ),
    );
  }
}
