import 'package:blockchain/Account.dart';
import 'package:blockchain/Login/AuthCheck.dart';
import 'package:blockchain/Login/Login.dart';
import 'package:blockchain/main.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:web3dart/web3dart.dart';
import 'dart:math';

class MyHomePage extends StatefulWidget {
  MyHomePage({required this.title});
  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  late Client httpClient;
  late Web3Client ethereumClient;
  TextEditingController controller = TextEditingController();
  var instance = const Account();

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
        sender: EthereumAddress.fromHex(ownAddress),
        contract: contract,
        function: function,
        params: args);
    return result;
  }

  Future<String> transaction(String functionName, List<dynamic> args) async {
    EthPrivateKey credential = EthPrivateKey.fromHex(private_key);
    DeployedContract contract = await getContract();
    ContractFunction function = contract.function(functionName);
    dynamic result = await ethereumClient.sendTransaction(
      credential,
      Transaction.callContract(
        from: EthereumAddress.fromHex(ownAddress),
        contract: contract,
        function: function,
        parameters: args,
      ),
      fetchChainIdFromNetworkId: true,
      chainId: null,
    );

    return result;
  }

  Future<DeployedContract> getContract() async {
    String abi =
        '[{"inputs":[{"internalType":"address","name":"minter","type":"address"}],"name":"addMinter","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"owner","type":"address"},{"indexed":true,"internalType":"address","name":"spender","type":"address"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"Approval","type":"event"},{"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"approve","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"burn","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"account","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"burnFrom","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"subtractedValue","type":"uint256"}],"name":"decreaseAllowance","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"emergencyStop","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"addedValue","type":"uint256"}],"name":"increaseAllowance","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"minter","type":"address"}],"name":"removeMinter","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"resume","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"recipient","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"transfer","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"from","type":"address"},{"indexed":true,"internalType":"address","name":"to","type":"address"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"Transfer","type":"event"},{"inputs":[{"internalType":"address","name":"sender","type":"address"},{"internalType":"address","name":"recipient","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"transferFrom","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"from","type":"address"},{"indexed":true,"internalType":"address","name":"to","type":"address"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"inrAmount","type":"uint256"}],"name":"TransferWithInr","type":"event"},{"inputs":[],"name":"updateInrPrice","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"address","name":"owner","type":"address"},{"internalType":"address","name":"spender","type":"address"}],"name":"allowance","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"account","type":"address"}],"name":"balanceOf","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"BLOCK_REWARD","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"cap","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"decimals","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"emergencyStopped","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"inrPrice","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"INRPRICE","outputs":[{"internalType":"int256","name":"","type":"int256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"account","type":"address"}],"name":"isContract","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"ISSUER_SUPPLY","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"minters","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"name","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"owner","outputs":[{"internalType":"address payable","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"symbol","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"totalSupply","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"}]';
    String contractAddress = "0x929f2e6944915B10452Dc4d5f18BF46a1B53BEf9";

    DeployedContract contract = DeployedContract(
      ContractAbi.fromJson(abi, contractName),
      EthereumAddress.fromHex(contractAddress),
    );

    return contract;
  }

  Future<void> getBalance() async {
    loading = true;
    setState(() {});
    await query('updateInrPrice', []);
    List<dynamic> result2 = await query('updateInrPrice', []);
    List<dynamic> result = await query('INRPRICE', []);
    balance = (double.parse(result[0].toString()) * pow(10, -4)) * 1.1093;
    loading = false;
    print(balance.toString());
    print(result2.toString());
    setState(() {});
  }

  Future<String> Balanceof(String address) async {
    setState(() {
      isBalanceLoading = true;
    });
    await query('updateInrPrice', []);
    List<dynamic> result =
        await query('balanceOf', [EthereumAddress.fromHex(address)]);
    print("========${result.toString()}");
    var bal = result[0].toString();
    setState(() {
      isBalanceLoading = false;
    });

    return bal;
  }

  Future<String> Balanceofother(String address) async {
    setState(() {
      isBalanceLoading2 = true;
    });
    await query('updateInrPrice', []);
    List<dynamic> result =
        await query('balanceOf', [EthereumAddress.fromHex(address)]);
    print("========${result.toString()}");
    var bal = result[0].toString();
    setState(() {
      isBalanceLoading2 = false;
    });

    return bal;
  }

  Future<String> getOwnerAddress() async {
    setState(() {});
    List<dynamic> result = await query('owner', []);
    var name = result[0].toString();
    setState(() {});
    return name;
  }

  Future<String> transferINR(
      String sourceAddress, String address, int amount) async {
    String result = await transaction('transferFrom', [
      EthereumAddress.fromHex(ownAddress),
      EthereumAddress.fromHex(address),
      BigInt.from(amount)
    ]);
    print("========${result.toString()}");
    var bal = result[0].toString();
    return bal;
  }

  Future<void> transfer_amt_direct(String receiveAddress, int amount) async {
    setState(() {
      istransferring = true;
    });

    String result4 = await transaction(
        'increaseAllowance', [EthereumAddress.fromHex(ownAddress), BigInt.from(1)]);
    print("===app=====${result4.toString()}");



    String result2 = await transaction('transfer', [
      EthereumAddress.fromHex(receiveAddress),
      BigInt.from(amount)
    ]);

    String has = 'trans' + result2.toString();

    instance.add(receiveAddress, ownAddress, amount, result2.toString().length, id2);

    print("====trans====${result2.toString()}");




    setState(() {
      istransferring = false;
    });
  }

  Future<void> transfer_amt(String receiveAddress, int amount) async {
    setState(() {
      istransferring = true;
    });

    String result4 = await transaction(
        'approve', [EthereumAddress.fromHex(ownAddress), BigInt.from(10)]);
    print("===app=====${result4.toString()}");

    String result6 = await transaction(
        'approve', [EthereumAddress.fromHex(receiveAddress), BigInt.from(10)]);
    print("===app=====${result6.toString()}");

    String result7 = await transaction('increaseAllowance',
        [EthereumAddress.fromHex(ownAddress), BigInt.from(1000000)]);
    print("===all=====${result7.toString()}");

    String result3 = await transaction('increaseAllowance',
        [EthereumAddress.fromHex(receiveAddress), BigInt.from(1000000)]);
    print("===all=====${result3.toString()}");

    String result2 = await transaction('transferFrom', [
      EthereumAddress.fromHex(Owneraddress),
      EthereumAddress.fromHex(receiveAddress),
      BigInt.from(amount)
    ]);

    String has = 'trans' + result2.toString();

    instance.add(receiveAddress, ownAddress, amount, result2.toString().length, id2);

    print("====trans====${result2.toString()}");




    setState(() {
      istransferring = false;
    });
  }

  Future<int> getCap() async {
    loading = true;
    setState(() {});
    List<dynamic> result = await query('cap', []);
    var cap = int.parse(result[0].toString().substring(0, 8));
    loading = false;
    setState(() {});
    return cap;
  }

  Future<int> getReward() async {
    loading = true;
    setState(() {});
    List<dynamic> result = await query('BLOCK_REWARD', []);
    blockReward = int.parse(result[0].toString().substring(0, 2));
    loading = false;
    setState(() {});
    return blockReward;
  }

  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    getData();
    super.initState();
    httpClient = Client();
    ethereumClient = Web3Client(ethereumClientUrl, httpClient);
    getBalance();
  }

  int cap = 0;
  int blockReward = 0;
  String ownBalance = '';
  String othersBalance = '';
  String name = '';
  String balanceOfOwner = '';
  bool addressFilled = false;
  bool isLoading = true;
  bool isBalanceLoading = false;
  bool isBalanceLoading2 = false;
  bool istransferring = false;
  TextEditingController transferController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  late String ownAddress;
  late String id2;

  getData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    //
    ownAddress = sharedPreferences.getString('add')!;
    id2 = sharedPreferences.getString('id')!;
    //
    // var snapshot = await db.FirebaseFirestore.instance
    //     .collection('users')
    //     .where('id', isEqualTo: id)
    //     .get();
    //
    // setState(() {
    //   id2 = snapshot.docs[0]['id'].toString();
    //   ownAddress = snapshot.docs[0]['SepholiaAcc'].toString();
    //   isLoading = false;
    // });

    setState(() {
      ownAddress = ownAddress;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: SizedBox.expand(
          child: ListView(
            children: [
              DrawerHeader(
                child: Center(
                  child: SizedBox(
                      height: 100,
                      child: Image.asset(
                        'lib/assets/tether_icon.png',
                        height: 50,
                        width: 200,
                        color: Colors.grey,
                      )),
                ),
              ),
              ListTile(
                onTap: () async {
                  sharedPreferences = await SharedPreferences.getInstance();
                  sharedPreferences.remove('id').then((_) => Navigator.push(
                          context, MaterialPageRoute(builder: (context) {
                        return Login();
                      })));
                },
                leading: Icon(
                  Icons.person,
                  color: Colors.grey,
                ),
                title: Text(
                  "Logout",
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
              ),
              SizedBox(
                height: 400,
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 80,
        iconTheme: IconThemeData(color: Colors.white),
        title: Row(
          children: [
            Text(
              "In",
              style: GoogleFonts.getFont('Bebas Neue',
                  fontSize: 35, color: Colors.white),
            ),
            Container(
                child: Image.asset(
              "lib/assets/tether_icon.png",
              height: 40,
            )),
            Text(
              "Tether",
              style: GoogleFonts.getFont('Bebas Neue',
                  fontSize: 35, color: Colors.white),
            )
          ],
        ),
        actions: [
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Account();
                }));
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        'Accounts ',
                        style: GoogleFonts.nunito(color: Colors.white),
                      ),
                      Icon(Icons.person)
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: Scaffold(
        backgroundColor: Colors.grey.shade800,
        floatingActionButton: Visibility(
          visible: !keyboardIsOpen,
          child: FloatingActionButton.extended(
            onPressed: getBalance,
            label: Row(
              children: [
                Text("Current Price  ",
                    style: GoogleFonts.mulish(
                        color: Colors.black, fontWeight: FontWeight.w600)),
                loading
                    ? CircularProgressIndicator(
                        color: Colors.black,
                      )
                    : Text(balance.toString().substring(0, 6) + ' INR',
                        style: GoogleFonts.mulish(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.w700)),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: SingleChildScrollView(
          child: !isLoading
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.95,
                        height: MediaQuery.of(context).size.height * 0.285,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, right: 8),
                                child: Row(
                                  children: [
                                    Text(
                                      'Transfer ',
                                      style: GoogleFonts.mulish(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20),
                                    ),
                                    Container(
                                        child: Image.asset(
                                      "lib/assets/tether_icon.png",
                                      height: 40,
                                    )),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'to any ',
                                      style: GoogleFonts.mulish(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20),
                                    ),
                                    Text(
                                      'Account',
                                      style: GoogleFonts.mulish(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, right: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.grey.shade100),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: TextField(
                                      obscureText: false,
                                      controller: !addressFilled
                                          ? transferController
                                          : amountController,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: !addressFilled
                                              ? '  Address'
                                              : 'Enter Amount',
                                          hintStyle: GoogleFonts.nunito(
                                              color: Colors.black)),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Center(
                                child: GestureDetector(
                                  onTap: () {
                                    if (transferController.text
                                            .toString()
                                            .length >=
                                        40) {
                                      setState(() {
                                        addressFilled = true;
                                      });
                                    }

                                    if (amountController.text.isNotEmpty) {
                                      transfer_amt(
                                          transferController.text.trim(),
                                          int.parse(
                                              amountController.text.trim()));
                                      // transferINR(ownAddress,transferController.text.trim(),int.parse(amountController.text.trim()));
                                      setState(() {
                                        addressFilled = false;
                                        transferController.clear();
                                        amountController.clear();
                                      });
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blueAccent,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 90,
                                          right: 90,
                                          top: 3,
                                          bottom: 3),
                                      child: !istransferring
                                          ? Text(
                                              !addressFilled
                                                  ? 'Transfer'.toUpperCase()
                                                  : 'Submit'.toUpperCase(),
                                              style: GoogleFonts.mulish(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 22))
                                          : Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.65,
                                              child: CupertinoActivityIndicator(
                                                color: Colors.white,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: MediaQuery.of(context).size.height * 0.1,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              children: [
                                !isBalanceLoading
                                    ? Text(
                                        !isLoading
                                            ? 'Balance : ' +
                                                ownBalance.toString() +
                                                ' '
                                            : 'Balance : ',
                                        style: GoogleFonts.mulish(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14),
                                      )
                                    : Row(
                                        children: [
                                          Text(
                                            'Balance',
                                            style: GoogleFonts.mulish(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14),
                                          ),
                                          CupertinoActivityIndicator(
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                Image.asset(
                                  'lib/assets/tether_icon.png',
                                  height: 25,
                                )
                              ],
                            ),
                          ),
                          GestureDetector(
                              onTap: () async {
                                ownBalance = await Balanceof(ownAddress);
                                setState(() {
                                  ownBalance = ownBalance;
                                });
                              },
                              child: Icon(
                                Icons.refresh,
                                color: Colors.white,
                              ))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 200,
                      child: PageView(
                        controller: PageController(
                          initialPage: 1,
                          viewportFraction: 0.9,
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Container(
                                width: MediaQuery.of(context).size.width * 0.98,
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: TextField(
                                                obscureText: false,
                                                controller: addressController,
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: ' Enter Address',
                                                    hintStyle:
                                                        GoogleFonts.nunito(
                                                            color:
                                                                Colors.black)),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            await transfer_amt(addressController.text, 5);
                                          },
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.cyanAccent,
                                                  borderRadius:
                                                      BorderRadius.circular(12)),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 25,
                                                    right: 25,
                                                    top: 12,
                                                    bottom: 12),
                                                child: Text(
                                                  'Send 5 Tokens',

                                                  style: GoogleFonts.mulish(
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 15),
                                                ),
                                              )),
                                        ),
                                      ],
                                    ))),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Container(
                                width: MediaQuery.of(context).size.width * 0.98,
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: TextField(
                                                obscureText: false,
                                                controller: addressController,
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: ' Enter Address',
                                                    hintStyle:
                                                        GoogleFonts.nunito(
                                                            color:
                                                                Colors.black)),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            await transfer_amt(addressController.text, 10);
                                          },
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.yellowAccent,
                                                  borderRadius:
                                                      BorderRadius.circular(12)),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 25,
                                                    right: 25,
                                                    top: 12,
                                                    bottom: 12),
                                                child: Text(
                                                  'Send 10 Tokens',
                                                  style: GoogleFonts.mulish(
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 15),
                                                ),
                                              )),
                                        ),
                                      ],
                                    ))),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Container(
                                width: MediaQuery.of(context).size.width * 0.98,
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: TextField(
                                                obscureText: false,
                                                controller: addressController,
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: ' Enter Address',
                                                    hintStyle:
                                                        GoogleFonts.nunito(
                                                            color:
                                                                Colors.black)),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            await transfer_amt(addressController.text, 15);
                                          },
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.pinkAccent,
                                                  borderRadius:
                                                      BorderRadius.circular(12)),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 25,
                                                    right: 25,
                                                    top: 12,
                                                    bottom: 12),
                                                child: Text(
                                                  'Send 15 Tokens',
                                                  style: GoogleFonts.mulish(
                                                    fontWeight: FontWeight.w700,
                                                      fontSize: 15),
                                                ),
                                              )),
                                        ),
                                      ],
                                    ))),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                )
              : Center(
                  heightFactor: 6,
                  child: Shimmer.fromColors(
                      baseColor: Colors.grey,
                      highlightColor: Colors.white,
                      period: const Duration(milliseconds: 900),
                      child: SizedBox(
                          height: 100,
                          child: Image.asset(
                            'lib/assets/tether_icon.png',
                            height: 50,
                            width: 200,
                          ))),
                ),
        ),
      ),
    );
  }
}
