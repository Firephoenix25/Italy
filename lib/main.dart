import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:get/get.dart';
import 'Cities.dart';

void main() {
  runApp(GetMaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late MapShapeSource _dataSource;
  Set regioni = Set();
  Set province = Set();
  List list = [];
  double x = 0;
  double y = 0;
  @override
  void initState() {
    _dataSource = MapShapeSource.asset(
      'assets/Regioni.json',
      shapeDataField: 'STATE_NAME',
    );

    cities.forEach((element) {
      regioni.add(element['REGIONE']);
      province.add(element['PROVINCIA']);
    });
    list = regioni.toList();
    list.sort();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    x = MediaQuery.of(context).size.width;
    y = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Row(
      children: [
        Flexible(
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (BuildContext context, int i) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 400, vertical: 5),
                child: Container(
                    width: 40,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(Provincia(choose: list[i].toString()));
                      },
                      child: Text(list[i].toString()),
                    )),
              );
            },
          ),
        ),
        Container(
          width: x / 2,
          height: y,
          child: Container(
            width: 200,
            height: 400,
            child: SfMaps(
              layers: [
                MapShapeLayer(source: _dataSource),
              ],
            ),
          ),
        )
      ],
    ));
  }
}

/*
Container(
      width: 200,
      height: 400,
      child: SfMaps(
        layers: [
          MapShapeLayer(source: _dataSource),
        ],
      ),
    )*/

class Provincia extends StatefulWidget {
  final String choose;
  late MapShapeSource _dataSource;
  Provincia({required this.choose});

  @override
  State<Provincia> createState() => _ProvinciaState();
}

class _ProvinciaState extends State<Provincia> {
  Set regioni = Set();
  Set province = Set();
  List list = [];
  void initState() {
    widget._dataSource = MapShapeSource.asset(
      'assets/Province.json',
      shapeDataField: 'STATE_NAME',
    );

    cities.forEach((element) {
      if (widget.choose == element['REGIONE'])
        province.add(element['PROVINCIA']);

      list = province.toList();
      list.sort();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Row(
          children: [
            Flexible(
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 400, vertical: 5),
                    child: Container(
                      width: 40,
                      height: 40,
                      child: ElevatedButton(
                          onPressed: () {
                            Get.to(Comuni(
                              choose: list[i].toString(),
                            ));
                          },
                          child: Text(list[i].toString())),
                    ),
                  );
                },
              ),
            ),
            Container(
              width: Get.width / 2,
              height: Get.height,
              child: Container(
                width: 200,
                height: 400,
                child: SfMaps(
                  layers: [
                    MapShapeLayer(source: widget._dataSource),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}

class Comuni extends StatefulWidget {
  final String choose;
  Comuni({required this.choose});

  @override
  State<Comuni> createState() => _ComuniState();
}

class _ComuniState extends State<Comuni> {
  Set regioni = Set();
  Set province = Set();
  List list = [];
  List<Map> map = [];
  void initState() {
    cities.forEach((element) {
      if (widget.choose == element['PROVINCIA']) {
        map.add(
            {"COMUNE": element['COMUNE'], "PEOPLE": element['popolazione']});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Row(
          children: [
            Flexible(
              child: ListView.builder(
                itemCount: map.length,
                itemBuilder: (BuildContext context, int i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 200, vertical: 5),
                    child: Row(
                      children: [
                        Container(
                          width: 400,
                          height: 40,
                          child: ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: map[i]['PEOPLE'] < 50000
                                      ? Colors.red
                                      : Colors.green),
                            ),
                            title: Text(map[i]['COMUNE'].toString()),
                            subtitle: Text(
                              map[i]['PEOPLE'].toString(),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
                width: Get.width / 2, height: Get.height, color: Colors.grey)
          ],
        ));
  }
}
