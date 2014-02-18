package net.maxhorstmann.askthecrowds.services;

import java.io.UnsupportedEncodingException;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import net.maxhorstmann.askthecrowds.models.ApiResult;
import net.maxhorstmann.askthecrowds.models.Poll;
import net.maxhorstmann.askthecrowds.models.Vote;

import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.params.HttpConnectionParams;
import org.apache.http.util.EntityUtils;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

public class BackendService {
	
	private final String baseUrl = "http://ny-mhorstmannlp/api";
	private final int httpConnectionTimeout = 5000;
	
	private Gson gson;
	private LocalStorageService mLocalStorageService;	
	
	public BackendService(LocalStorageService localStorageService) {
		mLocalStorageService=localStorageService;
		gson = new GsonBuilder().setDateFormat("yyyy-MM-dd'T'HH:mm:ss").create(); // ISO 8601.. sort of
	}
	
	public List<Poll> getPolls() {
		try 
		{
			HttpGet get = getHttpGet("polls");
			HttpResponse response = getHttpClient().execute(get);
			int responseStatusCode = response.getStatusLine().getStatusCode();
		    if (responseStatusCode == HttpStatus.SC_OK){
		    	String json = EntityUtils.toString(response.getEntity());
				Poll[] polls = gson.fromJson(json, Poll[].class);
				return Arrays.asList(polls);
		    }
		}
		catch (Exception ex)
		{
			ex.printStackTrace();
		}		
		return null;		
	}

	public String postPoll(Poll poll) {
		try 
		{
     		poll.UserUuid = mLocalStorageService.getUserUuid();
     		poll.Created = new Date();
     		String json = gson.toJson(poll);
			HttpPost post = getHttpPost("polls", json);
			HttpResponse response = getHttpClient().execute(post);
			int responseStatusCode = response.getStatusLine().getStatusCode();
		    if (responseStatusCode == HttpStatus.SC_OK){
				ApiResult apiResult = gson.fromJson(EntityUtils.toString(response.getEntity()), ApiResult.class);
				mLocalStorageService.putUserUuid(apiResult.UserUuid);				
				return apiResult.Payload;
		    }
		}
		catch (Exception ex)
		{
			ex.printStackTrace();
		}		
		return null;		
	}
	
	public boolean postVote(Vote vote) {
		try 
		{
			vote.UserUuid = mLocalStorageService.getUserUuid();
			HttpPost post = getHttpPost("votes", gson.toJson(vote));
			HttpResponse response = getHttpClient().execute(post);
			int responseStatusCode = response.getStatusLine().getStatusCode();
		    if (responseStatusCode == HttpStatus.SC_OK){
				ApiResult apiResult = gson.fromJson(EntityUtils.toString(response.getEntity()), ApiResult.class);
				mLocalStorageService.putUserUuid(apiResult.UserUuid);				
				return true;
		    }
		}
		catch (Exception ex)
		{
			ex.printStackTrace();
		}		
		return false;		
	}
	
	private HttpGet getHttpGet(String route)
	{
		return new HttpGet(baseUrl + "/" + route);
	}
	
	private HttpPost getHttpPost(String route, String entity)
	{
		HttpPost post = new HttpPost(baseUrl + "/" + route);
		try {
			post.setEntity(new StringEntity(entity));
			return post;
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
			return null;
		}
	}
	
	private HttpClient getHttpClient()
	{
		HttpClient httpclient = new DefaultHttpClient();
		HttpConnectionParams.setConnectionTimeout(httpclient.getParams(), httpConnectionTimeout);
		HttpConnectionParams.setSoTimeout(httpclient.getParams(), httpConnectionTimeout);
		return httpclient;
	}
	
	
}
