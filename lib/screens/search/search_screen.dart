import 'package:esgi_tweet/blocs/users_bloc/users_bloc.dart';
import 'package:esgi_tweet/models/user.dart';
import 'package:esgi_tweet/screens/search/profile_card_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../profile/user_selected_profile_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _refreshController = RefreshController(initialRefresh: false);
  final TextEditingController _textFieldController = TextEditingController();
  List<UserApp> filteredUserList = [];
  List<UserApp> usersList = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  void _fetchUsers() {
    context.read<UsersBloc>().add(GetUsers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TextField(
          controller: _textFieldController,
          onChanged: (value) {
            setState(() {});
          },
          decoration: InputDecoration(
            hintText: 'Rechercher',
            filled: true,
            fillColor: Colors.white54,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide.none,
            ),
            suffixIcon: Icon(Icons.search),
          ),
        ),
      ),
      body: BlocBuilder<UsersBloc, UsersState>(
        builder: (context, state) {
          switch (state.status) {
            case UsersStatus.initial:
              return const SizedBox();
            case UsersStatus.loading:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case UsersStatus.error:
              return Center(
                child: Text(state.error),
              );
            case UsersStatus.success:
              final userList = state.users;

              if (userList.isEmpty) {
                return const Center(
                  child: Text('Aucun utilisateur trouvé'),
                );
              }
              usersList = userList;
              final searchText = _textFieldController.text.toLowerCase();

              filteredUserList = usersList
                  .where((user) =>
                      user.firstname.toLowerCase().contains(searchText) ||
                      user.pseudo.toLowerCase().contains(searchText) ||
                      user.lastname.toLowerCase().contains(searchText))
                  .toList();

              return SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                onRefresh: () async {
                  _onRefreshList(context);
                },
                child: ListView.builder(
                  itemCount: filteredUserList.length,
                  itemBuilder: (context, index) {
                    final user = filteredUserList[index];
                    return ProfileCardItem(
                      user: user,
                      onTap: () {
                        _onCardTap(context, user);
                      },
                    );
                  },
                ),
              );
          }
        },
      ),
    );
  }

  void _onCardTap(BuildContext context, UserApp userApp) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserSelectedProfilePage(user: userApp),
      ),
    );
  }

  void _onRefreshList(BuildContext context) {
    final postBloc = BlocProvider.of<UsersBloc>(context);
    postBloc.add(GetUsers());
    _refreshController.refreshCompleted();
  }
}
