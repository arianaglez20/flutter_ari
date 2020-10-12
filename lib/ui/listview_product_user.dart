import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter_ari/ui/product_screen.dart';
import 'package:flutter_ari/ui/product_information.dart';
import 'package:flutter_ari/model/product.dart';
import '../authentication_service.dart';
import 'package:provider/provider.dart';

class ListViewProduct_user extends StatefulWidget {
  @override
  _ListViewProduct_userState createState() => _ListViewProduct_userState();
}

final productReference = FirebaseDatabase.instance.reference().child('product');

class _ListViewProduct_userState extends State<ListViewProduct_user> {
  List<Product> items;
  StreamSubscription<Event> _onProductAddedSubscription;
  StreamSubscription<Event> _onProductChangedSubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    items = new List();
    _onProductAddedSubscription =
        productReference.onChildAdded.listen(_onProductAdded);
    _onProductChangedSubscription =
        productReference.onChildChanged.listen(_onProductUpdate);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _onProductAddedSubscription.cancel();
    _onProductChangedSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carta de productos',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Carta de productos'),
          centerTitle: true,
          backgroundColor: Colors.deepPurpleAccent,
          leading: IconButton(
            icon: Icon(Icons.cancel),
            onPressed: () => context.read<AuthenticationService>().signOut(),
          ),
        ),
        body: Center(
          child: ListView.builder(
              itemCount: items.length,
              padding: EdgeInsets.only(top: 12.0),
              itemBuilder: (context, position) {
                return Column(
                  children: <Widget>[
                    Divider(
                      height: 7.0,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                              title: Text(
                                '${items[position].nombre}',
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 21.0,
                                ),
                              ),
                              subtitle: Text(
                                '${items[position].descripcion}',
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 21.0,
                                ),
                              ),
                              leading: Column(
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundColor: Colors.cyan,
                                    radius: 17.0,
                                    child: Text(
                                      '${position + 1}',
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 21.0,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              onTap: () =>
                                  _navigateToProduct(context, items[position])),
                        ),

                      ],
                    ),
                  ],
                );
              }),
        ),

      ),
    );
  }

  void _onProductAdded(Event event) {
    setState(() {
      items.add(new Product.fromSnapShop(event.snapshot));
    });
  }

  void _onProductUpdate(Event event) {
    var oldProductValue =
    items.singleWhere((product) => product.id == event.snapshot.key);
    setState(() {
      items[items.indexOf(oldProductValue)] =
      new Product.fromSnapShop(event.snapshot);
    });
  }




  void _navigateToProduct(BuildContext context, Product product) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductInformation(product)),
    );
  }


}
