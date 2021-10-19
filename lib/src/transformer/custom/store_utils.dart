import 'package:kernel/ast.dart';

class Stores{


  ///print procedure
  static Procedure printProcedure;

  ///DateTime.now()
  static Constructor dateTimeNowConstructor;

  ///int
  static Reference intReference;

  ///LinkHashMap factory::from
  static Procedure linkHashMapFromProcedure;

  ///String reference
  static Reference stringReference;

  ///Map reference
  static Reference mapReference;

  ///operateBlackListMap reference
  static Reference operateBlackListMapReference;

  ///method isDoubleClick reference
  static Reference isDoubleClickReference;

  ///a
  void noUse(){

  }

  static void getInfoForStore(Component component,Component platformStrongComponent){
    final List<Library> libraries = component.libraries;
    if (libraries.isEmpty) {
      return;
    }
    final List<Library> concatLibraries = <Library>[
      ...libraries,
      ...platformStrongComponent != null
          ? platformStrongComponent.libraries
          : <Library>[]
    ];

    for (Library library in concatLibraries) {
      print("Stores:::library.name===${library.name}");

      final List<Class> classes = library.classes;
      for (Class cls in classes) {
        for (Member member in cls.members) {
          if (!(member is Member)) {
            continue;
          }
          setStores(library);
        }
      }

    }
  }

  static void setStores(Library library) {
    if(library.name == 'shake_handle_help'){
      for(Procedure procedure in library.procedures){
        Stores.isDoubleClickReference = procedure.reference;
      }
    }
    if(library.name == 'dart.core'){
      for(Procedure procedure in library.procedures){
        if(procedure.name.name == 'print'){
          Stores.printProcedure = procedure;
          break;
        }
      }
      for(Class cls in library.classes){
        final String clsName = cls.name;
        if(clsName == 'int'){
          Stores.intReference = cls.reference;
        }else if(clsName == 'String'){
          Stores.stringReference = cls.reference;
        }else if(clsName == 'Map'){
          Stores.mapReference = cls.reference;
        }else if(clsName == 'DateTime'){
          for(Constructor constructor in cls.constructorsInternal){
            if(constructor.name.name == 'now'){
              Stores.dateTimeNowConstructor = constructor;
            }
          }
        }
      }
    }
    if(library.name == 'dart.collection'){
      for(Class cls in library.classes){
        final String clsName = cls.name;
        if (clsName == 'LinkedHashMap'){
          for(Procedure procedure in cls.proceduresInternal){
            if(procedure.name.name == 'from'){
              Stores.linkHashMapFromProcedure = procedure;
            }
          }
        }
      }
    }
  }

}