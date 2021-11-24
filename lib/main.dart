import 'package:flutter/material.dart';
import 'package:final_flutter/screens/home.screen.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final HttpLink link = HttpLink(
    'http://localhost:4000/graphql'
  );

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      cache: GraphQLCache(),
      link: link
    )
  );

  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  final ValueNotifier<GraphQLClient> client;

  const MyApp({Key? key,required this.client}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GraphQLProvider(
      client: client,
      child: CacheProvider(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Final de programación móvil',
          home: HomeScreen(),
        ),
      ),
    );
  }
}