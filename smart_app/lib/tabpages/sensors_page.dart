
import 'package:flutter/material.dart';

class SensorsPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _SensorsPageState();
// TODO: implement createState

}

class _SensorsPageState extends State<SensorsPage> with AutomaticKeepAliveClientMixin<SensorsPage> {

  var sensorList = ['1','2','3'];

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement firebase images list and listner
    super.initState();
  }

//  @mustCallSuper
//  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body : GridView.builder(
            itemCount: sensorList.length,
            gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (BuildContext context, int index) {
              var packageData = sensorList[index];
              return new GestureDetector(
                child: new Card(
                  shape: new RoundedRectangleBorder(
                         side: new BorderSide(color: Colors.grey[700], width: 2.0),
                          borderRadius: BorderRadius.circular(4.0)),
                  elevation: 5.0,
                  child: new Container(
                    alignment: Alignment.center,
                    child: new Text(packageData + '\nicon\n' + 'value',
                        style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                onTap: () {
//                  print('Item $index');
//                  var path =  _getPath(packageData['package_name']);
//                  print(path);
//                  var route = new MaterialPageRoute(builder: (context) => PackagesList(packageListPath: path , package: packageData));
//                  Navigator.of(context).push(route);
                },
              );
            }),

    ); // This


}


}