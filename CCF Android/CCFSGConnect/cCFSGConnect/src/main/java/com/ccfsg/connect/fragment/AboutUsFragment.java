package com.ccfsg.connect.fragment;

import java.util.ArrayList;

import org.json.JSONArray;

import android.graphics.drawable.ColorDrawable;
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
import com.ccfsg.connect.adapter.AboutUsAdapter;
import com.ccfsg.connect.api.CCFDetailApi;
import com.ccfsg.connect.api.VolleyManager;
import com.ccfsg.connect.beans.CCFDetail;

public class AboutUsFragment extends Fragment {
    public static final String TAG = "CCFDetailFragment";
    private AdapterView listView;
    private ArrayList<CCFDetail> detailList;
    private ProgressBar progressBar;
    
    @Override
    public void onResume()
    {
    	super.onResume();
    	ActionBar actionBar = ((ActionBarActivity) getActivity() ).getSupportActionBar();
    	actionBar.setBackgroundDrawable( new ColorDrawable( getResources().getColor( R.color.home_blue ) ) );
    	actionBar.setTitle( getString( R.string.about_us ).toUpperCase() );
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View root;
        
        root = inflater.inflate(R.layout.fragment_about_us, container, false);
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
        AboutUsAdapter adapter = new AboutUsAdapter(getActivity(), detailList);
        listView.setAdapter(adapter);
        listView.setVisibility( View.VISIBLE );
    }
    
    public void execute() 
    {
    	try 
    	{
			CCFDetailApi.Query query = CCFDetailApi.getList( getActivity() );
			VolleyManager.makeVolleyStringRequest(getActivity(), query, new Response.Listener<String>() 
        		{
                    @Override
                    public void onResponse(String response) 
                    {
                        if (isDetached()) return;
                        try 
                        {
                        	JSONArray json = new JSONArray( response );
                            detailList = CCFDetail.toArrayList( json );
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
}
