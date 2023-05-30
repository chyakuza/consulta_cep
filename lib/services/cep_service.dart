import 'package:consulta_cep/model/cep.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class ConsultaWsCep {
   static Future<Cep> getCep(String cep)async {
    try {
      String url = "http://viacep.com.br/ws/${cep}/json/";
      print(url);

      final response = await http.get(url);
      final json = response.body;
      final Map<String, dynamic> mapResponse = convert.json.decode(json);
      print(mapResponse["erro"]);
      if (mapResponse["erro"] != true){
        if (response.statusCode == 200){
          Cep cep = Cep.fromJson(mapResponse);
          return cep;
        }
      }  
      return null;
    } catch (e, exception) {
      print("Erro : $e Excpt> $exception");
    }
} 
} 




