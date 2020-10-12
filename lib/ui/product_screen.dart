import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_ari/model/product.dart';

class ProductScreen extends StatefulWidget {
  final Product product;
  ProductScreen (this.product);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

final productReference = FirebaseDatabase.instance.reference().child('product');

class _ProductScreenState extends State<ProductScreen> {

  List<Product> items;
  TextEditingController _nombreController;
  TextEditingController _codigoController;
  TextEditingController _descripcionController;
  TextEditingController _precioController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nombreController = new TextEditingController(text: widget.product.nombre);
    _codigoController = new TextEditingController(text: widget.product.codigo);
    _descripcionController = new TextEditingController(text: widget.product.descripcion);
    _precioController = new TextEditingController(text: widget.product.precio);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Productos'),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Container(
        height: 570.0,
        padding: const EdgeInsets.all(20.0),
        child: Card(
          child: Center(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _nombreController,
                  style: TextStyle(fontSize: 17.0,color: Colors.deepOrangeAccent),
                  decoration: InputDecoration(icon: Icon(Icons.person),
                  labelText: 'Nombre'),
                ),
                Padding(padding: EdgeInsets.only(top: 8.0),),
                Divider(),
                TextField(
                  controller: _codigoController,
                  style: TextStyle(fontSize: 17.0,color: Colors.deepOrangeAccent),
                  decoration: InputDecoration(icon: Icon(Icons.code),
                      labelText: 'Codigo'),
                ),
                Padding(padding: EdgeInsets.only(top: 8.0),),
                Divider(),
                TextField(
                  controller: _descripcionController,
                  style: TextStyle(fontSize: 17.0,color: Colors.deepOrangeAccent),
                  decoration: InputDecoration(icon: Icon(Icons.list),
                      labelText: 'Descripción'),
                ),
                Padding(padding: EdgeInsets.only(top: 8.0),),
                Divider(),
                TextField(
                  controller: _precioController,
                  style: TextStyle(fontSize: 17.0,color: Colors.deepOrangeAccent),
                  decoration: InputDecoration(icon: Icon(Icons.monetization_on),
                      labelText: 'Precio'),
                ),
                Padding(padding: EdgeInsets.only(top: 8.0),),
                Divider(),
                FlatButton(onPressed: (){
                  if(widget.product.id != null){
                    productReference.child(widget.product.id).set({
                      'nombre' : _nombreController.text,
                      'codigo' : _codigoController.text,
                      'descripcion' : _descripcionController.text,
                      'precio' : _precioController.text,
                    }).then((_){
                      Navigator.pop(context);
                    });
                  }else{
                    productReference.push().set({
                      'nombre' : _nombreController.text,
                      'codigo' : _codigoController.text,
                      'descripcion' : _descripcionController.text,
                      'precio' : _precioController.text,
                    }).then((_){
                      Navigator.pop(context);
                    });
                  }
                  },
                    child: (widget.product.id != null) ? Text('Actualizar') : Text('Agregar')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

