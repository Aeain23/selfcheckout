package com.example.model;


import java.io.ByteArrayOutputStream;
import java.io.Console;
import java.util.Arrays;

import com.example.self_check_out.MainActivity;
// extends MainActivity
public abstract class Message extends MainActivity{
	public enum CardType{
		VISA, 
		MASTER,
        JCB,
        MPU,
        CUP
	}
	
	public static final  int STX = 0xAA; // start of text
    public static final  int ETX = 0xFF; // end of text
    
    public static final  int JUNCTION_PAYMENT = 0x00; // junction payment
    public static final  int JUNCTION_MEMBER = 0x01; // junction member
    
    // End of message
    public static final  int MM = 0x00; // more message
    public static final  int EM = 0x01; // end of message
    
    // Function type
    public static final  int REQUEST = 0x01; // request
    public static final  int RESPONSE = 0x02; // response
    public static final  int INDICATION = 0x03; // indication
    public static final  int CONFIRM = 0x04; // return message of Indication
    // Function code
    public static final  int START_SESSION = 0x01; // start session
    public static final  int SEND_JP_DETAILS = 0x02; // send junction payment details
    public static final  int GET_TRANS_HISTORY = 0x03; // get transaction history
    
    // Field code
    public static final  int RESULT = 0x0000; // result
    public static final  int DEVICE_ID = 0x0001; // device ID
    public static final  int MODE = 0x0002; // mode
    public static final  int CASHIER_ID = 0x0003; // cashier ID
    public static final  int TRANS_HISTORY = 0x0004; // get transaction history
    public static final  int INIT_BILL_AMT = 0x0005; // initial billing amount
    public static final  int RECEIPT_NUMBER = 0x0006; // receipt number
    public static final  int FINAL_BILL_AMT = 0x0007; // static final billing amount
    public static final  int TOTAL_VOUCHERS = 0x0008; // total vouchers
    public static final  int TOTAL_GIFT_TRANS = 0x0009; // total gift card transactions
    public static final  int DAYS_TRANS_HISTORY = 0x000A; // days of transaction history
    public static final  int VOUCHER_INFO_1 = 0x8001; // voucher info #1
    public static final  int VOUCHER_INFO_2 = 0x8002; // voucher info #2
    public static final  int VOUCHER_INFO_3 = 0x8003; // voucher info #3
    public static final  int GIFT_INFO_1 = 0xC001; // gift card info #1
    public static final  int GIFT_INFO_2 = 0xC002; // gift card info #2
    public static final  int GIFT_INFO_3 = 0xC003; // gift card info #3
    public static final int STX1 = 0x02;
    public static final int LLLL = 0x00;
    public static final int MSG_LENGTH = 0x21;
    public static final int VERSION = 0x01;
    public static final int MSG_BODY = 0x03;
    public static final int AMOUNT = 0x04;
    public static final int ETX1 = 0x03;
    public static final int VMSG_BODY = 0x04; // For void message
    public static final int VMSG_LENGTH = 0x13;// For void message length
    public static final int INV_NO = 0x62; //For void message
    public static final int CARD_TYPE = 0x15; //For void message

    public int stx;
    public Integer len;
    public int functionType;
    public int functionCode;
    public int etx;
    public int lrc;
    public int lrc1;

    public String DeviceID;  
    public int Result;
    public KBZPaymentInfo PaymentInfo;
    public VoucherInfo[] VoucherInfoList;
    public GiftCardInfo[] GiftCardsInfoList;
    public double InitialBillingAmount;
    
    private String Invoice_No;
    private String Card_Type;
    
    public Message() { }

    public Message(int functionType, int functionCode){
        this.stx = STX;
        this.functionType = functionType;
        this.functionCode = functionCode;
        this.etx = ETX;
    }

    public byte[] buildMessage(){
        // build header, data, and ETX
    	ByteArrayOutputStream  baos = new ByteArrayOutputStream();

        baos.write((byte)functionType);
        baos.write((byte)functionCode);
        baos.write(MM);
        
        byte[] data = buildData();
        baos.write(data, 0, data.length);

        baos.write(ETX);

        data = baos.toByteArray();
        
        baos = new ByteArrayOutputStream();
        baos.write(STX);
        int len = data.length - 1;
        baos.write((byte)(len >> 8));
        baos.write((byte)(len & 0xFF));
        baos.write(data, 0, data.length);

        lrc = Logger.computeLRC(data);
        baos.write((byte)lrc);

        return baos.toByteArray();
    }
    
    public byte[] buildMessage1(){
        // build header, data, and ETX
    	ByteArrayOutputStream baos = new ByteArrayOutputStream();
    	
        baos.write(STX1);
        baos.write(LLLL);
        baos.write(MSG_LENGTH);
        baos.write(VERSION);
        baos.write(MSG_BODY);
        byte[] data = buildData();
        byte s = Logger.calcLRC1(data);
                 
        baos.write(data, 0, data.length);
        baos.write(ETX1);
        baos.write(s);
        return baos.toByteArray();
    }
    
    public byte[] voidMessage(){
    	ByteArrayOutputStream baos = new ByteArrayOutputStream();
        
        baos.write(STX1);
        baos.write(LLLL);
        baos.write(VMSG_LENGTH);
        baos.write(VERSION);
        baos.write(VMSG_BODY);

        byte[] data = voidData();
        baos.write(data, 0, data.length);
        baos.write(ETX1);
                    
        byte v = Logger.calcLRC1(data);

        baos.write(v);
        return baos.toByteArray();
    }
    
    protected abstract byte[] buildData();

    protected abstract byte[] voidData();
    
    public void readMessage(byte[] msg) throws Exception{
        this.stx = Logger.byteToInt(msg[0]);
        if (this.stx != STX)
        {
            throw new Exception("Incorrect STX " + this.stx);
        }

        this.len = (msg[1] << 8) | msg[2];
        this.functionType = msg[3];
        this.functionCode = msg[4];
        this.etx = Logger.byteToInt(msg[len + 3]);
        if (this.etx != ETX)
        {
            throw new Exception("Incorrect ETX " + this.etx);
        }

        this.lrc = Logger.byteToInt(msg[len + 4]); // read LRC
        byte[] data = Arrays.copyOfRange(msg, 3, msg.length - 1);
        if (this.lrc != Logger.computeLRC(data))
        {
            throw new Exception("Incorrect LRC, expected " + this.lrc);
        }
        data = Arrays.copyOfRange(msg, 6, msg.length - 1); // crop function type and mode and MM
        System.out.print(Logger.bytesToHex(data));
        parseData(data);
    }
    
    public void readMessage1(byte[] msg) throws Exception{
    	
        this.stx = Logger.byteToInt(msg[0]);
    
        if (this.stx != STX1)
        {
        	
            throw new Exception("Incorrect STX " + this.stx);            
        }

        this.len = (msg[1] << 8) | msg[2];
        
        String s = toHexString1(this.len);

        this.len = Integer.parseInt(s);
       
        this.etx = Logger.byteToInt(msg[len + 3]);

        if (this.etx != ETX1)
        {
        	
            throw new Exception("Incorrect ETX " + this.etx);            
        }

        this.lrc = Logger.byteToInt(msg[len + 4]); // read LRC
       
        byte[] data = Arrays.copyOfRange(msg, 1, msg.length - 2);
       
        byte l = Logger.calcLRC1(data);
      
        if (data.length > 18)
        {
            if (this.lrc != l)
            {
            	
                throw new Exception("Incorrect LRC, expected " + this.lrc);
            }
        }

        data = Arrays.copyOfRange(msg, 5, msg.length - 2); // crop function type and mode and MM
        System.out.print(Logger.bytesToHex(data));
        
        parseData(data);
    }
    
    protected abstract void parseData(byte[] data) throws Exception;

    @Override
    public String toString()
    {
        return "stx=" + stx + ", len=" + len + ", functionType=" + functionType + ", functionCode=" + functionCode + ", etx=" + etx + ", lrc=" + lrc;
    }
}
