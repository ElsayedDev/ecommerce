import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';

import 'connect_screen.dart';
import 'logic/controller/bluetooth_controller_cubit.dart';
import 'logic/products/products_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = await HydratedStorage.build(
      storageDirectory: await getTemporaryDirectory());
  HydratedBlocOverrides.runZoned(
    () => runApp(const MyApp()),
    storage: storage,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => BluetoothControllerCubit(),
        ),
        BlocProvider(
          create: (context) => ProductsCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Ziad',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xff521945),
          scaffoldBackgroundColor: const Color(0xffEAF2EF),
          primarySwatch: const MaterialColor(0xff521945, <int, Color>{
            50: Color(0xffEAF2EF),
            100: Color(0xffEAF2EF),
            200: Color(0xffEAF2EF),
            300: Color(0xffEAF2EF),
            400: Color(0xffEAF2EF),
            500: Color(0xff521945),
            600: Color(0xff521945),
            700: Color(0xff521945),
            800: Color(0xff521945),
            900: Color(0xff521945),
          }),
        ),
        home: const ProductScreen(),
      ),
    );
  }
}

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final _size = MediaQuery.of(context).size;
    // final List<String> titles = [
    //   "Product 1",
    //   "Product 2",
    //   "Product 3",
    //   "Product 4",
    //   "Product 5",
    //   "Product 6",
    // ];

    // final List<Widget> images = [
    //   Container(
    //     decoration: BoxDecoration(
    //       color: Colors.red,
    //       borderRadius: BorderRadius.circular(10),
    //     ),
    //   ),
    //   Container(
    //     decoration: BoxDecoration(
    //       color: Colors.yellow,
    //       borderRadius: BorderRadius.circular(10),
    //     ),
    //   ),
    //   Container(
    //     decoration: BoxDecoration(
    //       color: Colors.black,
    //       borderRadius: BorderRadius.circular(10),
    //     ),
    //   ),
    //   Container(
    //     decoration: BoxDecoration(
    //       color: Colors.cyan,
    //       borderRadius: BorderRadius.circular(10),
    //     ),
    //   ),
    //   Container(
    //     decoration: BoxDecoration(
    //       color: Colors.blue,
    //       borderRadius: BorderRadius.circular(10),
    //     ),
    //   ),
    // ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Products Selection',
          style: TextStyle(
            color: Color(0xff521945),
          ),
        ),
        leading: Image.asset('assets/aiet_icon.png'),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const DiscoveryPage()));
            },
            icon: const Icon(
              Icons.bluetooth,
              color: Color(0xff521945),
            ),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  child: SizedBox(
                    height: 150,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(
                            "Do you want to deleted all products?",
                            style: TextStyle(fontSize: 18),
                          ),
                          TextButton(
                              onPressed: () {
                                context
                                    .read<ProductsCubit>()
                                    .removeAllProducts();

                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "Yes",
                                style: TextStyle(fontSize: 14),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.delete,
              color: Color(0xff521945),
            ),
          ),
        ],
      ),
      body: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          return SizedBox(
            // height: _size.height * 0.7,
            child: VerticalCardPager(
              textStyle: const TextStyle(
                  color: Color(0xff361F27), fontWeight: FontWeight.bold),
              titles: state.products.map((product) => product.name).toList(),
              // images:state.products.map((product) => Image.memory(base64Decode(product.image_path))).toList()  ,

              images: state.products
                  .map(
                    (product) => CardProduct(product: product),
                  )
                  .toList(),

              align: ALIGN.CENTER,
              onSelectedItem: (index) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProductView(
                      product: state.products[index],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const NewProduct(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CardProduct extends StatelessWidget {
  const CardProduct({Key? key, required this.product}) : super(key: key);
  final Product product;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: FileImage(File(product.image_path)),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class ProductView extends StatelessWidget {
  const ProductView({Key? key, required this.product}) : super(key: key);
  final Product product;
  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
            title: const Text(
          "Product View",
        )),
        body: Stack(
          children: [
            Container(
              // image
              height: _size.height * 0.7,
              width: _size.width,
              color: Colors.white,

              child: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                    height: _size.height * 0.5,
                    child: Image.file(
                      File(product.image_path),
                    )),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(25),
                height: _size.height * 0.35,
                decoration: BoxDecoration(
                  color: const Color(0xffEAF2EF),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: const Offset(0, -5), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 20,
                            color: Color(0xff912F56),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          product.description,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xff361F27),
                          ),
                        ),
                      ],
                    ),
                    OrderButton(
                      productId: product.id,
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

class OrderButton extends StatelessWidget {
  const OrderButton({Key? key, required this.productId}) : super(key: key);
  final String productId;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: BlocBuilder<BluetoothControllerCubit, BluetoothControllerState>(
          builder: (context, state) {
            return ElevatedButton(
              onPressed: state.status == BluetoothControllerStatus.connected
                  ? () => _sendData(context, productId)
                  : null,
              child: const Text("Order"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _sendData(BuildContext context, String data) async {
    final _cubit = BlocProvider.of<BluetoothControllerCubit>(context);
    _cubit.state.connection!.output.add(Uint8List.fromList(utf8.encode(data)));
    await _cubit.state.connection!.output.allSent;
  }
}

class NewProduct extends StatefulWidget {
  const NewProduct({Key? key}) : super(key: key);

  @override
  State<NewProduct> createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  String? _productID;
  String? _productName;
  String? _productDescription;
  String? _productImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Wrap(
          runSpacing: 30,
          children: [
            ImageSelection(
              onChanged: (value) {
                setState(() {
                  _productImage = value;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "Product Name",
                hintText: 'Add Product Name i.e "Product 1" ',
                labelStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _productName = value;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "Product ID",
                hintText: 'Product ID for Arduino i.e "2" ',
                labelStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _productID = value;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "Product Description",
                hintText: 'Product Description only show for you',
                labelStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              maxLines: null,
              onChanged: (value) {
                setState(() {
                  _productDescription = value;
                });
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (_productID != null &&
                _productImage != null &&
                _productName != null &&
                _productDescription != null)
            ? () {
                context.read<ProductsCubit>().addProduct(
                      Product(_productID!, _productName!, _productImage!,
                          _productDescription!),
                    );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Product Added, successfully!"),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            : null,
        backgroundColor: _productID != null &&
                _productImage != null &&
                _productName != null &&
                _productDescription != null
            ? null
            : Colors.grey,
        child: _productID != null &&
                _productImage != null &&
                _productName != null &&
                _productDescription != null
            ? const Icon(Icons.done)
            : const Icon(Icons.close),
      ),
    );
  }
}

class ImageSelection extends StatefulWidget {
  const ImageSelection({Key? key, required this.onChanged}) : super(key: key);

  final void Function(String) onChanged;
  @override
  State<ImageSelection> createState() => _ImageSelectionState();
}

class _ImageSelectionState extends State<ImageSelection> {
  String _imagePath = '';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 300,
        width: 300,
        child: ElevatedButton(
          onPressed: () async {
            final _picker = ImagePicker();
            final XFile? _file =
                await _picker.pickImage(source: ImageSource.gallery);
            setState(() {
              if (_file != null) {
                _imagePath = _file.path;
              }
            });

            if (_file != null) {
              setState(() {
                _imagePath = _file.path;
                widget.onChanged(_imagePath);
              });
            }
          },
          child: _imagePath.isEmpty
              ? const Icon(Icons.add)
              : Image.file(File(_imagePath)),
        ),
      ),
    );
  }
}
