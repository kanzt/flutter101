import 'dart:io';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter101/src/constants/api.dart';
import 'package:flutter101/src/model/product_response.dart';
import 'package:flutter101/src/service/network.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class ManagementPage extends StatefulWidget {
  @override
  _ManagementPageState createState() => _ManagementPageState();
}

class _ManagementPageState extends State<ManagementPage> {
  File _image;
  final picker = ImagePicker();

  /// GlobalKey สำหรับ Trigger ว่าให้เข้า onSave ตอนไหน
  final _form = GlobalKey<FormState>();

  bool _editMode;
  ProductResponse _product;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  /// คล้าย onCreate ทำครั้งเดียวตอนเปิดหน้า ถ้าหากมีการ setState ใหม่ ก็จะไม่เข้า initState
  @override
  void initState() {
    _editMode = false;
    _product = ProductResponse();
    super.initState();
  }

  callback(File image) {
    _image = image;
  }

  @override
  Widget build(BuildContext context) {
    /// รับค่าข้ามหน้า
    Object argument = ModalRoute.of(context).settings.arguments;
    if (argument is ProductResponse) {
      _product = argument;
      _editMode = true;
    }

    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Form(
            /// ต้องใส่ _form เพื่อให้ตอนเวลากด save มันไป Trigger onSaved
            key: _form,
            child: Column(
              children: [
                _buildNameInput(),
                SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    /// สร้าง layout คล้าย Relative layout
                    Flexible(
                      child: _buildPriceInput(),

                      /// คล้าย Layout-weight
                      flex: 1,
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Flexible(
                      child: _buildStockInput(),

                      /// คล้าย Layout-weight
                      flex: 1,
                    ),
                  ],
                ),
                ProductImage(callback, image: _product.image)
              ],
            ),
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: getImage,
      //   tooltip: 'Pick Image',
      //   child: Icon(Icons.add_a_photo),
      // ),
    );
  }

  InputDecoration inputStyle({String label}) => InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black12,
          ),
        ),
        labelText: label,
      );

  /// ใส่ชื่อสินค้า
  TextFormField _buildNameInput() => TextFormField(
        /// เซ็ทค่าให้กับ TextFormField
        initialValue: _product.name ?? "",
        decoration: inputStyle(label: "name"),
        onSaved: (String value) {
          _product.name = value;
        },
      );

  /// ใส่ราคาสินค้า
  TextFormField _buildPriceInput() => TextFormField(
        initialValue: _product.price == null ? '0' : _product.price.toString(),
        decoration: inputStyle(label: "price"),
        keyboardType: TextInputType.number,
        onSaved: (String value) {
          _product.price = int.parse(value ?? '0');
        },
      );

  /// ใส่รจำนวนสินค้า
  TextFormField _buildStockInput() => TextFormField(
        initialValue: _product.stock == null ? '0' : _product.stock.toString(),
        decoration: inputStyle(label: "stock"),
        keyboardType: TextInputType.number,
        onSaved: (String value) {
          _product.stock = int.parse(value ?? '0');
        },
      );

  /// เปลี่ยนการแสดงผล Appbar ตาม editMode
  AppBar _buildAppBar() => AppBar(
        title: Text(_editMode ? 'Edit Product' : 'Add Product'),
        actions: [
          TextButton(
            onPressed: () async {
              _form.currentState.save();
              FocusScope.of(context).requestFocus(FocusNode());
              if (_editMode) {
                try {
                  final message =
                      await NetworkService().editProduct(_image, _product);
                  Navigator.pop(context);
                  showAlertBar(
                    message,
                  );
                } catch (ex) {}
              } else {
                try {
                  final message =
                      await NetworkService().addProduct(_image, _product);
                  Navigator.pop(context);
                  showAlertBar(
                    message,
                  );
                } catch (ex) {
                  showAlertBar(
                    ex.toString(),
                    color: Colors.red,
                    icon: FontAwesomeIcons.cross,
                  );
                }
              }
            },
            child: Text(
              'submit',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
      );

  /// แสดง Notification จากด้านบน
  void showAlertBar(
    String message, {
    IconData icon = FontAwesomeIcons.checkCircle,
    MaterialColor color = Colors.green,
  }) {
    Flushbar(
      message: message,
      icon: Icon(
        icon,
        size: 28.0,
        color: color,
      ),
      flushbarPosition: FlushbarPosition.TOP,
      duration: Duration(seconds: 3),
      flushbarStyle: FlushbarStyle.GROUNDED,
    )..show(context);
  }
}

class ProductImage extends StatefulWidget {
  final Function callBack;
  final String image;

  const ProductImage(this.callBack, {Key key, @required this.image})
      : super(key: key);

  @override
  _ProductImageState createState() => _ProductImageState();
}

class _ProductImageState extends State<ProductImage> {
  File _imageFile;
  String _image;
  final _picker = ImagePicker();

  @override
  void initState() {
    _image = widget.image;
    super.initState();
  }

  @override
  void dispose() {
    _imageFile?.delete();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildPickerImage(),
          _buildPreviewImage(),
        ],
      ),
    );
  }

  dynamic _buildPreviewImage() {
    if ((_image == null || _image.isEmpty) && _imageFile == null) {
      return SizedBox();
    }

    final container = (Widget child) => Container(
          color: Colors.grey[100],
          margin: EdgeInsets.only(top: 4),
          alignment: Alignment.center,
          height: 350,
          child: child,
        );

    return _image != null
        ? container(Image.network('${API.IMAGE_URL}/$_image'))
        : Stack(
            children: [
              container(Image.file(_imageFile)),
              _buildDeleteImageButton(),
            ],
          );
  }

  OutlinedButton _buildPickerImage() => OutlinedButton.icon(
        icon: FaIcon(FontAwesomeIcons.image),
        label: Text('image'),
        onPressed: () {
          _modalPickerImage();
        },
      );

  void _modalPickerImage() {
    final buildListTile =
        (IconData icon, String title, ImageSource source) => ListTile(
              leading: Icon(icon),
              title: Text(title),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(source);
              },
            );

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              buildListTile(
                Icons.photo_camera,
                "Take a picture from camera",
                ImageSource.camera,
              ),
              buildListTile(
                Icons.photo_library,
                "Choose from photo library",
                ImageSource.gallery,
              ),
            ],
          ),
        );
      },
    );
  }

  void _pickImage(ImageSource source) {
    _picker
        .getImage(
      source: source,
      imageQuality: 70,
      maxHeight: 500,
      maxWidth: 500,
    )
        .then((file) {
      if (file != null) {
        setState(() {
          _imageFile = File(file.path);
          _image = null;
          widget.callBack(_imageFile);
        });
      }
    }).catchError((error) {
      //todo
    });
  }

  Positioned _buildDeleteImageButton() => Positioned(
        right: 0,
        child: IconButton(
          onPressed: () {
            setState(() {
              _imageFile = null;
              widget.callBack(null);
            });
          },
          icon: Icon(
            Icons.clear,
            color: Colors.black54,
          ),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
      );
}
