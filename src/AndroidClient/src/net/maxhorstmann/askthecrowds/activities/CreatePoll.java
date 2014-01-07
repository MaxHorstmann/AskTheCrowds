package net.maxhorstmann.askthecrowds.activities;

import java.util.ArrayList;

import net.maxhorstmann.askthecrowds.R;
import net.maxhorstmann.askthecrowds.models.Poll;
import net.maxhorstmann.askthecrowds.services.BackendService;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

public class CreatePoll extends Activity {

	private class PostPollTask extends AsyncTask<Poll, Void, String>
	{
		@Override
		protected String doInBackground(Poll... params) {
			BackendService backend = new BackendService();
			return backend.postPoll(params[0]);
		}				
		
		@Override 
		protected void onPostExecute(String result) {
			if ((result==null) || (result.length()==0))
			{
				CreatePoll.this.mAlertDialogFailure.show();
			}
			else
			{
				CreatePoll.this.mAlertDialogSuccess.show();
			}
		}
	}
	
	Button mButtonPublish;
	EditText mEditTextQuestion;
	
	EditText mEditTextAnswer1;
	EditText mEditTextAnswer2;

	AlertDialog mAlertDialogSuccess;
	AlertDialog mAlertDialogFailure;

	PostPollTask mPostPollTask;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);		

		createAlertDialogs();
		setContentView(R.layout.create_poll_fragment);
		
		mEditTextQuestion = (EditText)findViewById(R.id.editTextQuestion);
		mEditTextAnswer1 = (EditText)findViewById(R.id.editTextAnswer1);
		mEditTextAnswer2 = (EditText)findViewById(R.id.editTextAnswer2);		
		
		mButtonPublish = (Button)findViewById(R.id.buttonPublish);
		mButtonPublish.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				
				mButtonPublish.setEnabled(false);
				
				Poll poll = new Poll();
				
				poll.DurationHours = 1; 
				
				poll.Question = mEditTextQuestion.getText().toString();
				poll.Options = new ArrayList<String>();
				poll.Options.add(mEditTextAnswer1.getText().toString());
				poll.Options.add(mEditTextAnswer2.getText().toString());
				
				poll.UserGuid = "929ae5db-76e4-498a-9e8b-81c34838a4a1";
				
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
