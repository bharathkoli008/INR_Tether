
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

const String privateKey =
    'bc265c2e014824d5f41cef6ccde2f8f1d0c9262b603f9ff8df1bc381368179b8';
const String rpcUrl = 'http://127.0.0.1:7545';

Future<void> main() async {
  // start a client we can use to send transactions
  final client = Web3Client(rpcUrl, Client());

  final credentials = EthPrivateKey.fromHex(privateKey);
  final address = credentials.address;

  print(address.hexEip55);
  print(await client.getBalance(address));

  await client.sendTransaction(
    credentials,
    Transaction(
      to: EthereumAddress.fromHex('0x7D98BB0A02153370fB5937C73b71e93a3C608219'),
      gasPrice: EtherAmount.inWei(BigInt.one),
      maxGas: 100000,
      value: EtherAmount.fromInt(EtherUnit.ether, 1),
    ),
  );

  print('Transaction Succedssful');

  await client.dispose();
}