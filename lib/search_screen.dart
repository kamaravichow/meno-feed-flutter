import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          titleSpacing: 0,
          leadingWidth: 10,
          leading: const SizedBox.shrink(),
          title: SizedBox(
            height: 46,
            child: SearchBar(
              focusNode: _searchFocusNode,
              elevation: MaterialStateProperty.all(0),
              trailing: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
              leading: IconButton(
                icon: const Icon(Icons.search_rounded),
                onPressed: () {},
              ),
              controller: _searchController,
              hintText: 'Search',
              onChanged: (text) {
                print(text);
              },
            ),
          ),
          actions: [
            Gap(10),
          ],
        ));
  }
}
