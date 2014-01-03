package net.maxhorstmann.askthecrowds;

import java.util.ArrayList;
import java.util.Locale;

import net.maxhorstmann.askthecrowds.models.Poll;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

public class PollDetailsFragment extends Fragment {

	private Poll mPoll;
	//private bool mResultsView;
	private TextView mTextViewPollTitle;
	private LinearLayout mLinearLayoutOptions;
	
	@Override 
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		mPoll = new Poll();
		mPoll.Question = "What is the best place to take a vacation?";
		
		mPoll.Options = new ArrayList<String>();
		mPoll.Options.add("Hawaii");
		mPoll.Options.add("New Zealand");
		
		mPoll.Votes = new ArrayList<Integer>();
		mPoll.Votes.add(32);
		mPoll.Votes.add(21);		
	}
	
	@Override 
	public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
		
		View v = inflater.inflate(R.layout.poll_details, parent, false);
		
		mTextViewPollTitle = (TextView)v.findViewById(R.id.textViewPollTitle);
		mTextViewPollTitle.setText(mPoll.Question);
		
		
		
		mLinearLayoutOptions = (LinearLayout)v.findViewById(R.id.linearLayoutOptions);
		mLinearLayoutOptions.removeAllViewsInLayout();
		for (int i=0; i<mPoll.Options.size(); i++)
		{
			int votes = mPoll.Votes.get(i);
			String option = mPoll.Options.get(i);
			String optionText = String.format(Locale.ENGLISH, "%s     ( %d votes)", option, votes);
			TextView child = new TextView(getActivity());
			child.setText(optionText);			
			mLinearLayoutOptions.addView(child);			
		}
		
		return v;
	}
	
	
	
}
