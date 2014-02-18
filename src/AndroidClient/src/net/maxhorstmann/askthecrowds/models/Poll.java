package net.maxhorstmann.askthecrowds.models;

import java.util.Date;
import java.util.List;

public class Poll {
	public String Uuid;
	public String UserUuid;
	public int CategoryId;
	public Date Created;  
	public int DurationHours;
	public String Language;
	public String Question;
	public List<String> Options;
	public List<Integer> Votes;	
}

