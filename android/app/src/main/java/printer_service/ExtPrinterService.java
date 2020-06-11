/*
 * This file is auto-generated.  DO NOT MODIFY.
 * Original file: E:\\Android\\mpos_android\\mpos_android_svn\\src\\com\\sunmi\\extprinterservice\\ExtPrinterService.aidl
 */
package com.sunmi.extprinterservice;
// Declare any non-default types here with import statements

public interface ExtPrinterService extends android.os.IInterface
{
/** Local-side IPC implementation stub class. */
public static abstract class Stub extends android.os.Binder implements com.sunmi.extprinterservice.ExtPrinterService
{
private static final java.lang.String DESCRIPTOR = "com.sunmi.extprinterservice.ExtPrinterService";
/** Construct the stub at attach it to the interface. */
public Stub()
{
this.attachInterface(this, DESCRIPTOR);
}
/**
 * Cast an IBinder object into an com.sunmi.extprinterservice.ExtPrinterService interface,
 * generating a proxy if needed.
 */
public static com.sunmi.extprinterservice.ExtPrinterService asInterface(android.os.IBinder obj)
{
if ((obj==null)) {
return null;
}
android.os.IInterface iin = obj.queryLocalInterface(DESCRIPTOR);
if (((iin!=null)&&(iin instanceof com.sunmi.extprinterservice.ExtPrinterService))) {
return ((com.sunmi.extprinterservice.ExtPrinterService)iin);
}
return new com.sunmi.extprinterservice.ExtPrinterService.Stub.Proxy(obj);
}
@Override public android.os.IBinder asBinder()
{
return this;
}
@Override public boolean onTransact(int code, android.os.Parcel data, android.os.Parcel reply, int flags) throws android.os.RemoteException
{
switch (code)
{
case INTERFACE_TRANSACTION:
{
reply.writeString(DESCRIPTOR);
return true;
}
case TRANSACTION_sendRawData:
{
data.enforceInterface(DESCRIPTOR);
byte[] _arg0;
_arg0 = data.createByteArray();
int _result = this.sendRawData(_arg0);
reply.writeNoException();
reply.writeInt(_result);
return true;
}
case TRANSACTION_printerInit:
{
data.enforceInterface(DESCRIPTOR);
int _result = this.printerInit();
reply.writeNoException();
reply.writeInt(_result);
return true;
}
case TRANSACTION_getPrinterStatus:
{
data.enforceInterface(DESCRIPTOR);
int _result = this.getPrinterStatus();
reply.writeNoException();
reply.writeInt(_result);
return true;
}
case TRANSACTION_lineWrap:
{
data.enforceInterface(DESCRIPTOR);
int _arg0;
_arg0 = data.readInt();
int _result = this.lineWrap(_arg0);
reply.writeNoException();
reply.writeInt(_result);
return true;
}
case TRANSACTION_pixelWrap:
{
data.enforceInterface(DESCRIPTOR);
int _arg0;
_arg0 = data.readInt();
int _result = this.pixelWrap(_arg0);
reply.writeNoException();
reply.writeInt(_result);
return true;
}
case TRANSACTION_flush:
{
data.enforceInterface(DESCRIPTOR);
int _result = this.flush();
reply.writeNoException();
reply.writeInt(_result);
return true;
}
case TRANSACTION_tab:
{
data.enforceInterface(DESCRIPTOR);
int _result = this.tab();
reply.writeNoException();
reply.writeInt(_result);
return true;
}
case TRANSACTION_printText:
{
data.enforceInterface(DESCRIPTOR);
java.lang.String _arg0;
_arg0 = data.readString();
int _result = this.printText(_arg0);
reply.writeNoException();
reply.writeInt(_result);
return true;
}
case TRANSACTION_printBarCode:
{
data.enforceInterface(DESCRIPTOR);
java.lang.String _arg0;
_arg0 = data.readString();
int _arg1;
_arg1 = data.readInt();
int _arg2;
_arg2 = data.readInt();
int _arg3;
_arg3 = data.readInt();
int _arg4;
_arg4 = data.readInt();
int _result = this.printBarCode(_arg0, _arg1, _arg2, _arg3, _arg4);
reply.writeNoException();
reply.writeInt(_result);
return true;
}
case TRANSACTION_printQrCode:
{
data.enforceInterface(DESCRIPTOR);
java.lang.String _arg0;
_arg0 = data.readString();
int _arg1;
_arg1 = data.readInt();
int _arg2;
_arg2 = data.readInt();
int _result = this.printQrCode(_arg0, _arg1, _arg2);
reply.writeNoException();
reply.writeInt(_result);
return true;
}
case TRANSACTION_printBitmap:
{
data.enforceInterface(DESCRIPTOR);
android.graphics.Bitmap _arg0;
if ((0!=data.readInt())) {
_arg0 = android.graphics.Bitmap.CREATOR.createFromParcel(data);
}
else {
_arg0 = null;
}
int _arg1;
_arg1 = data.readInt();
int _result = this.printBitmap(_arg0, _arg1);
reply.writeNoException();
reply.writeInt(_result);
return true;
}
case TRANSACTION_setHorizontalTab:
{
data.enforceInterface(DESCRIPTOR);
int[] _arg0;
_arg0 = data.createIntArray();
int _result = this.setHorizontalTab(_arg0);
reply.writeNoException();
reply.writeInt(_result);
return true;
}
case TRANSACTION_setAlignMode:
{
data.enforceInterface(DESCRIPTOR);
int _arg0;
_arg0 = data.readInt();
int _result = this.setAlignMode(_arg0);
reply.writeNoException();
reply.writeInt(_result);
return true;
}
case TRANSACTION_cutPaper:
{
data.enforceInterface(DESCRIPTOR);
int _arg0;
_arg0 = data.readInt();
int _arg1;
_arg1 = data.readInt();
int _result = this.cutPaper(_arg0, _arg1);
reply.writeNoException();
reply.writeInt(_result);
return true;
}
case TRANSACTION_setFontZoom:
{
data.enforceInterface(DESCRIPTOR);
int _arg0;
_arg0 = data.readInt();
int _arg1;
_arg1 = data.readInt();
int _result = this.setFontZoom(_arg0, _arg1);
reply.writeNoException();
reply.writeInt(_result);
return true;
}
case TRANSACTION_printColumnsText:
{
data.enforceInterface(DESCRIPTOR);
java.lang.String[] _arg0;
_arg0 = data.createStringArray();
int[] _arg1;
_arg1 = data.createIntArray();
int[] _arg2;
_arg2 = data.createIntArray();
int _result = this.printColumnsText(_arg0, _arg1, _arg2);
reply.writeNoException();
reply.writeInt(_result);
return true;
}
}
return super.onTransact(code, data, reply, flags);
}
private static class Proxy implements com.sunmi.extprinterservice.ExtPrinterService
{
private android.os.IBinder mRemote;
Proxy(android.os.IBinder remote)
{
mRemote = remote;
}
@Override public android.os.IBinder asBinder()
{
return mRemote;
}
public java.lang.String getInterfaceDescriptor()
{
return DESCRIPTOR;
}
@Override public int sendRawData(byte[] cmd) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
int _result;
try {
_data.writeInterfaceToken(DESCRIPTOR);
_data.writeByteArray(cmd);
mRemote.transact(Stub.TRANSACTION_sendRawData, _data, _reply, 0);
_reply.readException();
_result = _reply.readInt();
}
finally {
_reply.recycle();
_data.recycle();
}
return _result;
}
@Override public int printerInit() throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
int _result;
try {
_data.writeInterfaceToken(DESCRIPTOR);
mRemote.transact(Stub.TRANSACTION_printerInit, _data, _reply, 0);
_reply.readException();
_result = _reply.readInt();
}
finally {
_reply.recycle();
_data.recycle();
}
return _result;
}
@Override public int getPrinterStatus() throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
int _result;
try {
_data.writeInterfaceToken(DESCRIPTOR);
mRemote.transact(Stub.TRANSACTION_getPrinterStatus, _data, _reply, 0);
_reply.readException();
_result = _reply.readInt();
}
finally {
_reply.recycle();
_data.recycle();
}
return _result;
}
@Override public int lineWrap(int n) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
int _result;
try {
_data.writeInterfaceToken(DESCRIPTOR);
_data.writeInt(n);
mRemote.transact(Stub.TRANSACTION_lineWrap, _data, _reply, 0);
_reply.readException();
_result = _reply.readInt();
}
finally {
_reply.recycle();
_data.recycle();
}
return _result;
}
@Override public int pixelWrap(int n) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
int _result;
try {
_data.writeInterfaceToken(DESCRIPTOR);
_data.writeInt(n);
mRemote.transact(Stub.TRANSACTION_pixelWrap, _data, _reply, 0);
_reply.readException();
_result = _reply.readInt();
}
finally {
_reply.recycle();
_data.recycle();
}
return _result;
}
@Override public int flush() throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
int _result;
try {
_data.writeInterfaceToken(DESCRIPTOR);
mRemote.transact(Stub.TRANSACTION_flush, _data, _reply, 0);
_reply.readException();
_result = _reply.readInt();
}
finally {
_reply.recycle();
_data.recycle();
}
return _result;
}
@Override public int tab() throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
int _result;
try {
_data.writeInterfaceToken(DESCRIPTOR);
mRemote.transact(Stub.TRANSACTION_tab, _data, _reply, 0);
_reply.readException();
_result = _reply.readInt();
}
finally {
_reply.recycle();
_data.recycle();
}
return _result;
}
@Override public int printText(java.lang.String text) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
int _result;
try {
_data.writeInterfaceToken(DESCRIPTOR);
_data.writeString(text);
mRemote.transact(Stub.TRANSACTION_printText, _data, _reply, 0);
_reply.readException();
_result = _reply.readInt();
}
finally {
_reply.recycle();
_data.recycle();
}
return _result;
}
@Override public int printBarCode(java.lang.String code, int type, int width, int height, int hriPos) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
int _result;
try {
_data.writeInterfaceToken(DESCRIPTOR);
_data.writeString(code);
_data.writeInt(type);
_data.writeInt(width);
_data.writeInt(height);
_data.writeInt(hriPos);
mRemote.transact(Stub.TRANSACTION_printBarCode, _data, _reply, 0);
_reply.readException();
_result = _reply.readInt();
}
finally {
_reply.recycle();
_data.recycle();
}
return _result;
}
@Override public int printQrCode(java.lang.String code, int modeSize, int errorlevel) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
int _result;
try {
_data.writeInterfaceToken(DESCRIPTOR);
_data.writeString(code);
_data.writeInt(modeSize);
_data.writeInt(errorlevel);
mRemote.transact(Stub.TRANSACTION_printQrCode, _data, _reply, 0);
_reply.readException();
_result = _reply.readInt();
}
finally {
_reply.recycle();
_data.recycle();
}
return _result;
}
@Override public int printBitmap(android.graphics.Bitmap bitmap, int mode) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
int _result;
try {
_data.writeInterfaceToken(DESCRIPTOR);
if ((bitmap!=null)) {
_data.writeInt(1);
bitmap.writeToParcel(_data, 0);
}
else {
_data.writeInt(0);
}
_data.writeInt(mode);
mRemote.transact(Stub.TRANSACTION_printBitmap, _data, _reply, 0);
_reply.readException();
_result = _reply.readInt();
}
finally {
_reply.recycle();
_data.recycle();
}
return _result;
}
@Override public int setHorizontalTab(int[] k) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
int _result;
try {
_data.writeInterfaceToken(DESCRIPTOR);
_data.writeIntArray(k);
mRemote.transact(Stub.TRANSACTION_setHorizontalTab, _data, _reply, 0);
_reply.readException();
_result = _reply.readInt();
}
finally {
_reply.recycle();
_data.recycle();
}
return _result;
}
@Override public int setAlignMode(int type) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
int _result;
try {
_data.writeInterfaceToken(DESCRIPTOR);
_data.writeInt(type);
mRemote.transact(Stub.TRANSACTION_setAlignMode, _data, _reply, 0);
_reply.readException();
_result = _reply.readInt();
}
finally {
_reply.recycle();
_data.recycle();
}
return _result;
}
@Override public int cutPaper(int m, int n) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
int _result;
try {
_data.writeInterfaceToken(DESCRIPTOR);
_data.writeInt(m);
_data.writeInt(n);
mRemote.transact(Stub.TRANSACTION_cutPaper, _data, _reply, 0);
_reply.readException();
_result = _reply.readInt();
}
finally {
_reply.recycle();
_data.recycle();
}
return _result;
}
@Override public int setFontZoom(int hori, int veri) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
int _result;
try {
_data.writeInterfaceToken(DESCRIPTOR);
_data.writeInt(hori);
_data.writeInt(veri);
mRemote.transact(Stub.TRANSACTION_setFontZoom, _data, _reply, 0);
_reply.readException();
_result = _reply.readInt();
}
finally {
_reply.recycle();
_data.recycle();
}
return _result;
}
@Override public int printColumnsText(java.lang.String[] colsTextArr, int[] colsWidthArr, int[] colsAlign) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
int _result;
try {
_data.writeInterfaceToken(DESCRIPTOR);
_data.writeStringArray(colsTextArr);
_data.writeIntArray(colsWidthArr);
_data.writeIntArray(colsAlign);
mRemote.transact(Stub.TRANSACTION_printColumnsText, _data, _reply, 0);
_reply.readException();
_result = _reply.readInt();
}
finally {
_reply.recycle();
_data.recycle();
}
return _result;
}
}
static final int TRANSACTION_sendRawData = (android.os.IBinder.FIRST_CALL_TRANSACTION + 0);
static final int TRANSACTION_printerInit = (android.os.IBinder.FIRST_CALL_TRANSACTION + 1);
static final int TRANSACTION_getPrinterStatus = (android.os.IBinder.FIRST_CALL_TRANSACTION + 2);
static final int TRANSACTION_lineWrap = (android.os.IBinder.FIRST_CALL_TRANSACTION + 3);
static final int TRANSACTION_pixelWrap = (android.os.IBinder.FIRST_CALL_TRANSACTION + 4);
static final int TRANSACTION_flush = (android.os.IBinder.FIRST_CALL_TRANSACTION + 5);
static final int TRANSACTION_tab = (android.os.IBinder.FIRST_CALL_TRANSACTION + 6);
static final int TRANSACTION_printText = (android.os.IBinder.FIRST_CALL_TRANSACTION + 7);
static final int TRANSACTION_printBarCode = (android.os.IBinder.FIRST_CALL_TRANSACTION + 8);
static final int TRANSACTION_printQrCode = (android.os.IBinder.FIRST_CALL_TRANSACTION + 9);
static final int TRANSACTION_printBitmap = (android.os.IBinder.FIRST_CALL_TRANSACTION + 10);
static final int TRANSACTION_setHorizontalTab = (android.os.IBinder.FIRST_CALL_TRANSACTION + 11);
static final int TRANSACTION_setAlignMode = (android.os.IBinder.FIRST_CALL_TRANSACTION + 12);
static final int TRANSACTION_cutPaper = (android.os.IBinder.FIRST_CALL_TRANSACTION + 13);
static final int TRANSACTION_setFontZoom = (android.os.IBinder.FIRST_CALL_TRANSACTION + 14);
static final int TRANSACTION_printColumnsText = (android.os.IBinder.FIRST_CALL_TRANSACTION + 15);
}
public int sendRawData(byte[] cmd) throws android.os.RemoteException;
public int printerInit() throws android.os.RemoteException;
public int getPrinterStatus() throws android.os.RemoteException;
public int lineWrap(int n) throws android.os.RemoteException;
public int pixelWrap(int n) throws android.os.RemoteException;
public int flush() throws android.os.RemoteException;
public int tab() throws android.os.RemoteException;
public int printText(java.lang.String text) throws android.os.RemoteException;
public int printBarCode(java.lang.String code, int type, int width, int height, int hriPos) throws android.os.RemoteException;
public int printQrCode(java.lang.String code, int modeSize, int errorlevel) throws android.os.RemoteException;
public int printBitmap(android.graphics.Bitmap bitmap, int mode) throws android.os.RemoteException;
public int setHorizontalTab(int[] k) throws android.os.RemoteException;
public int setAlignMode(int type) throws android.os.RemoteException;
public int cutPaper(int m, int n) throws android.os.RemoteException;
public int setFontZoom(int hori, int veri) throws android.os.RemoteException;
public int printColumnsText(java.lang.String[] colsTextArr, int[] colsWidthArr, int[] colsAlign) throws android.os.RemoteException;
}
