import 'package:get/get.dart';
import 'package:groomzy/model/provider.dart';

class ProviderController extends GetxController {
  final Rx<int> _selectedIndex = 0.obs;
  final Rx<Provider> _provider = Provider().obs;
  final RxList<Provider> _providers = [Provider()].obs;

  int get selectedIndex => _selectedIndex.value;
  set selectedIndex (int sIndex) => _selectedIndex.value = sIndex;

  Provider get provider => _provider.value;
  set provider(Provider p) => _provider.value = p;

  List<Provider> get providers => _providers.value;
  set providers(List<Provider> ps) => _providers.value = ps;
}
