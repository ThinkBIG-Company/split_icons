import 'dart:io';

import 'package:io/ansi.dart';
import 'package:yaml/yaml.dart';

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

// Yaml modify
typedef YamlFunction = String Function(String);

YamlFunction tempYaml = (String version) => '''
name: flutter_icons
description: Customizable Icons for Flutter，you can use with over 3K+ icons in your flutter project
version: ${version ?? '1.1.0'}
author: Sascha Heim<developers@think-big-company.com>
homepage: https://github.com/ThinkBIG-Company/flutter-icons.git

environment:
  sdk: ">=2.12.0-0 <3.0.0"

dependencies:
  flutter:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter

flutter:
  fonts:
''';
const String allFonts = '''
      - family: AntDesign
        fonts:
          - asset: fonts/AntDesign.ttf
      - family: AntDesign-Filled
        fonts:
          - asset: fonts/AntDesign-Filled.ttf
      - family: AntDesign-Outlined
        fonts:
          - asset: fonts/AntDesign-Outlined.ttf
      - family: Brandico
        fonts:
          - asset: fonts/Brandico.ttf
      - family: Elusive-Icons
        fonts:
          - asset: fonts/Elusiveicons.ttf
      - family: Entypo
        fonts:
          - asset: fonts/Entypo.ttf
      - family: EvilIcons
        fonts:
          - asset: fonts/EvilIcons.ttf
      - family: Feather
        fonts:
          - asset: fonts/Feather.ttf
      - family: FontAwesome
        fonts:
          - asset: fonts/FontAwesome.ttf
      - family: FontAwesome5_Brands
        fonts:
          - asset: fonts/FontAwesome5_Brands.ttf
      - family: FontAwesome5
        fonts:
          - asset: fonts/FontAwesome5_Regular.ttf
      - family: FontAwesome5_Solid
        fonts:
          - asset: fonts/FontAwesome5_Solid.ttf
      - family: Fontelico
        fonts:
          - asset: fonts/Fontelico.ttf
      - family: Fontisto
        fonts:
          - asset: fonts/Fontisto.ttf
      - family: Foundation
        fonts:
          - asset: fonts/Foundation.ttf
      - family: Iconic
        fonts:
          - asset: fonts/Iconic.ttf
      - family: Ionicons
        fonts:
          - asset: fonts/Ionicons.ttf
      - family: Linearicons-Free
        fonts:
          - asset: fonts/Linearicons-Free.ttf
      - family: Linecons
        fonts:
          - asset: fonts/Linecons.ttf
      - family: Maki
        fonts:
          - asset: fonts/Maki.ttf
      - family: MaterialCommunityIcons
        fonts:
          - asset: fonts/MaterialCommunityIcons.ttf
      - family: MaterialIcons-Baseline
        fonts:
          - asset: fonts/MaterialIcons-Baseline.ttf
      - family: MaterialIcons-Outline
        fonts:
          - asset: fonts/MaterialIcons-Outline.ttf
      - family: MaterialIcons-Round
        fonts:
          - asset: fonts/MaterialIcons-Round.ttf
      - family: MaterialIcons-Sharp
        fonts:
          - asset: fonts/MaterialIcons-Sharp.ttf
      - family: MaterialIcons-TwoTone
        fonts:
          - asset: fonts/MaterialIcons-TwoTone.ttf
      - family: Meteocons
        fonts:
          - asset: fonts/Meteocons.ttf
      - family: MfgLabs
        fonts:
          - asset: fonts/MfgLabs.ttf
      - family: ModernPictograms
        fonts:
          - asset: fonts/ModernPictograms.ttf
      - family: Octicons
        fonts:
          - asset: fonts/Octicons.ttf
      - family: RpgAwesome
        fonts:
          - asset: fonts/RpgAwesome.ttf
      - family: SimpleLineIcons
        fonts:
          - asset: fonts/SimpleLineIcons.ttf
      - family: Typicons
        fonts:
          - asset: fonts/Typicons.ttf
      - family: WeatherIcons
        fonts:
          - asset: fonts/WeatherIcons.ttf
      - family: WebSymbols
        fonts:
          - asset: fonts/WebSymbols.ttf
      - family: Zocial
        fonts:
          - asset: fonts/Zocial.ttf
''';
//Ant Design Icons -> ant
//Ant Design v4+ Filled Icons -> adf
//Ant Design v4+ Outlined Icons -> ado
//Brandico Icons -> bdo
//Elusive Icons -> elu
//Entypo Icons -> ent
//Evil Icons -> evi
//Feather Icons -> fea
//Font Awesome Icons -> fa
//Font Awesome 5 Brands -> fab
//Font Awesome 5 Regular -> far
//Font Awesome 5 Solid -> fas
//Fontelico Icons -> fon
//Fontisto Icons -> fto
//Foundation Icons -> fou
//Iconic Icons -> ico
//Ionicons Icons -> ion
//Linearicons Icons -> lin
//Linecons Icons -> lco
//Maki Icons -> mak
//Material Community Icons -> mco
//Material Icons Baseline -> mib
//Material Icons Outline -> mio
//Material Icons Round -> mir
//Material Icons Sharp -> mis
//Material Icons TwoTone **Not available at this moment**
//Meteocons Icons -> met
//MfgLabs Icons -> mfg
//ModernPictograms -> mod
//Octicons Icons -> oct
//RpgAwesome -> rpg
//Simple Line Icons -> sli
//Typicons -> typ
//Weather Icons -> wea
//WebSymbols Icons -> web
//Zocial Icons -> zoc
Map<String, String> fontsMap = {
  'ant': '''
      - family: AntDesign
        fonts:
          - asset: fonts/AntDesign.ttf
''',
  'adf': '''
      - family: AntDesign-Filled
        fonts:
          - asset: fonts/AntDesign-Filled.ttf
''',
  'ado': '''
      - family: AntDesign-Outlined
        fonts:
          - asset: fonts/AntDesign-Outlined.ttf
''',
  'bdo': '''
      - family: Brandico
        fonts:
          - asset: fonts/Brandico.ttf
''',
  'elu': '''
      - family: Elusive-Icons
        fonts:
          - asset: fonts/Elusiveicons.ttf
''',
  'ent': '''
      - family: Entypo
        fonts:
          - asset: fonts/Entypo.ttf
''',
  'evi': '''
      - family: EvilIcons
        fonts:
          - asset: fonts/EvilIcons.ttf
''',
  'fea': '''
      - family: Feather
        fonts:
          - asset: fonts/Feather.ttf
''',
  'fa': '''
      - family: FontAwesome
        fonts:
          - asset: fonts/FontAwesome.ttf
''',
  'fab': '''
      - family: FontAwesome5_Brands
        fonts:
          - asset: fonts/FontAwesome5_Brands.ttf
''',
  'far': '''
      - family: FontAwesome5
        fonts:
          - asset: fonts/FontAwesome5_Regular.ttf
''',
  'fas': '''
      - family: FontAwesome5_Solid
        fonts:
          - asset: fonts/FontAwesome5_Solid.ttf
''',
  'fon': '''
      - family: Fontelico
        fonts:
          - asset: fonts/Fontelico.ttf
''',
  'fto': '''
      - family: Fontisto
        fonts:
          - asset: fonts/Fontisto.ttf
''',
  'fou': '''
      - family: Foundation
        fonts:
          - asset: fonts/Foundation.ttf
''',
  'ico': '''
      - family: Iconic
        fonts:
          - asset: fonts/Iconic.ttf
''',
  'ion': '''
      - family: Ionicons
        fonts:
          - asset: fonts/Ionicons.ttf
''',
  'lin': '''
      - family: Linearicons-Free
        fonts:
          - asset: fonts/Linearicons-Free.ttf
''',
  'lco': '''
      - family: Linecons
        fonts:
          - asset: fonts/Linecons.ttf
''',
  'mak': '''
      - family: Maki
        fonts:
          - asset: fonts/Maki.ttf
''',
  'mco': '''
      - family: MaterialCommunityIcons
        fonts:
          - asset: fonts/MaterialCommunityIcons.ttf
''',
  'mib': '''
      - family: MaterialIcons-Baseline
        fonts:
          - asset: fonts/MaterialIcons-Baseline.ttf
''',
  'mio': '''
      - family: MaterialIcons-Outline
        fonts:
          - asset: fonts/MaterialIcons-Outline.ttf
''',
  'mir': '''
      - family: MaterialIcons-Round
        fonts:
          - asset: fonts/MaterialIcons-Round.ttf
''',
  'mis': '''
      - family: MaterialIcons-Sharp
        fonts:
          - asset: fonts/MaterialIcons-Sharp.ttf
''',
  'mit': '''
      - family: MaterialIcons-TwoTone
        fonts:
          - asset: fonts/MaterialIcons-TwoTone.ttf
''',
  'met': '''
      - family: Meteocons
        fonts:
          - asset: fonts/Meteocons.ttf
''',
  'mfg': '''
      - family: mfg_labs_iconsetregular
        fonts:
          - asset: fonts/MFGLabsiconset.ttf
''',
  'mod': '''
      - family: ModernPictograms
        fonts:
          - asset: fonts/ModernPictograms.ttf
''',
  'oct': '''
      - family: Octicons
        fonts:
          - asset: fonts/Octicons.ttf
''',
  'rpg': '''
      - family: RpgAwesome
        fonts:
          - asset: fonts/RpgAwesome.ttf
''',
  'sli': '''
      - family: SimpleLineIcons
        fonts:
          - asset: fonts/SimpleLineIcons.ttf
''',
  'typ': '''
      - family: Typicons
        fonts:
          - asset: fonts/Typicons.ttf
''',
  'wea': '''
      - family: WeatherIcons
        fonts:
          - asset: fonts/weathericons.ttf
''',
  'web': '''
      - family: WebSymbols
        fonts:
          - asset: fonts/WebSymbols.ttf
''',
  'zoc': '''
      - family: Zocial
        fonts:
          - asset: fonts/Zocial.ttf
'''
};