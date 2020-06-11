package com.example.model;

public class KBZPaymentInfo
{
    public KBZPaymentInfo()
    {
        ClearProperty();
    }
    
    public String mRespCode;
    public String mPAN;
    public String mSTAN;
    public String mApprovalCode;
    public String mAccountNo;
    public String mExpDate;
    public String mTime;
    public String mDate;
    public double mAmount;
    public String mRRN;
    public String mPOSEntry;
    public String mTerminalID;
    public String mMerchantID;
    public String mInvoiceNo;
    public String mCurrencyCode;
    public String mCardType;
    
    public void ClearProperty()
    {
        setmRespCode("");
        mRespCode = "";
        mPAN = "";
        mSTAN = "";
        mApprovalCode = "";
        mAccountNo = "";
        mExpDate = "";
        mTime = "";
        mDate = "";
        mAmount = 0;
        mRRN = "";
        mPOSEntry = "";
        mTerminalID = "";
        mMerchantID = "";
        mInvoiceNo = "";
        mCurrencyCode = "";
        mCardType = "";
    }

	public String getmRespCode() {
		return mRespCode;
	}

	public void setmRespCode(String mRespCode) {
		this.mRespCode = mRespCode;
	}
}
