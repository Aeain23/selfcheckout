package com.example.model;

import java.io.ByteArrayOutputStream;
import java.util.Arrays;
import com.example.model.Message;

public class POSMsg extends Message
{
    public static String rst;
    public byte[] MMK = new byte[] { 0x31, 0x30, 0x34 };
    public byte[] USD = new byte[] { 0x38, 0x34, 0x30 };
    public final int CURRENCY = 0x49;
    public final int CLENGHT = 0x03;
    private KBZPaymentInfo mPInfo;
    
    public POSMsg() { }
    
    public POSMsg(Boolean mIsVoid, String mInvNo, String mCType)
    {
    	super();
        Logger.mIsVoid = mIsVoid;
        this.InvNo = mInvNo;
        this.mCType = mCType;
    }
    public POSMsg(Boolean mCTYPE,String initialBillingAmount)
    {
    	super();
        this.CTYPE = mCTYPE;
        this.initialBillingAmount = initialBillingAmount;
    }
    
    public String initialBillingAmount;
    private int lrc;
    private Boolean CTYPE;
    private String InvNo;
    private String mCType;

    @Override
    protected byte[] buildData()
    {
    	ByteArrayOutputStream baos = new ByteArrayOutputStream();

        Logger.writeHex(baos, AMOUNT, initialBillingAmount);
        baos.write(CURRENCY);
        baos.write(CLENGHT);
        if (CTYPE)
        {
            for (int i = 0; i < MMK.length; i++)
                baos.write(MMK[i]);
        }
        else
        {
            for (int i = 0; i < USD.length; i++)
                baos.write(USD[i]);
        }
        return baos.toByteArray();
    }

    @Override
    protected byte[] voidData()
    {
    	ByteArrayOutputStream baos = new ByteArrayOutputStream();

        if (InvNo != "")
        {                
            Logger.writeHex(baos, INV_NO, InvNo);
            Logger.writeHex(baos, CARD_TYPE, mCType);
        }
        return baos.toByteArray();
    }

    @Override
    protected void parseData(byte[] data)
    {
        int fieldCode;
        int pos = 1;
        int len;
        mPInfo = new KBZPaymentInfo();
        len = Logger.byteToInt(data[pos++]);
        if (data.length > 18)//Condition for Cancle Message
        {
            
        	try{

	            mPInfo.mAmount = Double.parseDouble(new String(Arrays.copyOfRange(data, pos, pos + len),"UTF-8").replace("\0", ""));
	            pos += len + 1;
	            len = Logger.byteToInt(data[pos++]);
	
	            mPInfo.mRespCode += new String(Arrays.copyOfRange(data, pos, pos + len),"UTF-8").replace("\0", "");
	            pos += len + 1;
	            len = Logger.byteToInt(data[pos++]);
	
	            mPInfo.mPAN += new String(Arrays.copyOfRange(data, pos, pos + len),"UTF-8").replace("\0", "");
	            pos += len + 1;
	            len = Logger.byteToInt(data[pos++]);
	
	            mPInfo.mExpDate += new String(Arrays.copyOfRange(data, pos, pos + len),"UTF-8").replace("\0", "");
	            pos += len + 1;
	            len = Logger.byteToInt(data[pos++]);
	
	            mPInfo.mSTAN += new String(Arrays.copyOfRange(data, pos, pos + len),"UTF-8").replace("\0", "");
	            pos += len + 1;
	            len = Logger.byteToInt(data[pos++]);
	
	            mPInfo.mTime += new String(Arrays.copyOfRange(data, pos, pos + len),"UTF-8").replace("\0", "");
	            pos += len + 1;
	            len = Logger.byteToInt(data[pos++]);
	
	            mPInfo.mDate += new String(Arrays.copyOfRange(data, pos, pos + len),"UTF-8").replace("\0", "");
	            pos += len + 1;
	            len = Logger.byteToInt(data[pos++]);
	
	            mPInfo.mApprovalCode += new String(Arrays.copyOfRange(data, pos, pos + len),"UTF-8").replace("\0", "");
	            pos += len + 1;
	            len = Logger.byteToInt(data[pos++]);
	
	            mPInfo.mRRN += new String(Arrays.copyOfRange(data, pos, pos + len),"UTF-8").replace("\0", "");
	            pos += len + 1;
	            len = Logger.byteToInt(data[pos++]);
	
	            mPInfo.mPOSEntry += new String(Arrays.copyOfRange(data, pos, pos + len),"UTF-8").replace("\0", "");
	            pos += len + 1;
	            len = Logger.byteToInt(data[pos++]);
	
	            mPInfo.mTerminalID += new String(Arrays.copyOfRange(data, pos, pos + len),"UTF-8").replace("\0", "");
	            pos += len + 1;
	            len = Logger.byteToInt(data[pos++]);
	
	            mPInfo.mMerchantID += new String(Arrays.copyOfRange(data, pos, pos + len),"UTF-8").replace("\0", "");
	            pos += len + 1;
	            len = Logger.byteToInt(data[pos++]);
	            if (!Logger.mIsVoid)
	            {
	                mPInfo.mInvoiceNo += new String(Arrays.copyOfRange(data, pos, pos + len),"UTF-8").replace("\0", "");
	                pos += len + 1;
	                len = Logger.byteToInt(data[pos++]);
	
	                byte[] s = Arrays.copyOfRange(data, pos, pos + len);
	
	                // mPInfo.mCardType += Byte.toString(s[0]).format("00");
                    mPInfo.mCardType = Byte.toString(s[0]).format("%02d", s[0]);
	                pos += len + 1;
	                len = Logger.byteToInt(data[pos++]);
	            }
	            mPInfo.mCurrencyCode += new String(Arrays.copyOfRange(data, pos, pos + len),"UTF-8").replace("\0", "");
	
	            PaymentInfo = mPInfo;
	            if (Logger.mIsVoid)
	                Logger.mIsVoid = false;
        	}
        	catch (Exception e)
        	{
        		
        	
        	}
        }
        else
        {
            PaymentInfo = null;
        }
    }
}