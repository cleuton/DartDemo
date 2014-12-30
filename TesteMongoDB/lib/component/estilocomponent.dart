library estilocomponent;
import 'package:angular/angular.dart';
import 'dart:html';
import 'dart:convert' show UTF8, JSON;
@Component(
    selector: 'lista-estilos',
    templateUrl: 'estilo.html',
    exportExpressions: const["estilos"])
class Estilocomp {
  List<String> estilos = new List<String>();
  
  Estilocomp() {
    _loadData();
  }
  
  void _loadData() {
    var url = "http://127.0.0.1:3000/estilos";
    var request = HttpRequest.getString(url).then((String texto) {
      List data = JSON.decode(texto);
      data.forEach(pegaNome); 
    });
  }
  
  void pegaNome(estilo) {
    estilos.add(estilo['nome']);
  }
}

