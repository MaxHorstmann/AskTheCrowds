package net.maxhorstmann.askthecrowds.tasks;

import net.maxhorstmann.askthecrowds.models.services.BackendService;
import android.os.AsyncTask;


public class TestTask extends AsyncTask<Void, Void, String> {

	BackendService s = new BackendService();
	
	@Override
	protected String doInBackground(Void... params) {
		return s.createUser();
	}
	
}