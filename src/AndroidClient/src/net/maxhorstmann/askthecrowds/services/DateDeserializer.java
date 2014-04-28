package net.maxhorstmann.askthecrowds.services;

import java.lang.reflect.Type;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.TimeZone;

import com.google.gson.JsonDeserializationContext;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonElement;
import com.google.gson.JsonParseException;
import com.google.gson.JsonPrimitive;
import com.google.gson.JsonSerializationContext;
import com.google.gson.JsonSerializer;

public class DateDeserializer implements JsonDeserializer<Date>, JsonSerializer<Date> {

	static SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", Locale.US);
	
	@Override
	public Date deserialize(JsonElement element, Type arg1, JsonDeserializationContext arg2) throws JsonParseException {
		String date = element.getAsString();
		formatter.setTimeZone(TimeZone.getTimeZone("UTC"));
		try {
			return formatter.parse(date);
		} catch (ParseException e) {
			return null;
		}
	}
	
	@Override
	public JsonElement serialize(Date src, Type typeOfSrc, JsonSerializationContext context) {
	  formatter.setTimeZone(TimeZone.getTimeZone("UTC"));
      return src == null ? null : new JsonPrimitive(formatter.format(src));
	}

}