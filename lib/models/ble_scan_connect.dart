import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';

import 'ble_stream.dart';

class BleScanConnect {
  late BluetoothDevice device1;
  late BluetoothDevice device2;
  BluetoothAdapterState? states;
  List<String> lefttoeoutputs = [];
  List<String> leftheeloutputs = [];
  List<String> righttoeoutputs = [];
  List<String> rightheeloutputs = [];
  final String characteristicUuidRt = "beb5483e-36e1-4688-b7f5-ea07361b26a8";
  final String characteristicUuidRh = "b478a77f-7777-459f-b999-a6d3eaaddbe1";
  final String characteristicUuidLt = "c3b19f80-4e80-48e0-b3b5-0fcaa545e3db";
  final String characteristicUuidLh = "a6d06e3e-8aa8-444a-9df8-7a74dba288d1";
  StreamSubscription? leftToeSubscription;
  StreamSubscription? leftHeelSubscription;
  StreamSubscription? rightToeSubscription;
  StreamSubscription? rightHeelSubscription;
  final int maxSize = 50;
  Future scan() async {
    lefttoeoutputs = [];
    leftheeloutputs = [];
    righttoeoutputs = [];
    rightheeloutputs = [];
    print("Scanning");
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.setStringList('righttoe', righttoeoutputs);
    // prefs.setStringList('rightheel', rightheeloutputs);
    //prefs.setStringList('leftheel', leftheeloutputs);
    //prefs.setStringList('lefttoe', lefttoeoutputs);
    // FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);

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
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

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

      await device1.connect();
      await device2.connect();
      // Stream stream = controller.stream;
      getStreamData();
      // Note: You must call discoverServices after every re-connection!
    } else {
      print("Bluetooth is off,could not connect");
    }
    subscription.cancel();
    return [device1, device2];
  }

  void printOutput(BluetoothDevice device1, BluetoothDevice device2) async {
    await device1.disconnect();
    await device2.disconnect();
    // Close the StreamControllers
    BleStream.leftToeController.close();
    BleStream.leftHeelController.close();
    BleStream.rightToeController.close();
    BleStream.rightHeelController.close();
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
          .value = DoubleCellValue(double.parse(leftitem1[i]));
    }
    sheet.cell(CellIndex.indexByColumnRow(rowIndex: 0, columnIndex: 1)).value =
        const TextCellValue("Left Foot heel");

    for (var i = 1; i < leftitem2!.length; i++) {
      sheet
          .cell(CellIndex.indexByColumnRow(rowIndex: i, columnIndex: 1))
          .value = DoubleCellValue(double.parse(leftitem2[i]));
    }

    sheet.cell(CellIndex.indexByColumnRow(rowIndex: 0, columnIndex: 2)).value =
        const TextCellValue("Right Foot top");
    for (var i = 1; i < rightitem1!.length; i++) {
      sheet
          .cell(CellIndex.indexByColumnRow(rowIndex: i, columnIndex: 2))
          .value = DoubleCellValue(double.parse(rightitem1[i]));
    }

    sheet.cell(CellIndex.indexByColumnRow(rowIndex: 0, columnIndex: 3)).value =
        const TextCellValue("Riight Foot heel");
    for (var i = 1; i < rightitem2!.length; i++) {
      sheet
          .cell(CellIndex.indexByColumnRow(rowIndex: i, columnIndex: 3))
          .value = DoubleCellValue(double.parse(rightitem2[i]));
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
      BluetoothDevice device1, BluetoothDevice device2) async {}

  Future<int> measureweight() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> lefttoelistnum = prefs.getStringList('lefttoelist')!;
    List<String> leftheellistnum = prefs.getStringList('leftheellist')!;
    List<String> righttoelistnum = prefs.getStringList('righttoelist')!;
    List<String> rightheellistnum = prefs.getStringList('rightheellist')!;
    print(lefttoelistnum);
    print(leftheellistnum);
    print(righttoelistnum);
    print(rightheellistnum);

    final lefttoeavg = calculateAverage(lefttoelistnum);
    final leftheelavg = calculateAverage(leftheellistnum);
    final righttoeavg = calculateAverage(righttoelistnum);
    final rightheelavg = calculateAverage(rightheellistnum);
    print(lefttoeavg + leftheelavg + righttoeavg + rightheelavg);
    int weight =
        (lefttoeavg + leftheelavg + righttoeavg + rightheelavg).round();
    return weight;
  }

  double calculateAverage(List<String> numbers) {
    // Initialize sum to 0
    num totalSum = 0;

    // Iterate through the list and sum up all numbers
    for (var num in numbers) {
      totalSum += double.parse(num);
    }

    // Divide the sum by the total count of numbers to get the average
    double average = totalSum / numbers.length;

    return average;
  }

  void disconnect(BluetoothDevice device1, BluetoothDevice device2) async {
    await device1.disconnect();
    await device2.disconnect();
    // Close the StreamControllers
    BleStream.leftToeController.close();
    BleStream.leftHeelController.close();
    BleStream.rightToeController.close();
    BleStream.rightHeelController.close();
  }

  void getStreamData() async {
    // Check if device1 is connected before discovering services
    // Stream controllers for each service

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (device1.isConnected) {
      Fluttertoast.showToast(
          msg: "Left shoe connected!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      List<BluetoothService> services1 = await device1.discoverServices();
      print('start reading');
      for (var service in services1) {
        for (var characteristic in service.characteristics) {
          if (characteristic.uuid.toString() == characteristicUuidLt) {
            characteristic.setNotifyValue(!characteristic.isNotifying);
            leftToeSubscription =
                characteristic.onValueReceived.listen((value) {
              // Check the size of the list before adding new items
              if (lefttoeoutputs.length >= maxSize) {
                // If the list is too large, remove the first item
                lefttoeoutputs.removeAt(0);
              }

              lefttoeoutputs.add(ascii.decode(value));
              prefs.setStringList('lefttoelist', leftheeloutputs);
              BleStream.leftToeController
                  .add(ascii.decode(value)); // Add value to stream
              // print(lefttoeoutputs);
            });
          }
          if (characteristic.uuid.toString() == characteristicUuidLh) {
            characteristic.setNotifyValue(!characteristic.isNotifying);
            leftHeelSubscription =
                characteristic.onValueReceived.listen((value) {
              // Check the size of the list before adding new items
              if (leftheeloutputs.length >= maxSize) {
                // If the list is too large, remove the first item
                leftheeloutputs.removeAt(0);
              }

              // Add the new item to the list

              leftheeloutputs.add(ascii.decode(value));
              prefs.setStringList('leftheellist', leftheeloutputs);
              BleStream.leftHeelController
                  .add(ascii.decode(value)); // Add value to stream
              // print(leftheeloutputs);
            });
          }
        }
      }
    } else {
      print('Error: device1 is not connected');
    }
// Check if device2 is connected before discovering services
    if (device2.isConnected) {
      Fluttertoast.showToast(
          msg: "Right shoe connected!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      List<BluetoothService> services2 = await device2.discoverServices();

      for (var service in services2) {
        for (var characteristic in service.characteristics) {
          if (characteristic.uuid.toString() == characteristicUuidRt) {
            characteristic.setNotifyValue(!characteristic.isNotifying);
            rightToeSubscription =
                characteristic.onValueReceived.listen((value) {
              if (righttoeoutputs.length >= maxSize) {
                // If the list is too large, remove the first item
                righttoeoutputs.removeAt(0);
              }

              righttoeoutputs.add(ascii.decode(value));
              prefs.setStringList('righttoelist', righttoeoutputs);
              BleStream.rightToeController
                  .add(ascii.decode(value)); // Add value to stream
              // print(righttoeoutputs);
            });
          }
          if (characteristic.uuid.toString() == characteristicUuidRh) {
            characteristic.setNotifyValue(!characteristic.isNotifying);
            rightHeelSubscription =
                characteristic.onValueReceived.listen((value) {
              if (rightheeloutputs.length >= maxSize) {
                // If the list is too large, remove the first item
                rightheeloutputs.removeAt(0);
              }

              rightheeloutputs.add(ascii.decode(value));
              prefs.setStringList('rightheellist', rightheeloutputs);
              BleStream.rightHeelController
                  .add(ascii.decode(value)); // Add value to stream
              // print(rightheeloutputs);
            });
          }
        }
      }
    } else {
      print('Error: device2 is not connected');
    }
  }

  void stopNotifications() async {
    leftToeSubscription?.cancel();
    leftHeelSubscription?.cancel();
    rightToeSubscription?.cancel();
    rightHeelSubscription?.cancel();
  }
}
