package com.example.model;

public class GiftCardInfo
{
    public GiftCardInfo()
    {
        ClearProperty();
    }
    
    public int mday;
    public String mserialNumber;
    public String mtransactionRefNum;
    public String mcurrency;
    public Double mamount;
    
    public void ClearProperty()
    {
        mday = 0;
        mserialNumber = "";
        mtransactionRefNum = "";
        mcurrency = "";
        mamount = 0.0;
    }
}
