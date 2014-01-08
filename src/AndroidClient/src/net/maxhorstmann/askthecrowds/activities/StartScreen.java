package net.maxhorstmann.askthecrowds.activities;

import net.maxhorstmann.askthecrowds.R;
import net.maxhorstmann.askthecrowds.services.LocalStorageService;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

public class StartScreen extends Activity {
	
	Button mButtonCreatePoll;
	TextView mTextViewUserGuid;
	LocalStorageService mLocalStorageService;
	
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
		
		mLocalStorageService = new LocalStorageService(this);
	}
	
	@Override
	protected void onResume() {
		super.onResume();
		mTextViewUserGuid.setText(mLocalStorageService.getUserGuid());
	}

}
