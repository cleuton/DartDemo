library estilos;

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';
import 'package:TesteMongoDB/component/estilocomponent.dart';

class MyAppModule extends Module {
  MyAppModule() {
    bind(Estilocomp);
  }
}

void main() {
  applicationFactory()
      .addModule(new MyAppModule())
      .run();
}


