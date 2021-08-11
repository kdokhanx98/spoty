import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:spoty/providers/purchase_provider.dart';
import 'package:spoty/screens/signup_screen.dart';

class SubScreen extends StatefulWidget {
  static const routeName = '/SubScreen';

  @override
  _SubScreenState createState() => _SubScreenState();
}

class _SubScreenState extends State<SubScreen> {
  final InAppPurchase _iap = InAppPurchase.instance;



  void _buyProduct(ProductDetails prod) {
    final purhcaseParam = PurchaseParam(productDetails: prod);
    _iap.buyNonConsumable(purchaseParam: purhcaseParam);
  }



  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PurchaseProvider>(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    print("purchased: ${provider.isPurchased}");

    WidgetsBinding.instance!.addPostFrameCallback((_){

    if(provider.isPurchased){
      Navigator.popAndPushNamed(context, SignUp.routeName);
    }
    });

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset("assets/images/subscription_image.png", width: width * 0.6, height: height * 0.3,),
                SizedBox(width: width * 0.01,),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(25)),
                        color: HexColor("#006D72"),
                      ),
                      child: IconButton(
                        iconSize: 25,
                        color: Colors.white,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.01,),
             Text(
              "Get Unlimited Access\nTo All Features",
              style: TextStyle(
                  fontSize: 24,
                  color: HexColor("#006D72"),
                  fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
            ),
            SizedBox(height: height * 0.02,),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: ListTile(
                      title: const Text(
                        "Unlock all app features and get unlimited access",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.start,
                      ),
                      leading: IconButton(
                        iconSize: 25,
                        color: Colors.black,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon:  Icon(Icons.check, color: HexColor("#006D72"),),
                      ),
                    ),
                  ),
                ),

            SizedBox(height: height * 0.03,),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ListTile(
                  title: const Text(
                    "Track real-time location of your family and keep them safe",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                  leading: IconButton(
                    iconSize: 25,
                    color: Colors.black,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon:  Icon(Icons.track_changes, color: HexColor("#006D72"),),
                  ),
                ),
              ),
            ),

            SizedBox(height: height * 0.03,),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ListTile(
                  title: const Text(
                    "Get full location report and\nset smart notifications",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                  leading: IconButton(
                    iconSize: 25,
                    color: Colors.black,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.map, color: HexColor("#006D72"),),
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.05,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GestureDetector(
                onTap: (){
                  if(!provider.available){
                    print("InAppPurchase: not available");
                    Fluttertoast.showToast(msg: "Play Store is not available!");
                  }else{
                    print("InAppPurchase: available");
                    for(var prod in provider.products){
                      print("id ${prod.id}");
                      provider.hasPurchased(prod.id);
                      if(provider.hasPurchased(prod.id) == null){
                        print("InAppPurchase: not purchased");
                        _buyProduct(prod);
                      }
                    }
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: height * 0.07,
                  decoration: BoxDecoration(
                    color: HexColor("006D72"),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "START FOR FREE",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.02,),
            const Text(
              "3 days free trial\nthen \$99.99/year",
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.normal),
              textAlign: TextAlign.center,
            ),

          ],
        ),
      ),
    );
  }

}
