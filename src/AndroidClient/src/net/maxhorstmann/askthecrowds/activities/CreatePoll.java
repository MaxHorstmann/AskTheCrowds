package net.maxhorstmann.askthecrowds.activities;

import net.maxhorstmann.askthecrowds.R;
import net.maxhorstmann.askthecrowds.models.Poll;
import net.maxhorstmann.askthecrowds.services.BackendService;
import net.maxhorstmann.askthecrowds.services.LocalStorageService;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.provider.MediaStore;
import android.view.KeyEvent;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ProgressBar;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.TextView.OnEditorActionListener;

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
			CreatePoll.this.mProgressBarPublish.setVisibility(View.INVISIBLE);
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
	
	
	
	
	Poll mPoll;
	int screen = 0;
	
	Button mButtonPublish;
	EditText mEditTextQuestion;
	
	EditText mEditTextAnswer1;
	EditText mEditTextAnswer2;

	AlertDialog mAlertDialogSuccess;
	AlertDialog mAlertDialogFailure;
	
	ProgressBar mProgressBarPublish;
	PostPollTask mPostPollTask;
	
	Spinner mSpinnerCategory;
	Spinner mSpinnerLanguage;
	
	BackendService mBackendService;
	LocalStorageService mLocalStorageService;		
	
	ProgressBar progressBarPictureUpload;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		mLocalStorageService = new LocalStorageService(this);
		mBackendService = new BackendService(mLocalStorageService);

		mPoll = new Poll();
		
		
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
		
		mEditTextQuestion = (EditText)findViewById(R.id.editTextQuestion);
		mEditTextQuestion.setOnEditorActionListener(new OnEditorActionListener() {
		    @Override
		    public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
		        boolean handled = false;
		        if (actionId == EditorInfo.IME_ACTION_DONE) {
		        	mPoll.Question = mEditTextQuestion.getText().toString();
		        	if (mPoll.Question.length()>0) {
		        		
		        		InputMethodManager imm = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE);
		        	    imm.hideSoftInputFromWindow(mEditTextQuestion.getWindowToken(), 0);
		        		
			            screen=1;
			            draw();
			            handled = true;
		        	}
		        }
		        return handled;
		    }
		 });
		
		mEditTextQuestion.requestFocus();
		InputMethodManager imm = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE);
	    imm.showSoftInput(mEditTextQuestion, 0); // hmmm doesn't work... 
		
	
	}
	
	
	private static final int PICK_IMAGE = 1;
	private static final int TAKE_PICTURE = 2;

	private void drawPhotoScreen() {
		setContentView(R.layout.create_poll_1);
		
		Button bTakePhoto = (Button)findViewById(R.id.buttonTakePhoto);
		bTakePhoto.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
				startActivityForResult(intent, TAKE_PICTURE);
				
			}
		});
		
		Button bPickFromGallery = (Button)findViewById(R.id.buttonPickFromGallery);
		bPickFromGallery.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				Intent intent = new Intent(Intent.ACTION_GET_CONTENT);
				intent.setType("image/*");
				startActivityForResult(Intent.createChooser(intent, "Select Picture"), PICK_IMAGE);				
			}
		});
		
		
		progressBarPictureUpload = (ProgressBar)findViewById(R.id.progressBarPictureUpload);
		progressBarPictureUpload.setVisibility(View.INVISIBLE);
		

		
		Button bSkip = (Button)findViewById(R.id.buttonSkipPhoto);
		bSkip.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				screen=2;
				draw();
			}
		} );
		
	}
	
	private void drawPublishScreen() {
		
		createAlertDialogs();		
		
		setContentView(R.layout.create_poll_2);

		mProgressBarPublish =  (ProgressBar)findViewById(R.id.progressBarPublish);
		mProgressBarPublish.setVisibility(View.INVISIBLE);

		mButtonPublish = (Button)findViewById(R.id.buttonPublish);
		
		mButtonPublish.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				mProgressBarPublish.setVisibility(View.VISIBLE);
				mButtonPublish.setEnabled(false);
				PostPollTask postPollTask = new PostPollTask();
				postPollTask.execute(mPoll);
			}
		});

		

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
