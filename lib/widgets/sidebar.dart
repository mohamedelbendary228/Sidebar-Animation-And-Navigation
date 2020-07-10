import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sidebarandnavigation/bloc/navigation_bloc.dart';
import 'package:sidebarandnavigation/widgets/custom_clipper.dart';
import 'package:sidebarandnavigation/widgets/menu_items.dart';

class SideBar extends StatefulWidget {
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar>
    with SingleTickerProviderStateMixin<SideBar> {
  final _animationDuration = const Duration(milliseconds: 500);
  StreamController<bool> _isSidebarOpenStreamController;
  Stream<bool> _isSidebarOpenStream;
  StreamSink<bool> _isSidebarOpenSink;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: _animationDuration);
    _isSidebarOpenStreamController = PublishSubject<bool>();
    _isSidebarOpenStream = _isSidebarOpenStreamController.stream;
    _isSidebarOpenSink = _isSidebarOpenStreamController.sink;
  }

  @override
  void dispose() {
    _controller.dispose();
    _isSidebarOpenStreamController.close();
    _isSidebarOpenSink.close();
    super.dispose();
  }

  void onIconPressed() {
    final animationStatus = _controller.status;
    final isAnimationCompleted = animationStatus == AnimationStatus.completed;
    if (isAnimationCompleted) {
      _isSidebarOpenSink.add(false);
      _controller.reverse();
    } else {
      _isSidebarOpenSink.add(true);
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return StreamBuilder<bool>(
      initialData: false,
      stream: _isSidebarOpenStream,
      builder: (context, sidebarSnapshot) {
        return AnimatedPositioned(
          duration: _animationDuration,
          top: 0,
          bottom: 0,
          left: sidebarSnapshot.data ? 0 : -mediaQuery.width,
          right: sidebarSnapshot.data ? 0 : mediaQuery.width - 45,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.deepPurple,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 100),
                        ListTile(
                          title: Text(
                            "Mohamed Elbendary",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800),
                          ),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage('https://scontent-pmo1-1.xx.fbcdn.net/v/t1.0-9/79766450_1299776156872077_4990517492737638400_n.jpg?_nc_cat=103&_nc_sid=09cbfe&_nc_ohc=QCD0YxofUEQAX-Go4cu&_nc_ht=scontent-pmo1-1.xx&oh=0249573987ffd5f71ffdd275fb906064&oe=5F2EB8D7'),
                            radius: 25,
                          ),
                        ),
                        Divider(
                          height: 64,
                          thickness: 1,
                          color: Colors.white.withOpacity(0.3),
                          indent: 32,
                          endIndent: 32,
                        ),
                        MenuItem(
                          icon: Icons.home,
                          title: 'Home',
                          onTap: () {
                            onIconPressed();
                            BlocProvider.of<NavigationBloc>(context).add(
                              NavigationEvents.HomePageClickedEvent,
                            );
                          },
                        ),
                        MenuItem(
                          icon: Icons.person,
                          title: 'Account',
                          onTap: () {
                            onIconPressed();
                            BlocProvider.of<NavigationBloc>(context).add(
                              NavigationEvents.AccountClickedEvent,
                            );
                          },
                        ),
                        MenuItem(
                          icon: Icons.shopping_cart,
                          title: 'Orders',
                          onTap: () {
                            onIconPressed();
                            BlocProvider.of<NavigationBloc>(context).add(
                              NavigationEvents.OrdersClickedEvent,
                            );
                          },
                        ),
                        Divider(
                          height: 64,
                          thickness: 1,
                          color: Colors.white.withOpacity(0.3),
                          indent: 32,
                          endIndent: 32,
                        ),
                        MenuItem(
                          icon: Icons.settings,
                          title: 'Setting',
                          onTap: () {},
                        ),
                        MenuItem(
                          icon: Icons.exit_to_app,
                          title: 'Logout',
                          onTap: () {},
                        ),
                      ],
                    )),
              ),
              Align(
                alignment: Alignment(0, -0.9),
                child: GestureDetector(
                  onTap: () => onIconPressed(),
                  child: ClipPath(
                    clipper: CustomMenuClipper(),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      width: 35,
                      height: 110,
                      color: Colors.deepPurple,
                      child: AnimatedIcon(
                        progress: _controller.view,
                        icon: AnimatedIcons.menu_close,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
