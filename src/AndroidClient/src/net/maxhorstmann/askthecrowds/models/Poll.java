package net.maxhorstmann.askthecrowds.models;

import java.util.List;

public class Poll {
	public String PollGuid;
	public String UserGuid;
	public int CategoryId;
	public long Created; // ms since unix epoch 
	public int DurationHours;
	public String Language;
	public String Question;
	public List<String> Options;
	public List<Integer> Votes;
}

