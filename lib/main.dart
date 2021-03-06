import 'package:flutter/material.dart';
import 'package:l_token/config/states.dart';
import 'package:l_token/pages/dialogs.dart';
import 'package:l_token/style/themes.dart';
import 'package:l_token/pages/main_page.dart';
import 'package:l_token/pages/routes/page.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

void main() {
  Store<AppState> store = new Store(appReducer,
      initialState: new AppState(theme: kLightTheme, loadingVisible: false));
  runApp(new App(store: store));
}

class App extends StatelessWidget {
  final Store<AppState> store;

  App({this.store});

  @override
  Widget build(BuildContext context) {
    return new StoreProvider(
        store: store,
        child: new StoreBuilder<AppState>(builder: (context, store) {
          bool needLoadingVisible = store.state.loadingVisible;
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Opacity(
                opacity: needLoadingVisible ? 1.0 : 0.0,
                child: _buildGlobalLoading(context),
              ),
              new MaterialApp(
                theme: store.state.theme.themeData,
                routes: _buildRoutes(),
                home: new MainPage(),
              ),
            ],
          );
        }));
  }

  _buildApp() {
    return new MaterialApp(
      theme: store.state.theme.themeData,
      routes: _buildRoutes(),
      home: new MainPage(),
    );
  }

  Map<String, WidgetBuilder> _buildRoutes() {
    return new Map<String, WidgetBuilder>.fromIterable(
      kAllPages,
      key: (dynamic page) => '${page.routeName}',
      value: (dynamic page) => page.buildRoute,
    );
  }

  _buildGlobalLoading(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        const ModalBarrier(
          color: Colors.grey,
        ),
        Container(
          width: 102.0,
          height: 102.0,
          padding: EdgeInsets.all(24.0),
          decoration: BoxDecoration(
              color: theme.backgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(12.0))),
          child: new CircularProgressIndicator(),
        )
      ],
    );
  }
}
