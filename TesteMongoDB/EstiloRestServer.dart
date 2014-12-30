import 'dart:io';
import 'package:http_server/http_server.dart';
import 'package:path/path.dart';
import 'dart:convert' show UTF8, JSON;
import 'package:mongo_dart/mongo_dart.dart';

final PORT = 3000; 

Db db;
var staticFiles;

main() {
  db = new Db("mongodb://127.0.0.1/banco");
  db.open()
      .then((ok) {
        var pathToBuild = join("./build/web");
        print(pathToBuild);
        staticFiles = new VirtualDirectory(pathToBuild);
        staticFiles.allowDirectoryListing = true;
        staticFiles.directoryHandler = (dir, request) {
                var indexUri = new Uri.file(dir.path).resolve('index.html');
               staticFiles.serveFile(new File(indexUri.toFilePath()), request);
        };        
        HttpServer
            .bind(InternetAddress.ANY_IP_V4, PORT)
            .then((server) {
              server.listen((HttpRequest request) {
                print(">> " + request.uri.path);
                switch (request.method) {
                  case "GET": 
                    process(request);
                    break;
                  default: methodNotAllowed(request);
                }
              }, 
              onError: msgErro);
            });
  });
}

void process(request) {
  if(request.uri.path == '/estilos') {
    // Request para a lista de estilos
    DbCollection dbEstilos = new DbCollection(db, 'estilo');
    List estilos = new List();
    dbEstilos.find().forEach((Map mEstilo) {
          estilos.add(mEstilo);
        }).then((v) {
        request.response.headers.set("Access-Control-Allow-Origin",
                             '*');           
        request.response.headers.contentType
                          = new ContentType("application", "json", charset: "utf-8");
        request.response.write(JSON.encode(estilos));
        request.response.close();
    });
  }
  else {
    staticFiles.serveRequest(request);      
  }
}

void methodNotAllowed(request) {
  request.response.statusCode = HttpStatus.METHOD_NOT_ALLOWED;
  request.response.write("Unsupported request: ${request.method}.");
  request.response.close();
}

void msgErro(erro) {
  print("ERRO: " + erro);
}