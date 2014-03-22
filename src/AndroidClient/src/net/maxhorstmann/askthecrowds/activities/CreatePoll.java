package net.maxhorstmann.askthecrowds.activities;

import java.util.ArrayList;

import net.maxhorstmann.askthecrowds.R;
import net.maxhorstmann.askthecrowds.models.Poll;
import net.maxhorstmann.askthecrowds.services.BackendService;
import net.maxhorstmann.askthecrowds.services.LocalStorageService;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ProgressBar;
import android.widget.Spinner;

public class CreatePoll extends Activity {

	private class PostPollTask extends AsyncTask<Poll, Void, String>
	{
		@Override
		protected String doInBackground(Poll... polls) {
     		Poll poll = polls[0];
			return mBackendService.postPoll(poll);
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
				mLocalStorageService.addMyPollId(result);
				mAlertDialogSuccess.show();
			}
		}
	}
	
	Poll newPoll;
	int screen = 0;
	
//	Button mButtonPublish;
//	EditText mEditTextQuestion;
	
	EditText mEditTextAnswer1;
	EditText mEditTextAnswer2;

	AlertDialog mAlertDialogSuccess;
	AlertDialog mAlertDialogFailure;
	
	ProgressBar mProgressBar;
	PostPollTask mPostPollTask;
	
	Spinner mSpinnerCategory;
	Spinner mSpinnerLanguage;
	
	BackendService mBackendService;
	LocalStorageService mLocalStorageService;		
	
	

	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		mLocalStorageService = new LocalStorageService(this);
		mBackendService = new BackendService(mLocalStorageService);

		screen = 0;
		draw();

		
	}
	
	private void draw() {
		
		switch (screen)
		{
			case 0: drawQuestionScreen(); break;
			case 1: drawPhotoScreen(); break;
			case 2: drawPublishScreen(); break;
			
		
		}
		

	}
	
	private void drawQuestionScreen() {
		setContentView(R.layout.create_poll_0);
		
		Button buttonSubmitQuestion = (Button)findViewById(R.id.buttonSubmitQuestion);
		buttonSubmitQuestion.setOnClickListener(new View.OnClickListener() {			
			@Override
			public void onClick(View v) {
				screen = 1;
				draw();
			}
		});		
	}
	
	private void drawPhotoScreen() {
		setContentView(R.layout.create_poll_1);
		
	}
	
	private void drawPublishScreen() {
		
		createAlertDialogs();

		//mEditTextQuestion = (EditText)findViewById(R.id.editTextQuestion);
		
		//mProgressBar = (ProgressBar)findViewById(R.id.progressBar1);
		//mProgressBar.setVisibility(View.INVISIBLE);
		
		//mSpinnerCategory = (Spinner)findViewById(R.id.spinnerCategory);
		//mSpinnerLanguage = (Spinner)findViewById(R.id.spinnerLanguage);
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
