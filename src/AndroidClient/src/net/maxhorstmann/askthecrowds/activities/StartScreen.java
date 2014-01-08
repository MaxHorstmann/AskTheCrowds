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
		mPreferences = getSharedPreferences("ASK_THE_CROWDS", MODE_PRIVATE);
		mUserGuid = mPreferences.getString("USER_GUID", "");
		
		mTextViewUserGuid.setText(mUserGuid);
	}

}
