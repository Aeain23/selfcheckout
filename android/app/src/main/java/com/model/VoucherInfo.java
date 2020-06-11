package com.example.model;

public class VoucherInfo
{
    public VoucherInfo()
    {
        ClearProperty();
    }
    
    public int mday;
    public String mvoucherNumber;
    public String mvoucherName;
    public String mvoucherForm;
    public String mserialNumber;
    public String mcurrency;
    public Double mdenomination;
    public String mtype;
    
    public void ClearProperty()
    {
        mday = 0;
        mvoucherNumber = "";
        mvoucherName = "";
        mvoucherForm = "";
        mserialNumber = "";
        mcurrency = "";
        mdenomination = 0.0;
        mtype = "";
    }
}