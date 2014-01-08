package net.maxhorstmann.askthecrowds.activities;

import net.maxhorstmann.askthecrowds.R;
import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

public class StartScreen extends Activity {
	
	Button mButtonCreatePoll;
	TextView mTextViewUserGuid;
	SharedPreferences mPreferences;
	String mUserGuid;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);		
		
		setContentView(R.layout.activity_start_screen);
		
		mButtonCreatePoll = (Button)findViewById(R.id.buttonCreatePoll);
		mButtonCreatePoll.setOnClickListener(new View.OnClickListener() {			
			@Override
			public void onClick(View v) {				
				Intent intent = new Intent(StartScreen.this, CreatePoll.class);
				startActivity(intent);				
			}
		});
		
		mTextViewUserGuid = (TextView)findViewById(R.id.textViewUserId);
		mPreferences = getPreferences(MODE_PRIVATE);
		mUserGuid = mPreferences.getString("USER_GUID", "");
		
		mTextViewUserGuid.setText(mUserGuid);
	}

//	@Override
//	public boolean onCreateOptionsMenu(Menu menu) {
//		// Inflate the menu; this adds items to the action bar if it is present.
//		getMenuInflater().inflate(R.menu.start_screen, menu);
//		return true;
//	}
	
//	@Override
//	public void onDestroy()
//	{
//		super.onDestroy();
//		resultDownloader.quit();
//	}
	
//	private class CreateUserTask extends AsyncTask<TextView, Void, String> {
//
//		TextView mTextView;
//		
//		@Override
//		protected String doInBackground(TextView... textView) {
//			mTextView = textView[0];
//			return new BackendService().createUser();
//			
//		}
//		
//		@Override
//		protected void onPostExecute(String result) {
//			// runs on the UI thread!
//			mTextView.setText(result);
//			
//		}
//		
//	}

}
