package com.ccfsg.connect.fragment;

import android.app.Dialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.support.v4.app.DialogFragment;

import com.ccfsg.connect.R;

public class ProgressDialogFragment extends DialogFragment{
	private ProgressDialog dialog;
	private boolean isCancelled = false;
	public ProgressDialogFragment(){}

	@Override
	public Dialog onCreateDialog(final Bundle savedInstanceState) {
		dialog = new ProgressDialog(getActivity());
		dialog.setMessage(getActivity().getString(R.string.loading));
		return dialog;
	}

	@Override 
	public void onCancel(DialogInterface dialog){
		//getActivity().finish();
		isCancelled = true;
	}
	
	public boolean isCancelled()
	{
		return isCancelled;
	}
	
	@Override 
	public void onDismiss(DialogInterface dialog){
		dialog.dismiss();
	}
}
