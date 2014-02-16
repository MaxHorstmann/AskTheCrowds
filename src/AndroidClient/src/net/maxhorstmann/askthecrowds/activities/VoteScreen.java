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
			mProgressBar.setVisibility(View.INVISIBLE);
			if (success) {
				nextPoll();
			}
		}
	}
	
	private class GetPollsTask extends AsyncTask<Void, Void, List<Poll>>
	{
		@Override
		protected List<Poll> doInBackground(Void... voids) {
			return mBackendService.getPolls();
		}	
		
		@Override 
		protected void onPostExecute(List<Poll> polls) {
			mProgressBar.setVisibility(View.INVISIBLE);
			mPolls = polls;
			mPollIndex = 0;
			displayPoll();
		}
	}
	
	
	private class OnVoteButtonClickListener implements View.OnClickListener
	{
		int mOption;
		Poll mPoll;
		public OnVoteButtonClickListener(Poll poll, int option)
		{
			mOption = option;		
			mPoll = poll;
		}
		
		@Override
		public void onClick(View v) {
			VoteScreen.this.mProgressBar.setVisibility(View.VISIBLE);
			Vote vote = new Vote();
			vote.PollUuid = mPoll.Uuid;
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
	
	List<Poll> mPolls;
	int mPollIndex;

	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		mLocalStorageService = new LocalStorageService(this);
		mBackendService = new BackendService(mLocalStorageService);

		setContentView(R.layout.vote_screen);
		mProgressBar = (ProgressBar)findViewById(R.id.progressBar1);
		mTextViewQuestion = (TextView)findViewById(R.id.textViewQuestion);
		
		VoteScreen.this.mProgressBar.setVisibility(View.VISIBLE);
		GetPollsTask getPollsTask = new GetPollsTask();
		getPollsTask.execute();
		
	}
	
	private void displayPoll() {
		
		if ((mPolls == null) || (mPolls.size() == 0)) {
			return;
		}
		
		Poll poll = mPolls.get(mPollIndex);
		
		mTextViewQuestion.setText(poll.Question);
		
		mTextViewsOptions = new ArrayList<TextView>();
		mTextViewsOptions.add((TextView)findViewById(R.id.textViewOption1));
		mTextViewsOptions.add((TextView)findViewById(R.id.textViewOption2));
		// TODO add more...
				
		mButtonsVote = new ArrayList<Button>();
		mButtonsVote.add((Button)findViewById(R.id.buttonVote1));
		mButtonsVote.add((Button)findViewById(R.id.buttonVote2));
		// TODO ...
		
		for (int i=0; i<poll.Options.size(); i++) {
			mTextViewsOptions.get(i).setText(poll.Options.get(i));
			mButtonsVote.get(i).setOnClickListener(new OnVoteButtonClickListener(poll, i));			
		}
		
		mButtonSkip = (Button)findViewById(R.id.buttonSkip);
		mButtonSkip.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				nextPoll();												
			}
		});
			
		mProgressBar.setVisibility(View.INVISIBLE);
		
	}
	
	private void nextPoll()
	{
		mPollIndex++;
		if (mPollIndex >= mPolls.size()) {
			mPollIndex = 0;
		}
		displayPoll();
	}

}
