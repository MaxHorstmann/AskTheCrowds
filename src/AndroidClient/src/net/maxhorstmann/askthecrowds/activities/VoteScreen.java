package net.maxhorstmann.askthecrowds.activities;

import java.util.ArrayList;
import java.util.List;

import net.maxhorstmann.askthecrowds.R;
import net.maxhorstmann.askthecrowds.models.Poll;
import net.maxhorstmann.askthecrowds.models.Vote;
import net.maxhorstmann.askthecrowds.services.BackendService;
import net.maxhorstmann.askthecrowds.services.LocalStorageService;
import android.app.Activity;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.ProgressBar;
import android.widget.TextView;

public class VoteScreen extends Activity {

	private class PostVoteTask extends AsyncTask<Vote, Void, Boolean>
	{
		@Override
		protected Boolean doInBackground(Vote... votes) {
     		Vote vote = votes[0];
			return mBackendService.postVote(vote);
		}	
		
		@Override 
		protected void onPostExecute(Boolean success) {
			VoteScreen.this.mProgressBar.setVisibility(View.INVISIBLE);
			// TODO handle success/failure
		}
	}
	
	
	private class OnVoteButtonClickListener implements View.OnClickListener
	{
		int mOption;
		public OnVoteButtonClickListener(int option)
		{
			mOption = option;			
		}
		
		@Override
		public void onClick(View v) {
			Vote vote = new Vote();
			vote.PollGuid = mPoll.PollGuid;
			vote.Option = mOption;
			PostVoteTask postVoteTask = new PostVoteTask();
			postVoteTask.execute(vote);					
		}	
	}
	
	Button mButtonSkip;
	Button mButtonFlag;
	List<Button> mButtonsVote;
	List<TextView> mTextViewsOptions;
	TextView mTextViewQuestion;
	
	ProgressBar mProgressBar;
	PostVoteTask mPostVoteTask;
	
	BackendService mBackendService;
	LocalStorageService mLocalStorageService;
	
	Poll mPoll;

	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		mPoll = new Poll();
		mPoll.Question = "Which movie is better?";
		mPoll.PollGuid = "a2f0399e-cac1-4c51-8a13-a356fb7ff6fd";
		mPoll.Options = new ArrayList<String>();
		mPoll.Options.add("Terminator");
		mPoll.Options.add("Braveheart");
		
		mLocalStorageService = new LocalStorageService(this);
		mBackendService = new BackendService(mLocalStorageService);
		
		setContentView(R.layout.vote_screen);
		
		mTextViewQuestion = (TextView)findViewById(R.id.textViewQuestion);
		mTextViewQuestion.setText(mPoll.Question);
		
		mTextViewsOptions = new ArrayList<TextView>();
		mTextViewsOptions.add((TextView)findViewById(R.id.textViewOption1));
		mTextViewsOptions.add((TextView)findViewById(R.id.textViewOption2));
		// TODO add more...
				
		mButtonsVote = new ArrayList<Button>();
		mButtonsVote.add((Button)findViewById(R.id.buttonVote1));
		mButtonsVote.add((Button)findViewById(R.id.buttonVote2));
		// TODO ...
		
		for (int i=0; i<mPoll.Options.size(); i++) {
			mTextViewsOptions.get(i).setText(mPoll.Options.get(i));
			mButtonsVote.get(i).setOnClickListener(new OnVoteButtonClickListener(i));			
		}
			
		mProgressBar = (ProgressBar)findViewById(R.id.progressBar1);
		mProgressBar.setVisibility(View.INVISIBLE);
		
	}

}
