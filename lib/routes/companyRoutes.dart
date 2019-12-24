import 'package:cloud_firestore/cloud_firestore.dart';
class CompanyRutes {
  getCompanyRoutes(String id) {
    return Firestore.instance
        .collection('Rute')
        .where('user_id', isEqualTo: id)
        .getDocuments();
  }
}