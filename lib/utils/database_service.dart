import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseServices {
  static CollectionReference productCollection =
      Firestore.instance.collection('products');

  static Future<void> createOrUpdateProduct(String id,
      {String jenis, String date, int price}) async {}
}
