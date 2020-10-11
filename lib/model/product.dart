import 'package:firebase_database/firebase_database.dart';

class Product{
  String _id;
  String _nombre;
  String _codigo;
  String _descripcion;
  String _precio;

  Product(this._id, this._nombre, this._codigo, this._descripcion, this._precio);

  Product.map(dynamic obj){
    this._nombre = obj['nombre'];
    this._codigo = obj['codigo'];
    this._descripcion = obj['descripcion'];
    this._precio = obj['precio'];
  }

  String get id => _id;
  String get nombre =>_nombre;
  String get codigo => _codigo;
  String get descripcion => _descripcion;
  String get precio => _precio;

  Product.fromSnapShop(DataSnapshot snapshot){
    _id = snapshot.key;
    _nombre = snapshot.value['nombre'];
    _codigo = snapshot.value['codigo'];
    _descripcion = snapshot.value['descripcion'];
    _precio = snapshot.value['precio'];
  }

}