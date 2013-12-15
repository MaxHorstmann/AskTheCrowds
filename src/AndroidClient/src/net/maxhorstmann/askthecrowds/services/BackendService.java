package net.maxhorstmann.askthecrowds.services;

import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.StatusLine;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;

public class BackendService {
	
	private final String baseUrl = "http://askthecrowds.cloudapp.net/api";

	public String createUser()	{
		
		HttpClient httpclient = new DefaultHttpClient();
		HttpPost post = new HttpPost(baseUrl + "/users");
		HttpResponse response;
		
		try {
			response = httpclient.execute(post);
		    StatusLine statusLine = response.getStatusLine();
		    if(statusLine.getStatusCode() == HttpStatus.SC_OK){
		    	return "created";
		    }
		} 
		catch (Exception ex)
		{
		}
		
		return "1234-5678-1234-5678";
		
	}
}
