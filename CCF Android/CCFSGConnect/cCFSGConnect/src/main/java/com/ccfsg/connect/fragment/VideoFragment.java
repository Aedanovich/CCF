package com.ccfsg.connect.fragment;

import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONObject;

import android.content.Context;
import android.content.Intent;
import android.graphics.drawable.ColorDrawable;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.app.ActionBar;
import android.support.v7.app.ActionBarActivity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ProgressBar;

import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.ccfsg.connect.R;
import com.ccfsg.connect.VideoPlayerActivity;
import com.ccfsg.connect.adapter.VideoAdapter;
import com.ccfsg.connect.api.VimeoApi;
import com.ccfsg.connect.api.VolleyManager;
import com.ccfsg.connect.beans.VimeoDetail;
import com.ccfsg.connect.beans.VimeoVideo;
import com.ccfsg.connect.utils.DialogUtils;

public class VideoFragment extends Fragment {
    public static final String TAG = "SearchFragment";
    private AdapterView listView;
    private ArrayList<VimeoDetail> videoList;
    private ProgressBar progressBar;
    
    @Override
    public void onResume()
    {
    	super.onResume();
    	ActionBar actionBar = ((ActionBarActivity) getActivity() ).getSupportActionBar();
    	actionBar.setBackgroundDrawable( new ColorDrawable( getResources().getColor( R.color.home_blue ) ) );
    	actionBar.setTitle( getString( R.string.videos ).toUpperCase() );
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View root;
        
        root = inflater.inflate(R.layout.fragment_video, container, false);
        listView = (AdapterView) root.findViewById(R.id.listview);
        progressBar = (ProgressBar) root.findViewById( R.id.progress_bar );
        return root;
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceStates){
        super.onActivityCreated(savedInstanceStates);
        execute();
    }

    private void renderContent()
    {
        VideoAdapter adapter = new VideoAdapter(getActivity(), videoList);
        listView.setAdapter(adapter);
        listView.setOnItemClickListener(new android.widget.AdapterView.OnItemClickListener() 
        {
            @Override
            public void onItemClick(android.widget.AdapterView<?> adapterView, View view, int position, long id)
            {
            	VimeoDetail detail = (VimeoDetail) listView.getItemAtPosition(position);
            	loadVideo( detail );
            }
        });
        listView.setVisibility(View.VISIBLE);
    }
    
    public void execute() 
    {
    	try 
    	{
			VimeoApi.Query query = VimeoApi.getVideos( getActivity() );
			VolleyManager.makeVolleyStringRequest(getActivity(), query, new Response.Listener<String>() 
        		{
                    @Override
                    public void onResponse(String response) 
                    {
                        if (isDetached()) return;
                        try 
                        {
                        	JSONArray json = new JSONArray( response );
                            videoList = VimeoDetail.toArrayList( json );
                            progressBar.setVisibility( View.GONE );
                            renderContent();
                        } 
                        catch (Exception e) 
                        {
                        	e.printStackTrace();
                        }
                    }
                }, new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error)
                    {
                    	error.printStackTrace();
                    }
                }
            );
		}
    	catch (Exception e)
		{
			e.printStackTrace();
		}
    }
    
    public void loadVideo( VimeoDetail detail )
    {
    	try 
    	{
    		DialogUtils.showProgressDialog( getActivity(), "loading" );
			VimeoApi.Query query = VimeoApi.getVideo( getActivity(), detail.getId() );
			VolleyManager.makeVolleyStringRequest(getActivity(), query, new Response.Listener<String>() 
        		{
                    @Override
                    public void onResponse(String response) 
                    {
                        if (isDetached()) return;
                        try 
                        {
                        	JSONObject json = new JSONObject( response );
                            VimeoVideo video = new VimeoVideo( json );
                            Intent myIntent = new Intent(getActivity(), VideoPlayerActivity.class);
                            myIntent.putExtra( VideoPlayerActivity.URL, isConnected( getActivity() ) ? video.getUrl() : video.getMobileUrl() );
                            startActivity(myIntent);
                        } 
                        catch (Exception e) 
                        {
                        	e.printStackTrace();
                        }
                        finally
                        {
                    		DialogUtils.dismissDialogFragment( getActivity(), "loading" );
                        }
                    }
                }, new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error)
                    {
                    	error.printStackTrace();
                		DialogUtils.dismissDialogFragment( getActivity(), "loading" );
                    }
                }
            );
		}
    	catch (Exception e)
		{
			e.printStackTrace();
    		DialogUtils.dismissDialogFragment( getActivity(), "loading" );
		}
    }
    
    private static boolean isConnected(Context context)
    {
    	try
    	{
	        ConnectivityManager connectivityManager = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
	        NetworkInfo networkInfo = null;
	        if (connectivityManager != null)
	        {
	            networkInfo = connectivityManager.getNetworkInfo(ConnectivityManager.TYPE_WIFI);
	        }
	        return networkInfo == null ? false : networkInfo.isConnected();
    	}
    	catch( Exception e )
    	{
    		return false;
    	}
    }
}