import 'dart:io';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:connectivity/connectivity.dart';
import 'package:image_picker/image_picker.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class AddUserScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddUserScreenState();
  }
}

class _AddUserScreenState extends State<AddUserScreen> {
  late File image;
  late String sentBy;
  late int long;
  late int lat;
  final _formKey = GlobalKey<FormState>();
  final _descripcionController = TextEditingController();

  bool _isSaving = false;

  String insertUser() {
    return """
    mutation UploadFile(\$file: Upload, \$description: String, \$sentBy: String, \$long: Int, \$lat: Int) {
      uploadFile(file: \$file, description: \$description, sentBy: \$sentBy, long: \$long, lat: \$lat)
    }
    """;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Añadir usuario"),
        backgroundColor: Colors.blue[900],
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 36,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 10),
                  color: Colors.grey.shade300,
                  blurRadius: 30,
                ),
              ],
            ),
            child: Mutation(
              options: MutationOptions(
                document: gql(insertUser()),
                fetchPolicy: FetchPolicy.noCache,
                onCompleted: (data) => Navigator.pop(context, true),
              ),
              builder: (
                runMutation,
                result,
              ) {
                return formulario(runMutation);
              },
            ),
          ),
        ),
      ),
    );
  }

  formulario(runMutation) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          SizedBox(height: 12),
          ElevatedButton(
              onPressed: () {
                obtenerImagen(ImageSource.camera);
                obtenerTipoConectividad();
                obtenerUbicacion();
              },
              child: Text("Tomar Foto")),
          SizedBox(height: 15),
          TextFormField(
            controller: _descripcionController,
            decoration: new InputDecoration(
              labelText: "Descripción",
              fillColor: Colors.black,
              border: OutlineInputBorder(
                borderSide: BorderSide(),
              ),
            ),
            validator: (v) {
              if (v?.length == 0) {
                return "Name cannot be empty";
              } else {
                return null;
              }
            },
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 24),
          _isSaving
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                  ),
                )
              : TextButton(
                  onPressed: () {
                    setState(() {
                      _isSaving = true;
                    });

                    print('**********object*************');
                    print(image);
                    print(_descripcionController.text);
                    print(sentBy);
                    print(long);
                    print(lat);

                    runMutation({
                      'file': image,
                      'description': _descripcionController.text,
                      'sentBy': sentBy,
                      'long': long,
                      'lat': lat,
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 36,
                      vertical: 12,
                    ),
                    child: Text(
                      "Guardar",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Future obtenerImagen(ImageSource source) async {
    // ignore: invalid_use_of_visible_for_testing_member
    var picture = await ImagePicker.platform.pickImage(source: source);

    if (picture != null) {
      image = File(picture.path);
    }
  }

  Future obtenerUbicacion() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();

    long = _locationData.longitude!.toInt();
    lat = _locationData.latitude!.toInt();
  }

  Future obtenerTipoConectividad() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      sentBy = 'mobile';
    } else if (connectivityResult == ConnectivityResult.wifi) {
      sentBy = 'wifi';
    }
  }
}
