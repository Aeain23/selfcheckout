package com.example.model;

import java.io.ByteArrayOutputStream;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import com.example.model.Message;

public class SendJPDIndication extends Message
{
    private Integer totalVouchers;
    private Integer totalGiftCards;
    private VoucherInfo[] vouchers;
    private GiftCardInfo[] giftCards;
    
    public SendJPDIndication() { }

    public SendJPDIndication(VoucherInfo[] vouchers, GiftCardInfo[] giftCards) 
    {
    	super(INDICATION,SEND_JP_DETAILS);
        this.totalVouchers = vouchers.length;
        this.vouchers = vouchers;
        this.totalGiftCards = giftCards.length;
        this.giftCards = giftCards;
    }

    @Override
    protected  byte[] voidData()
    {
        byte[] b=new byte[10];
        return b;
    }
    
    @Override
    protected byte[] buildData()
    {
    	ByteArrayOutputStream baos = new ByteArrayOutputStream();

        Logger.writeField(baos, TOTAL_VOUCHERS, totalVouchers.toString(), MM);
        Logger.writeField(baos, TOTAL_GIFT_TRANS, totalGiftCards.toString(), MM);

        for (int i = 0; i < totalVouchers; i++)
        {
            Logger.write2Bytes(baos, VOUCHER_INFO_1 + i);
            Logger.write2Bytes(baos, 0x0000); // length - currently simply write length 0
            Logger.writeString(baos, vouchers[i].mvoucherNumber); // voucher number
            Logger.writeString(baos, vouchers[i].mvoucherName); // voucher name
            Logger.writeString(baos, vouchers[i].mvoucherForm); // voucher form
            Logger.writeString(baos, vouchers[i].mserialNumber); // serial number
            Logger.writeString(baos, vouchers[i].mcurrency); // currency
            Logger.writeString(baos, vouchers[i].mdenomination.toString()); // denomination
            Logger.writeString(baos, vouchers[i].mtype); // type
            baos.write(MM);
        }

        for (int i = 0; i < totalGiftCards; i++)
        {
            Logger.write2Bytes(baos, GIFT_INFO_1 + i);
            Logger.write2Bytes(baos, 0x0000); // length - currently simply write length 0
            Logger.writeString(baos, giftCards[i].mserialNumber); // serial number
            Logger.writeString(baos, giftCards[i].mtransactionRefNum); // transaction ref number
            Logger.writeString(baos, giftCards[i].mcurrency); // currency
            Logger.writeString(baos, giftCards[i].mamount.toString()); // amount
            if (i < totalGiftCards - 1)
            {
                baos.write(MM);
            }
            else
            {
                baos.write(EM);
            }
        }

        return baos.toByteArray();

    }

    @Override
    protected void parseData(byte[] data) throws Exception
    {
        int fieldCode;
        int pos = 0;
        int len;

        // read total vouchers
        fieldCode = (data[pos] << 8) | data[pos + 1];
        pos += 2;
        if (fieldCode != TOTAL_VOUCHERS)
        {
            throw new Exception("Invalid field code for Total Vouchers " + fieldCode);
        }
        len = Logger.byteToInt(data[pos++]);
        totalVouchers = Logger.byteToInt(data[pos++]);
        pos += 1;

        // read total gift card transactions
        fieldCode = (data[pos] << 8) | data[pos + 1];
        pos += 2;
        if (fieldCode != TOTAL_GIFT_TRANS)
        {
            throw new Exception("Invalid field code for Total Gift Card Transactions " + fieldCode);
        }
        len = Logger.byteToInt(data[pos++]);
        totalGiftCards = Logger.byteToInt(data[pos++]);
        pos += 1;

        // read vouchers
        vouchers = new VoucherInfo[totalVouchers];
        for (int i = 0; i < totalVouchers; i++)
        {
            vouchers[i] = new VoucherInfo();

            pos += 2; // skip Field Code for Voucher Info #x
            len = (data[pos] << 8) | data[pos + 1];
            pos += 2;

            // voucher number
            len = Logger.byteToInt(data[pos++]);
            vouchers[i].mvoucherNumber = new String(Arrays.copyOfRange(data, pos, pos + len), StandardCharsets.UTF_8);
            pos += len;

            // voucher name
            len = Logger.byteToInt(data[pos++]);
            vouchers[i].mvoucherName = new String(Arrays.copyOfRange(data, pos, pos + len), StandardCharsets.UTF_8);
            pos += len;

            // voucher form
            len = Logger.byteToInt(data[pos++]);
            vouchers[i].mvoucherForm = new String(Arrays.copyOfRange(data, pos, pos + len), StandardCharsets.UTF_8);
            pos += len;

            // serial number
            len = Logger.byteToInt(data[pos++]);
            vouchers[i].mserialNumber = new String(Arrays.copyOfRange(data, pos, pos + len), StandardCharsets.UTF_8);
            pos += len;

            // currency
            len = Logger.byteToInt(data[pos++]);
            vouchers[i].mcurrency = new String(Arrays.copyOfRange(data, pos, pos + len), StandardCharsets.UTF_8);
            pos += len;

            // denomination
            len = Logger.byteToInt(data[pos++]);
            vouchers[i].mdenomination = Double.parseDouble(new String(Arrays.copyOfRange(data, pos, pos + len), StandardCharsets.UTF_8));
            pos += len;

            // type
            len = Logger.byteToInt(data[pos++]);
            vouchers[i].mtype = new String(Arrays.copyOfRange(data, pos, pos + len), StandardCharsets.UTF_8);
            pos += len;

            pos++; // skip end of message
        }

        // read gift cards
        giftCards = new GiftCardInfo[totalGiftCards];
        for (int i = 0; i < totalGiftCards; i++)
        {
            giftCards[i] = new GiftCardInfo();

            pos += 2; // skip Field Code for Voucher Info #x
            len = (data[pos] << 8) | data[pos + 1];
            pos += 2;

            // serial number
            len = Logger.byteToInt(data[pos++]);
            giftCards[i].mserialNumber = new String(Arrays.copyOfRange(data, pos, pos + len), StandardCharsets.UTF_8);
            pos += len;

            // transaction ref num
            len = Logger.byteToInt(data[pos++]);
            giftCards[i].mtransactionRefNum = new String(Arrays.copyOfRange(data, pos, pos + len), StandardCharsets.UTF_8);
            pos += len;

            // currency
            len = Logger.byteToInt(data[pos++]);
            giftCards[i].mcurrency = new String(Arrays.copyOfRange(data, pos, pos + len), StandardCharsets.UTF_8);
            pos += len;

            // amount
            len = Logger.byteToInt(data[pos++]);
            giftCards[i].mamount = Double.parseDouble(new String(Arrays.copyOfRange(data, pos, pos + len), StandardCharsets.UTF_8));
            pos += len;

            pos++; // skip end of message
        }

        VoucherInfoList = vouchers;
        GiftCardsInfoList = giftCards;            
    }

    public double getVouchers()
    {
        double sum = 0;
        for (int i = 0; i < totalVouchers; i++)
        {
            sum += vouchers[i].mdenomination;
        }
        return sum;
    }

    /** Returns sum of the gift cards */
    public double getGiftCard()
    {
        double sum = 0;
        for (int i = 0; i < totalGiftCards; i++)
        {
            sum += giftCards[i].mamount;
        }
        return sum;
    }

    public String toString()
    {
        return "SendJPDIndication{" + "totalVouchers=" + getVouchers() + ", totalGiftCards=" + getGiftCard() +
                ", vouchers=" + vouchers.toString() + ", giftCard=" + giftCards.toString() + ", " +
                super.toString() + '}';
    }
}