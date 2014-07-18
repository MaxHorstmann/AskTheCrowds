package com.example.firebaseprototype;


public class Poll
{
	public String getQuestion() {
		return question;
	}


	public void setQuestion(String question) {
		this.question = question;
	}


	public int[] getVotes() {
		return votes;
	}


	public void setVotes(int[] votes) {
		this.votes = votes;
	}


	private String question;
	public String[] getAnwers() {
		return anwers;
	}


	public void setAnwers(String[] anwers) {
		this.anwers = anwers;
	}


	private String[] anwers;
	private int[] votes;
	
	Poll() {
		
	}
	
	public Poll(String question, String[] answers, int[] votes) {
		this.question = question;
		this.anwers = answers;
		this.votes = votes;
	}
	
	
	
}