import 'package:scoped_model/scoped_model.dart';

class DataModel extends Model {

  Parent _parent;
  Parent get parent => _parent;

  getParent(Parent parent) {
    this._parent = parent;
    notifyListeners();
  }
  
}

class Parent {
  String MatriculeParent;
  String NomArParent;
  String PrenomArParent;
  String email;
  String password;

  Parent({this.MatriculeParent, this.NomArParent, this.PrenomArParent,
    this.email, this.password});


}