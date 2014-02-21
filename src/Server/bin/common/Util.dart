library Util;


class Util
{
  static String DateTimeToIso8601(DateTime dt)
  {
    return dt.toString().replaceFirst(" ", "T");
  }
  
  static List<int> Range(int from, int to)
  {
    var list = new List<int>();
    var sign = from < to ? 1 : -1;
    for (var i = from; i != to; i += sign)
    {
      list.add(i);
    }    
    return list;
  }
  
  
}