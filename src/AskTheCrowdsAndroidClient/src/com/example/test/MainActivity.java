package com.example.test;

import java.io.ByteArrayOutputStream;
import java.io.IOException;

import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.StatusLine;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.json.JSONArray;
import org.json.JSONObject;

import android.app.Activity;
import android.os.Bundle;
import android.os.StrictMode;
import android.view.Menu;
import android.widget.TextView;

public class MainActivity extends Activity {

	private TextView mCategories;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		
		mCategories = (TextView)findViewById(R.id.categories);
		mCategories.setText("loading...");
		

		String url="http://askthecrowds.cloudapp.net/categories";
		
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
		        
		        JSONObject json = new JSONObject(responseString);
		        StringBuilder sb = new StringBuilder();
		        
		        JSONArray categories = json.getJSONArray("categories");
		        for (int i=0; i<categories.length(); i++) {
		        	sb.append((String)(categories.get(i)));
		        	sb.append("\n");
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

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}

}
