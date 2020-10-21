/*Este archivo contiene una coleccion de listas que no requiren un modelo para funcionar y algunos metodos extra*/

class UtilLists{

   static Map<String, String> EstadosCiviles(){
    return {
      'S':'Soltero(a)',
      'C':'Casado(a)',
      'D':'Divorciado(a)',
      'V':'Viudo(a)',
      'U':'Union Libre',
      'O':'Otro'
    };
  }

  static Map<String, String> Sexo(){
     return {
       "M":"HOMBRE",
       "F":"MUJER"
     };
  }


}