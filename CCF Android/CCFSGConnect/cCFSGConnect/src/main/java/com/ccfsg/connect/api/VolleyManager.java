package com.ccfsg.connect.api;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.HashMap;
import java.util.Map;

import org.json.JSONObject;
import org.xml.sax.ErrorHandler;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.graphics.Bitmap;
import android.preference.PreferenceManager;
import android.support.v4.util.LruCache;
import android.text.TextUtils;
import android.util.Log;
import android.util.SparseArray;
import android.widget.ImageView;

import com.android.volley.DefaultRetryPolicy;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.Response.ErrorListener;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.ImageLoader;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.NetworkImageView;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;
import com.ccfsg.connect.network.NetworkUtils;

/**
 * Created by viki on 5/29/13.
 */
public class VolleyManager {

    private static final String TAG = "VolleyManager";

    private static final String JSON_CONTENT_TYPE = "application/json";

    public static final int NO_DEFAULT_IMAGE = 0;
    private static final String HEADER_DEVICE_MODEL = "device_model";
    private static final String HEADER_MANUFACTURER = "manufacturer";
    private static final String HEADER_CARRIER = "carrier";

    public static SparseArray<Integer> NETWORK_METHODS;
    static{
        NETWORK_METHODS = new SparseArray<Integer>();
        NETWORK_METHODS.append(NetworkUtils.METHOD_GET, Request.Method.GET);
        NETWORK_METHODS.append(NetworkUtils.METHOD_POST, Request.Method.POST);
        NETWORK_METHODS.append(NetworkUtils.METHOD_PUT, Request.Method.PUT);
        NETWORK_METHODS.append(NetworkUtils.METHOD_DELETE, Request.Method.DELETE);
    }

    private static RequestQueue volleyRequestQueue;
    private static ImageLoader volleyImageLoader;

    public static void prepareVolley(Context context){
        volleyRequestQueue =  Volley.newRequestQueue(context);
        volleyImageLoader = new ImageLoader(volleyRequestQueue, new BitmapLruCache());
    }

    public static void queueRequest(Context context, Request request){
        if (volleyRequestQueue == null){
            prepareVolley(context);
        }
        volleyRequestQueue.add(request);
    }

    public static ImageLoader getImageLoader(Context context){
        if (volleyImageLoader == null){
            prepareVolley(context);
        }
        return volleyImageLoader;
    }

    public static void makeVolleyStringRequest(final Context context, final BaseQuery query, final Response.Listener<String> responseListener, final Response.ErrorListener errorListener) throws Exception{
        
    	makeVolleyStringRequest( context, query, responseListener, errorListener, false, DefaultRetryPolicy.DEFAULT_MAX_RETRIES, DefaultRetryPolicy.DEFAULT_TIMEOUT_MS );
    }
    public static void makeVolleyStringRequest(final Context context, final BaseQuery query, final Response.Listener<String> responseListener, final Response.ErrorListener errorListener, boolean shouldCache, int retryCount, int timeout ) throws Exception{

        
        Response.Listener<String> wrappedResponseListener = new Response.Listener<String>() {

			@Override
			public void onResponse(String response) {
				responseListener.onResponse(response);
			}
		};
		
		ErrorListener wrappedErrorListener = new Response.ErrorListener() {
			@Override
			public void onErrorResponse(VolleyError error) {
			errorListener.onErrorResponse(error);
		}
		};
        StringRequest request = new StringRequest(NETWORK_METHODS.get(query.getRequestMethod()), query.getRequestUrl(),
//                headers, query.getParameters(), query.getPostText(),
        		wrappedResponseListener, wrappedErrorListener) {
            @Override
            public Map<String, String> getHeaders() throws com.android.volley.AuthFailureError {
                HashMap<String, String> headers = new HashMap<String, String>();
                headers.put("Content-Type", JSON_CONTENT_TYPE);
                headers.put(HEADER_DEVICE_MODEL, android.os.Build.MODEL);
                headers.put(HEADER_MANUFACTURER, android.os.Build.MANUFACTURER);
                headers.putAll(query.getHeaders());
                return headers;
            }
        };
        
        request.setShouldCache( shouldCache );
        request.setRetryPolicy( new DefaultRetryPolicy( timeout, retryCount, DefaultRetryPolicy.DEFAULT_BACKOFF_MULT ) );
        queueRequest(context, request);
    }
    

    public static void loadImage(Context context, NetworkImageView imageView, String imageUrl, int defaultImageResId){
        if (volleyImageLoader == null){
            prepareVolley(context);
        }
        imageView.setDefaultImageResId(defaultImageResId);
        imageView.setImageUrl(imageUrl, volleyImageLoader);
    }

    public static void loadImageWithoutNetworkImage(Context context, final ImageView imageView, String imageUrl, int defaultImageResId){
        if (volleyImageLoader == null){
            prepareVolley(context);
        }
        if (defaultImageResId != NO_DEFAULT_IMAGE){
            imageView.setImageDrawable(context.getResources().getDrawable(defaultImageResId));
        }
        volleyImageLoader.get(imageUrl, new ImageLoader.ImageListener() {
            @Override
            public void onResponse(ImageLoader.ImageContainer response, boolean isImmediate) {
                if (response.getBitmap() != null){
                    imageView.setImageBitmap(response.getBitmap());
                }
            }
            @Override
            public void onErrorResponse(VolleyError error) {
            }
        });
    }

    private static class BitmapLruCache extends LruCache<String, Bitmap> implements ImageLoader.ImageCache {
        public static int getDefaultLruCacheSize() {
            final int maxMemory = (int) (Runtime.getRuntime().maxMemory() / 1024);
            final int cacheSize = maxMemory / 16;

            return cacheSize;
        }

        public BitmapLruCache() {
            this(getDefaultLruCacheSize());
        }

        public BitmapLruCache(int sizeInKiloBytes) {
            super(sizeInKiloBytes);
        }

        @Override
        protected int sizeOf(String key, Bitmap value) {
            return value.getRowBytes() * value.getHeight() / 1024;
        }

        @Override
        public Bitmap getBitmap(String url) {
            return get(url);
        }

        @Override
        public void putBitmap(String url, Bitmap bitmap) {
            put(url, bitmap);
        }
    }
    
	public static void clearCache()
	{
		if(volleyRequestQueue != null)
		{
			//Volley.clearCache(volleyRequestQueue);
		}
	}

}
