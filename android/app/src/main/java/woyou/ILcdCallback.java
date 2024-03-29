/*
 * This file is auto-generated.  DO NOT MODIFY.
 * Original file: E:\\Android\\mpos_android\\mpos_android_svn\\src\\woyou\\aidlservice\\jiuiv5\\ILcdCallback.aidl
 */
package woyou.aidlservice.jiuiv5;
/**
 * 顾显反馈结果
 */
public interface ILcdCallback extends android.os.IInterface
{
/** Local-side IPC implementation stub class. */
public static abstract class Stub extends android.os.Binder implements woyou.aidlservice.jiuiv5.ILcdCallback
{
private static final java.lang.String DESCRIPTOR = "woyou.aidlservice.jiuiv5.ILcdCallback";
/** Construct the stub at attach it to the interface. */
public Stub()
{
this.attachInterface(this, DESCRIPTOR);
}
/**
 * Cast an IBinder object into an woyou.aidlservice.jiuiv5.ILcdCallback interface,
 * generating a proxy if needed.
 */
public static woyou.aidlservice.jiuiv5.ILcdCallback asInterface(android.os.IBinder obj)
{
if ((obj==null)) {
return null;
}
android.os.IInterface iin = obj.queryLocalInterface(DESCRIPTOR);
if (((iin!=null)&&(iin instanceof woyou.aidlservice.jiuiv5.ILcdCallback))) {
return ((woyou.aidlservice.jiuiv5.ILcdCallback)iin);
}
return new woyou.aidlservice.jiuiv5.ILcdCallback.Stub.Proxy(obj);
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
case TRANSACTION_onRunResult:
{
data.enforceInterface(DESCRIPTOR);
boolean _arg0;
_arg0 = (0!=data.readInt());
this.onRunResult(_arg0);
return true;
}
}
return super.onTransact(code, data, reply, flags);
}
private static class Proxy implements woyou.aidlservice.jiuiv5.ILcdCallback
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
/**
	* 返回执行结果
	* @param show:		  true 显示成功  false 显示失败
	*/
@Override public void onRunResult(boolean show) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
try {
_data.writeInterfaceToken(DESCRIPTOR);
_data.writeInt(((show)?(1):(0)));
mRemote.transact(Stub.TRANSACTION_onRunResult, _data, null, android.os.IBinder.FLAG_ONEWAY);
}
finally {
_data.recycle();
}
}
}
static final int TRANSACTION_onRunResult = (android.os.IBinder.FIRST_CALL_TRANSACTION + 0);
}
/**
	* 返回执行结果
	* @param show:		  true 显示成功  false 显示失败
	*/
public void onRunResult(boolean show) throws android.os.RemoteException;
}
