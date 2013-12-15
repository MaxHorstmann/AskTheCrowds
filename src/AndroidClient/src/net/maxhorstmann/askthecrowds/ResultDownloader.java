package net.maxhorstmann.askthecrowds;

import android.os.HandlerThread;


public class ResultDownloader<Token> extends HandlerThread {

  private static final String TAG = "ResultDownloader";
  
  public ResultDownloader()
  {
	  super(TAG);
  }
  
  public void queueResultDownload(Token token, String pollGuid)
  {
	  	  
  }
   	
	
	
}
