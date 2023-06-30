import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esgi_tweet/models/user.dart';
import 'package:esgi_tweet/screens/search/profile_card_item.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = UserApp(
        firstname: "Zine",
        lastname: "lastname",
        pseudo: "pseudo",
        email: "email",
        birthDate: Timestamp.fromDate(DateTime.now()),
        phoneNumber: "",
        address: "address",
        photoURL:
            "https://v.wpimg.pl/OTMyODguYDUsGzl3SA5tIG9DbS0OV2N2OFt1ZkhEfWR9AXlzUlo8MmAYKykOGyYnOQsuJw0UYSM9GisqSQUjez4NIDYGEipmYh8qJRMAPTEpJiA2DhImOiwVYHJUQnliKB13JQRGfjd7Jn1yVEx8ZnVBYS4XEm0p");
    return ListView.builder(
        itemCount: 23,
        itemBuilder: (item, index) {
          return ProfileCardItem(
            user: user, onTap: () { print("item ${index}"); },
          );
        });
  }
}
