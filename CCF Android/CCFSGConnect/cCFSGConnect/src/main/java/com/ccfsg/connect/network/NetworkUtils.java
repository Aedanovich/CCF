package com.ccfsg.connect.network;

import java.util.HashMap;

import org.xml.sax.ErrorHandler;

import android.content.Context;
import android.util.SparseArray;

import com.foxykeep.datadroid.network.NetworkConnection;
import com.foxykeep.datadroid.network.NetworkConnection.ConnectionResult;
import com.foxykeep.datadroid.network.NetworkConnection.Method;

public class NetworkUtils {
	private static final String TAG = "NetworkUtils";

	public static final int METHOD_GET = 0;
	public static final int METHOD_POST = 1;
	public static final int METHOD_PUT = 2;
	public static final int METHOD_DELETE = 3;
	public static final int METHOD_HEAD = 4;
	public static SparseArray<Method> NETWORK_METHODS;
	static{
		NETWORK_METHODS = new SparseArray<Method>();
		NETWORK_METHODS.append(METHOD_GET, NetworkConnection.Method.GET);
		NETWORK_METHODS.append(METHOD_POST, NetworkConnection.Method.POST);
		NETWORK_METHODS.append(METHOD_PUT, NetworkConnection.Method.PUT);
		NETWORK_METHODS.append(METHOD_DELETE, NetworkConnection.Method.DELETE);
	}
	
	public static String getResponse(Context context, String requestUrl, ErrorHandler handler, int method) throws Exception{
		try {
			NetworkConnection networkConnection = new NetworkConnection(context, requestUrl);
			networkConnection.setMethod(NETWORK_METHODS.get(method));
			ConnectionResult result = networkConnection.execute();
			return result.body;
		}
		catch (Exception e) {
		}
		return null;
	}
	
	public static String getResponse(Context context, String requestUrl, ErrorHandler handler, int method, HashMap<String, String> parameters, String postText, HashMap<String, String> headers) throws Exception{
		try {
			NetworkConnection networkConnection = new NetworkConnection(context, requestUrl);
			networkConnection.setMethod(NETWORK_METHODS.get(method));
			networkConnection.setParameters(parameters);
			networkConnection.setHeaderList(headers);
			if (postText != null){
				networkConnection.setPostText(postText);
			}
			ConnectionResult result = networkConnection.execute();
			return result.body;
		}
		catch (Exception e) {
		}
		return null;
	}
}
