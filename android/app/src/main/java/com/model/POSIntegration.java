package com.example.model;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.nio.charset.StandardCharsets;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.*; 

import android.app.AlertDialog;
import android.app.AlertDialog.Builder;
import android.content.DialogInterface;
import android.hardware.usb.UsbDeviceConnection;
import android.hardware.usb.UsbEndpoint;
import android.widget.TextView;

import com.example.self_check_out.MainActivity;
public class POSIntegration extends MainActivity
{
    String comPortName = "";
    private static ByteArrayOutputStream baos;
    private static Integer msgLen = 0;
    private static MessageFactory msgFactory;
    public static Message mMessage;
    private static V_TYPE mVType;
    private static String l_comPath;
    private TextView mResponseTextView;
    private static final int MAX_LINES = 25;
    
    AlertDialog.Builder builder;  
   
    
    public enum Function
    {
        NONE,
        JUNCTION_PAYMENT,
        JUNCTION_MEMBER
    }

    public enum V_TYPE
    {
        KBZ,
        JUNCTION
    }

    public POSIntegration(V_TYPE fun)
    {
        msgFactory = new MessageFactory();
        baos = new ByteArrayOutputStream();
        mMessage = new SendJPDConfirm();
        mMessage = new SendJPDIndication();
        mMessage = new POSMsg();
        mVType = fun;
        setup();
    }

    public POSIntegration(V_TYPE fun,String ComPath)
    {
        msgFactory = new MessageFactory();
        baos = new ByteArrayOutputStream();
        mMessage = new SendJPDConfirm();
        mMessage = new SendJPDIndication();
        mMessage = new POSMsg();
        mVType = fun;
        l_comPath = ComPath;
        setup();
    }

    public Function function;
    synchronized public byte[] sendMessage(Message msg)
    {
    	byte[] data = null;
    	try {
    		if (mVType == V_TYPE.KBZ)
            {
    			data = msg.buildMessage1();                              
            }
            else if (mVType == V_TYPE.JUNCTION)
            {
                data = msg.buildMessage();                
            }
		} catch (Exception e) {
			e.printStackTrace();
		}
    	
    	return data;
        
        
    }
    
   

    public void VoidMessage(final Message msg)
    {
    	try {
    		 builder = new Builder(null);
    	        
    	        builder.setMessage("Do you want to void ?")  
    	                .setCancelable(false)  
    	                .setNegativeButton("Yes", new DialogInterface.OnClickListener() {  
    	                    public void onClick(DialogInterface dialog, int id) {  
    	                        try {
									finalize();
									byte[] data = msg.voidMessage();
	    	                        if (data.length > 7)
	    	                        {	    	                            
	    	                        }
	    	                        else
	    	                        {
	    	                            return;
	    	                        }
								} catch (Throwable e) {
									
									e.printStackTrace();
								} 
    	                        
    	                         
    	                    }  
    	                })  
    	                .setNegativeButton("No", new DialogInterface.OnClickListener() {  
    	                    public void onClick(DialogInterface dialog, int id) {  
    	                        //  Action for 'NO' Button  
    	                        dialog.cancel();
    	                        return;
    	                    }  
    	                });  
    	        AlertDialog alert = builder.create(); 
    	        alert.show();
			
		} catch (Exception e) {
			e.printStackTrace();
		}
       
    }
    
    public void setup(){

    }
    
    public Message buildResponseMessage(byte[] buffer){
    	try{

            if (mVType == V_TYPE.KBZ)
            {               
                Logger.WriteAYALog("Received: " + Logger.bytesToHex(buffer));
                
                baos.write(buffer, 0, buffer.length);
                String s = "";

                if (msgLen == 0 && buffer.length >= 3)
                {

                    byte[] first = baos.toByteArray();

                    if(first[0] != 6)
                        msgLen = (first[1] << 8) | first[2];
                    else
                    	msgLen = (first[2] << 8) | first[3];

                    s = toHexString1(msgLen);

                    msgLen = Integer.parseInt(s);

                }

                if (baos.size() >= msgLen + 5)
                {

                    byte[] msgBytes = baos.toByteArray();
                   
                    if (msgBytes[0] == 6)
                        msgBytes = Arrays.copyOfRange(msgBytes, 1, msgBytes.length);
                    mMessage = msgFactory.build1(msgBytes);
                    baos = new ByteArrayOutputStream();
                    msgLen = 0;
                }
            }
            else if (mVType == V_TYPE.JUNCTION)
            {
                System.out.println("Received: " + Logger.bytesToHex(buffer));
                baos.write(buffer, 0, buffer.length);

                if (msgLen == 0 && buffer.length >= 3)
                {
                    byte[] first = baos.toByteArray();
                    msgLen = (first[1] << 8) | first[2];
                    System.out.println("msgLen: " + msgLen);
                }

                // check whether full message is received
                if (baos.size() >= msgLen + 4)
                {
                    byte[] msgBytes = baos.toByteArray();
                    System.out.println("Full msg: " + Logger.bytesToHex(msgBytes));
                    mMessage = msgFactory.build(msgBytes);
                    baos = new ByteArrayOutputStream();
                    msgLen = 0;
                }
            }
            
            baos = new ByteArrayOutputStream();
            msgLen = 0;
            //Thread.Sleep(3000);
        }
        catch (Exception ex)
        {
            baos = new ByteArrayOutputStream();
            msgLen = 0;
            System.out.println(ex.toString());
            System.out.print(ex.getStackTrace());
        }

    	return mMessage;
    }

}