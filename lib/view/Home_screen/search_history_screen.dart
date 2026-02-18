import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../controller/app_main/App_main_controller.dart';
import '../../controller/home/search_controller.dart';
import '../../controller/post/app_post_controller.dart';
import '../../core/app_color.dart';
import '../../core/app_prefrences.dart';
import '../../core/app_textstyle.dart';
import '../../widget/custom_vertical_listview_list.dart';
import '../../widget/my_post_list_custom.dart';
import '../../widget/form_widgets/app_button.dart';
import '../../widget/custom_navigator.dart'; // Added
import '../profile_screens/My Posts/Post_Details_screen.dart';

class SearchHistoryScreen extends StatefulWidget {
  final String? nextPageName;
  const SearchHistoryScreen({super.key, this.nextPageName});

  @override
  State<SearchHistoryScreen> createState() => _SearchHistoryScreenState();
}

class _SearchHistoryScreenState extends State<SearchHistoryScreen> {
  late final SearchForPostsController controller;
  final FocusNode _focusNode = FocusNode();
  List<String> searchHistory = [];
  List<String> filteredSuggestions = [];
  static const String _searchHistoryKey = 'search_history';
  static const int _maxHistoryItems = 10;
  bool isUserTyping = false;
  final AppPostController postcontroller = Get.put(AppPostController());

  @override
  void initState() {
    super.initState();
    controller = Get.put(SearchForPostsController());
    controller.searchController.addListener(_onSearchChanged);
    _focusNode.addListener(_onFocusChanged);
    _loadSearchHistory();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   controller.onSearchTap();
    // });


    // ✅ REMOVE ANDROID KEYBOARD BLACK LINE
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );
  }

  @override
  void dispose() {
    controller.searchController.removeListener(_onSearchChanged);
    _focusNode.removeListener(_onFocusChanged);
    controller.searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    _filterSuggestions();
    setState(() {});
  }

  void _onSearchChanged() {
    isUserTyping = controller.searchController.text.trim().isNotEmpty;
    _filterSuggestions();
    setState(() {});
  }

  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();

    final history = prefs.getStringList(_searchHistoryKey) ?? [];

    print('📦 Initial History Loaded: $history');


    setState(() {
      searchHistory = history;
      _filterSuggestions(); // query ke basis par filter
    });

  }

  Future<void> _saveSearchQuery(String query) async {
    if (query.trim().isEmpty) return;

    final trimmedQuery = query.trim();
    print(" save search query : $trimmedQuery");

    final prefs = await SharedPreferences.getInstance();

    // 🔹 Load existing list FIRST
    final history = prefs.getStringList(_searchHistoryKey) ?? [];

    history.remove(trimmedQuery);
    history.insert(0, trimmedQuery);

    if (history.length > _maxHistoryItems) {
      history.removeRange(_maxHistoryItems, history.length);
    }

    await prefs.setStringList(_searchHistoryKey, history);

    final savedHistory = prefs.getStringList(_searchHistoryKey);
    print('📦 History from SharedPreferences (REAL): $savedHistory');

    setState(() {
      searchHistory = history;
      _filterSuggestions();
    });
  }

  void _filterSuggestions() {
    final query = controller.searchController.text.trim().toLowerCase();

    // 🔹 Focus nahi hai → suggestions nahi
    if (!_focusNode.hasFocus) {
      filteredSuggestions = [];
      return;
    }

    // 🔹 Text empty hai → puri history dikhao
    if (query.isEmpty) {
      filteredSuggestions = List.from(searchHistory);
      return;
    }

    // 🔹 Text type ho raha hai → filtered history
    filteredSuggestions = searchHistory
        .where((item) => item.toLowerCase().contains(query))
        .toList();
  }

  void _onSuggestionTap(String suggestion) {
    controller.searchController.text = suggestion;

    controller.searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: suggestion.length),
    );

    // ✅ Cursor forcefully show
    _focusNode.requestFocus();

    // ❌ Search yahin mat chalao (sirf text fill karo)
    setState(() {
      filteredSuggestions = [];
    });
  }


  void _performSearch(String query) {
    print(" Query : $query");


    isUserTyping = false; // ❌ stop suggestions

    if (query.trim().isEmpty) return;

    _saveSearchQuery(query);
    _focusNode.unfocus();
  }

  Future<void> _removeSingleHistoryItem(String value) async {
    final prefs = await SharedPreferences.getInstance();

    searchHistory.remove(value);
    filteredSuggestions.remove(value);

    await prefs.setStringList(_searchHistoryKey, searchHistory);

    print('❌ Removed from history: $value');
    print('📦 Updated History: $searchHistory');

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {



    final AppSettingsController appController = Get.put(
      AppSettingsController(),
    );
    final homePage = appController.homePage.value; // <-- HomePage? model
    final search=homePage?.design?.searchBar?.title;

    return Scaffold(
      backgroundColor: Colors.transparent,

      // ⭐ MOST IMPORTANT
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: AppColors.appTextColor),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppColors.appbarColor,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.appTextColor),
          onPressed: () => Get.back(),
        ),
        title: Material(
          color: Colors.transparent,
          child: Theme(
            data: Theme.of(context).copyWith(
              textSelectionTheme: TextSelectionThemeData(
                selectionColor: AppColors.appColor,
                selectionHandleColor: AppColors.appColor,
              ),
            ),
            child: TextField(
              controller: controller.searchController,
              focusNode: _focusNode,
              autofocus: true,
              cursorColor: AppColors.appTextColor,
              style: AppTextStyle.title(color: AppColors.appTextColor),
              decoration: InputDecoration(
                hintText: search,
                hintStyle: TextStyle(
                  color: AppColors.appTextColor.withOpacity(0.7),
                ),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                isDense: true,
                isCollapsed: true,
              ),
              onChanged: (value) {
                _filterSuggestions();
                setState(() {});
              },
              onSubmitted: (value) {
                _performSearch(value);
                _focusNode.unfocus();
              },
            ),
          ),
        ),

        actions: [
          if (controller.searchController.text.isNotEmpty)
            IconButton(
              icon: Icon(Icons.clear, color: AppColors.appTextColor),
              onPressed: () {
                controller.searchController.clear();

                isUserTyping = false; // ❌ stop suggestions
                filteredSuggestions = [];
                _focusNode.requestFocus();
                setState(() {});

              },
            ),

          if (controller.searchController.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 8.0, top: 8.0, bottom: 8.0),
              child: InkWell(
                onTap: () {
                  _performSearch(controller.searchController.text);
                  _focusNode.unfocus(); // Keyboard + suggestions hide karo (better UX)
                  controller.onSearchTap();
                  CustomNavigator.navigate(widget.nextPageName ?? "search_filter_screen"); // Use CustomNavigator
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.appButtonColor,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.search,
                    color: AppColors.appButtonTextColor,
                    size: 20,
                  ),
                ),
              ),
            ),
        ],
      ),

      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: AppColors.appPagecolor,
        ),
        padding: EdgeInsets.only(
          top: kToolbarHeight + MediaQuery.of(context).padding.top,
        ),
        child: Column(
          children: [
            /// 🔹 SEARCH SUGGESTIONS
            if (_focusNode.hasFocus && filteredSuggestions.isNotEmpty)
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                margin: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  gradient: AppColors.appPagecolor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  itemCount: filteredSuggestions.length,
                  itemBuilder: (context, index) {
                    final suggestion = filteredSuggestions[index];
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _onSuggestionTap(suggestion),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.history,
                                color: AppColors.appDescriptionColor,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  suggestion,
                                  style: AppTextStyle.description(
                                    color: AppColors.appDescriptionColor,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () =>
                                    _removeSingleHistoryItem(suggestion),
                                child: Icon(
                                  Icons.clear,
                                  color: AppColors.appDescriptionColor,
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

          ],
        ),
      ),
    );
  }
}