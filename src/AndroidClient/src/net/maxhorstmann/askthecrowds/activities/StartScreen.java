package net.maxhorstmann.askthecrowds.activities;

import java.util.ArrayList;
import java.util.List;

import net.maxhorstmann.askthecrowds.R;
import net.maxhorstmann.askthecrowds.models.Poll;
import net.maxhorstmann.askthecrowds.services.BackendService;
import net.maxhorstmann.askthecrowds.services.LocalStorageService;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.ViewFlipper;

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
				mActivePolls = new ArrayList<Poll>();
				mClosedPolls = new ArrayList<Poll>();
				for (Poll p : polls)
				{
					if (p.IsClosed()) {
						mClosedPolls.add(p);
					} else {
						mActivePolls.add(p);
					}
				}				
				UpdatePollViews();
			}
		}
	}
	
	
	Button mButtonCreatePoll;
	Button mButtonRefresh;
	
	ViewFlipper mViewFlipperActivePolls;
	ViewFlipper mViewFlipperResults;
	
	BackendService mBackendService;
	LocalStorageService mLocalStorageService;

	List<Poll> mActivePolls = null;
	List<Poll> mClosedPolls = null;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);		

		setContentView(R.layout.activity_start_screen);

		mLocalStorageService = new LocalStorageService(this);
		mBackendService = new BackendService(mLocalStorageService);

		mViewFlipperActivePolls = (ViewFlipper)findViewById(R.id.viewFlipperActivePolls);
		mViewFlipperResults = (ViewFlipper)findViewById(R.id.viewFlipperResults);

		
		mButtonCreatePoll = (Button)findViewById(R.id.buttonCreatePoll);
		mButtonCreatePoll.setOnClickListener(new View.OnClickListener() {			
			@Override
			public void onClick(View v) {				
				Intent intent = new Intent(StartScreen.this, CreatePoll.class);
				startActivity(intent);				
			}
		});
		
		mViewFlipperActivePolls.setOnClickListener(new View.OnClickListener() {
			
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
		mViewFlipperActivePolls.stopFlipping();
		mViewFlipperActivePolls.removeAllViews();
		Context context = mViewFlipperActivePolls.getContext();
		for (Poll poll : mActivePolls)
		{
			TextView childTextView = new TextView(context);
			childTextView.setTextAppearance(context, android.R.style.TextAppearance_Large);
			String text = String.format("%s (%s minutes) %s", poll.Id, poll.GetRemainingMinutes(), poll.Question);
			childTextView.setText(text);
			mViewFlipperActivePolls.addView(childTextView);
		}
		mViewFlipperActivePolls.setFlipInterval(1000);
		mViewFlipperActivePolls.startFlipping();
		
		mViewFlipperResults.stopFlipping();
		mViewFlipperResults.removeAllViews();
		for (Poll poll : mClosedPolls)
		{
			TextView childTextView = new TextView(mViewFlipperResults.getContext());
			String text = String.format("%s (closed) %s", poll.Id, poll.Question);
			childTextView.setText(text);
			mViewFlipperResults.addView(childTextView);
		}
		mViewFlipperResults.setFlipInterval(1200);
		mViewFlipperResults.startFlipping();
	}
	
	@Override
	protected void onResume() {
		super.onResume();
		
		// ...
	}

}
