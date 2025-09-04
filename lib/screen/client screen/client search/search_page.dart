import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:freelancer/screen/client%20screen/client%20service%20details/client_service_details.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../widgets/constant.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> serviceList = [
    'All',
    'Logo Design',
    'Brand Style Guide',
    'Fonts & Typography',
  ];

@override
void initState() {
  super.initState();
  _tabController = TabController(length: serviceList.length, vsync: this);
  _tabController.addListener(() {
    setState(() {}); 
  });
}


  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            runSpacing: 16,
            children: [
              Center(
                child: Container(
                  height: 5,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text("Filters",
                  style: kTextStyle.copyWith(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              const Divider(),

              // Category Filter
              Text("Category",
                  style: kTextStyle.copyWith(fontWeight: FontWeight.w600)),
              Wrap(
                spacing: 8,
                children: serviceList.map((e) {
                  return ChoiceChip(
                    label: Text(e),
                    selected: _tabController.index == serviceList.indexOf(e),
                    onSelected: (v) {
                      if (v) {
                        setState(() {
                          _tabController.index = serviceList.indexOf(e);
                        });
                        Navigator.pop(context);
                      }
                    },
                  );
                }).toList(),
              ),

              // Price Range Filter
              const SizedBox(height: 10),
              Text("Price Range",
                  style: kTextStyle.copyWith(fontWeight: FontWeight.w600)),
              RangeSlider(
                values: const RangeValues(10, 80),
                min: 0,
                max: 100,
                divisions: 10,
                activeColor: kPrimaryColor,
                onChanged: (values) {},
              ),

              // Rating Filter
              const SizedBox(height: 10),
              Text("Minimum Rating",
                  style: kTextStyle.copyWith(fontWeight: FontWeight.w600)),
              Row(
                children: List.generate(5, (index) {
                  return Icon(Icons.star,
                      color: index < 4 ? Colors.amber : Colors.grey);
                }),
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Apply Filters",style: TextStyle(color: kWhite),),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkWhite,
    appBar: AppBar(
  elevation: 0.0,
  backgroundColor: kDarkWhite,
  centerTitle: true,
  iconTheme: const IconThemeData(color: kNeutralColor),
  leading: IconButton(
    icon: const Icon(Icons.arrow_back, color: kNeutralColor),
    onPressed: () => Navigator.pop(context),
  ),
  title: Text(
    'Post for you',
    style: kTextStyle.copyWith(
        color: kNeutralColor, fontWeight: FontWeight.bold),
  ),
  actions: [
    Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: GestureDetector(
        onTap: _openFilterSheet,
        child: const Icon(
          FeatherIcons.sliders,
          color: kNeutralColor,
        ),
      ),
    )
  ],
  bottom: PreferredSize(
    preferredSize: const Size.fromHeight(65),
    child: TabBar(
      controller: _tabController,
      isScrollable: true,
      indicator: const BoxDecoration(),
      onTap: (_) => setState(() {}),
      labelPadding: EdgeInsets.zero,
      tabs: serviceList.map((e) {
        final isSelected = _tabController.index == serviceList.indexOf(e);
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: isSelected ? kPrimaryColor : Colors.white,
            gradient: isSelected
                ? LinearGradient(
                    colors: [kPrimaryColor, kPrimaryColor.withOpacity(0.7)],
                  )
                : null,
            borderRadius: BorderRadius.circular(30),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: kPrimaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
            border: Border.all(
              color: isSelected ? kPrimaryColor : kBorderColorTextField,
              width: 1.2,
            ),
          ),
          child: Text(
            e,
            style: kTextStyle.copyWith(
                color: isSelected ? Colors.white : kNeutralColor,
                fontWeight: FontWeight.w600),
          ),
        );
      }).toList(),
    ),
  ),
),

      body: TabBarView(
        controller: _tabController,
        children: serviceList.map((category) {
          List<Service> filtered = category == 'All'
              ? services
              : services
                  .where((s) =>
                      s.title.toLowerCase().contains(category.toLowerCase()))
                  .toList();

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.count(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 0.75,
              crossAxisCount: 2,
              children: List.generate(
                filtered.length,
                (index) {
                  final service = filtered[index];
                  return GestureDetector(
                    onTap: () {
                      const ClientServiceDetails().launch(context);
                    },
                    child: Container(
                      height: 205,
                      width: 156,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: kBorderColorTextField),
                        boxShadow: const [
                          BoxShadow(
                            color: kDarkWhite,
                            blurRadius: 5.0,
                            spreadRadius: 2.0,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                height: 100,
                                width: 156,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(12.0),
                                    topLeft: Radius.circular(12.0),
                                  ),
                                  image: DecorationImage(
                                    image: AssetImage(service.image),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    service.isFavorite = !service.isFavorite;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: service.isFavorite
                                        ? const Icon(Icons.favorite,
                                            color: Colors.red, size: 18)
                                        : const Icon(Icons.favorite_border,
                                            color: kNeutralColor, size: 18),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  service.title,
                                  style: kTextStyle.copyWith(
                                      color: kNeutralColor,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const Icon(IconlyBold.star,
                                        color: Colors.amber, size: 18),
                                    const SizedBox(width: 2),
                                    Text('${service.rating}',
                                        style: kTextStyle.copyWith(
                                            color: kNeutralColor)),
                                    const SizedBox(width: 2),
                                    Text('(${service.reviews} review)',
                                        style: kTextStyle.copyWith(
                                            color: kLightNeutralColor)),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                RichText(
                                  text: TextSpan(
                                    text: 'Price: ',
                                    style: kTextStyle.copyWith(
                                        color: kLightNeutralColor),
                                    children: [
                                      TextSpan(
                                        text: '$currencySign${service.price}',
                                        style: kTextStyle.copyWith(
                                            color: kPrimaryColor,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class Service {
  final String title;
  final String image;
  final double rating;
  final int reviews;
  final int price;
  bool isFavorite;

  Service({
    required this.title,
    required this.image,
    required this.rating,
    required this.reviews,
    required this.price,
    this.isFavorite = false,
  });
}

List<Service> services = [
  Service(
      title: 'Mobile UI UX design or app design',
      image: 'images/shot1.png',
      rating: 5.0,
      reviews: 520,
      price: 30),
  Service(
      title: 'Web Design & Development',
      image: 'images/shot2.png',
      rating: 4.8,
      reviews: 310,
      price: 50),
  Service(
      title: 'Logo Design Premium',
      image: 'images/shot1.png',
      rating: 4.9,
      reviews: 410,
      price: 25),
  Service(
      title: 'Fonts & Typography Pack',
      image: 'images/shot2.png',
      rating: 4.7,
      reviews: 200,
      price: 15),
];
