
class InputValitadors{

  static String RegExp_curp= r"^[A-Z]{1}[AEIOU]{1}[A-Z]{2}[0-9]{2}(0[1-9]|1[0-2])(0[1-9]|1[0-9]|2[0-9]|3[0-1])[HM]{1}(AS|BC|BS|CC|CS|CH|CL|CM|DF|DG|GT|GR|HG|JC|MC|MN|MS|NT|NL|OC|PL|QT|QR|SP|SL|SR|TC|TS|TL|VZ|YN|ZS|NE)[B-DF-HJ-NP-TV-Z]{3}[0-9A-Z]{1}[0-9]{1}$";
  static String RegExp_email= r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  static String RegExp_zipCode=  r"^[0-9]{5}$";
  static String RegExp_phone=  r"^[0-9]{3}-[0-9]{7}$";
  static String email(value){
    Pattern pattern = RegExp_email;
    RegExp expresion = new RegExp(pattern);

    if(expresion.hasMatch(value)){
      return null;
    }

    return "Esto no es un correo valido";
  }

  static String curp(value){
    Pattern pattern= RegExp_curp;
    RegExp expresion = new RegExp(pattern);
    if(expresion.hasMatch(value)){
      return null;
    }

    return "Verifica la escritura de tu CURP";
  }

  static String isValidDate(String input) {
    input=input.replaceAll(RegExp("-"), "");
    try {
      final date = DateTime.parse(input);
      final originalFormatString = _toOriginalFormatString(date);
      return input == originalFormatString?null:"Esto no es una fecha valida";
    } catch(e) {
      return "Esto no es una fecha valida";;
    }
  }

  static String _toOriginalFormatString(DateTime dateTime) {
    final y = dateTime.year.toString().padLeft(4, '0');
    final m = dateTime.month.toString().padLeft(2, '0');
    final d = dateTime.day.toString().padLeft(2, '0');
    return "$y$m$d";
  }

  static String zipValidator(String zip){

    Pattern pattern=RegExp_zipCode;
  print(zip);
    RegExp expresion = new RegExp(pattern);
    if(expresion.hasMatch(zip)){
      return null;
    }

    return "Este no es un código postal valido";

  }

  static String intValidator(String number){
    try{
      return int.tryParse(number)!=null? null : "Esto no es un número valido";
    }catch(e){
      return "Esto no es un número valido";
    }
  }

  static String phoneValidator(String phone){
    Pattern pattern = RegExp_phone;
    print(phone);
    RegExp expresion = new RegExp(pattern);
    if(expresion.hasMatch(phone)){
      return null;
    }

    return "Este no es un número telefónico valido";

  }

  static String isBlankField(String text){
    if(text.length!=0){
      return null;
    }
    return "Este campo no puede estar vacío";
  }

}

