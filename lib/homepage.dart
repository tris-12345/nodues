import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled/popup.dart';
import 'authenticate.dart';
import 'newrequests.dart';



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {

  final _auth= FirebaseAuth.instance;
  final _firestore=FirebaseFirestore.instance;
  var userdoc;
  late User loggedInUser;
  var ref = FirebaseFirestore.instance.collection('users');
  List months =['JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC'];

  @override
  void initState() {
    getcurrentuser();
    super.initState();

    print("initialte !!");
  }
  void getcurrentuser() async{
    final user= await _auth.currentUser!;
    if (user!=null){
      loggedInUser=user;
      currentuser = loggedInUser.uid.toString();
      print(currentuser);


      if(userdoc == null)print('yes');

    }
  }



  void messagesstream() async {
    await for (var snapshot in _firestore.collection('requests').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  Widget build(BuildContext context) {

    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(

            title: Text('Welcome'),
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.money_off), text: "Transactions"),
                Tab(icon: Icon(Icons.arrow_back_rounded), text: "My requests ")
              ],
            ),
          ),
          body: TabBarView(
            children: [
              //IconButton(onPressed: (){messagesstream();}, icon: Icon(Icons.connected_tv_sharp)),
              Column(
                  children:  <Widget>[
                    StreamBuilder<QuerySnapshot>(
                      stream: _firestore.collection('requests').snapshots(),
                      builder: (context,snapshot){
                        if (snapshot.hasData){
                          final requests=snapshot.data!.docs;
                          List<Widget> requestWidgets=[];
                          for (var request in requests!){
                            final requestsender=request['sender'];
                            final requestreceiver=request['receiver'];
                            final requestitem=request['item'];
                            final requeststatus=request['status'];
                            final id=request.id;
                            final day= request['day'];
                            final month= request['month'];

                            final messageWidget =
                            ListTile(
                              key: Key(id),
                              title: Text('$requestsender -> $requestreceiver '),
                              leading: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(day.toString(), style: TextStyle(fontWeight: FontWeight.normal, fontSize: 22),),
                                  Text(months[month-1], style: TextStyle(fontWeight: FontWeight.normal),),

                                ],
                              ),
                              subtitle: Text('$requestitem'),
                              trailing: Icon(Icons.arrow_right_sharp),
                            );

                            if(requeststatus == 'accepted'){
                              requestWidgets.add(messageWidget);
                              requestWidgets.add(const Divider(
                                color: Colors.grey, //color of divider
                                height: 5, //height spacing of divider
                                thickness: 0.5, //thickness of divier line
                                indent: 5, //spacing at the start of divider
                                endIndent: 5, //spacing at the end of divider
                              ));}
                          }

                          return Expanded(

                            child: Padding(
                              padding: const EdgeInsets.all(4.0),

                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: requestWidgets,
                                ),
                              ),

                            ),
                          );

                        }
                        return Text("");

                      },
                    ),


                  ]
              ),
              Column(
                  children:  <Widget>[
                    StreamBuilder<QuerySnapshot>(
                      stream: _firestore.collection('requests').snapshots(),
                      builder: (context,snapshot){
                        if (snapshot.hasData){
                          final requests=snapshot.data!.docs;
                          List<Widget> requestWidgets=[];
                          for (var request in requests!){
                            final requestsender=request['sender'];
                            final requestreceiver=request['receiver'];
                            final requestitem=request['item'];
                            final requeststatus=request['status'];
                            final id=request.id;
                            final day= request['day'];
                            final month= request['month'];

                            final messageWidget =
                            ListTile(


                              title: Text('$requestsender -> $requestreceiver '),
                              leading: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:

                                [

                                  Text(day.toString(), style: TextStyle(fontWeight: FontWeight.normal, fontSize: 22),),
                                  Text(months[month-1], style: TextStyle(fontWeight: FontWeight.normal),),

                                ],
                              ),
                              subtitle: Text('$requestitem'),
                              trailing: Icon(Icons.arrow_right_sharp),
                              onTap: () {
                                requestDialog(context, id);
                              },

                            );

                            if(requestreceiver == loggedInUser.email.toString() && requeststatus=='pending'){
                              requestWidgets.add(messageWidget);
                              requestWidgets.add(const Divider(
                                color: Colors.grey, //color of divider
                                height: 5, //height spacing of divider
                                thickness: 0.5, //thickness of divier line
                                indent: 5, //spacing at the start of divider
                                endIndent: 5, //spacing at the end of divider
                              ));}
                          }

                          return Expanded(

                            child: Padding(
                              padding: const EdgeInsets.all(4.0),

                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: requestWidgets,
                                ),
                              ),

                            ),
                          );

                        }
                        return Text("");

                      },
                    ),


                  ]
              ),
            ],
          ),



          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final user = _auth.currentUser;
              print(user?.uid);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const reqs()),
              );
            },
            backgroundColor: Colors.blue,
            child: const Icon(Icons.add),
          ),

        ),
      ),
    );
  }
}