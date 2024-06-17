extension Text on String{
  String padCenter(int total){
    final diff = total - length;
    var result = this;
    if(total > 0){
      for (var i = 0; i < diff; i++) {
        if(i.isEven){
          result = " " + result;
        }else{
          result = result + " ";
        }
      }

      return result;
    }

    return this;
  }
}