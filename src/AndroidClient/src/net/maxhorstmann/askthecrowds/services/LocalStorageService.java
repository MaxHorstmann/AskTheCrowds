package net.maxhorstmann.askthecrowds.services;

import android.app.Activity;
import android.content.SharedPreferences;

public class LocalStorageService {

	SharedPreferences mPreferences;
	
	private final String userUuidSetting = "USER_GUID";
	
	public LocalStorageService(Activity activity){
		mPreferences = activity.getSharedPreferences("ASK_THE_CROWDS", Activity.MODE_PRIVATE);
	}
	
	public String getUserUuid() {
		return mPreferences.getString(userUuidSetting, null);
	}
	
	public boolean putUserUuid(String userUuid) {
		SharedPreferences.Editor editor = mPreferences.edit();
		editor.putString(userUuidSetting, userUuid);
		return editor.commit();
	}	


	
}
