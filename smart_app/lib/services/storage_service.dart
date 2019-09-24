import 'package:path_provider/path_provider.dart';

class Storage{

  Future<String> get localPath async{
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<String> get localFile async{
    final path = await localPath;
    return path;
  }




}