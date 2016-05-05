package com.ccfsg.connect.api;

import android.content.Context;
import android.os.Bundle;

import com.ccfsg.connect.network.NetworkUtils;

public class DGroupApi extends BaseApi {
    private static final String TAG = "DGroupApi";
    public static class Query extends BaseQuery{

        private static final String TAG = "DGroupApi.Query";

        private Query(Context context, String request, Bundle params, int requestMethod) throws Exception{
            super(context, request, params, requestMethod);
        }

        public static Query prepareQuery(Context context, String request, Bundle params, int requestMethod) throws Exception {
            return new Query(context, request, params, requestMethod);
        }
        
        public static final String DGROUP_LIST_REQUEST = "dgroup_list_request";
        private static final String DGROUP_LIST_URL = "http://www.ccfsingapore.org/wp-content/uploads/DGroup.txt";
          
        @Override
        protected String getRequestUrlFromRequest(String request, Bundle params)
                throws Exception {
            String requestUrl = null;
            if (request.equals(DGROUP_LIST_REQUEST))
            {
                requestUrl = DGROUP_LIST_URL;
            }
            if (requestUrl == null){
                throw new Exception();
            }
            return requestUrl;
        }
    }
    
    public static Query getList(Context context) throws Exception
    {
    	Bundle params = new Bundle();
        return DGroupApi.Query.prepareQuery(context, Query.DGROUP_LIST_REQUEST, params, NetworkUtils.METHOD_GET);
    }
}