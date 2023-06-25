import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String timestampToString(Timestamp? timestamp) {
  if (timestamp != null) {
    final dateTime = timestamp.toDate();
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(dateTime);
  }
  return '';
}