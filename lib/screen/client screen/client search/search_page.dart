import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:freelancer/screen/seller%20screen/seller%20home/my%20service/service_details.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../widgets/constant.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<String> serviceList = [
    'All',
    'Logo Design',
    'Brand Style Guide',
    'Fonts & Typography',
  ];
  String selectedServiceList = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkWhite,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: kDarkWhite,
        centerTitle: true,
        iconTheme: const IconThemeData(color: kNeutralColor),
        title: Text(
          'Popular Services',
          style: kTextStyle.copyWith(
              color: kNeutralColor, fontWeight: FontWeight.bold),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15.0),
            child: Icon(
              FeatherIcons.sliders,
              color: kNeutralColor,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Container(
          decoration: const BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 15.0),
                HorizontalList(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  itemCount: serviceList.length,
                  itemBuilder: (_, i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedServiceList = serviceList[i];
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: selectedServiceList == serviceList[i]
                                ? kPrimaryColor
                                : kDarkWhite,
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          child: Text(
                            serviceList[i],
                            style: kTextStyle.copyWith(
                              color: selectedServiceList == serviceList[i]
                                  ? kWhite
                                  : kNeutralColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                    childAspectRatio: 0.75,
                    crossAxisCount: 2,
                    children: List.generate(
                      services.length,
                      (index) {
                        bool isFavorite = false;
                        final service = services[index];
                        return GestureDetector(
                          onTap: () {
                            const ServiceDetails().launch(context);
                          },
                          child: Container(
                            height: 205,
                            width: 156,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
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
                                          topRight: Radius.circular(8.0),
                                          topLeft: Radius.circular(8.0),
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
                                          isFavorite = !isFavorite;
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
                                          child: isFavorite
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
                                              text:
                                                  '$currencySign${service.price}',
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
                ),
              ],
            ),
          ),
        ),
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

  Service({
    required this.title,
    required this.image,
    required this.rating,
    required this.reviews,
    required this.price,
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
  // Add more services here
];
