package com.ccfsg.connect.api;

import android.content.Context;
import android.os.Bundle;

import com.ccfsg.connect.network.NetworkUtils;
import com.ccfsg.connect.utils.StringUtils;

public class VimeoApi extends BaseApi {
    private static final String TAG = "VimeoApi";
    public static class Query extends BaseQuery{

        private static final String TAG = "VimeoApi.Query";
        private static final String VIDEO_ID_PARAM = "video_id_param";

        private Query(Context context, String request, Bundle params, int requestMethod) throws Exception{
            super(context, request, params, requestMethod);
        }

        public static Query prepareQuery(Context context, String request, Bundle params, int requestMethod) throws Exception {
            return new Query(context, request, params, requestMethod);
        }
        

        public static final String VIDEO_REQUEST = "video_request";
        public static final String VIDEO_LIST_REQUEST = "video_list_request";
        private static final String VIDEO_URL = "https://player.vimeo.com/video/:video_id/config";
        private static final String VIDEO_LIST_URL = "http://vimeo.com/api/v2/user7006079/videos.json";
          
        @Override
        protected String getRequestUrlFromRequest(String request, Bundle params)
                throws Exception {
            String requestUrl = null;
            if (request.equals(VIDEO_LIST_REQUEST))
            {
                requestUrl = VIDEO_LIST_URL;
            }
            if (request.equals(VIDEO_REQUEST)){
                String containerId = params.getString(VIDEO_ID_PARAM);
                if (containerId != null){
                    params.remove(VIDEO_ID_PARAM);
                    requestUrl = VIDEO_URL;
                    requestUrl = StringUtils.replace(requestUrl, ":video_id", containerId);
                }
            }
            if (requestUrl == null){
                throw new Exception();
            }
            return requestUrl;
        }
    }
    
    public static Query getVideos(Context context) throws Exception
    {
    	Bundle params = new Bundle();
        return VimeoApi.Query.prepareQuery(context, Query.VIDEO_LIST_REQUEST, params, NetworkUtils.METHOD_GET);
    }
    
    public static Query getVideo(Context context, int videoId) throws Exception
    {
    	Bundle params = new Bundle();
    	params.putString( Query.VIDEO_ID_PARAM, "" + videoId);
        return VimeoApi.Query.prepareQuery(context, Query.VIDEO_REQUEST, params, NetworkUtils.METHOD_GET);
    }
    
}