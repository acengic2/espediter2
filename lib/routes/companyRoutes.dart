import 'package:cloud_firestore/cloud_firestore.dart';

// Company Routes klasa

class CompanyRutes {
  // getCompanyRoutes
  //
  // metoda koja prima [id] (userID) i koja filtrira kroz kolekciju ruta
  // izjednacava [user_id] iz baze i id trenutno logovane kompanije
  getCompanyRoutes(String id) {
    return Firestore.instance
        .collection('Rute')
        .where('user_id', isEqualTo: id)
        .getDocuments();
  }
}
