import 'package:bloc/bloc.dart';
import 'package:sidebarandnavigation/screens/aacount_page.dart';
import 'package:sidebarandnavigation/screens/home_page.dart';
import 'package:sidebarandnavigation/screens/order_page.dart';


enum NavigationEvents {
  HomePageClickedEvent,
  AccountClickedEvent,
  OrdersClickedEvent,
}

abstract class NavigationStates {

}


class NavigationBloc extends Bloc<NavigationEvents, NavigationStates>{


  @override
  NavigationStates get initialState => HomePage();

  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    switch (event) {
      case NavigationEvents.HomePageClickedEvent:
        yield HomePage();
        break;
      case NavigationEvents.AccountClickedEvent:
        yield AccountsPage();
        break;
      case NavigationEvents.OrdersClickedEvent:
        yield OrdersPage();
        break;
    }
  }


}