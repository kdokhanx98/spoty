
import 'dart:async';

import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PurchaseProvider with ChangeNotifier{
   final InAppPurchase _iap = InAppPurchase.instance;
   late StreamSubscription<List<PurchaseDetails>> subscription;
   late final Stream<List<PurchaseDetails>> purchaseUpdated;
   bool available = true;
   static const productID = "yearly_with_free_trial";

   bool _isPurchased = false;
   bool get isPurchased => _isPurchased;
   set isPurchased(bool value) {
      _isPurchased = value;
      notifyListeners();
   }

   // here is the list of purchases

   List _purchases = [];
   List get purchases => _purchases;
   set purchases(List value) {
      _purchases = value;
      notifyListeners();
   }

   List _products = [];
   List get products => _products;
   set products(List value){
      _products = value;
      notifyListeners();
   }

   void initialize() async {
      purchaseUpdated = InAppPurchase.instance.purchaseStream;
      available = await _iap.isAvailable();
      print("available: $available");
      if (available) {
         await _getProducts();
         await _getPastPurchases();
         verifyPurchases();
         subscription = purchaseUpdated.listen((purchaseDetailsList) {
            purchases.addAll(purchaseDetailsList);
            verifyPurchases();
         }, onDone: () {
            subscription.cancel();
         }, onError: (error) {
            // handle error here.
         });
      }
   }


   void verifyPurchases(){

      PurchaseDetails purchase = hasPurchased(productID);

      if(purchase != null && purchase.status == PurchaseStatus.restored){
         isPurchased = true;
      }else if(purchase != null && purchase.status == PurchaseStatus.pending){
         Fluttertoast.showToast(msg: "Your purchase is pending, try again later");
      }else if(purchase != null && purchase.status == PurchaseStatus.error) {
        Fluttertoast.showToast(msg: "Error: ${purchase.error!.message}");
      }else if(purchase != null && purchase.status == PurchaseStatus.purchased) {
         if(purchase.pendingCompletePurchase){
            _iap.completePurchase(purchase);
            isPurchased = true;
         }
      }

   }

   PurchaseDetails hasPurchased(String productID) {
      return purchases
          .firstWhereOrNull((purchase) => purchase.productID == productID);
   }

   Future<void> _getProducts() async {
      const Set<String> ids = <String>{productID};
      ProductDetailsResponse response = await _iap.queryProductDetails(ids);
      products = response.productDetails;
   }

   Future<void> _getPastPurchases() async {
      _iap.restorePurchases();
   }


}