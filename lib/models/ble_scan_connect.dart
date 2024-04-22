import 'dart:io';
import 'dart:convert';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';

class BleScanConnect {
  late BluetoothDevice device1;
  late BluetoothDevice device2;
  BluetoothAdapterState? states;
  int leftperc = 60;
  int rightperc = 40;
  List<String> lefttoeoutputs = [];
  List<String> leftheeloutputs = [];
  List<String> righttoeoutputs = [];
  List<String> rightheeloutputs = [];
  final String characteristicUuidRt = "beb5483e-36e1-4688-b7f5-ea07361b26a8";
  final String characteristicUuidRh = "b478a77f-7777-459f-b999-a6d3eaaddbe1";
  final String characteristicUuidLt = "c3b19f80-4e80-48e0-b3b5-0fcaa545e3db";
  final String characteristicUuidLh = "444238fa-5fd4-40cf-8c41-700babfc7aca";

  void scan() async {
    print("Scanning");
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.setStringList('righttoe', righttoeoutputs);
    // prefs.setStringList('rightheel', rightheeloutputs);
    //prefs.setStringList('leftheel', leftheeloutputs);
    //prefs.setStringList('lefttoe', lefttoeoutputs);
    FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);

    if (await FlutterBluePlus.isSupported == false) {
      print("Bluetooth not supported by this device");
      return;
    }
    var subscription = FlutterBluePlus.adapterState
        .listen((BluetoothAdapterState state) async {
      states = state;
      print(state);
    });

    if (Platform.isAndroid) {
      await FlutterBluePlus.turnOn();
    }

    if (states == BluetoothAdapterState.on) {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));

      FlutterBluePlus.onScanResults.listen(
        (results) async {
          if (results.isNotEmpty) {
            ScanResult r = results.last; // the most recently found device
            print(
                '${r.device.remoteId}: "${r.advertisementData.advName}" found!');

            if (r.advertisementData.advName == "SmartStepleft") {
              device1 = r.device;

              print("left Device found");
            }
            if (r.advertisementData.advName == "SmartStepright") {
              device2 = r.device;

              print("right Device found");
            }
          }
        },
        onError: (e) => print(e),
      );

      // FlutterBluePlus.cancelWhenScanComplete(subscription2);

      await FlutterBluePlus.adapterState
          .where((val) => val == BluetoothAdapterState.on)
          .first;

      await FlutterBluePlus.isScanning.where((val) => val == false).first;

//        var subscription3 =
      //          device.connectionState.listen((BluetoothConnectionState state) async {
      //    if (state == BluetoothConnectionState.disconnected) {
      //        print("${device.disconnectReason}");
      //  }
      //});

      // device.cancelWhenDisconnected(subscription3, delayed: true, next: true);

      //await device.connect();

      // List<BluetoothService> services = await device.discoverServices();
      // services.forEach((service) async {
      // var characteristics = service.characteristics;
      //for (BluetoothCharacteristic c in characteristics) {
      // List value = await c.read();
      // print("kittti value $value");
      // }
      // });
      // List<BluetoothDevice> devs = FlutterBluePlus.connectedDevices;
      // for (var d in devs) {
      // print("ithanu devices $d");
      //}

      // subscription3.cancel();
      // measureweight();
      connectandlisten(device1, device2);

      
    } else {
      print("Bluetooth is off,could not connect");
    }
    subscription.cancel();
  }

  void printOutput() async {
    await device1.disconnect();
    await device2.disconnect();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<dynamic>? leftitem1 = prefs.getStringList('lefttoe');
    final List<dynamic>? leftitem2 = prefs.getStringList('leftheel');
    final List<dynamic>? rightitem1 = prefs.getStringList('righttoe');
    final List<dynamic>? rightitem2 = prefs.getStringList('rightheel');

// Create a new Excel workbook
    var excel = Excel.createExcel();

    // Add a worksheet to the workbook
    Sheet sheet = excel['Sheet1'];

    sheet.cell(CellIndex.indexByColumnRow(rowIndex: 0, columnIndex: 0)).value =
        const TextCellValue("Left Foot toe");

    // Add the list elements to the worksheet
    for (var i = 1; i < leftitem1!.length; i++) {
      sheet
          .cell(CellIndex.indexByColumnRow(rowIndex: i, columnIndex: 0))
          .value = TextCellValue(leftitem1[i]);
    }
    sheet.cell(CellIndex.indexByColumnRow(rowIndex: 0, columnIndex: 1)).value =
        const TextCellValue("Left Foot heel");

    for (var i = 1; i < leftitem2!.length; i++) {
      sheet
          .cell(CellIndex.indexByColumnRow(rowIndex: i, columnIndex: 1))
          .value = TextCellValue(leftitem2[i]);
    }

    sheet.cell(CellIndex.indexByColumnRow(rowIndex: 0, columnIndex: 2)).value =
        const TextCellValue("Right Foot top");
    for (var i = 1; i < rightitem1!.length; i++) {
      sheet
          .cell(CellIndex.indexByColumnRow(rowIndex: i, columnIndex: 2))
          .value = TextCellValue(rightitem1[i]);
    }

    sheet.cell(CellIndex.indexByColumnRow(rowIndex: 0, columnIndex: 3)).value =
        const TextCellValue("Riight Foot heel");
    for (var i = 1; i < rightitem2!.length; i++) {
      sheet
          .cell(CellIndex.indexByColumnRow(rowIndex: i, columnIndex: 3))
          .value = TextCellValue(rightitem2[i]);
    }
    // Save the Excel file

    var fileBytes = excel.save();
    var directory = await getApplicationDocumentsDirectory();
    print(directory.path);
    File(join(directory.path, 'smartstep.xlsx'))
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes!);

    print(leftitem1.length);
    print(leftitem2.length);
    print(rightitem2.length);
    print(rightitem1.length);
  }

  void connectandlisten(
      BluetoothDevice device1, BluetoothDevice device2) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Note: You must call discoverServices after every re-connection!
    List<BluetoothService> services1 = await device1.discoverServices();
    List<BluetoothService> services2 = await device2.discoverServices();
    print('start reading');
    services1.forEach((service) {
      for (var characteristic in service.characteristics) {
        if (characteristic.uuid.toString() == characteristicUuidLt) {
          characteristic.setNotifyValue(!characteristic.isNotifying);
          characteristic.onValueReceived.listen((value) {
            lefttoeoutputs.add(ascii.decode(value));
            print(righttoeoutputs);
            prefs.setStringList('lefttoe', lefttoeoutputs);
          });
        }
        if (characteristic.uuid.toString() == characteristicUuidLh) {
          characteristic.setNotifyValue(!characteristic.isNotifying);
          characteristic.onValueReceived.listen((value) {
            leftheeloutputs.add(ascii.decode(value));
            print(rightheeloutputs);
            prefs.setStringList('leftheel', leftheeloutputs);
          });
        }
      }
    });
    services2.forEach((service) {
      for (var characteristic in service.characteristics) {
        if (characteristic.uuid.toString() == characteristicUuidRt) {
          characteristic.setNotifyValue(!characteristic.isNotifying);
          characteristic.onValueReceived.listen((value) {
            righttoeoutputs.add(ascii.decode(value));
            print(righttoeoutputs);
            prefs.setStringList('righttoe', righttoeoutputs);
          });
        }
        if (characteristic.uuid.toString() == characteristicUuidRh) {
          characteristic.setNotifyValue(!characteristic.isNotifying);
          characteristic.onValueReceived.listen((value) {
            rightheeloutputs.add(ascii.decode(value));
            print(rightheeloutputs);
            prefs.setStringList('rightheel', rightheeloutputs);
          });
        }
      }
    });
  }

  void measureweight() async {
    await device2.connect();
    Fluttertoast.showToast(
        msg: "Right shoe connected!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
    await device1.connect();
    Fluttertoast.showToast(
        msg: "Left shoe connected!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
    // Note: You must call discoverServices after every re-connection!
    List<BluetoothService> services1 = await device1.discoverServices();
    List<BluetoothService> services2 = await device2.discoverServices();

    services1.forEach((service) {
      for (var characteristic in service.characteristics) {
        if (characteristic.uuid.toString() == characteristicUuidLt) {
          characteristic.setNotifyValue(!characteristic.isNotifying);
          characteristic.onValueReceived.listen((value) {
            // lefttoeoutputs.add(int.parse(ascii.decode(value)));
            // print(righttoeoutputs);
          });
        }
        if (characteristic.uuid.toString() == characteristicUuidLh) {
          characteristic.setNotifyValue(!characteristic.isNotifying);
          characteristic.onValueReceived.listen((value) {
            // leftheeloutputs.add(int.parse(ascii.decode(value)));
            // print(rightheeloutputs);
          });
        }
      }
    });
    services2.forEach((service) {
      for (var characteristic in service.characteristics) {
        if (characteristic.uuid.toString() == characteristicUuidRt) {
          characteristic.setNotifyValue(!characteristic.isNotifying);
          characteristic.onValueReceived.listen((value) {
            // righttoeoutputs.add(int.parse(ascii.decode(value)));
            // print(righttoeoutputs);
          });
        }
        if (characteristic.uuid.toString() == characteristicUuidRh) {
          characteristic.setNotifyValue(!characteristic.isNotifying);
          characteristic.onValueReceived.listen((value) {
            // rightheeloutputs.add(int.parse(ascii.decode(value)));
            // print(rightheeloutputs);
          });
        }
      }
    });
    Future.delayed(const Duration(seconds: 5), () async {
      await device1.disconnect();
      await device2.disconnect();
    });
    // final lefttoeavg = calculateAverage(lefttoeoutputs);
    // final leftheelavg = calculateAverage(leftheeloutputs);
    // final righttoeavg = calculateAverage(righttoeoutputs);
    // final rightheelavg = calculateAverage(rightheeloutputs);
    // print(lefttoeavg + leftheelavg + righttoeavg + rightheelavg);
  }

  double calculateAverage(List<num> numbers) {
    // Initialize sum to 0
    num totalSum = 0;

    // Iterate through the list and sum up all numbers
    for (var num in numbers) {
      totalSum += num;
    }

    // Divide the sum by the total count of numbers to get the average
    double average = totalSum / numbers.length;

    return average;
  }
}
