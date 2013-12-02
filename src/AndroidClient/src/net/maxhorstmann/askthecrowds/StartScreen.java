package net.maxhorstmann.askthecrowds;

import android.app.Activity;
import android.os.Bundle;
import android.view.Menu;

import com.google.gson.Gson;

public class StartScreen extends Activity {
	
	Gson gson = new Gson();

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_start_screen);
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.start_screen, menu);
		return true;
	}

}
