package net.maxhorstmann.askthecrowds.activities;

import java.util.ArrayList;

import net.maxhorstmann.askthecrowds.R;
import net.maxhorstmann.askthecrowds.models.Poll;
import net.maxhorstmann.askthecrowds.services.BackendService;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.SharedPreferences;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ProgressBar;

public class CreatePoll extends Activity {

	private class PostPollTask extends AsyncTask<Poll, Void, String>
	{
		@Override
		protected String doInBackground(Poll... polls) {
			BackendService backend = new BackendService();
     		Poll poll = polls[0];
     		
     		String userGuid = mPreferences.getString("USER_GUID", null);

     		
     		if (userGuid == null) {
     			userGuid = backend.createUser();
     			if (userGuid == null) {
     				return null;
     			}
     			SharedPreferences.Editor editor = mPreferences.edit();
     			editor.putString("USER_GUID", userGuid);
     			if (!editor.commit())
     			{
     				return null;
     			}
     		}
     		
     		poll.UserGuid = userGuid;
			return backend.postPoll(poll);
		}	
		
		@Override 
		protected void onPostExecute(String result) {
			CreatePoll.this.mProgressBar.setVisibility(View.INVISIBLE);
			if ((result==null) || (result.length()==0))
			{
				mAlertDialogFailure.show();
			}
			else
			{
				mAlertDialogSuccess.show();
			}
		}
	}
	
	Button mButtonPublish;
	EditText mEditTextQuestion;
	
	EditText mEditTextAnswer1;
	EditText mEditTextAnswer2;

	AlertDialog mAlertDialogSuccess;
	AlertDialog mAlertDialogFailure;
	
	ProgressBar mProgressBar;

	PostPollTask mPostPollTask;
	
	SharedPreferences mPreferences;

	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		mPreferences = getSharedPreferences("ASK_THE_CROWDS", MODE_PRIVATE);

		createAlertDialogs();
		setContentView(R.layout.create_poll_fragment);
		
		mEditTextQuestion = (EditText)findViewById(R.id.editTextQuestion);
		mEditTextAnswer1 = (EditText)findViewById(R.id.editTextAnswer1);
		mEditTextAnswer2 = (EditText)findViewById(R.id.editTextAnswer2);		
		
		mProgressBar = (ProgressBar)findViewById(R.id.progressBar1);
		mProgressBar.setVisibility(View.INVISIBLE);
		
		mButtonPublish = (Button)findViewById(R.id.buttonPublish);
		mButtonPublish.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				
				mButtonPublish.setEnabled(false);
				mProgressBar.setVisibility(View.VISIBLE);
				
				Poll poll = new Poll();
				
				poll.DurationHours = 1; 
				
				poll.Question = mEditTextQuestion.getText().toString();
				poll.Options = new ArrayList<String>();
				poll.Options.add(mEditTextAnswer1.getText().toString());
				poll.Options.add(mEditTextAnswer2.getText().toString());
				
				mPostPollTask = new PostPollTask();
				mPostPollTask.execute(poll);
			}
		});
		
	}


	private void createAlertDialogs() {
		AlertDialog.Builder builder = new AlertDialog.Builder(this);
		builder.setTitle("Success");
		builder.setMessage("Your poll has been published!");
		builder.setPositiveButton("OK", new DialogInterface.OnClickListener() {
			@Override
			public void onClick(DialogInterface dialog, int which) {
				CreatePoll.this.finish();
			}
		});
		mAlertDialogSuccess = builder.create();
		
		builder = new AlertDialog.Builder(this);
		builder.setTitle("Failure");
		builder.setMessage("Sorry - couldn't publish your poll. Try again in a minute, and make sure your internet connection is working.");
		builder.setPositiveButton("OK", new DialogInterface.OnClickListener() {
			@Override
			public void onClick(DialogInterface dialog, int which) {
				CreatePoll.this.mButtonPublish.setEnabled(true);
			}
		});
		mAlertDialogFailure = builder.create();
	}
}
