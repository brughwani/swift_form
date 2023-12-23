import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
//import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swift_form/config/config.dart';
class ViewOrderform extends StatefulWidget {
  ViewOrderform({super.key,required this.id,required this.auth,required this.name,required this.phone});
  int id;
  String auth;
  String name;
  String phone;
  @override
  State<ViewOrderform> createState() => _ViewOrderformState();
}

class _ViewOrderformState extends State<ViewOrderform> {
  String name="";
  String address="";
  List<DataRow> _rows = [];
  List<Map<String, dynamic>> _data = [];
  List<Map<String, dynamic>> _dataforpdf=[];
  //List<pw.TableRow> _tablerows=[];


  Future<String> saveDocument({required String name, required pw.Document pdf}) async {
    // Get the temporary directory for file storage.
    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = tempDir.path;


    // Generate a unique filename for the PDF.
    final String filePath = '$tempPath/$name';

    // Write the PDF to the file.
    final File file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    return filePath;
  }


  Future<void> _generatePdf(BuildContext context) async {
    int serialNumber = 1;
    const tableHeaders = [
'Sr. No.',
      'Item Description',
      'Quantity',
      'Price',
      'Discount'
      'Total'
    ];


    Map<String, dynamic> orderDetails = await fetchOrderDetails();
    String orderformno=orderDetails['id'].toString();
    String date=orderDetails['created_at'].toString();
    String name = orderDetails['customer']['name'];
    String address = orderDetails['customer']['address'];
    List<dynamic> orderItems = orderDetails['order_items'];
    //print(orderItems);

    final pdf = pw.Document();
    final font = await rootBundle.load("assets/fonts/Poppins-Regular.ttf");
    final font2=await rootBundle.load("assets/fonts/BalooBhai2-Medium.ttf");


    for (var e in orderItems) {
      //print(e['quantity'].runtimeType);
      print(e['item']['price'].runtimeType);

      //final int quantity = int.parse(e['quantity']); // Convert 'quantity' to an integer
     final double price = double.parse(e['item']['price']); // Convert 'price' to a double

      _dataforpdf.add({
        'SerialNo.': serialNumber.toString(),
        'itemName': e['item']['name'],
        'quantity': e['quantity'],
        'price': e['item']['price'],
        'discount':e['discount'],
        'total':e['quantity']*price
      }
      );
      serialNumber++;
    }


    pdf.addPage(

      pw.Page(
        build: (context) {

          return
            pw.Column(
          children:[
            pw.Table(
                border: pw.TableBorder.all(width: 1),
              children: [

                pw.TableRow(
                    children: [
                      pw.Text("Salesman Name:" + widget.name,
                          style: pw.TextStyle(font: pw.Font.ttf(font))),
                      pw.Divider(),
                      pw.Text("Phone:" + widget.phone,
                          style: pw.TextStyle(font: pw.Font.ttf(font))),
                      pw.Divider(),

                      pw.Text("Date & Time:" + date,
                          style: pw.TextStyle(font: pw.Font.ttf(font))),
                    ]
                ),
                pw.TableRow(
                    children: [
                      pw.Text("Order form no.${orderformno}"),
                      pw.Divider(),
                      pw.Text("Customer Name:" + name,
                          style: pw.TextStyle(font: pw.Font.ttf(font))),
                      pw.Divider(),
                      pw.Text("Customer Address:" + address,
                          style: pw.TextStyle(font: pw.Font.ttf(font))),
                    ]
                ),

                pw.TableRow(children: [
                  pw.Text("Credit Period:30 days"),
                 pw.Divider(),
                 pw.Text("૩૦ દિવસ ઉપર રકમ બાકી હશે તો સદર ઓર્ડરનો માલ રવાના કરવામાં નહિ આવે",style:pw.TextStyle(font: pw.Font.ttf(font2))),
                  //pw.Text("If the amount is outstanding for more than 30 days, the goods of the above order will not be dispatched"),
                  pw.Divider(),
                  pw.Text("For emergency service and spareparts kindly whatsapp 9925234758")

                ]),
          ]
          ),

                pw.TableHelper.fromTextArray(
                  context: context,
                  headers: List<String>.generate(
                    tableHeaders.length,
                        (col) => tableHeaders[col],
                  ),
                  data: <List<String>>[
                    for (var item in _dataforpdf)

                      [item['SerialNo.'],item['itemName'], item['quantity'].toString(), item['price'].toString(),item['discount'].toString(),item['total'].toString()],

                  ],
                  //border: pw.Border(),
                  cellHeight: 30,
                  columnWidths: {
                    0: pw.FlexColumnWidth(1),
                    1: pw.FlexColumnWidth(3),
                    2: pw.FlexColumnWidth(1),
                    3: pw.FlexColumnWidth(1),
                    4: pw.FlexColumnWidth(1)
                  },
                  cellStyle: pw.TextStyle(
                    fontSize: 12,
                  ),
                ),
                pw.Text("GST જુદો લેવામો આવશે",style:pw.TextStyle(font: pw.Font.ttf(font2))),
                pw.Row(
                  children:[
                    pw.Container(
                      color:PdfColors.black,
                child:pw.Text("બ્રાંડેડ કંપનીની રીપેરીંગની જવાબદારી જે તે કંપની ના સર્વિસ સેન્ટરની હોય છે",style:pw.TextStyle(font: pw.Font.ttf(font2),color: PdfColors.white)),
                    ),
          pw.Spacer(),
          pw.Container(

          color:PdfColors.black,
               child:pw.Text("રીપેરીંગ માટે વોરંટી કાર્ડ જરૂરી છે",style:pw.TextStyle(font: pw.Font.ttf(font2),color: PdfColors.white))
                  )
          ]),
            pw.Container(
                color:PdfColors.black,
                child:pw.Text("રકમ આપતી વખતે રકમની પાવતી લેવી જરૂરી છે પાવતી વગર ૨કમ જમા મળશે નહીં",style:pw.TextStyle(font: pw.Font.ttf(font2),color: PdfColors.white))
            )
                // pw.Table(
                //     children: _tablerows
                // )

              ],
          );
        }
      )
    );



    final pdfPath = await saveDocument(name: '${name}'+'.pdf', pdf: pdf);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfViewerPage(pdffile: pdfPath ),
      ),
    );
    _dataforpdf.clear();
    // Add PDF content using the pdf package

  }




  Future<Map<String, dynamic>> fetchOrderDetails() async {
    //var url = "http://localhost:3000/api/v1/order_forms/${widget.id}";
    var url2= "${Config.getBaseUrl}/api/v1/order_forms/${widget.id}";
    final Map<String, String>? headers = {
      'Authorization': widget.auth,
      // Add any other required headers,
    };
    var response = await get(Uri.parse(url2), headers: headers);
    var data=jsonDecode(response.body);
   //print(data.runtimeType);
//   print(data);
    //_data.clear();
    if(data is Map<String, dynamic>) {
      //print(data);

      for (var e in data['order_items']) {
         print(e);
        _data.add({
          'itemName': e['item']['name'],
          'quantity': e['quantity'],
          'price': e['item']['price'],
          'discount':e['discount']
        });
      }
       // print(e['quantity']);
      for(var i in _data) {
        print(i);
        _rows.add(DataRow(cells: [
          DataCell(Text(i['itemName'])),
          DataCell(Text(i['quantity'].toString())),
          DataCell(Text(i['price'].toString())),
           DataCell(Text(i['discount'].toString())),
        ]));
      }
    }
    _data.clear();
    //print(_data);
    return data;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orderform details"),
        actions: [IconButton(onPressed: (){
          print(name);
          print(address);
          _generatePdf(context);
        }, icon:Icon(Icons.picture_as_pdf))],
      ),
      body:FutureBuilder<Map<String, dynamic>>(
        future: fetchOrderDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            //print(snapshot.data!);
            String name = snapshot.data!['customer']['name'];
            String address=snapshot.data!['customer']['address'];
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Text("Name:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        Text(name),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Text("Address:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        Text(address),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [Text("Orderform no.:"+snapshot.data!['id'].toString(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600))],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [Text("Date & Time:"+snapshot.data!['created_at'], style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600))],
                    ),
                  ),
                  DataTable(columns: [DataColumn(label:Text("Name")),DataColumn(label:Text("Quantity")),DataColumn(label:Text("Price")),DataColumn(label:Text("Discount"))], rows:_rows),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class PdfViewerPage extends StatelessWidget {
  String pdffile;

  PdfViewerPage({required this.pdffile});

  void shareFile(String filePath) async {
    try {
      XFile file = XFile(filePath);

      // Check if the file exists
      await Share.shareXFiles([file],
          subject: 'Check out this file!',
          text: 'Hey, I wanted to share this file with you.');

    } catch (e) {
      // Handle any errors that occur during the sharing process
      print("Error sharing file: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Orderform PDF'),
      actions: [IconButton(onPressed:(){shareFile(pdffile);}, icon:Icon(Icons.share))],),
      body: SfPdfViewer.file(File(pdffile))
    );
  }
}
