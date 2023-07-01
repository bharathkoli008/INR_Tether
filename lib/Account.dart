import 'package:http/http.dart';
import 'package:blockchain/MyhomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:web3dart/contracts.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';


class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  Future<void> add(String receiveAddress, String ownAddress,int amount, int has, String id2) async {
    await FirebaseFirestore.instance.collection('transactions').add({
      'from':id2,
      'to':receiveAddress,
      'fromAddress':ownAddress,
      'amt':amount,
      'time':Timestamp.now(),
      'status': (has == 66) ? 'succcessful' : 'failed'
    });
  }

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {




  late Client httpClient;
  late Web3Client ethereumClient;
  TextEditingController controller = TextEditingController();

  String Owneraddress = '0xB869faffaed891c692AC6E56454884177C161Ad1';
  String ethereumClientUrl =
      'https://sepolia.infura.io/v3/84a3ad8d884a4a8a9b37ca254056d103';
  String contractName = "INRToken";
  String private_key =
      '6ee0348f9db5a4401e520e288f33a613abd21182e5072c2adf31ef159bbf802a';

  double balance = 0;
  bool loading = false;

  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    DeployedContract contract = await getContract();
    ContractFunction function = contract.function(functionName);
    List<dynamic> result = await ethereumClient.call(
        sender: EthereumAddress.fromHex(Owneraddress),
        contract: contract, function: function, params: args);
    return result;
  }

  Future<DeployedContract> getContract() async {
    String abi =
        '[{"inputs":[{"internalType":"address","name":"minter","type":"address"}],"name":"addMinter","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"owner","type":"address"},{"indexed":true,"internalType":"address","name":"spender","type":"address"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"Approval","type":"event"},{"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"approve","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"burn","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"account","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"burnFrom","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"subtractedValue","type":"uint256"}],"name":"decreaseAllowance","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"emergencyStop","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"addedValue","type":"uint256"}],"name":"increaseAllowance","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"minter","type":"address"}],"name":"removeMinter","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"resume","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"recipient","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"transfer","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"from","type":"address"},{"indexed":true,"internalType":"address","name":"to","type":"address"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"Transfer","type":"event"},{"inputs":[{"internalType":"address","name":"sender","type":"address"},{"internalType":"address","name":"recipient","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"transferFrom","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"from","type":"address"},{"indexed":true,"internalType":"address","name":"to","type":"address"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"inrAmount","type":"uint256"}],"name":"TransferWithInr","type":"event"},{"inputs":[],"name":"updateInrPrice","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"address","name":"owner","type":"address"},{"internalType":"address","name":"spender","type":"address"}],"name":"allowance","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"account","type":"address"}],"name":"balanceOf","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"BLOCK_REWARD","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"cap","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"decimals","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"emergencyStopped","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"inrPrice","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"INRPRICE","outputs":[{"internalType":"int256","name":"","type":"int256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"account","type":"address"}],"name":"isContract","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"ISSUER_SUPPLY","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"minters","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"name","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"owner","outputs":[{"internalType":"address payable","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"symbol","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"totalSupply","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"}]';
    String contractAddress = "0x120662CBA6953f661bADef474eD258415E5Fa9F2";

    DeployedContract contract = DeployedContract(
      ContractAbi.fromJson(abi, contractName),
      EthereumAddress.fromHex(contractAddress),
    );

    return contract;
  }





  Future<String> Balanceofother(String address) async {
    setState(() {
      isBalanceLoading2 = true;
    });
    await query('updateInrPrice', []);
    List<dynamic> result = await query('balanceOf',[ EthereumAddress.fromHex(address)]);
    print("========${result.toString()}");
    var bal = result[0].toString();
    setState(() {
      isBalanceLoading2 = false;
    });

    return bal;
  }

  late SharedPreferences sharedPreferences;
  late String name;
  late String Address;
  late String id2;

  List<String> names = [];
  List<String> Addresses = [];

  List<String> transactions_amount = [];
  List<String> fromAdd = [];
  List<String> toAdd = [];
  List<String> timing = [];


  getData() async {



    sharedPreferences = await SharedPreferences.getInstance();

    var id = sharedPreferences.getString('id');

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: id)
        .get();


       await FirebaseFirestore.instance
        .collection('users')
        .get().then((value)  {
          value.docs.forEach((element) {
            setState(() {
              names.add(element['Name']);
              Addresses.add(element['SepholiaAcc']);

            });
          });
    });

    await FirebaseFirestore.instance
        .collection('transactions')
        .get().then((value)  {
      value.docs.forEach((element) {
        setState(() {
          timing.add(element['time'].toString());
          transactions_amount.add(element['amt'].toString());
          fromAdd.add(element['fromAddress'].toString());
          toAdd.add(element['to'].toString());

        });
      });
    });

    setState(() {
      id2 = snapshot.docs[0]['id'].toString();
      name = snapshot.docs[0]['Name'].toString();
      Address = snapshot.docs[0]['SepholiaAcc'].toString();
      isLoading = false;
    });
  }

  bool isLoading = true;
  bool isBalanceLoading2 = false;
  String othersBalance = '';
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    getData();
    super.initState();
    httpClient = Client();
    ethereumClient = Web3Client(ethereumClientUrl, httpClient);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      appBar:  AppBar(
      backgroundColor: Colors.black,
      toolbarHeight: 60,
      iconTheme: IconThemeData(color: Colors.white),
      title: Row(
        children: [
          Text(
            "In",
            style: GoogleFonts.getFont('Bebas Neue',
                fontSize: 35,
                color: Colors.white),
          ),
          Container(
              child: Image.asset(
                "lib/assets/tether_icon.png",
                height: 40,
              )),
          Text(
            "Tether",
            style: GoogleFonts.getFont('Bebas Neue',
                fontSize: 35,
                color: Colors.white),
          )
        ],
      ),
    ),

      body: !isLoading ?  SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SizedBox(
                height: 10,
              ),


              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: MediaQuery.of(context).size.height * 0.15,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12)
                ),

                child: Column(
                  children: [
                    Row(

                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child:  Row(
                                children: [
                                  !isBalanceLoading2 ?  !(othersBalance.toString().length > 5) ?   Text(' Check Balance : ' + othersBalance.toString() + ' ',
                                    style: GoogleFonts.mulish(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14
                                    ),) : Text(' Check Balance : ' + othersBalance.toString().substring(0,10) + ' ',
                                    style: GoogleFonts.mulish(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14
                                    ),) : Row(
                                    children: [
                                      Text('Balance',
                                        style: GoogleFonts.mulish(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14
                                        ),),
                                      CupertinoActivityIndicator(
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),

                                  Image.asset('lib/assets/tether_icon.png',
                                    height: 25 ,)
                                ],
                              ),
                            ),
                          ],
                        ),

                        GestureDetector(
                            onTap: () async {
                              MyHomePage(title: 'sds',);
                              othersBalance = await Balanceofother(addressController.text.trim());
                              setState(() {
                                othersBalance  = othersBalance;
                              });
                            },
                            child: Icon(Icons.refresh,color: Colors.white,))
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 20,right: 20),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey.shade100),
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: TextField(
                            obscureText: false,
                            controller: addressController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText:  ' Enter Address',
                                hintStyle: GoogleFonts.nunito(color: Colors.black)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

              ),



              Container(
                height: 300,
                child: ListView.builder(
                  itemCount: names.length,
                  itemBuilder: (BuildContext context,int index){
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: !(names[index] == name) ? Colors.black : Colors.grey.shade700,
                            borderRadius: BorderRadius.circular(8)
                        ),
                        child: ListTile(
                          trailing: GestureDetector(
                            onTap: (){
                              Clipboard.setData(
                                  ClipboardData(text: Addresses[index])
                              );
                            },
                            child: Icon(Icons.copy,
                            color: Colors.white,),
                          ),
                          title: Text(Addresses[index],

                          style: GoogleFonts.nunito(
                            color: Colors.grey,
                            fontSize: 18
                          ),),
                          subtitle: Text( !(names[index] == name) ? names[index] : 'You',
                          style: GoogleFonts.nunito(
                            color:  !(names[index] == name) ?  Colors.grey.shade700 : Colors.black
                          ),)
                        ),
                      ),
                    );
                  },
                ),
              ),


              Text('Transactions :',
              style: GoogleFonts.nunito(
                color: Colors.white
              ),),
              SingleChildScrollView(
                child: Container(
                  height: 280,
                  child: ListView.builder(
                    itemCount: fromAdd.length,
                    itemBuilder: (BuildContext context,int index){
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(8)
                          ),
                          child: ListTile(
                              title: Column(
                                children: [
                                  Text('from :' + fromAdd[index],

                                    style: GoogleFonts.nunito(
                                        color: Colors.grey,
                                        fontSize: 18
                                    ),),


                                  Text('Amount : '  + transactions_amount[index],
                                    style: GoogleFonts.nunito(
                                        color: Colors.grey.shade700
                                    ),),


                                ],
                              ),
                              subtitle: Column(
                                children: [
                                  Text('to :' + toAdd[index],

                                    style: GoogleFonts.nunito(
                                        color: Colors.grey,
                                        fontSize: 18
                                    ),),

                                ],
                              )
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ) :  Center(
        child: Shimmer.fromColors(
          baseColor: Colors.grey,
          highlightColor: Colors.white,
          period: const Duration(
              milliseconds: 900),
          child: SizedBox(
              height: 100,
              child: Image.asset(
                'lib/assets/tether_icon.png',
                height: 50,
                width: 200,
              ))),
      ),
    );
  }
}
