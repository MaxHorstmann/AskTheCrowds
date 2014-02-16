library Util;


class Util
{
  static String DateTimeToIso8601(DateTime dt)
  {
    return dt.toString().replaceFirst(" ", "T");
  }
  
  
}