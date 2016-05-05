package com.ccfsg.connect.fragment;

import java.util.ArrayList;

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
import com.ccfsg.connect.R;
import com.ccfsg.connect.ResourcesActivity;
import com.ccfsg.connect.adapter.ResourceListAdapter;
import com.ccfsg.connect.api.ResourceApi;
import com.ccfsg.connect.api.VolleyManager;
import com.ccfsg.connect.beans.Resource;

public class ResourcesListFragment extends Fragment {
    public static final String TAG = "MinistryListFragment";
    private AdapterView listView;
    private ArrayList<Resource> resourceList;
    private ProgressBar progressBar;
    
    @Override
    public void onResume()
    {
    	super.onResume();
    	ActionBar actionBar = ((ActionBarActivity) getActivity() ).getSupportActionBar();
    	actionBar.setBackgroundDrawable( new ColorDrawable( getResources().getColor( R.color.home_blue ) ) );
    	actionBar.setTitle( getString( R.string.resources ).toUpperCase() );
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View root;
        
        root = inflater.inflate(R.layout.fragment_resource_list, container, false);
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
    	ResourceListAdapter adapter = new ResourceListAdapter(getActivity(), resourceList);
        listView.setAdapter(adapter);
        listView.setOnItemClickListener(new android.widget.AdapterView.OnItemClickListener() 
        {
            @Override
            public void onItemClick(android.widget.AdapterView<?> adapterView, View view, int position, long id)
            {
            	Resource resource = (Resource) listView.getItemAtPosition(position);
            	Intent myIntent = new Intent(getActivity(), ResourcesActivity.class);
                myIntent.putExtra( ResourcesActivity.RESOURCE, resource );
				startActivity(myIntent);
            }
        });
        listView.setVisibility(View.VISIBLE);
    }
    
    public void execute() 
    {
    	try 
    	{
    		ResourceApi.Query query = ResourceApi.getList( getActivity() );
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
                            resourceList = Resource.toArrayList( json );
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