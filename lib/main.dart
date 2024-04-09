import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "",
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: Center(child: HomePage()),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _cepController = TextEditingController();
  bool _isLoading = false; // Variável para controlar o estado de carregamento
  Map<String, dynamic> _responseData =
      {}; // Mapa para armazenar os dados da resposta da API

  Future<void> fetchData(String cep) async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(
      Uri.parse('https://brasilapi.com.br/api/cep/v1/$cep'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        _responseData = data;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResponsePage(responseData: data),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erro'),
            content: Text('Falha ao carregar os dados do CEP.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFD3E3E3), // Cor mais clara
              Color(0xFFC2D9E8), // Cor intermediária
              Color(0xFFA8BCCB), // Cor mais escura
            ],
            stops: [
              0.0,
              0.5,
              1.0
            ], // Paradas para controlar a distribuição das cores
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.grey), // Adiciona a borda cinza
                    borderRadius: BorderRadius.circular(
                        8.0), // Adiciona bordas arredondadas
                  ),
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'where is?',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                          height: 8.0), // Espaço entre as duas linhas de texto
                      Text(
                        'Digite o CEP desejado para encontrar a localização',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 16.0), // Espaço abaixo do segundo texto
                      TextField(
                        controller: _cepController,
                        decoration: InputDecoration(
                          labelText: 'CEP',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                fetchData(_cepController.text);
                              },
                        child: _isLoading
                            ? CircularProgressIndicator()
                            : Text('Consultar'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ResponsePage extends StatelessWidget {
  final Map<String, dynamic> responseData;

  const ResponsePage({Key? key, required this.responseData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voltar e pesquisar outro CEP'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFD3E3E3), // Cor mais clara
              Color(0xFFC2D9E8), // Cor intermediária
              Color(0xFFA8BCCB), // Cor mais escura
            ],
            stops: [
              0.0,
              0.5,
              1.0
            ], // Paradas para controlar a distribuição das cores
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CEP: ${responseData['cep']}',
                  style: TextStyle(fontSize: 18.0),
                ),
                Text(
                  'Estado: ${responseData['state']}',
                  style: TextStyle(fontSize: 18.0),
                ),
                Text(
                  'Cidade: ${responseData['city']}',
                  style: TextStyle(fontSize: 18.0),
                ),
                Text(
                  'Bairro: ${responseData['neighborhood']}',
                  style: TextStyle(fontSize: 18.0),
                ),
                Text(
                  'Rua: ${responseData['street']}',
                  style: TextStyle(fontSize: 18.0),
                ),
                Text(
                  'Serviço: ${responseData['service']}',
                  style: TextStyle(fontSize: 18.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
