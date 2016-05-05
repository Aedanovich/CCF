package com.ccfsg.connect.api;
import java.util.HashMap;

import android.annotation.SuppressLint;
import android.content.Context;

import com.ccfsg.connect.network.NetworkUtils;


public abstract class BaseApi {
	private static final String TAG = "BaseApi";
	private static final String JSON_CONTENT_TYPE = "application/json";

    private static final String HEADER_DEVICE_MODEL = "device_model";
    private static final String HEADER_MANUFACTURER = "manufacturer";

	@SuppressLint("NewApi")
	public static String makeApiRequest(final Context context, final BaseQuery query){
		HashMap<String, String> headers = new HashMap<String, String>();
		headers.put("Content-Type", JSON_CONTENT_TYPE);
		headers.put(HEADER_DEVICE_MODEL, android.os.Build.MODEL);
        headers.put(HEADER_MANUFACTURER, android.os.Build.MANUFACTURER);
        
		headers.putAll(query.getHeaders());
		try{
			String result = NetworkUtils.getResponse(context, query.getRequestUrl(), query.getErrorHandler(),query.getRequestMethod(), query.getParameters(), query.getPostText(), headers);
			return result;
		}
		catch (Exception e)
		{
			return null;
		}
	}
}


