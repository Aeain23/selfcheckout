package com.example.model;

import java.io.ByteArrayOutputStream;
import java.util.Arrays;

public class StartSessionResponse extends Message {
	private String deviceID;
    private Integer result;

    public StartSessionResponse() { }

    public StartSessionResponse(String deviceID, int result)
    {
    	super(Message.RESPONSE, Message.START_SESSION);
        this.deviceID = deviceID;
        this.result = result;
    }
    
    @Override
    protected byte[] voidData()
    {
        byte[] b = new byte[10];
        return b;
    }

    @Override
    protected byte[] buildData()
    {
    	ByteArrayOutputStream baos = new ByteArrayOutputStream();

        Logger.writeField(baos, DEVICE_ID, deviceID, MM);
        Logger.writeField(baos, RESULT, result.toString(), EM);

        return baos.toByteArray();
    }

    @Override
    protected void parseData(byte[] data) throws Exception
    {
        int fieldCode;
        int pos = 0;
        int len;

        // read device ID
        fieldCode = (data[pos] << 8) | data[pos + 1];
        pos += 2;
        if (fieldCode != DEVICE_ID)
        {
            throw new Exception("Invalid field code for Device ID " + fieldCode);
        }
        len = Logger.byteToInt(data[pos++]);
        deviceID = new String(Arrays.copyOfRange(data, pos, pos + len),"UTF-8");
        pos += len + 1;

        // read result
        fieldCode = (data[pos] << 8) | data[pos + 1];
        pos += 2;
        if (fieldCode != RESULT)
        {
            throw new Exception("Invalid field code for Result " + fieldCode);
        }
        result = Logger.byteToInt(data[pos + 1]);
        Result = result;
        DeviceID = deviceID;
    }

    public String getDeviceID() {
    return deviceID;
    }

    public int getResult() {
        return result;
    }

    @Override
    public String toString()
    {
        return "StartSessionResponse{" + "deviceID=" + deviceID + ", result=" + result + ", " + super.toString() + '}';
    }
}
