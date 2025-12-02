import 'package:get/get.dart';

class ClientAllCategoriesController extends GetxController {
  final RxList<String> catName = [
    'Graphics Design',
    'Video Editing',
    'Digital Marketing',
    'Business',
    'Writing & Translation',
    'Programming',
    'Lifestyle'
  ].obs;

  final RxList<String> catIcon = [
    'assets/images/graphic.png',
    'assets/images/videoicon.png',
    'assets/images/dm.png',
    'assets/images/b.png',
    'assets/images/t.png',
    'assets/images/p.png',
    'assets/images/l.png'
  ].obs;
}