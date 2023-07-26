import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class ImageRepository {
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  Future<String> getImage(reference) async {
    final String url =
        await firebaseStorage.ref('images/$reference').getDownloadURL();
    return url;
  }

  Future<String> uploadImage(file) async {
    var uuid = const Uuid();
    var fileName = uuid.v1();
    try {
      await firebaseStorage.ref('images/$fileName').putFile(file);
      return getImage(fileName);
    } on FirebaseException catch (e) {
      return '';
    }
  }
}
