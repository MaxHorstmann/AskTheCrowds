package net.maxhorstmann.askthecrowds.services;

import android.app.Activity;
import android.content.SharedPreferences;

public class LocalStorageService {

	SharedPreferences mPreferences;
	
	private final String userGuidSetting = "USER_GUID";
	
	public LocalStorageService(Activity activity){
		mPreferences = activity.getSharedPreferences("ASK_THE_CROWDS", Activity.MODE_PRIVATE);
	}
	
	public String getUserGuid() {
		return mPreferences.getString(userGuidSetting, "");
	}
	
	public boolean putUserGuid(String userGuid) {
		SharedPreferences.Editor editor = mPreferences.edit();
		editor.putString(userGuidSetting, userGuid);
		return editor.commit();
	}	


	
}
