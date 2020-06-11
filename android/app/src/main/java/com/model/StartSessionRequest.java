package com.example.model;

import java.io.ByteArrayOutputStream;
import java.util.Arrays;

public class StartSessionRequest extends Message
{
    private Integer mode;
    private String cashierID;
    private Double initialBillingAmount;
    private String receiptNumber;

    public StartSessionRequest() { }

    public StartSessionRequest(Boolean junctionPayment, String cashierID, double initialBillingAmount,
            String receiptNumber) 
    {
    	super(Message.REQUEST,Message.START_SESSION);
    	
        if (junctionPayment)
        {
            mode = JUNCTION_PAYMENT;
        }
        else
        {
            mode = JUNCTION_MEMBER;
        }

        this.cashierID = cashierID;
        this.initialBillingAmount = initialBillingAmount;
        this.receiptNumber = receiptNumber;
    }
    
    @Override
    protected byte[] buildData()
    {
    	ByteArrayOutputStream baos = new ByteArrayOutputStream();

        Logger.writeField(baos, MODE, mode.toString(), MM);
        Logger.writeField(baos, CASHIER_ID, cashierID, MM);
        Logger.writeField(baos, INIT_BILL_AMT, initialBillingAmount.toString(), MM);
        Logger.writeField(baos, RECEIPT_NUMBER, receiptNumber, EM);
        return baos.toByteArray();
    }

    @Override
    protected byte[] voidData()
    {
        byte[] b = new byte[10];
        return b;
    }

    @Override
    protected void parseData(byte[] data) throws Exception
    {
        int fieldCode;
        int pos = 0;
        int len;
        
        // read mode
        fieldCode = (data[pos] << 8) | data[pos + 1];        
        pos += 2;
        if (fieldCode != MODE) {
        	throw new Exception("Invalid field code for Mode " + fieldCode);
        }
        len = Logger.byteToInt(data[pos++]);
        mode = Logger.byteToInt(data[pos++]);
        //System.out.println("mode: " + mode);
        pos += 1;

        // read cashier ID
        fieldCode = (data[pos] << 8) | data[pos + 1];   
        pos += 2;
        if (fieldCode != CASHIER_ID) {
            throw new Exception("Invalid field code for Cashier ID " + fieldCode);
        }
        len = Logger.byteToInt(data[pos++]);
        cashierID = new String(Arrays.copyOfRange(data, pos, pos + len),"UTF-8");
        //System.out.println("cashierID: " + cashierID);
        pos += len + 1;
        
        // read initial billing amount
        fieldCode = (data[pos] << 8) | data[pos + 1];   
        pos += 2;
        if (fieldCode != INIT_BILL_AMT) {
            throw new Exception("Invalid field code for Initial Billing Amount " + fieldCode);
        }
        len = Logger.byteToInt(data[pos++]);
        String initialBillingAmountStr = new String(Arrays.copyOfRange(data, pos, pos + len),"UTF-8");
        initialBillingAmount = Double.parseDouble(initialBillingAmountStr);
        //System.out.println("initialBillingAmount: " + initialBillingAmount);
        pos += len + 1;
        
        // read receipt number
        fieldCode = (data[pos] << 8) | data[pos + 1];   
        pos += 2;
        if (fieldCode != RECEIPT_NUMBER) {
            throw new Exception("Invalid field code for Receipt Number " + fieldCode);
        }
        len = Logger.byteToInt(data[pos++]);
        receiptNumber = new String(Arrays.copyOfRange(data, pos, pos + len),"UTF-8");

        //System.out.println("receiptNumber: " + receiptNumber);
    }
    
    @Override
    public String toString()
    {
        return "StartSessionRequest{" + "mode=" + mode + ", cashierID=" + cashierID + ", initialBillingAmount=" + initialBillingAmount +
            ", receiptNumber=" + receiptNumber + ", " + super.toString() + '}';
    }
}