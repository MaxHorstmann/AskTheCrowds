package net.maxhorstmann.askthecrowds.fragments;

import java.util.ArrayList;

import net.maxhorstmann.askthecrowds.R;
import net.maxhorstmann.askthecrowds.models.Poll;
import net.maxhorstmann.askthecrowds.services.BackendService;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;

public class CreatePollFragment extends Fragment {
	
	private class PostPollTask extends AsyncTask<Poll, Void, String>
	{

		@Override
		protected String doInBackground(Poll... params) {
			BackendService backend = new BackendService();
			String pollId = backend.postPoll(params[0]);
			return pollId;

		}		
		
	}
	

	Button mButtonPublish;
	EditText mEditTextQuestion;
	
	EditText mEditTextAnswer1;
	EditText mEditTextAnswer2;
	
	@Override 
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);		
	
	}
	
	@Override 
	public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
		
		View v = inflater.inflate(R.layout.create_poll_fragment, parent, false);
		
		mEditTextQuestion = (EditText)v.findViewById(R.id.editTextQuestion);
		mEditTextAnswer1 = (EditText)v.findViewById(R.id.editTextAnswer1);
		mEditTextAnswer2 = (EditText)v.findViewById(R.id.editTextAnswer2);		
		
		mButtonPublish = (Button)v.findViewById(R.id.buttonPublish);
		mButtonPublish.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				Poll poll = new Poll();
				
				poll.DurationHours = 1; 
				
				poll.Question = mEditTextQuestion.getText().toString();
				poll.Options = new ArrayList<String>();
				poll.Options.add(mEditTextAnswer1.getText().toString());
				poll.Options.add(mEditTextAnswer2.getText().toString());
				
				poll.UserGuid = "929ae5db-76e4-498a-9e8b-81c34838a4a1";
				
				PostPollTask postPollTask = new PostPollTask();
				postPollTask.execute(poll);
				
			}
		});
		
		return v;
	}
	
	
}
