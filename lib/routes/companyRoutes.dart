import 'package:cloud_firestore/cloud_firestore.dart';

class CompanyRutes {
  // getCompanyRoutes
  //
  // metoda koja prima [id] (userID) i koja filtrira kroz kolekciju ruta
  // izjednacava [user_id] iz baze i id trenutno logovane kompanije 
  // i fetcha sve dokumente koji imaju taj id
  getCompanyRoutes(String id) {
    print('Doslo je');
    return Firestore.instance
        .collection('Rute')
        .where('user_id', isEqualTo: id)
        .getDocuments();
  }
  

}
