package net.maxhorstmann.askthecrowds;

import net.maxhorstmann.askthecrowds.services.BackendService;
import android.app.Activity;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.Menu;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

public class StartScreen extends Activity {
	
	Button button;
	TextView textView;
	
	ResultDownloader<String> resultDownloader;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		
		setContentView(R.layout.activity_start_screen);
		
		textView = (TextView)findViewById(R.id.textView1);

		resultDownloader = new ResultDownloader<String>();		
		resultDownloader.start();
		resultDownloader.getLooper();
		
		button = (Button)findViewById(R.id.button1);
		button.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				
				textView.setText("creating user...");
				
				resultDownloader.queueResultDownload(token, pollGuid)
				
				//CreateUserTask createUserTask = new CreateUserTask();
				//createUserTask.execute(textView);
				
			}
		});
		
			
		
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.start_screen, menu);
		return true;
	}
	
	@Override
	public void onDestroy()
	{
		super.onDestroy();
		resultDownloader.quit();
	}
	
	private class CreateUserTask extends AsyncTask<TextView, Void, String> {

		TextView mTextView;
		
		@Override
		protected String doInBackground(TextView... textView) {
			mTextView = textView[0];
			return new BackendService().createUser();
			
		}
		
		@Override
		protected void onPostExecute(String result) {
			// runs on the UI thread!
			mTextView.setText(result);
			
		}
		
	}

}
