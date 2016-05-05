package com.ccfsg.connect.api;

import android.content.Context;
import android.os.Bundle;

import com.ccfsg.connect.network.NetworkUtils;

public class MinistryApi extends BaseApi {
    private static final String TAG = "MinistryApi";
    public static class Query extends BaseQuery{

        private static final String TAG = "MinistryApi.Query";

        private Query(Context context, String request, Bundle params, int requestMethod) throws Exception{
            super(context, request, params, requestMethod);
        }

        public static Query prepareQuery(Context context, String request, Bundle params, int requestMethod) throws Exception {
            return new Query(context, request, params, requestMethod);
        }
        
        public static final String MINISTRY_LIST_REQUEST = "minsitry_list_request";
        private static final String MINISTRY_LIST_URL = "http://www.ccfsingapore.org/wp-content/uploads/Ministry.txt";
          
        @Override
        protected String getRequestUrlFromRequest(String request, Bundle params)
                throws Exception {
            String requestUrl = null;
            if (request.equals(MINISTRY_LIST_REQUEST))
            {
                requestUrl = MINISTRY_LIST_URL;
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
        return MinistryApi.Query.prepareQuery(context, Query.MINISTRY_LIST_REQUEST, params, NetworkUtils.METHOD_GET);
    }
}