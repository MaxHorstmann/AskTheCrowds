package net.maxhorstmann.askthecrowds.activities;

import java.util.List;

import net.maxhorstmann.askthecrowds.R;
import net.maxhorstmann.askthecrowds.models.Poll;
import net.maxhorstmann.askthecrowds.services.BackendService;
import net.maxhorstmann.askthecrowds.services.LocalStorageService;
import android.app.Activity;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;

public class StartScreen extends Activity {
	
	private class UpdatePollsTask extends AsyncTask<Void, Void, List<Poll>>
	{
		@Override
		protected List<Poll> doInBackground(Void... votes) {
			return mBackendService.getPolls();			
		}	
		
		@Override 
		protected void onPostExecute(List<Poll> polls) {
			if (polls != null) {
				mPolls = polls;
				UpdatePollViews();
			}
		}
	}
	
	
	Button mButtonCreatePoll;
	Button mButtonVoteScreen;
	Button mButtonRefresh;
	LinearLayout mLinearLayoutPolls;
	
	BackendService mBackendService;
	LocalStorageService mLocalStorageService;

	List<Poll> mPolls = null;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);		

		setContentView(R.layout.activity_start_screen);

		mLocalStorageService = new LocalStorageService(this);
		mBackendService = new BackendService(mLocalStorageService);

		mLinearLayoutPolls = (LinearLayout)findViewById(R.id.linearLayoutPolls);		
		
		mButtonCreatePoll = (Button)findViewById(R.id.buttonCreatePoll);
		mButtonCreatePoll.setOnClickListener(new View.OnClickListener() {			
			@Override
			public void onClick(View v) {				
				Intent intent = new Intent(StartScreen.this, CreatePoll.class);
				startActivity(intent);				
			}
		});
		
		mButtonVoteScreen = (Button)findViewById(R.id.buttonVote);
		mButtonVoteScreen.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				Intent intent = new Intent(StartScreen.this, VoteScreen.class);
				startActivity(intent);				
			}
		});		
		
		mButtonRefresh = (Button)findViewById(R.id.buttonRefresh);
		mButtonRefresh.setOnClickListener(new View.OnClickListener() {			
			@Override
			public void onClick(View v) {
				(new UpdatePollsTask()).execute();
			}
		});
		
	}
	
	private void UpdatePollViews()
	{
		mLinearLayoutPolls.removeAllViews();
		for (Poll poll : mPolls)
		{
			TextView childTextView = new TextView(mLinearLayoutPolls.getContext());
			String text = String.format("(%s minutes) %s", poll.GetRemainingMinutes(), poll.Question);
			childTextView.setText(text);
			mLinearLayoutPolls.addView(childTextView);
		}
	}
	
	@Override
	protected void onResume() {
		super.onResume();
		
		// ...
	}

}
