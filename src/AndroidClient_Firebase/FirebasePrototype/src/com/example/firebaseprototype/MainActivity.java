package com.example.firebaseprototype;

import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.firebase.client.DataSnapshot;
import com.firebase.client.Firebase;
import com.firebase.client.FirebaseError;
import com.firebase.client.ValueEventListener;


public class MainActivity extends ActionBarActivity {
	

	
	TextView tvQuestion;
	Button[] tvAnswers;
	
	Firebase fb;
	Poll poll;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        
        tvQuestion = (TextView)findViewById(R.id.Question);
        Button tvAnswer1 = (Button)findViewById(R.id.Answer1);
        Button tvAnswer2 = (Button)findViewById(R.id.Answer2);
        tvAnswers = new Button[] { tvAnswer1, tvAnswer2 };
        
        
        tvAnswer1.setOnClickListener(new View.OnClickListener() {			
			@Override
			public void onClick(View v) {
				poll.getVotes()[0]++;
				Save();				
			}
		});

        tvAnswer2.setOnClickListener(new View.OnClickListener() {			
			@Override
			public void onClick(View v) {
				poll.getVotes()[1]++;
				Save();				
			}
		});

        
        fb = new Firebase("https://examino.firebaseio.com/123");
        poll = new Poll("What's the best place for a vacation?", new String[] {"Hawaii", "New York"}, new int[] {0,0});

        // Write data to Firebase
        Save();

        // Read data and react to changes
        fb.addValueEventListener(new ValueEventListener() {

			@Override
            public void onDataChange(DataSnapshot snap) {
				poll = (Poll)snap.getValue(Poll.class);     
            	DrawPoll();
            }

            @Override public void onCancelled(FirebaseError error) { }
        });
    }
    
    private void DrawPoll()
    {
    	tvQuestion.setText(poll.getQuestion());
    	
    	for (int i=0; i <poll.getAnwers().length; i++) {
    		tvAnswers[i].setText(String.format("%s    %d", poll.getAnwers()[i], poll.getVotes()[i]));
    	}   	
    	
    }
    
    private void Save()
    {
        fb.setValue(poll);
    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();
        if (id == R.id.action_settings) {
            return true;
        }
        return super.onOptionsItemSelected(item);
    }
}
