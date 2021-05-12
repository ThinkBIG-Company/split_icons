import 'dart:io';

import 'package:io/ansi.dart';
import 'package:yaml/yaml.dart';

import 'yaml_modify.dart';

void main(List<String> arguments) {
  // Platform.environment.forEach((k,v)=>print('$k $v'));
  // 执行命令
  // Process.run(executable, arguments);
  print(yellow.wrap(
      '${DateTime.now().toString()
          .substring(0, 19)}: The command is executing, please wait...'));
  var pubSpec = File('./pubspec.yaml');
  //print(pubSpec.existsSync());
  var pubSpecDoc = loadYaml(pubSpec.readAsStringSync());
  var packages = File('./.packages');
  if (!packages.existsSync()) {
    print(yellow.wrap('${DateTime.now().toString()
        .substring(0, 19)}: Get the dependencies first'));
    return;
  }
  // ignore: omit_local_variable_types
  List<String> lines = packages.readAsLinesSync();
  String flutterIconPath;
  var flutterIconVersion;
  for (var i = 0; i < lines.length; i++) {
    if (lines[i].contains('flutter_icons')) {
      flutterIconPath = lines[i]
          .replaceAll(
          'flutter_icons:file://${Platform.isWindows ? '/' : ''}', '')
          .replaceAll('/lib/', '');

      if (flutterIconVersion != null) {
        flutterIconVersion =
            flutterIconPath.substring(flutterIconPath.lastIndexOf('-'));
      }

      break;
    }
  }

  if (flutterIconPath == null || !File(flutterIconPath).existsSync()) {
    print(red.wrap(
        '${DateTime.now().toString()
            .substring(0, 19)}: Attention! You need to add the flutter_icons dependency first'));
    return;
  }
  // ignore: omit_local_variable_types
  File flutterIconsFile = File(flutterIconPath + 'pubspec.yaml');
  List includes;
  var yamlString = tempYaml(flutterIconVersion);
  if (pubSpecDoc['flutter_icons'] != null &&
      pubSpecDoc['flutter_icons']['includes'] != null) {
    includes = pubSpecDoc['flutter_icons']['includes'];
    includes.forEach((key) {
      yamlString += fontsMap[key];
    });
  } else {
    yamlString += allFonts;
  }
  flutterIconsFile.writeAsStringSync(yamlString);
  var resDoc = loadYaml(yamlString);
  var useFonts = List.of(resDoc['flutter']['fonts']).map((
      item) => item['family']);
  print('${DateTime.now().toString()
      .substring(0, 19)}: The fonts you are using is ${useFonts.toString()}');
  print(blue.wrap('${DateTime.now().toString()
      .substring(0, 19)}: Finish the work'));
}