package com.example.model;

public class TerminalResultMessage {
	public int stx;
    public int len;
    public int etx;
    // public KBZPaymentInfo paymentInfo;
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
    
    public TerminalResultMessage(){
    	this.stx = 0;
    	this.len = 0;
    	this.etx = 0;
		this.mRespCode="";
		this.mPAN="";
		this.mSTAN="";
		this.mApprovalCode = "";
        this.mAccountNo = "";
        this.mExpDate = "";
        this.mTime = "";
        this.mAmount = 0;
        this.mRRN = "";
        this.mDate = "";
        this.mPOSEntry = "";
        this.mTerminalID = "";
        this.mMerchantID = "";
        this.mInvoiceNo = "";
        this.mCurrencyCode = "";
        this.mCardType = "";
		

    	// this.paymentInfo = new KBZPaymentInfo();
    }
    
    public TerminalResultMessage(double amt){
    	this.stx = 2;
    	this.len = 21;
    	this.etx = 3;
    	//this.paymentInfo = new KBZPaymentInfo();
    	//this.paymentInfo.mAmount = amt;
		this.mRespCode="";
		this.mPAN="";
		this.mSTAN="";
		this.mApprovalCode = "";
        this.mAccountNo = "";
        this.mExpDate = "";
        this.mTime = "";
        this.mAmount = amt;
        this.mRRN = "";
        this.mDate = "";
        this.mPOSEntry = "";
        this.mTerminalID = "";
        this.mMerchantID = "";
        this.mInvoiceNo = "";
        this.mCurrencyCode = "";
        this.mCardType = "";
    }

	public int getStx() {
		return stx;
	}

	public void setStx(int stx) {
		this.stx = stx;
	}

	public int getLen() {
		return len;
	}

	public void setLen(int len) {
		this.len = len;
	}

	public int getEtx() {
		return etx;
	}

	public void setEtx(int etx) {
		this.etx = etx;
	}

	public String getmRespCode() {
		return mRespCode;
	}

	public void setmRespCode(String mRespCode) {
		this.mRespCode = mRespCode;
	}

	public String getmPAN() {
		return mPAN;
	}

	public void setmPAN(String mPAN) {
		this.mPAN = mPAN;
	}

	public String getmSTAN() {
		return mSTAN;
	}

	public void setmSTAN(String mSTAN) {
		this.mSTAN = mSTAN;
	}

	public String getmApprovalCode() {
		return mApprovalCode;
	}

	public void setmApprovalCode(String mApprovalCode) {
		this.mApprovalCode = mApprovalCode;
	}

	public String getmAccountNo() {
		return mAccountNo;
	}

	public void setmAccountNo(String mAccountNo) {
		this.mAccountNo = mAccountNo;
	}

	public String getmExpDate() {
		return mExpDate;
	}

	public void setmExpDate(String mExpDate) {
		this.mExpDate = mExpDate;
	}

	public String getmTime() {
		return mTime;
	}

	public void setmTime(String mTime) {
		this.mTime = mTime;
	}

	public String getmDate() {
		return mDate;
	}

	public void setmDate(String mDate) {
		this.mDate = mDate;
	}

	public double getmAmount() {
		return mAmount;
	}

	public void setmAmount(double mAmount) {
		this.mAmount = mAmount;
	}

	public String getmRRN() {
		return mRRN;
	}

	public void setmRRN(String mRRN) {
		this.mRRN = mRRN;
	}

	public String getmPOSEntry() {
		return mPOSEntry;
	}

	public void setmPOSEntry(String mPOSEntry) {
		this.mPOSEntry = mPOSEntry;
	}

	public String getmTerminalID() {
		return mTerminalID;
	}

	public void setmTerminalID(String mTerminalID) {
		this.mTerminalID = mTerminalID;
	}

	public String getmMerchantID() {
		return mMerchantID;
	}

	public void setmMerchantID(String mMerchantID) {
		this.mMerchantID = mMerchantID;
	}

	public String getmInvoiceNo() {
		return mInvoiceNo;
	}

	public void setmInvoiceNo(String mInvoiceNo) {
		this.mInvoiceNo = mInvoiceNo;
	}

	public String getmCurrencyCode() {
		return mCurrencyCode;
	}

	public void setmCurrencyCode(String mCurrencyCode) {
		this.mCurrencyCode = mCurrencyCode;
	}

	public String getmCardType() {
		return mCardType;
	}

	public void setmCardType(String mCardType) {
		this.mCardType = mCardType;
	}

	// public KBZPaymentInfo getPaymentInfo() {
	// 	return paymentInfo;
	// }

	// public void setPaymentInfo(KBZPaymentInfo paymentInfo) {
	// 	this.paymentInfo = paymentInfo;
	// }
    
    
}
