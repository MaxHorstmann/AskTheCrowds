package com.example.test.Models;

import java.util.Date;
import java.util.List;

public class Poll {
  public String PollGuid;
  public String UserGuid;
  public int CategoryId;
  //public Date Created; 
  public int DurationHours;
  public String Language;
  public String Question;
  public List<String> Options;
  public List<Integer> Votes;
 }

