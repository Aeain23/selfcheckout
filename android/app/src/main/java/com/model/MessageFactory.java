package com.example.model;

public class MessageFactory {
	//JAVA TO C# CONVERTER WARNING: Method 'throws' clauses are not available in .NET:
    //ORIGINAL LINE: public Message build(byte[] msgBytes) throws MessageException
    public Message build(byte[] msgBytes)
    {
        Message msg = null;
        int functionType = Logger.byteToInt(msgBytes[3]);
        int functionCode = Logger.byteToInt(msgBytes[4]);

        try{
	        switch (functionType)
	        {
	            case Message.REQUEST:
	                if (functionCode == Message.START_SESSION)
	                {
	                    msg = new StartSessionRequest();
	                    msg.readMessage(msgBytes);
	                }
	                break;
	            case Message.RESPONSE:
	                if (functionCode == Message.START_SESSION)
	                {
	                    msg = new StartSessionResponse();
	                    msg.readMessage(msgBytes);
	                }
	                break;
	            case Message.INDICATION:
	                if (functionCode == Message.SEND_JP_DETAILS)
	                {
	                    Double amount = 0.0;
	                    msg = new SendJPDIndication();
	                    msg.readMessage(msgBytes);
	                    for (VoucherInfo v : msg.VoucherInfoList)
	                    {
	                    	amount += v.mdenomination;
	                    }
	                }
	                else if (functionCode == Message.CONFIRM)
	                {
	                    msg = new SendJPDConfirm();
	                    msg.readMessage(msgBytes);
	                }
	                break;
	            case Message.CONFIRM:
	                if (functionCode == Message.SEND_JP_DETAILS)
	                {
	                    msg = new SendJPDConfirm();
	                    msg.readMessage(msgBytes);
	                }
	                //else if (functionCode == Message.GET_TRANS_HISTORY)
	                //{
	                //    msg = new GetTransHisConfirm();
	                //    msg.readMessage(msgBytes);
	                //}
	                break;
	            default:
	                break;
	        }
        }
        catch(Exception e)
        {
        	
        }
        return msg;
    }
    public Message build1(byte[] msgBytes)
    {
    	Message msg = null;
    	try{
	        msg = new POSMsg();
	        msg.readMessage1(msgBytes);
    	}
    	catch(Exception e)
    	{
    		return null;
    	}
        return msg;
    }
}
