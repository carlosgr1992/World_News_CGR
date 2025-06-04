
import 'FireBaseAdmin.dart';

class DataHolder {
  static final DataHolder _dataHolder = DataHolder._internal();
  static final FirebaseAdmin firebaseAdmin = FirebaseAdmin();


  DataHolder._internal();

  void initDataHolder(){


  }

  factory DataHolder() {
    return _dataHolder;
  }



}