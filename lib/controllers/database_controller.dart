import 'package:e_commerce_app/models/add_to_cart_model.dart';
import 'package:e_commerce_app/models/delivery_method.dart';
import 'package:e_commerce_app/models/product.dart';
import 'package:e_commerce_app/models/user_data.dart';

import '../services/firestore_services.dart';
import '../utilites/api_path.dart';

abstract class Database {
  Stream<List<Product>> salesProductsStream();
  Stream<List<Product>> newProductsStream();
  Stream<List<AddToCartModel>> myProductsCart();
  Stream<List<DeliveryMethod>> deliveryMethodsStream();
  Future<void> setUserData(UserData userData);
  Future<void> addToCart(AddToCartModel product);
}

class FirestoreDatabase implements Database {
  final String uid;
  final _service = FireStoreServices.instance;
  FirestoreDatabase(this.uid);
  @override
  Stream<List<Product>> salesProductsStream() => _service.collectionsStream(
        path: ApiPath.product(),
        builder: (data, documentId) => Product.fromMap(data!, documentId),
        queryBuilder: (query) => query.where('discountValue', isNotEqualTo: 0),
      );
  @override
  Stream<List<Product>> newProductsStream() => _service.collectionsStream(
        path: ApiPath.product(),
        builder: (data, documentId) => Product.fromMap(data!, documentId),
      );

  @override
  Future<void> setUserData(UserData userData) async => await _service.setData(
        path: ApiPath.user(userData.uid),
        data: userData.toMap(),
      );

  @override
  Future<void> addToCart(AddToCartModel product) async => _service.setData(
        path: ApiPath.addToCart(uid, product.id),
        data: product.toMap(),
      );

  @override
  Stream<List<AddToCartModel>> myProductsCart() => _service.collectionsStream(
        path: ApiPath.myProductsCart(uid),
        builder: (data, documentId) =>
            AddToCartModel.fromMap(data!, documentId),
      );

  @override
  Stream<List<DeliveryMethod>> deliveryMethodsStream() =>
      _service.collectionsStream(
          path: ApiPath.deliveryMethods(),
          builder: (data, documentId) =>
              DeliveryMethod.fromMap(data!, documentId));}