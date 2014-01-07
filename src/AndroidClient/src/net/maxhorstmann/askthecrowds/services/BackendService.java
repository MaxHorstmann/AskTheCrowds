package net.maxhorstmann.askthecrowds.services;

import java.io.UnsupportedEncodingException;

import net.maxhorstmann.askthecrowds.models.ApiResult;
import net.maxhorstmann.askthecrowds.models.Poll;

import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.StatusLine;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.params.HttpConnectionParams;
import org.apache.http.util.EntityUtils;

import com.google.gson.Gson;

public class BackendService {
	
	private final String baseUrl = "http://askthecrowds.cloudapp.net/api";
	private final int httpConnectionTimeout = 5000;

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
	
	public String postPoll(Poll poll) {
		
		Gson gson = new Gson();
		String json = gson.toJson(poll);
		
		HttpClient httpclient = new DefaultHttpClient();
		int timeout = 5;
		HttpConnectionParams.setConnectionTimeout(httpclient.getParams(), httpConnectionTimeout);
		HttpConnectionParams.setSoTimeout(httpclient.getParams(), httpConnectionTimeout);
		
		HttpPost post = new HttpPost(baseUrl + "/polls");
		try {
			post.setEntity(new StringEntity(json));
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		HttpResponse response;
		
		try {
			response = httpclient.execute(post);
		    StatusLine statusLine = response.getStatusLine();
		    if(statusLine.getStatusCode() == HttpStatus.SC_OK){
				String jsonResult = EntityUtils.toString(response.getEntity());
				ApiResult result = gson.fromJson(jsonResult, ApiResult.class);
				return result.Payload;
				
		    }
		} 
		catch (Exception ex)
		{
			ex.printStackTrace();
		}
		
		return null;
		
		
	}
}
