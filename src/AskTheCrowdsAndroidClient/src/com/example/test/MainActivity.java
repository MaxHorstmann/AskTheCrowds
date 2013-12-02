package com.example.test;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.Random;

import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.StatusLine;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;

import android.app.Activity;
import android.os.Bundle;
import android.os.StrictMode;
import android.view.Menu;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.example.test.Models.Poll;
import com.example.test.Models.Vote;
import com.google.gson.Gson;

public class MainActivity extends Activity {

	private TextView mCategories;
	private Button mButtonRefresh;
	private Button mButtonVote;

	private String url="http://askthecrowds.cloudapp.net/api/polls";
	private String urlVotes="http://askthecrowds.cloudapp.net/api/votes";
	
	private Gson gson = new Gson();
	
	private Poll[] polls;
	
	private Random random = new Random();
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
	
		mButtonRefresh = (Button)findViewById(R.id.refreshButton);
		mCategories = (TextView)findViewById(R.id.categories);
		mCategories.setText("loading...");
		
		mButtonRefresh.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				try
				{
					StrictMode.ThreadPolicy policy = new StrictMode.
					          ThreadPolicy.Builder().permitAll().build();
					StrictMode.setThreadPolicy(policy); 
					
					HttpClient httpclient = new DefaultHttpClient();
				    HttpResponse response = httpclient.execute(new HttpGet(url));
				    StatusLine statusLine = response.getStatusLine();
				    
				    if(statusLine.getStatusCode() == HttpStatus.SC_OK){
				        ByteArrayOutputStream out = new ByteArrayOutputStream();
				        response.getEntity().writeTo(out);
				        out.close();
				        String responseString = out.toString();

				        StringBuilder sb = new StringBuilder();
				        
				        polls = gson.fromJson(responseString, Poll[].class);				        
				        for (Poll poll : polls) 
				        {
				        	sb.append(poll.Question + "\n");
				        }

				        mCategories.setText(sb.toString());
				        
				        //..more logic
				    } else{
				        //Closes the connection.
				        response.getEntity().getContent().close();
				        throw new IOException(statusLine.getReasonPhrase());
				    }
				}
				catch (Exception e)
				{
					mCategories.setText("Error: " + e.toString());
				}
			}
		});
		
		
		mButtonVote = (Button)findViewById(R.id.voteButton);
		
		mButtonVote.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				
				// cast a vote
				Poll poll = polls[1];
				Vote vote = new Vote();
				vote.PollGuid = poll.PollGuid;
				vote.UserGuid = poll.UserGuid;
				vote.Option = random.nextInt(poll.Options.size());
				String json = gson.toJson(vote);
				
				HttpClient httpclient = new DefaultHttpClient();
			    try {
					HttpPost post = new HttpPost(urlVotes);
					post.setEntity(new StringEntity(json));
					HttpResponse response = httpclient.execute(post);
				    StatusLine statusLine = response.getStatusLine();
				    
				    if(statusLine.getStatusCode() == HttpStatus.SC_OK){
						mCategories.setText("Voted " + Integer.toString(vote.Option));
				    }
				    else {
						mCategories.setText("Tried to vite, didn't work.");
				    }
					
					
					
				} catch (ClientProtocolException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

				
			}
		});


		
		
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}

}
