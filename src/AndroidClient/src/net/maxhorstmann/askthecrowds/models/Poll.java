package net.maxhorstmann.askthecrowds.models;

import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.TimeZone;

public class Poll {
	public String Id;
	public String UserId;
	public int CategoryId;
	public int TypeId;
	public Date Created;  
	public int DurationHours;
	public String LanguageCode;
	public String Question;
	public List<String> Options;
	public List<Integer> Votes;	
	
	public Date GetEndTime()
	{
		Calendar c = Calendar.getInstance(TimeZone.getTimeZone("UTC"));
		c.setTime(Created);
		c.add(Calendar.HOUR, DurationHours);
		return c.getTime();
	}
	
	public long GetRemainingMinutes()
	{
		// TODO needs work
		Calendar c = Calendar.getInstance(TimeZone.getTimeZone("UTC"));
		Date now = c.getTime();
		Date endTime = GetEndTime();
		if (now.after(endTime)) {
			return 0;
		}
		long diff = endTime.getTime() - now.getTime();
		return diff / (1000 * 60);		
	}
	
    public boolean IsClosed() {
    	return GetRemainingMinutes() <= 0;

    }
}

