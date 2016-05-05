package com.ccfsg.connect.fragment;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;

import org.json.JSONArray;
import org.json.JSONObject;

import android.content.Intent;
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
import com.ccfsg.connect.MinistryActivity;
import com.ccfsg.connect.R;
import com.ccfsg.connect.adapter.MinistryListAdapter;
import com.ccfsg.connect.api.MinistryApi;
import com.ccfsg.connect.api.VolleyManager;
import com.ccfsg.connect.beans.Ministry;

public class MinistryListFragment extends Fragment {
    public static final String TAG = "MinistryListFragment";
    private AdapterView listView;
    private ArrayList<Ministry> ministryList;
    private ProgressBar progressBar;
    
    @Override
    public void onResume()
    {
    	super.onResume();
    	ActionBar actionBar = ((ActionBarActivity) getActivity() ).getSupportActionBar();
    	actionBar.setBackgroundDrawable( new ColorDrawable( getResources().getColor( R.color.home_blue ) ) );
    	actionBar.setTitle( getString( R.string.ministries ).toUpperCase() );
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View root;
        
        root = inflater.inflate(R.layout.fragment_ministry_list, container, false);
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
        Collections.sort(ministryList, new MinistryComparator());
    	MinistryListAdapter adapter = new MinistryListAdapter(getActivity(), ministryList);
        listView.setAdapter(adapter);
        listView.setOnItemClickListener(new android.widget.AdapterView.OnItemClickListener() 
        {
            @Override
            public void onItemClick(android.widget.AdapterView<?> adapterView, View view, int position, long id)
            {
            	Ministry ministry = (Ministry) listView.getItemAtPosition(position);
            	Intent myIntent = new Intent(getActivity(), MinistryActivity.class);
                myIntent.putExtra( MinistryActivity.MINISTRY, ministry );
				startActivity(myIntent);
            }
        });
        listView.setVisibility(View.VISIBLE);
    }
    
    public void execute() 
    {
    	try 
    	{
    		MinistryApi.Query query = MinistryApi.getList( getActivity() );
			VolleyManager.makeVolleyStringRequest(getActivity(), query, new Response.Listener<String>() 
        		{
                    @Override
                    public void onResponse(String response) 
                    {
                        if (isDetached()) return;
                        try 
                        {
                        	JSONObject jsonObject = new JSONObject( response );
                        	JSONArray json = jsonObject.getJSONArray( "data" );
                            ministryList = Ministry.toArrayList( json );
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

    class MinistryComparator implements Comparator<Ministry> {
        @Override
        public int compare(Ministry o1, Ministry o2) {
            return o1.getName().compareTo(o2.getName());
        }
    }
}
