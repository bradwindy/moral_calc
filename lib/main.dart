import 'dart:async';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

void main() {
  Admob.initialize("ca-app-pub-9783239556129868~5221524670");
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    return MaterialApp(
      title: 'The Moral Calculator',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        brightness: Brightness.light,
        accentColor: Color.fromRGBO(67, 127, 63, 1),
        accentColorBrightness: Brightness.dark,
        primaryColor: Colors.white,
        canvasColor: Colors.white,
        fontFamily: 'Palanquin',
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class GroupModel {
  String text;
  int index;

  GroupModel({this.text, this.index});
}

class _MyHomePageState extends State<MyHomePage> {

  /// The In App Purchase plugin
  InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;

  /// Products for sale
  List<ProductDetails> _products = [];

  /// Past purchases
  List<PurchaseDetails> _purchases = [];

  /// Updates to purchases
  StreamSubscription _subscription;

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  /// Initialize data
  void _initialize() async {
    bool _available = await _iap.isAvailable();

    if (_available) {
      await _getProducts();
    }

    _subscription = _iap.purchaseUpdatedStream.listen((data) =>
        setState(() {
          _purchases.addAll(data);
          debugPrint("PURCHASE DATA" + data.last.status.toString());

          if (data.last.status == PurchaseStatus.purchased) {
            _showThanksDialog();
          } else if (data.last.status == PurchaseStatus.error) {
            _showErrorDialog();
          }
        }));
  }


  Future<void> _getProducts() async {
    Set<String> ids = <String>[
      'onedollar.donation',
      'fivedollar.donation',
    ].toSet();

    ProductDetailsResponse response = await _iap.queryProductDetails(ids);

    setState(() {
      _products = response.productDetails;
    });
  }

  void _buyProduct(ProductDetails prod) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
    _iap.buyConsumable(purchaseParam: purchaseParam);
  }

  final List<String> questions =
  [
    "Have you ever donated to charity?",
    "Are you vegan?",
    "Have you ever taken a selfie at a funeral?",
    "Do you regularly volunteer?",
    "Have you ever committed genocide?",
    "Have you ever helped a snail into shade?",
    "Do you use reusable shopping bags?",
    "Have you ever poisoned a river?",
    "Have you ever used the term 'The Google'?",
    "Do you have solar panels on your home?",
    "Have you ever bought a trashy magazine?",
    "Have you ever planted a tree?",
    "Did you end slavery?",
    "Have you ever fought with a mall santa?",
    "Are you a fan of Richard Nixon?",
    "Have you ever helped with disaster relief?",
    "Have you ever helped a hurt bird?",
    "Have you ever spoiled a movie ending?",
    "Have you ever sneezed on a salad bar?",
    "Do you own a BMW?",
  ];

  List<int> indexes = [null, null, null, null, null, null, null, null,
    null, null, null, null, null, null, null, null, null, null, null, null];

  List<GroupModel> _group = [
    GroupModel(
      text: "Yes",
      index: 1,
    ),
    GroupModel(
      text: "No",
      index: 2,
    ),
  ];

  Widget _buildList(context) {
    return Flexible(
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 20),
        itemCount: questions.length,
        itemBuilder: (context, int) {
          return Card(
              margin: EdgeInsets.only(top: 8, left: 20, right: 20),
              elevation: 0,
              shape: RoundedRectangleBorder(
                  side: new BorderSide(
                      color: Colors.grey[300], width: 1.2
                  ),
                  borderRadius: BorderRadius.circular(8.0)
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                            child: new Container(
                              padding: new EdgeInsets.only(),
                              child: new Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text(questions[int],
                                      style: new TextStyle(
                                          fontSize: 14.0,
                                          fontFamily: 'Palanquin',
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.w700
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _group.map((item) =>
                              Row(
                                children: <Widget>[
                                  Text("${item.text}",
                                    style: new TextStyle(
                                        fontFamily: 'Palanquin',
                                        fontWeight: FontWeight.w100,
                                        color: Colors.grey[700],
                                        fontSize: 12
                                    ),
                                  ),
                                  Radio(
                                    groupValue: indexes[int],
                                    value: item.index,
                                    activeColor: Colors.black,
                                    onChanged: (val) {
                                      setState(() {
                                        indexes[int] = val;
                                      });
                                    },
                                  ),
                                ],
                              ),
                          ).toList(),
                        )

                      ],
                    ),
                  ],
                ),
              )
          );
        },
      ),
    );
  }

  void _select(choice) {
    if (choice.toString() == "clear") {
      setState(() {
        indexes = [
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null
        ];
      });
    } else if (choice.toString() == "about") {
      _showAboutDialog();
    } else if (choice.toString() == "donate") {
      _showDonateDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Padding(
          padding: EdgeInsets.only(left: 5, top: 2),
          child: Text(
            "The Moral Calculator",
            style: new TextStyle(
                fontFamily: 'Palanquin',
                fontWeight: FontWeight.w700,
                fontSize: 22
            ),
          ),
        ),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: _select,
            tooltip: 'Menu',
            itemBuilder: (BuildContext context) =>
            <PopupMenuItem>[
              PopupMenuItem(
                value: "clear",
                child: Row(
                  children: <Widget>[
                    Icon(Icons.clear_all),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'Clear All',
                        style: new TextStyle(
                          fontFamily: 'Palanquin',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: "about",
                child: Row(
                  children: <Widget>[
                    Icon(OMIcons.accountCircle),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'About',
                        style: new TextStyle(
                          fontFamily: 'Palanquin',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              PopupMenuItem(
                value: "donate",
                child: Row(
                  children: <Widget>[
                    Icon(OMIcons.favoriteBorder, color: Colors.red),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'Donate',
                        style: new TextStyle(
                            fontFamily: 'Palanquin',
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildList(context),
            Padding(
                padding: EdgeInsets.only(bottom: 80, top: 20),
                child: AdmobBanner(
                  adUnitId: "ca-app-pub-9783239556129868/1006947496",
                  adSize: AdmobBannerSize.BANNER,
                )
            )
          ],
        ),
      ),

      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerFloat,

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showDialog(),
        tooltip: 'Get Score',
        icon: Icon(Icons.show_chart),
        label: const Text(
          'Get Score',
          style: TextStyle(
              fontFamily: 'Palanquin',
              fontSize: 14,
              fontWeight: FontWeight.w700
          ),
        ),

      ),
    );
  }

  void _showDialog() {
    double points = 0;
    bool nullexists = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        for (int i = 0; i < indexes.length; i++) {
          if (indexes[i] == null) {
            nullexists = true;
          }
        }

        if (nullexists == false) {
          for (int i = 0; i < indexes.length; i++) {
            debugPrint(i.toString());
            if (i == 0) {
              if (indexes[i] == 1) {
                points += 1000;
              } else {
                points -= 3000;
              }
            } else if (i == 1) {
              if (indexes[i] == 1) {
                points += 5555.55;
              } else {
                points -= 5324.23;
              }
            } else if (i == 2) {
              if (indexes[i] == 1) {
                points -= 10900.77;
              } else {
                points += 333.28;
              }
            } else if (i == 3) {
              if (indexes[i] == 1) {
                points += 5555.55;
              } else {
                points -= 524.89;
              }
            } else if (i == 4) {
              if (indexes[i] == 1) {
                points -= 100723.45;
              } else {
                points += 102.22;
              }
            } else if (i == 5) {
              if (indexes[i] == 1) {
                points += 200.65;
              } else {
                points -= 103.49;
              }
            } else if (i == 6) {
              if (indexes[i] == 1) {
                points += 533.65;
              } else {
                points -= 122.47;
              }
            } else if (i == 7) {
              if (indexes[i] == 1) {
                points -= 52834.93;
              } else {
                points += 430.82;
              }
            } else if (i == 8) {
              if (indexes[i] == 1) {
                points -= 2183.69;
              } else {
                points += 933.01;
              }
            } else if (i == 9) {
              if (indexes[i] == 1) {
                points += 5555.55;
              } else {
                points -= 524.89;
              }
            } else if (i == 10) {
              if (indexes[i] == 1) {
                points -= 7583.69;
              } else {
                points += 1003.01;
              }
            } else if (i == 11) {
              if (indexes[i] == 1) {
                points += 5555.55;
              } else {
                points -= 5224.89;
              }
            } else if (i == 12) {
              if (indexes[i] == 1) {
                points += 500000;
              } else {
                points -= 5;
              }
            } else if (i == 13) {
              if (indexes[i] == 1) {
                points -= 5555.55;
              } else {
                points += 524.89;
              }
            } else if (i == 14) {
              if (indexes[i] == 1) {
                points -= 9555.27;
              } else {
                points += 1024.37;
              }
            } else if (i == 15) {
              if (indexes[i] == 1) {
                points += 15545.72;
              } else {
                points -= 723.26;
              }
            } else if (i == 16) {
              if (indexes[i] == 1) {
                points += 2572.02;
              } else {
                points -= 273.89;
              }
            } else if (i == 17) {
              if (indexes[i] == 1) {
                points -= 2572.02;
              } else {
                points += 873.32;
              }
            } else if (i == 18) {
              if (indexes[i] == 1) {
                points -= 22572.02;
              } else {
                points += 273.89;
              }
            } else if (i == 19) {
              if (indexes[i] == 1) {
                points -= 220572.02;
              } else {
                points += 10273.89;
              }
            }
          }

          if (points > 0) {
            return AlertDialog(
              title: Text(
                "+" + points.toStringAsFixed(2),
                style: new TextStyle(
                    fontFamily: 'Palanquin',
                    fontSize: 36,
                    color: Colors.green,
                    fontWeight: FontWeight.w700
                ),
              ),
              content: new Text(
                "You're morrally correct 😊",
                style: new TextStyle(
                  fontFamily: 'Palanquin',
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text(
                    "SUPPORT",
                    style: new TextStyle(
                        fontFamily: 'Palanquin',
                        fontWeight: FontWeight.w700,
                        color: Colors.redAccent
                    ),
                  ),
                  onPressed: () {
                    _showDonateDialog();
                  },
                ),

                new FlatButton(
                  child: new Text(
                    "CLOSE",
                    style: new TextStyle(
                        fontFamily: 'Palanquin',
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[700]
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          } else {
            return AlertDialog(
              title: Text(
                points.toStringAsFixed(2),
                style: new TextStyle(
                    fontFamily: 'Palanquin',
                    fontSize: 36,
                    color: Colors.red,
                    fontWeight: FontWeight.w700
                ),
              ),
              content: new Text(
                "You're morally corrupt 😈",
                style: new TextStyle(
                  fontFamily: 'Palanquin',
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text(
                    "SUPPORT",
                    style: new TextStyle(
                        fontFamily: 'Palanquin',
                        fontWeight: FontWeight.w700,
                        color: Colors.red
                    ),
                  ),
                  onPressed: () {
                    _showDonateDialog();
                  },
                ),

                new FlatButton(
                  child: new Text(
                    "CLOSE",
                    style: new TextStyle(
                        fontFamily: 'Palanquin',
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[700]
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }
        } else {
          return AlertDialog(
            title: Text(
              "Oops!",
              style: new TextStyle(
                  fontFamily: 'Palanquin',
                  fontWeight: FontWeight.w700
              ),
            ),
            content: new Text("One or more questions were not answered",
              style: new TextStyle(
                fontFamily: 'Palanquin',
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text("GO BACK",
                  style: new TextStyle(
                    fontFamily: 'Palanquin',
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[700],
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
      },
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "About",
            style: new TextStyle(
                fontFamily: 'Palanquin',
                fontWeight: FontWeight.w700
            ),
          ),
          content: new Text(
            "Developed by Bradley Windybank in NZ 🇳🇿, I'm a student developer, so bugs may be present and may take a while to fix, sorry!\n\n"
                "App is Copyright © Bradley Windybank, 2019 - All Rights Reserved.\n\n"
                "App takes inspiration from 'The Good Place' TV show but all trademark use, inspiration and similarities come under fair use.",
            style: new TextStyle(
              fontFamily: 'Palanquin',
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("GO BACK",
                style: new TextStyle(
                  fontFamily: 'Palanquin',
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[700],
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDonateDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Donate",
            style: new TextStyle(
                fontFamily: 'Palanquin',
                fontWeight: FontWeight.w700
            ),
          ),
          content: new Text(
            "I'm a University Student from New Zealand. If you enjoyed the app, feel free to donate, every little bit helps.\n\n"
                "Thank you ❤️",
            style: new TextStyle(
              fontFamily: 'Palanquin',
            ),
          ),
          actions: <Widget>[
            for (var prod in _products)
              ...[
                new FlatButton(
                  child: new Text(prod.price,
                    style: new TextStyle(
                        fontFamily: 'Palanquin',
                        fontWeight: FontWeight.w700
                    ),
                  ),
                  onPressed: () {
                    _buyProduct(prod);
                  },
                ),
              ],

            new FlatButton(
              child: new Text("GO BACK",
                style: new TextStyle(
                    fontFamily: 'Palanquin',
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[700]
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showThanksDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Thank you",
            style: new TextStyle(
                fontFamily: 'Palanquin',
                fontWeight: FontWeight.w700
            ),
          ),
          content: new Text(
            "Thanks so much for your support ❤️",
            style: new TextStyle(
              fontFamily: 'Palanquin',
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("GO BACK",
                style: new TextStyle(
                  fontFamily: 'Palanquin',
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[700],
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Error",
            style: new TextStyle(
                fontFamily: 'Palanquin',
                fontWeight: FontWeight.w700
            ),
          ),
          content: new Text(
            "An error occurred or the payment was aborted",
            style: new TextStyle(
              fontFamily: 'Palanquin',
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OKAY",
                style: new TextStyle(
                  fontFamily: 'Palanquin',
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[700],
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
