package com.example.model;

import java.io.ByteArrayOutputStream;
import java.util.Arrays;
import com.example.model.Message;

public class SendJPDConfirm extends Message
{
    private Integer result;
    private double finalBillingAmount;
    private String receiptNumber;

    public SendJPDConfirm() { }

    public SendJPDConfirm(int result, double finalBillingAmount, String receiptNumber)
    {
    	super(CONFIRM, SEND_JP_DETAILS);
        this.result = result;
        this.finalBillingAmount = finalBillingAmount;
        this.receiptNumber = receiptNumber;
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

        Logger.writeField(baos, RESULT, result.toString(), MM);
        Logger.writeField(baos, FINAL_BILL_AMT, "" + finalBillingAmount, MM);
        Logger.writeField(baos, RECEIPT_NUMBER, receiptNumber, EM);

        return baos.toByteArray();
    }
    
    @Override
    protected void parseData(byte[] data) throws Exception
    {
        int fieldCode;
        int pos = 0;
        int len;

        // read result
        fieldCode = (data[pos] << 8) | data[pos + 1];
        pos += 2;
        if (fieldCode != RESULT)
        {
            throw new Exception("Invalid field code for Result " + fieldCode);
        }
        len = Logger.byteToInt(data[pos++]);
        result = Logger.byteToInt(data[pos++]);
        pos += 1;

        // read final billing amount
        fieldCode = (data[pos] << 8) | data[pos + 1];
        pos += 2;
        if (fieldCode != FINAL_BILL_AMT)
        {
            throw new Exception("Invalid field code for Final Billing Amount " + fieldCode);
        }
        len = Logger.byteToInt(data[pos++]);
        finalBillingAmount = Double.parseDouble(new String(Arrays.copyOfRange(data, pos, pos + len),"UTF-8"));
        pos += len + 1;

        // read receipt number
        fieldCode = (data[pos] << 8) | data[pos + 1];
        pos += 2;
        if (fieldCode != RECEIPT_NUMBER)
        {
            throw new Exception("Invalid field code for Receipt Number " + fieldCode);
        }
        len = Logger.byteToInt(data[pos++]);
        receiptNumber = new String(Arrays.copyOfRange(data, pos, pos + len),"UTF-8").toString();
        Result = result;
    }
}
