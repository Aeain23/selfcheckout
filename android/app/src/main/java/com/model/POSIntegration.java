package com.example.model;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.nio.charset.StandardCharsets;
//import java.nio.file.Files;
//import java.nio.file.Paths;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
//import javax.comm.*;
//import javax.swing.JOptionPane;
//import java.time.LocalDate;
import java.util.*; 

import android.app.AlertDialog;
import android.app.AlertDialog.Builder;
import android.content.DialogInterface;
import android.hardware.usb.UsbDeviceConnection;
import android.hardware.usb.UsbEndpoint;
import android.widget.TextView;


//import jssc.SerialPort;
//import jssc.SerialPortException;
//import jssc.SerialPortList;
import com.example.self_check_out.MainActivity;
// extends MainActivity
public class POSIntegration extends MainActivity
{
    //private static SerialPort com;
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
    public byte[] sendMessage(Message msg)
    {
    	byte[] data = null;
    	try {
    		//data = msg.buildMessage1();
//    		logMsg("sendMessage : ");
    		if (mVType == V_TYPE.KBZ)
            {
    			data = msg.buildMessage1();
                //com.Write(data, 0, data.length);
                //com.writeBytes(data);                       
   	            // This is where it sends                
            }
            else if (mVType == V_TYPE.JUNCTION)
            {
                data = msg.buildMessage();
                //com.Write(data, 0, data.length);
                //com.writeBytes(data);
            }
		} catch (Exception e) {
			e.printStackTrace();
		}
    	
    	return data;
        
        
    }
    
   

    public void VoidMessage(final Message msg)
    {
//        if (JOptionPane.showConfirmDialog(null, "Are you sure want to void?", "", JOptionPane.QUESTION_MESSAGE) == 0)
//        {
//            byte[] data = msg.voidMessage();
//            if (data.length > 7)
//            {
//                com.Write(data, 0, data.length);
//            }
//            else
//            {
//                return;
//            }
//        }
//        else
//        {
//            return;
//        }
        
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
	    	                            //com.Write(data, 0, data.length);
	    	                            //com.writeBytes(data);
	    	                        }
	    	                        else
	    	                        {
	    	                            return;
	    	                        }
								} catch (Throwable e) {
									// TODO Auto-generated catch block
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

    public void sendConfirm(Message msg)
    {       
//        try {
//        	 byte[] data = msg.buildMessage();
//             //com.Write(data, 0, data.length);
//			//com.writeBytes(data);
//		} catch (SerialPortException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
    }

    //AA002204020000000100000007063330302E30300000060C52313730363038303030303201FF3F

	/*public static void com_DataReceived( Object sender,
            SerialPortEventListener e)
    {
        try
        {
            Thread.sleep(1000);
            if (mVType == V_TYPE.KBZ)
            {
                byte[] buffer = new byte[500];
                //com.read(buffer, 0, buffer.length);
                //com.readBytes(buffer.length);
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
                    s = msgLen.toString().format("X2");
                    msgLen = Integer.parseInt(s);
                    System.out.println("msgLen: " + s);
                }
                if (baos.size() >= msgLen + 5)
                {
                    byte[] msgBytes = baos.toByteArray();
                    System.out.println("Full msg: " + Logger.bytesToHex(msgBytes));
                    if (msgBytes[0] == 6)
                        msgBytes = Arrays.copyOfRange(msgBytes, 1, msgBytes.length);
                    mMessage = msgFactory.build1(msgBytes);
                    //GeneralUtility.ShowInfoMsgBox(mMessage.PaymentInfo.PAN);
                    baos = new ByteArrayOutputStream();
                    msgLen = 0;
                }
            }
            else if (mVType == V_TYPE.JUNCTION)
            {
//                byte[] buffer = new byte[com.BytesToRead];
//                com.Read(buffer, 0, buffer.length);
//            	byte[] buffer = new byte[com.getOutputBufferBytesCount()];
//            	//com.readBytes(buffer.length);
//                System.out.println("Received: " + Logger.bytesToHex(buffer));
//                baos.write(buffer, 0, buffer.length);
//
//                if (msgLen == 0 && buffer.length >= 3)
//                {
//                    byte[] first = baos.toByteArray();
//                    msgLen = (first[1] << 8) | first[2];
//                    System.out.println("msgLen: " + msgLen);
//                }
//
//                // check whether full message is received
//                if (baos.size() >= msgLen + 4)
//                {
//                    byte[] msgBytes = baos.toByteArray();
//                    System.out.println("Full msg: " + Logger.bytesToHex(msgBytes));
//                    mMessage = msgFactory.build(msgBytes);
//                    //JOptionPane.showMessageDialog(null,mMessage.GiftCardsInfoList[0].mamount.toString());
////                    Toast.makeText(getApplicationContext(),
////                    		mMessage.GiftCardsInfoList[0].mamount.toString(), Toast.LENGTH_SHORT)
////    						.show();
//                    baos = new ByteArrayOutputStream();
//                    msgLen = 0;
//                }
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
    }
*/
//    private void setup()
//    {
//        try
//        {
//            LocalDate start = LocalDate.now();
//            
//            
//            if (l_comPath == null)
//            {
//                l_comPath = System.getProperty("user.dir") + "\\COMPORT.txt";    
//            }                
//
//            File f = new File(l_comPath);
//            
//            if (f.exists())
//            {
//                String l_comtext = new String(Files.readAllBytes(Paths.get(l_comPath)), StandardCharsets.UTF_8);
//                if (l_comtext == "" || l_comtext == null)
//                {
//                	//JOptionPane.showMessageDialog(null,"Please setup PORT");
//                	Toast.makeText(getApplicationContext(),
//    						e.getMessage(), Toast.LENGTH_SHORT)
//    						.show();
//                     return;
//                }
//                //com = new SerialPort(l_comPath, 9600, Parity.None, 8, StopBits.One);
//                com = new SerialPort(l_comtext);
//                //com.PortName = l_comtext;
//            }
//            else
//            {
//                String[] portNames = SerialPort.GetPortNames();
//                
//                if (portNames.Length < 1)
//                {
//                	JOptionPane.showMessageDialog(null,"No INSTOR device connected");
//                    return;
//                }
//
//                comPortName = portNames[0];
//                com = new SerialPort(comPortName, 9600, Parity.None, 8, StopBits.One);
//            }
//            if (com.IsOpen) com.Close();
//            // SerialPort.RtsEnable = true; // Request-to-send
//            // SerialPort.DtrEnable = true; // Data-terminal-ready
//            com.ReadTimeout = 150; // tried this, but didn't help
//            com.WriteTimeout = 150; // tried this, but didn't help
//            com.Open();
//
//            com.DataReceived += new SerialDataReceivedEventHandler(com_DataReceived);
//        }
//        catch (Exception e)
//        {
//            System.out.print(e.toString());
//        }   
//    	
//    	
//    }
    
    public void setup(){
//    	try {
//    		String[] portNames = SerialPortList.getPortNames();
//    		if (portNames.length > 1) {
//            	comPortName = portNames[0];
//                //com = new SerialPort(comPortName, 9600, Parity.None, 8, StopBits.One);
//                com = new SerialPort(comPortName);
//                if(com.isOpened()) com.closePort();
//				com.openPort();
//                com.setParams(SerialPort.BAUDRATE_9600,
//                              SerialPort.DATABITS_8,
//                              SerialPort.STOPBITS_1,
//                              SerialPort.PARITY_NONE);
//
//                com.setFlowControlMode(SerialPort.FLOWCONTROL_RTSCTS_IN | 
//                                              SerialPort.FLOWCONTROL_RTSCTS_OUT);
//
//                com.addEventListener(new PortReader(), SerialPort.MASK_RXCHAR);
//                
//                com.writeString("Hurrah!");
//                
//                
//            }
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
    }
    
//    private static class PortReader implements SerialPortEventListener {
//
//        @Override
//        public void serialEvent(SerialPortEvent event) {
////            if(event.isRXCHAR() && event.getEventValue() > 0) {
////                try {
////                    String receivedData = com.readString(event.getEventValue());
////                    System.out.println("Received response: " + receivedData);
////                }
////                catch (SerialPortException ex) {
////                    System.out.println("Error in receiving string from COM-port: " + ex);
////                }
////            }
////        	try{
////                Thread.sleep(1000);
////                if (mVType == V_TYPE.KBZ)
////                {
////                    byte[] buffer = new byte[500];
////                    com.readBytes(buffer.length);
////                    Logger.WriteAYALog("Received: " + Logger.bytesToHex(buffer));
////                    baos.write(buffer, 0, buffer.length);
////                    String s = "";
////                    
////                    if (msgLen == 0 && buffer.length >= 3)
////                    {
////                        byte[] first = baos.toByteArray();
////                        if(first[0] != 6)
////                            msgLen = (first[1] << 8) | first[2];
////                        else
////                        msgLen = (first[2] << 8) | first[3];
////                        s = msgLen.toString().format("X2", "");
////                        msgLen = Integer.parseInt(s);
////                    }
////                    if (baos.size() >= msgLen + 5)
////                    {
////                        byte[] msgBytes = baos.toByteArray();
////                        if (msgBytes[0] == 6)
////                            msgBytes = MITCardCore.Message.Arrays.CopyOfRange(msgBytes, 1, msgBytes.length);
////                        mMessage = msgFactory.build1(msgBytes);
////                        //GeneralUtility.ShowInfoMsgBox(mMessage.PaymentInfo.PAN);
////                        baos = new MemoryStream();
////                        msgLen = 0;
////                    }
////                }
////                else if (mVType == V_TYPE.JUNCTION)
////                {
////                    byte[] buffer = new byte[com.BytesToRead];
////                    com.Read(buffer, 0, buffer.length);
////                    Console.WriteLine("Received: " + Logger.bytesToHex(buffer));
////                    baos.write(buffer, 0, buffer.length);
////
////                    if (msgLen == 0 && buffer.length >= 3)
////                    {
////                        byte[] first = baos.toByteArray();
////                        msgLen = (first[1] << 8) | first[2];
////                        Console.WriteLine("msgLen: " + msgLen);
////                    }
////
////                    // check whether full message is received
////                    if (baos.length >= msgLen + 4)
////                    {
////                        byte[] msgBytes = baos.toByteArray();
////                        Console.WriteLine("Full msg: " + Logger.bytesToHex(msgBytes));
////                        mMessage = msgFactory.build(msgBytes);
////                        GeneralUtility.ShowInfoMsgBox(mMessage.GiftCardsInfoList[0].Amount.ToString());
////                        baos = new MemoryStream();
////                        msgLen = 0;
////                    }
////                }
////                
////                baos = new MemoryStream();
////                msgLen = 0;
////                //Thread.Sleep(3000);
////            }
////            catch (Exception ex)
////            {
////                baos = new MemoryStream();
////                msgLen = 0;
////                Console.WriteLine(ex.toString());
////                Console.Write(ex.StackTrace);
////            }
//        	
//        	try{
//                Thread.sleep(1000);
//                if (mVType == V_TYPE.KBZ)
//                {
//                    byte[] buffer = new byte[500];
//                    //com.read(buffer, 0, buffer.length);
//                    com.readBytes(buffer.length);
//                    Logger.WriteAYALog("Received: " + Logger.bytesToHex(buffer));
//                    baos.write(buffer, 0, buffer.length);
//                    String s = "";
//                    
//                    if (msgLen == 0 && buffer.length >= 3)
//                    {
//                        byte[] first = baos.toByteArray();
//                        if(first[0] != 6)
//                            msgLen = (first[1] << 8) | first[2];
//                        else
//                        msgLen = (first[2] << 8) | first[3];
//                        s = msgLen.toString().format("X2");
//                        msgLen = Integer.parseInt(s);
//                        System.out.println("msgLen: " + s);
//                    }
//                    if (baos.size() >= msgLen + 5)
//                    {
//                        byte[] msgBytes = baos.toByteArray();
//                        System.out.println("Full msg: " + Logger.bytesToHex(msgBytes));
//                        if (msgBytes[0] == 6)
//                            msgBytes = Arrays.copyOfRange(msgBytes, 1, msgBytes.length);
//                        mMessage = msgFactory.build1(msgBytes);
//                        //GeneralUtility.ShowInfoMsgBox(mMessage.PaymentInfo.PAN);
//                        baos = new ByteArrayOutputStream();
//                        msgLen = 0;
//                    }
//                }
//                else if (mVType == V_TYPE.JUNCTION)
//                {
////                    byte[] buffer = new byte[com.BytesToRead];
////                    com.Read(buffer, 0, buffer.length);
//                	byte[] buffer = new byte[com.getOutputBufferBytesCount()];
//                	com.readBytes(buffer.length);
//                    System.out.println("Received: " + Logger.bytesToHex(buffer));
//                    baos.write(buffer, 0, buffer.length);
//
//                    if (msgLen == 0 && buffer.length >= 3)
//                    {
//                        byte[] first = baos.toByteArray();
//                        msgLen = (first[1] << 8) | first[2];
//                        System.out.println("msgLen: " + msgLen);
//                    }
//
//                    // check whether full message is received
//                    if (baos.size() >= msgLen + 4)
//                    {
//                        byte[] msgBytes = baos.toByteArray();
//                        System.out.println("Full msg: " + Logger.bytesToHex(msgBytes));
//                        mMessage = msgFactory.build(msgBytes);
//                        //JOptionPane.showMessageDialog(null,mMessage.GiftCardsInfoList[0].mamount.toString());
////                        Toast.makeText(getApplicationContext(),
////                        		mMessage.GiftCardsInfoList[0].mamount.toString(), Toast.LENGTH_SHORT)
////        						.show();
//                        baos = new ByteArrayOutputStream();
//                        msgLen = 0;
//                    }
//                }
//                
//                baos = new ByteArrayOutputStream();
//                msgLen = 0;
//                //Thread.Sleep(3000);
//            }
//            catch (Exception ex)
//            {
//                baos = new ByteArrayOutputStream();
//                msgLen = 0;
//                System.out.println(ex.toString());
//                System.out.print(ex.getStackTrace());
//            }
//        }
//
//    }
    
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