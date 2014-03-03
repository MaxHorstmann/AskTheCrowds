package net.maxhorstmann.askthecrowds.services;

import java.util.Arrays;
import java.util.Date;
import java.util.List;

import android.app.Activity;
import android.content.SharedPreferences;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

public class LocalStorageService {

	SharedPreferences mPreferences;
	private Gson gson;

	
	private final String userIdSetting = "USER_ID";
	private final String myPollsSetting = "MY_POLLS";
	// private final String pollsIhaveVotedForSetting = "VOTED_POLLS";  -- TODO
	

	public LocalStorageService(Activity activity){
		mPreferences = activity.getSharedPreferences("ASK_THE_CROWDS", Activity.MODE_PRIVATE);
		GsonBuilder gsonBuilder = new GsonBuilder();
		gsonBuilder.registerTypeAdapter(Date.class, new DateDeserializer());
		gson = gsonBuilder.create();

	}
	
	public String getUserUuid() {
		return mPreferences.getString(userIdSetting, null);
	}
	
	public boolean putUserUuid(String userUuid) {
		SharedPreferences.Editor editor = mPreferences.edit();
		editor.putString(userIdSetting, userUuid);
		return editor.commit();
	}
	
	public String[] getMyPollIds() {
		String setting = mPreferences.getString(myPollsSetting, null);
		if (setting == null) return new String[] {};
		return gson.fromJson(setting, String[].class);		
	}
	
	public boolean addMyPollId(String pollId) {
		List<String> myPollIds = Arrays.asList(getMyPollIds());
		myPollIds.add(pollId);
		SharedPreferences.Editor editor = mPreferences.edit();
		editor.putString(myPollsSetting, gson.toJson(myPollIds));
		return editor.commit();
	}


	
}
