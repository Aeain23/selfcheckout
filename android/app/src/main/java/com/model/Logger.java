package com.example.model;


import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.nio.charset.StandardCharsets;

public class Logger
{
	public static Boolean mIsVoid = false;
    public static void WriteLog(String aData)
    {
        String pathfolder = System.getProperty("user.dir") + "\\Cardlog";
        try { 
	        File file = new File(pathfolder);
	        if (!file.exists())
	        {
	            file.createNewFile();               
	            WriteLogData(aData);
	        }
	        else
	        {
	
	            WriteLogData(aData);
	        }
    	}catch (IOException e) {
			// TODO Auto-generated catch block
		}
    }
    
    public static void WriteAYALog(String aData)
    {

        String pathfolder = System.getProperty("user.dir") + "\\AYACardlog";
        try { 
	        File file = new File(pathfolder);
	        if (!file.exists())
	        {
	            file.createNewFile();               
	            WriteAYALogData(aData);
	        }
	        else
	        {
	        	WriteAYALogData(aData);  
	        }
        }catch (IOException e) {
			// TODO Auto-generated catch block
		}
    }
    
    private static void WriteLogData(String aData)
    {
        String path = System.getProperty("user.dir") + "\\Cardlog\\Cardtrace.log";
        try { 
        	File file = new File(path);
	        if (!file.exists())
	        {
	        	file.createNewFile();
				
	            //GC.Collect();
	            //GC.WaitForPendingFinalizers();
	
	            OutputStream outputStream = new FileOutputStream(path);      
	            Writer tw = new OutputStreamWriter(outputStream);  
	            tw.write("The very first line!");
	            tw.write(aData);
	            tw.close();
	        }
	        else if (file.exists())
	        {
	        	OutputStream outputStream = new FileOutputStream(path);      
	            Writer tw = new OutputStreamWriter(outputStream);  
	            tw.append(aData);
	            tw.close();
	        }
        } catch (IOException e) {
			// TODO Auto-generated catch block
		}
    }
    
    private static void WriteAYALogData(String aData)
    {
        String path = System.getProperty("user.dir") + "\\AYACardlog\\AYACardtrace.log";
        File file = new File(path);
        try { 
	        if (!file.exists())
	        {
	            file.createNewFile();
	            //GC.Collect();
	            //GC.WaitForPendingFinalizers();
	
	            OutputStream outputStream = new FileOutputStream(path);      
	            Writer tw = new OutputStreamWriter(outputStream);  
	            tw.write("The very first line!");
	            tw.write(aData);
	            tw.close();
	        }
	        else if (file.exists())
	        {
	        	OutputStream outputStream = new FileOutputStream(path);      
	            Writer tw = new OutputStreamWriter(outputStream);  
	            tw.append(aData);
	            tw.close();
	        }
        } catch (IOException e) {
			// TODO Auto-generated catch block
		}
    }
    
    public static int computeLRC(byte[] data)
    {
        int lrc = 0;
        for (int i = 0; i < data.length; i++)
        {
            lrc = (lrc + data[i]) & 0xFF;
        }
        lrc = (((lrc ^ 0xFF) + 1) & 0xFF);
        return lrc;
    }
    
    public static String calcLRC(byte[] data)
    {
//        byte b = 0x00;
//        for (int i = 0; i < data.length; i++)
//        {
//            b = (byte)(((b ^ data[i]) + 1) & 0xFF);                              
//        }
//        String hex = "0x" + b.toString("X2");

    	String hex = toHexString(data);
        return hex;
    }
    
    public static String toHexString(byte[] buffer) {
		String bufferString = "";
		for (int i = 0; i < buffer.length; i++) {

			String hexChar = Integer.toHexString(buffer[i] & 0xFF);
			if (hexChar.length() == 1) {
				hexChar = "0" + hexChar;
			}
			bufferString += hexChar.toUpperCase();
		}
		return bufferString;
	}
	
    
    public static byte calcLRC1(byte[] data)
    {
        int lrc = 0;
        for (int i = 0; i < data.length; i++)
        {
            lrc = lrc ^ data[i];
        }
        char c = (char)lrc;
        return (byte)lrc;
    }

    protected static char[] hexArray = "0123456789ABCDEF".toCharArray();
    
    public static String bytesToHex(byte[] bytes)
    {
        char[] hexChars = new char[bytes.length * 2];
        for (int j = 0; j < bytes.length; j++)
        {
            int v = bytes[j] & 0xFF;
            hexChars[j * 2] = hexArray[(int)(v >> 4)];
            hexChars[j * 2 + 1] = hexArray[v & 0x0F];
        }
        return new String(hexChars);
    }
    
    public static int byteToInt(byte b)
    {
        return b & 0xFF;
    }
    
    public static void writeString(ByteArrayOutputStream baos, String value)
    {
        baos.write((byte)value.length());
        byte[] v = value.getBytes(StandardCharsets.US_ASCII); //Encoding.ASCII.GetBytes(value);
        baos.write(v,0,v.length);
    }
    
    public static void write2Bytes(ByteArrayOutputStream baos, int twoBytes)
    {
        baos.write((byte)(twoBytes >> 8));
        baos.write((byte)(twoBytes & 0xFF));
    }
    
    public static void writeField(ByteArrayOutputStream baos, int twoByteFieldCode, String value, int em)
    {
        baos.write((byte)(twoByteFieldCode >> 8));
        baos.write((byte)(twoByteFieldCode & 0xFF));
        baos.write((byte)(value.length()));
        if (value.length() > 1)
        {
            byte[] v = value.getBytes(StandardCharsets.US_ASCII); //Encoding.ASCII.GetBytes(value);
            baos.write(v, 0, v.length);
        } else
			try {
				baos.write(value.getBytes());
			} catch (IOException e) {
				// TODO Auto-generated catch block
				
		}
        baos.write((byte)(em));
    }
    
    public static void writeHex(ByteArrayOutputStream baos,int twoByteFieldCode, String value)
    {      
        baos.write((byte)(twoByteFieldCode));
        baos.write((byte)(value.length()));
        if (value.length() > 1)
        {
            byte[] v = value.getBytes(StandardCharsets.US_ASCII); //Encoding.ASCII.GetBytes(value);
            baos.write(v, 0, v.length);
        } else
			try {
				baos.write(value.getBytes());
			} catch (IOException e) {
				// TODO Auto-generated catch block
				
		}
    }
}
