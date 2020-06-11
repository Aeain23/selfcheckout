package com.example.self_check_out;
import android.annotation.TargetApi;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.Build;
import android.os.IBinder;
import android.os.RemoteException;
import android.widget.Toast;
import android.content.IntentFilter;
import android.app.PendingIntent;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import android.util.DisplayMetrics;

import com.sunmi.extprinterservice.ExtPrinterService;

import woyou.aidlservice.jiuiv5.ICallback;
import woyou.aidlservice.jiuiv5.IWoyouService;
//
//import woyou.aidlservice.jiuiv5.ICallback;

import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONException;

import java.io.IOException;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.Locale;

import java.util.List;
import com.hoho.android.usbserial.driver.UsbSerialDriver;
import com.hoho.android.usbserial.driver.UsbSerialProber;
import android.hardware.usb.UsbDevice;
import android.hardware.usb.UsbManager;
import android.hardware.usb.UsbDeviceConnection;
import com.hoho.android.usbserial.driver.UsbSerialPort;
import com.google.gson.Gson;
import com.example.model.TerminalResultMessage;
import com.example.model.Message;
import com.example.model.POSIntegration;
import com.example.model.POSMsg;
import com.example.model.POSIntegration.V_TYPE;
import java.text.DecimalFormat;
import java.util.Arrays;
import android.hardware.usb.UsbEndpoint;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.hardware.usb.UsbInterface;

import android.view.inputmethod.InputMethodManager;
import android.view.View;
import java.text.SimpleDateFormat;
import java.util.Date;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "flutter.native/helper";
    private ExtPrinterService extPrinterService;
    private IWoyouService woyouService;
    public static boolean isVertical = false;
    private PendingIntent mPermissionIntent;
    private static final String ACTION_USB_PERMISSION = "com.android.example.USB_PERMISSION";

    private UsbManager mManager;
    public UsbSerialDriver driver = null;
    public UsbSerialPort port = null;
    private byte[] mReadBuffer;
    private byte[] mWriteBuffer;
    byte[] readBuffer;
    public static Message mMessage;
    private POSMsg posMsg;
    private POSIntegration posIntegration;
    private UsbEndpoint mReadEndpoint;
    private UsbEndpoint mWriteEndpoint;
    private UsbDeviceConnection mConnection;
    private UsbInterface mControlInterface;
    private UsbEndpoint mControlEndpoint;
    private UsbInterface mDataInterface;
    private static final int DEFAULT_READ_BUFFER_SIZE = 32 * 1024;
    private static final int DEFAULT_WRITE_BUFFER_SIZE = 32 * 1024;

    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {

                    IntentFilter filter = new IntentFilter();
                    filter.addAction(ACTION_USB_PERMISSION);
                    filter.addAction(UsbManager.ACTION_USB_DEVICE_DETACHED);
                    registerReceiver(mReceiver, filter);
                    mManager = (UsbManager) getSystemService(Context.USB_SERVICE);
                    mPermissionIntent = PendingIntent.getBroadcast(this, 0, new Intent(ACTION_USB_PERMISSION), 0);

                    switch (call.method) {
                        case "hideKeyboard":
                            String hideData = hideSystemKeyboard();
                            result.success(hideData);
                            break;
                        case "connectPrinter":
                            innitView();
                            result.success("Connected Printer");
                            break;
                        case "connectTerminal":
                            boolean response = openTerminal();
                            result.success(response);
                            break;
                        case "paymentTerminal":
                            try {
                              
                                    
                                    String mbalanceDue = call.argument("mbalanceDue");
                                    String re = "";
                        
                                    re = terminalPayment(mbalanceDue);
                                    result.success(re);
                                   
                                
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                            break;
                        case "helloFromNativeCode":
                            String data = call.argument("data");
                            String system = call.argument("system");
                            String counter = call.argument("counter");
                            String userid = call.argument("userid");
                            String isreprint = call.argument("isreprint");
                            String macAddress = call.argument("macAddress");

                            String greetings = printInvoice(data, system, counter, userid, isreprint, macAddress);

                            // String greetings = helloFromNativeCode();
                            result.success(data);
                            break;
                        case "epinNativeCode":
                            String data1 = call.argument("data");
                            String macAddress1 = call.argument("macAddress");
                            String epingreetings = printEpin(data1, macAddress1);

                            result.success(epingreetings);
                            break;
                        default:
                            break;
                    }

                });

    }

    public String hideSystemKeyboard() {
        String data = "";
        try {
            View view = MainActivity.this.getCurrentFocus();
            if (view != null) {
                InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
                imm.hideSoftInputFromWindow(view.getWindowToken(), 0);
                data = "true";
            }
        } catch (Exception e) {
            e.printStackTrace();
            data = "false";
        }
        return data;
    }

    private final BroadcastReceiver mReceiver = new BroadcastReceiver() {
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            /*
             * if(BluetoothDevice.ACTION_BOND_STATE_CHANGED.equals(action)) {
             * listView.setAdapter(new
             * ArrayAdapter<String>(context,android.R.layout.simple_list_item_1,
             * pairedDevList)); }
             */
            // if (BluetoothDevice.ACTION_FOUND.equals(action)) {
            // BluetoothDevice device = intent
            // .getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);
            // mDeviceList.add(device.getName() + "\n" + device.getAddress());
            // Log.i("BT", device.getName() + "\n" + device.getAddress());
            // listView.setAdapter(new ArrayAdapter<String>(context,
            // android.R.layout.simple_list_item_1, mDeviceList));
            // }

            try {
                if (ACTION_USB_PERMISSION.equals(action)) {
                    synchronized (this) {
                        UsbDevice device = (UsbDevice) intent.getParcelableExtra(UsbManager.EXTRA_DEVICE);

                        if (intent.getBooleanExtra(UsbManager.EXTRA_PERMISSION_GRANTED, false)) {
                            if (device != null) {
                                // if (mReader.isSupported(device)) {
                                // new OpenTask().execute(device);
                                // } else
                                if (device.getVendorId() == 4554 && device.getProductId() == 546) {
                                    // with usb
                                    mReadBuffer = new byte[DEFAULT_READ_BUFFER_SIZE];
                                    mWriteBuffer = new byte[DEFAULT_WRITE_BUFFER_SIZE];
                                    openUsbTerminal(device);

                                }
                                // else {
                                // with serial port
                                // new OpenSerialPortTask().execute(device);
                                // }
                            }

                        } else {
                            // Toast.makeText(getApplicationContext(),
                            //         "Permission denied for device " + device.getDeviceName(), Toast.LENGTH_SHORT)
                            //         .show();
                        }

                    }

                }
                // else if (UsbManager.ACTION_USB_DEVICE_DETACHED.equals(action)) {
                // synchronized (this) {
                // UsbDevice device = (UsbDevice) intent
                // .getParcelableExtra(UsbManager.EXTRA_DEVICE);

                // if (device != null
                // // && device.equals(mReader.getDevice())
                // ) {
                // Toast.makeText(getApplicationContext(),
                // "Closing reader... ", Toast.LENGTH_SHORT)
                // .show();

                // new CloseTask().execute();
                // } else if (device != null
                // && device.equals(driver.getDevice())) {
                // Toast.makeText(getApplicationContext(),
                // "Closing Serial Port... ",
                // Toast.LENGTH_SHORT).show();

                // // new CloseSerialPortTask().execute();
                // }
                // }
                // }
            } catch (Exception e) {
                e.printStackTrace();
            }

        }
    };

    private void openUsbTerminal(UsbDevice device) {
        try {
            boolean forceClaim = true;

            UsbInterface intf = device.getInterface(0);
            UsbEndpoint readendpoint = intf.getEndpoint(0);

            UsbInterface writeintf = device.getInterface(1);
            UsbEndpoint writeendpoint = writeintf.getEndpoint(1);
            UsbDeviceConnection connection = mManager.openDevice(device);

            mConnection = connection;
            mConnection.controlTransfer(0x21, 0x22, 0x1, 0, null, 0, 0);

            mControlInterface = device.getInterface(0);

            if (!mConnection.claimInterface(mControlInterface, true)) {
                throw new IOException("Could not claim control interface.");
            }

            mControlEndpoint = mControlInterface.getEndpoint(0);
            mDataInterface = device.getInterface(1);

            if (!mConnection.claimInterface(mDataInterface, true)) {
                throw new IOException("Could not claim data interface.");
            }
            mReadEndpoint = mDataInterface.getEndpoint(1);
            mWriteEndpoint = mDataInterface.getEndpoint(0);

        } catch (Exception e) {
            // Toast.makeText(getApplicationContext(), e.toString(), Toast.LENGTH_SHORT).show();
        }
    }

    private void innitView() {
        DisplayMetrics dm = new DisplayMetrics();
        getWindow().getWindowManager().getDefaultDisplay().getMetrics(dm);
        int width = dm.widthPixels;
        int height = dm.heightPixels;
        if (height > width) {
            isVertical = true;
            connectKPrintService();
        } else {
            connectPrintService();
        }
    }

    @TargetApi(Build.VERSION_CODES.DONUT)
    private void connectKPrintService() {
        Intent intent = new Intent();
        intent.setPackage("com.sunmi.extprinterservice");
        intent.setAction("com.sunmi.extprinterservice.PrinterService");
        bindService(intent, connService, Context.BIND_AUTO_CREATE);
    }

    private void connectPrintService() {
        Intent intent = new Intent();
        intent.setPackage("woyou.aidlservice.jiuiv5");
        intent.setAction("woyou.aidlservice.jiuiv5.IWoyouService");
        getApplicationContext().bindService(intent, connService, Context.BIND_AUTO_CREATE);
    }

    ICallback callback = new ICallback.Stub() {

        @Override
        public void onRunResult(boolean success) throws RemoteException {
        }

        @Override
        public void onReturnString(final String value) throws RemoteException {
        }

        @Override
        public void onRaiseException(int code, final String msg) throws RemoteException {
        }

        @Override
        public void onPrintResult(int code, String msg) throws RemoteException {

        }
    };

    private ServiceConnection connService = new ServiceConnection() {

        @Override
        public void onServiceDisconnected(ComponentName name) {

            woyouService = null;
            extPrinterService = null;
        }

        @Override
        public void onServiceConnected(ComponentName name, IBinder service) {
            //woyouService = IWoyouService.Stub.asInterface(service);
            if (isVertical) {
                extPrinterService = ExtPrinterService.Stub.asInterface(service);
            }

            woyouService = IWoyouService.Stub.asInterface(service);

        }
    };

    public String printEpin(String data, String macAddress) {

        Toast.makeText(getApplicationContext(), "Invoice Epin Printing... ", Toast.LENGTH_SHORT).show();

        try {
            Toast.makeText(getApplicationContext(), "Prepare Invoice Epin Message ... ", Toast.LENGTH_SHORT).show();
            // String prepareMessage = prepareInvoiceMessage(data, system, counter, userid,
            // isreprint, macAddress);
            String prepareMessage = prepareInvoiceEpinMessage(data);
            // Toast.makeText(getApplicationContext(), "woyou prepareMessage .. " +
            // prepareMessage,
            // Toast.LENGTH_SHORT).show();
            if (extPrinterService.getPrinterStatus() != 0) {
                Toast.makeText(getApplicationContext(), "Print Epin state .. " + extPrinterService.getPrinterStatus(),
                        Toast.LENGTH_SHORT).show();

                // Toast.makeText(getApplicationContext(), "return not Zero",
                // Toast.LENGTH_SHORT).show();
            } else {
                // Log.d("prepare",prepareMessage);
                Toast.makeText(getApplicationContext(), "Success", Toast.LENGTH_SHORT).show();
                extPrinterService.printText(prepareMessage);
                extPrinterService.flush();
                extPrinterService.lineWrap(3);
                extPrinterService.cutPaper(0, 0);
            }

        } catch (RemoteException e) {
            e.printStackTrace();
            Toast.makeText(getApplicationContext(), "Print Epin error... " + e.toString(), Toast.LENGTH_SHORT).show();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return data;
    }

    public String prepareInvoiceEpinMessage(String data) throws IOException, JSONException {

        // Toast.makeText(getApplicationContext(), "data ... " + data,
        // Toast.LENGTH_SHORT).show();

        String dataToPrint = "";
        try {
            JSONObject reader = new JSONObject(data);
            JSONArray topupList = reader.getJSONArray("topupData");
            for (int i = 0; i < topupList.length(); i++) {
                dataToPrint = dataToPrint + ("------------------------------------------------\n");
                JSONObject d = topupList.getJSONObject(i);
                String dateData = d.getString("createddate");
                String date1 = dateData.substring(6, 8);
                String date2 = dateData.substring(4, 6);
                String date3 = dateData.substring(0, 4);
                String fordate = date1 + "/" + date2 + "/" + date3;
                dataToPrint = dataToPrint + "Date         : " + fordate + "\n";
                String cashier = d.getString("userid");
                dataToPrint = dataToPrint + "Cashier      : " + cashier + "\n";
                String terminalID = d.getString("t9");
                dataToPrint = dataToPrint + "Terminal ID  : " + terminalID + "\n";
                String topupValue = d.getString("actualvalue");
                String formatted_topupValue = NumberFormat.getNumberInstance(Locale.US)
                        .format(Long.parseLong(topupValue));
                dataToPrint = dataToPrint + "Topup Value  : Kyats " + formatted_topupValue + "\n";
                String serialNo = d.getString("serial");
                dataToPrint = dataToPrint + "Serial No.   : " + serialNo + "\n";
                String instructions = d.getString("text");
                dataToPrint = dataToPrint + "Instructions : \n" + instructions + "\n";
                dataToPrint = dataToPrint + ("------------------------------------------------\n");
                String voucher = d.getString("voucher");
                String y = "";
                if (voucher.length() < 48) {
                    int t = 48 - voucher.length();
                    for (int c = 0; c < t / 2; c++) {
                        y += "-";
                    }
                    dataToPrint = dataToPrint + (y + voucher + y + "\n");
                }
                String info = d.getString("text1");
                dataToPrint = dataToPrint + info;
                dataToPrint = dataToPrint + ("\n\n\n");
            }

        } catch (Exception e) {
            Toast.makeText(getApplicationContext(), "Print error... " + e.toString(), Toast.LENGTH_SHORT).show();
        }
        return dataToPrint;

    }

    public String printInvoice(String data, String system, String counter, String userid, String isreprint,
            String macAddress) {

        Toast.makeText(getApplicationContext(), "Invoice Printing... ", Toast.LENGTH_SHORT).show();

        
        if (macAddress == null || macAddress.equals("") || macAddress.equals("undefined")) {
            //Toast.makeText(getApplicationContext(), "Woyou Invoice Printing... ", Toast.LENGTH_SHORT).show();
            try {
                String prepareMessage = prepareInvoiceMessage(data, system, counter, userid, isreprint);
                // String prepareMessage = demoInvoice();
                // Toast.makeText(getApplicationContext(), "woyou >>" + prepareMessage, Toast.LENGTH_SHORT).show();

                woyouService.printText(prepareMessage, callback);
                woyouService.cutPaper(callback);
            } catch (RemoteException e) {
                e.printStackTrace();
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {

            try {
                Toast.makeText(getApplicationContext(), "Prepare Invoice Message ... ", Toast.LENGTH_SHORT).show();
                // String prepareMessage = prepareInvoiceMessage(data, system, counter, userid,
                // isreprint, macAddress);
                 String prepareMessage = prepareInvoiceMessage(data, system, counter, userid, isreprint);
                // Toast.makeText(getApplicationContext(), "woyou prepareMessage .. " +
                // prepareMessage,
                // Toast.LENGTH_SHORT).show();
                if (extPrinterService.getPrinterStatus() != 0) {
                    Toast.makeText(getApplicationContext(), "Print state .. " + extPrinterService.getPrinterStatus(),
                            Toast.LENGTH_SHORT).show();

                    // Toast.makeText(getApplicationContext(), "return not Zero",
                    // Toast.LENGTH_SHORT).show();
                } else {
                    // Log.d("prepare",prepareMessage);
                    Toast.makeText(getApplicationContext(), "Success", Toast.LENGTH_SHORT).show();
                    extPrinterService.printText(prepareMessage);
                    extPrinterService.flush();
                    extPrinterService.lineWrap(3);
                    extPrinterService.cutPaper(0, 0);
                }

            } catch (RemoteException e) {
                e.printStackTrace();
                Toast.makeText(getApplicationContext(), "Print error... " + e.toString(), Toast.LENGTH_SHORT).show();
            } catch (Exception e) {
                e.printStackTrace();
            }

        }

        return data;
    }

    public String demoInvoice() throws Exception {
        String dataToPrint = "";
        dataToPrint = dataToPrint + ("                  TEST                   " + "\n");
        // dataToPrint = dataToPrint + (" Thanks U ");
        // Toast.makeText(getApplicationContext(), dataToPrint,
        // Toast.LENGTH_SHORT).show();
        return dataToPrint;
    }

    // ICallback callback = new ICallback.Stub() {
    //
    // @Override
    // public void onRunResult(boolean success) throws RemoteException {
    // }
    //
    // @Override
    // public void onReturnString(final String value) throws RemoteException {
    // }
    //
    // @Override
    // public void onRaiseException(int code, final String msg) throws
    // RemoteException {
    // }
    //
    // @Override
    // public void onPrintResult(int code, String msg) throws RemoteException {
    //
    // }
    // };

    public String prepareInvoiceMessage(String data, String system, String counter, String userid, String isreprint)
            throws IOException, JSONException {

        // Toast.makeText(getApplicationContext(), "data ... " + data,
        // Toast.LENGTH_SHORT).show();

        String dataToPrint = "";
        try {
            JSONObject reader = new JSONObject(data);
            // Toast.makeText(getApplicationContext(), "reader>> " + reader.toString(),
            // Toast.LENGTH_SHORT).show();
            JSONObject header = reader.getJSONObject("headerData");
            // Toast.makeText(getApplicationContext(), "header>> " + header.toString(),
            // Toast.LENGTH_SHORT).show();
            JSONArray detail = reader.getJSONArray("detailsData");
            // JSONArray detail = new JSONArray();
            // Toast.makeText(getApplicationContext(), "detail " + detail.toString(),
            // Toast.LENGTH_SHORT).show();
            JSONArray payment = reader.getJSONArray("paymentData");
            // Toast.makeText(getApplicationContext(), "payment " + payment.toString(),
            // Toast.LENGTH_SHORT).show();
            JSONObject t2pPrintData = reader.getJSONObject("t2pPrintData");
            // Toast.makeText(getApplicationContext(), "t2pPrintData " +
            // t2pPrintData.toString(), Toast.LENGTH_SHORT).show();
            JSONArray t2pPaymentData = reader.getJSONArray("t2pPaymentList");
            // Toast.makeText(getApplicationContext(), "t2pPaymentData " +
            // t2pPaymentData.toString(), Toast.LENGTH_SHORT).show();
            JSONArray serialDataList = reader.getJSONArray("serialDataList");
            // Toast.makeText(getApplicationContext(), "serialDataList " +
            // serialDataList.toString(), Toast.LENGTH_SHORT).show();
            // JSONArray t2pRewards = t2pPrintData.getJSONArray("rewards");
            String slipno = header.getString("t1");
            // Toast.makeText(getApplicationContext(), "slipno " + slipno.toString(),
            // Toast.LENGTH_SHORT).show();
            String date = header.getString("modifieddate");
            // Toast.makeText(getApplicationContext(), "date " + date.toString(),
            // Toast.LENGTH_SHORT).show();
            //String time = header.getString("t11");
            String time = getCurrentTime();
            // Toast.makeText(getApplicationContext(), "time " + time.toString(),
            // Toast.LENGTH_SHORT).show();
            String date1 = date.substring(6, 8);
            String date2 = date.substring(4, 6);
            String date3 = date.substring(0, 4);
            String fordate = date1 + "/" + date2 + "/" + date3;
           
   
            String hour = time.substring(0, 2);
            String min = time.substring(2, 4);
            int hr = Integer.parseInt(hour);
            int m1 = Integer.parseInt(min);
            String fortime = "";
            // if (hr > 12) {
            //     int hrs=(hr - 12);
            //      hour=String.valueOf(hrs);
            //     fortime = hour + ":" + min + " PM";
            // } else {
            //     fortime = hour + ":" + min + " AM";
            // }

            // if (hr > 12) {
            //     hour = String.valueOf(Integer.parseInt(hour) - 12);
            //     fortime = hour + ":" + min + " PM";
            // } else if (hr == 12 && m1 >0){
            //     fortime = hour + ":" + min + " PM";
            // } else if(hr == 24) {
            //     hour = String.valueOf(Integer.parseInt(hour) - 12);
            //     fortime = hour + ":" + min + " AM";
            // } else {
            //     fortime = hour + ":" + min + " AM";
            // }

            if (hr >= 12) {
				if(hr != 12){
					hour = String.valueOf(hr - 12);
				}
				
				fortime = hour + ":" + min + " PM";
			} else {
				if(hr == 0){
					hour = "12";
				}
				
				fortime = hour + ":" + min + " AM";
			}

            String headerdisc = header.getString("n9");
            long head = Math.round(Double.parseDouble(headerdisc));
            headerdisc = Long.toString(head);

            String taxamt = header.getString("n14");
            long taxamountint = Math.round(Double.parseDouble(taxamt));
            // Toast.makeText(getApplicationContext(), "taxAmt " + taxamt.toString(),
            // Toast.LENGTH_SHORT).show();
            // String systemsetup=system.replaceAll("\"","");
            // Toast.makeText(getApplicationContext(), "system setup string to json " +
            // systemsetup,
            // Toast.LENGTH_SHORT).show();
            JSONObject sys = new JSONObject(system);

            String title = sys.getString("t1");
            String branch = sys.getString("t2");
            String phno = sys.getString("t3");
            String open = sys.getString("t7");
            // Toast.makeText(getApplicationContext(), "open " + open.toString(),
            // Toast.LENGTH_SHORT).show();

            String nett_amt = "";

            String y = "";
            if (title.length() < 48) {
                int t = 48 - title.length();
                for (int i = 0; i < t / 2; i++) {
                    y += " ";
                }
                dataToPrint = dataToPrint + (y + title + y + "\n");
            }

            String z = "";
            if (branch.length() < 48) {
                int bch = 48 - branch.length();
                for (int i = 0; i < bch / 2; i++) {
                    z += " ";
                }
                dataToPrint = dataToPrint + (z + branch + z + "\n");
            }

            String x = "";
            if (phno.length() < 48) {
                int phone = 48 - phno.length();
                for (int i = 0; i < phone / 2; i++) {
                    x += " ";
                }
                dataToPrint = dataToPrint + (x + phno + x + "\n");
            }

            String w = "";
            if (open.length() < 48) {
                int op = 48 - open.length();
                for (int i = 0; i < op / 2; i++) {
                    w += " ";
                }
                dataToPrint = dataToPrint + (w + open + w + "\n");
            }

            dataToPrint = dataToPrint + ("           Taxpayer ID No.113516550       " + "\n");
            if (Integer.parseInt(header.getString("n30")) == 1)
                dataToPrint = dataToPrint + ("                   CASH SALE                     " + "\n");
            else
                dataToPrint = dataToPrint + ("                  SALE RETURN                    " + "\n");

            if (isreprint.equals("true")) {
                dataToPrint = dataToPrint + ("                 ##  REPRINT  ##                 " + "\n");
            }

            String space = "";
            if (slipno.length() < 6) {
                int s = 6 - slipno.length();
                for (int i = 0; i < s; i++) {
                    space += " ";
                }
                dataToPrint = dataToPrint + ("Slip No.: " + slipno + space);
            } else {
                dataToPrint = dataToPrint + ("Slip No.: " + slipno);
            }
            dataToPrint = dataToPrint + ("             ");
            dataToPrint = dataToPrint + (fordate + " " + fortime + "\n");

            space = "";
            if (counter.length() < 5) {
                int c = 5 - counter.length();
                for (int i = 0; i < c; i++) {
                    space += " ";
                }
                dataToPrint = dataToPrint + ("Counter : " + counter + space);
            } else {
                dataToPrint = dataToPrint + ("Counter : " + counter);
            }
            dataToPrint = dataToPrint + ("          ");
            space = "";
            if (userid.length() < 10) {
                int u = 10 - userid.length();
                for (int i = 0; i < u; i++) {
                    space += " ";
                }
                dataToPrint = dataToPrint + ("Cashier ID : " + space + userid + "\n");
            } else {
                dataToPrint = dataToPrint + ("Cashier ID : " + userid + "\n");
            }
            dataToPrint = dataToPrint + ("Qty-------------------------------------------Ks\n");

            long totalamount = 0;
            int totalqty = 0;

            for (int i = 0; i < detail.length(); i++) {
                JSONObject d = detail.getJSONObject(i);
                String l_SPACE = getSpace(d.getString("n8").length() + 1);
                String desc = d.getString("t3");
                String qty = d.getString("n8");

                long gg = Math.round(Double.parseDouble(qty));

                // Toast.makeText(getApplicationContext(), "qty " + qty.toString(),
                // Toast.LENGTH_SHORT).show();
                String price = d.getString("n14");
                // Toast.makeText(getApplicationContext(), "price " + price.toString(),
                // Toast.LENGTH_SHORT).show();
                long amt = Math.round(Double.parseDouble(qty) * Double.parseDouble(price));
                String amount = Long.toString(amt);
                String itemdisc = d.getString("n21");
                // Toast.makeText(getApplicationContext(), "itemDisc " + itemdisc.toString(),
                // Toast.LENGTH_SHORT).show();
                double unitdisc = Double.parseDouble(d.getString("n19"));
                // Toast.makeText(getApplicationContext(), "unitDisc " + unitdisc.toString(),
                // Toast.LENGTH_SHORT).show();
                double memberDisc = Double.parseDouble(d.getString("n35"));
                // Toast.makeText(getApplicationContext(), "memberDisc " +
                // memberDisc.toString(), Toast.LENGTH_SHORT).show();
                //totalqty += Double.parseDouble(qty);
                // Toast.makeText(getApplicationContext(), "gram qty " +
                // d.getString("t1"), Toast.LENGTH_SHORT).show();
                if (d.getString("t1").length()==13 &&
                    d.getString("t1").substring(0, 2).equals("55")) {                 
                totalqty += 1;
                //  Toast.makeText(getApplicationContext(), "gram qty " +
            //   d.getString("t1")+","+totalqty, Toast.LENGTH_SHORT).show();
                } else {
                    totalqty += Double.parseDouble(qty);
                    // totalqty+=Integer.parseInt(qty);
                }
                long idisc = Math.round(Double.parseDouble(itemdisc));
                itemdisc = Long.toString(idisc);
                totalamount += Math.round(Double.parseDouble(amount));
                Integer deleteline = d.getInt("recordStatus");
                // Toast.makeText(getApplicationContext(), "deleteLine " +
                // deleteline.toString(), Toast.LENGTH_SHORT).show();
                String sp = "";
                if (String.valueOf(gg).length() < 5) {
                    int q = 5 - String.valueOf(gg).length();
                    for (int j = 0; j < q; j++) {
                        sp += " ";
                    }
                    dataToPrint = dataToPrint + (sp + gg + " ");
                } else {
                    dataToPrint = dataToPrint + (gg) + " ";
                }
    
                if (desc.length() < 32) {
                    String s = "";
                    int slength = 32 - desc.length();
                    for (int j = 0; j < slength; j++) {
                        s += " ";
                    }
                    dataToPrint = dataToPrint + (desc + s);
                } else if (desc.length() > 32) {
                    String fsub = desc.substring(0, 32);
                    dataToPrint = dataToPrint + (fsub);
                } else {
                    dataToPrint = dataToPrint + (desc);
                }
    
                if (amount.length() < 10) {
                    String e = "";
                    int a = 10 - amount.length();
                    for (int j = 0; j < a; j++) {
                        e += " ";
                    }
                    dataToPrint = dataToPrint + (e + amount + "\n");
                } else {
                    dataToPrint = dataToPrint + (amount + "\n");
                }
                if (!itemdisc.equals("0") && deleteline != 4) {
                    if (itemdisc.length() < 10 && desc.length() <= 32) {
                        totalamount = totalamount - Long.parseLong(itemdisc);
                        itemdisc = "-" + itemdisc;
                        String ic = "";
                        int id = 10 - itemdisc.length();
                        for (int j = 0; j < id; j++) {
                            ic += " ";
                        }
                        if (unitdisc > 0)
                            dataToPrint = dataToPrint
                                    + ("                                      "
                                            + ic + itemdisc + "\n");
                    }
                    if (desc.length() > 32) {
                        String secsub = desc.substring(32, desc.length());
                        if (secsub.length() < 32) {
                            String sb = "";
                            int ss = 32 - secsub.length();
                            for (int j = 0; j < ss; j++) {
                                sb += " ";
                            }
                            dataToPrint = dataToPrint + ("      " + secsub + sb);
                        } else {
                            dataToPrint = dataToPrint + ("      " + secsub);
                        }
                        if (itemdisc.length() < 10) {
                            totalamount = totalamount - Long.parseLong(itemdisc);
                            itemdisc = "-" + itemdisc;
                            String ic = "";
                            int id = 10 - itemdisc.length();
                            for (int j = 0; j < id; j++) {
                                ic += " ";
                            }
                            if (unitdisc > 0)
                                dataToPrint = dataToPrint + (ic + itemdisc + "\n");
                        } else {
                            if (unitdisc > 0)
                                dataToPrint = dataToPrint + (itemdisc + "\n");
                        }
                    }
                } else {
                    if (desc.length() > 32) {
                        String secsub = desc.substring(33, desc.length());
                        dataToPrint = dataToPrint + ("      " + secsub + "\n");
                    }
                }
    
                if (memberDisc > 0) {
                    String l_PromotionCode = "";
                    String l_promoDesc = d.getString("t7");
                    String[] ArrPromotionCode = l_promoDesc.split(",");
                    ArrayList<String> lstPromotionCode = new ArrayList<String>();
                    int l_Count = 0;
                    String l_MDiscount = "";
                    for (int m = 0; m < ArrPromotionCode.length; m++) {
                        lstPromotionCode.add(ArrPromotionCode[m]);
                    }
                    String code = "";
                    for (int c = 0; c < lstPromotionCode.size(); c++) {
                        code = lstPromotionCode.get(c);
                        if (code != "") {
                            if (l_Count == 0)
                                l_MDiscount = "-" + memberDisc;
                            else
                                l_MDiscount = "";
                            String C_Code = code.split("-")[0].trim();
                            String C_Qty = code.split("-")[1].trim();
                            if (C_Code.length() > 34) {
                                String l_FirstCode = C_Code.substring(0, 34);
                                String l_SecondCode = l_SPACE
                                        + C_Code.substring(33, C_Code.length());
    
                                l_PromotionCode = " *"
                                        + l_FirstCode
                                        + getSpace(46 - (l_FirstCode.length() + l_MDiscount
                                                .length())) + l_MDiscount;
                                dataToPrint = dataToPrint
                                        + (l_PromotionCode + "\n");
                                if (l_SecondCode.length() > 34) {
                                    String l_SecondCode_1 = l_SecondCode.substring(
                                            0, 34);
    
                                    l_PromotionCode = l_SecondCode_1
                                            + getSpace(48 - (l_SecondCode_1
                                                    .length() + l_MDiscount
                                                    .length())) + l_MDiscount;
                                    dataToPrint = dataToPrint
                                            + (l_PromotionCode + "\n");   
                                    
                                } else {
                                    String s = C_Qty.trim();
                                    double dv = Double.parseDouble(s);
                                    int iv = (int) dv;
                                    dataToPrint = dataToPrint
                                            + (l_SecondCode + "(" + iv + ")" + "\n");
                                }
                                l_Count += 1;
                            } else {
                                l_PromotionCode = " *"
                                        + code.split("-")[0].trim()
                                        + "("
                                        + code.split("-")[1].trim()
                                        + ")"
                                        + getSpace(44 - (code.split("-")[0].trim()
                                                .length() + l_MDiscount.length()))
                                        + l_MDiscount;
                                dataToPrint = dataToPrint
                                        + (l_PromotionCode + "\n");
                                l_Count += 1;
                            }
                        }
                    }
                }
                if (Integer.parseInt(d.getString("n31")) == 80) {
                    for (int s = 0; s < serialDataList.length(); s++) {
                        JSONObject serialData = serialDataList.getJSONObject(s);
                        String itemCodeStr = serialData.getString("productcode");
                        String[] itemCodeArr = itemCodeStr.split("-");
                        if (itemCodeArr[0].equals(d.getString("t2"))) {
                            dataToPrint = dataToPrint + "    Serial No. "
                                    + serialData.getString("serialno") + "\n";
                        }
                    }
                }
                if (deleteline == 4) {
                    sp = "";
                    qty = "-" + qty;
                    amount = "-" + amount;
                    if (String.valueOf(gg).length() < 4) {
                        int q = 4 - String.valueOf(gg).length();
                        for (int j = 0; j < q; j++) {
                            sp += " ";
                        }
                        dataToPrint = dataToPrint + (sp +"-"+ gg) + " ";
                    } else {
                        dataToPrint = dataToPrint + "-"+(gg) + " ";
                    }
    
                    if (desc.length() < 32) {
                        String s = "";
                        int slength = 32 - desc.length();
                        for (int j = 0; j < slength; j++) {
                            s += " ";
                        }
                        dataToPrint = dataToPrint + (desc + s);
                    } else if (desc.length() > 32) {
                        String fsub = desc.substring(0, 32);
                        dataToPrint = dataToPrint + (fsub);
                    } else {
                        dataToPrint = dataToPrint + (desc);
                    }
    
                    if (amount.length() < 10) {
                        String e = "";
                        int a = 10 - amount.length();
                        for (int j = 0; j < a; j++) {
                            e += " ";
                        }
                        dataToPrint = dataToPrint + (e + amount + "\n");
                    } else {
                        dataToPrint = dataToPrint + (amount + "\n");
                    }
                    if (desc.length() > 32) {
                        String secsub = desc.substring(33, desc.length());
                        dataToPrint = dataToPrint + ("      " + secsub + "\n");
                    }
                    // totalqty = totalqty + Integer.parseInt(qty);
                    //totalqty += Double.parseDouble(qty);
                    if (d.getString("t1").length()==13 &&
                        d.getString("t1").substring(0, 2).equals("55")) {                
                        totalqty += (-1);
                    } else {
                        totalqty += Double.parseDouble(qty);
                        // totalqty+=Integer.parseInt(qty);
                    }
                    totalamount = Math.round(totalamount
                            + Double.parseDouble(amount));
                    ;// Seprator
                }
            }

            dataToPrint = dataToPrint + ("------------------------------------------------\n");
            String totqty = Integer.toString(totalqty);
            String totamt = NumberFormat.getNumberInstance(Locale.US).format(totalamount) + "";

            if (totqty.length() < 5) {
                String b = "";
                int t = 5 - totqty.length();
                for (int j = 0; j < t; j++) {
                    b += " ";
                }
                dataToPrint = dataToPrint + (b + totqty) + " ";
            } else {
                dataToPrint = dataToPrint + (totqty) + " ";
            }
            dataToPrint = dataToPrint + ("Total:(Inclusive Tax)           ");
            if (totamt.length() < 10) {
                String m = "";
                int tamt = 10 - totamt.length();
                for (int j = 0; j < tamt; j++) {
                    m += " ";
                }
                dataToPrint = dataToPrint + (m + totamt + "\n");
            } else {
                dataToPrint = dataToPrint + (totamt + "\n");
            }

            if (!headerdisc.equals("0")) {
                dataToPrint = dataToPrint + ("    Discount:                         ");
                if (headerdisc.length() < 10) {
                    String hdisc = "";
                    int hd = 10 - headerdisc.length();
                    for (int j = 0; j < hd; j++) {
                        hdisc += " ";
                    }
                    dataToPrint = dataToPrint + (hdisc + headerdisc + "\n");
                } else {
                    dataToPrint = dataToPrint + (headerdisc + "\n");
                }

                nett_amt = NumberFormat.getNumberInstance(Locale.US).format(totalamount);
                dataToPrint = dataToPrint + ("    Nett-Amount:                      ");
                if (nett_amt.length() < 10) {
                    String namt = "";
                    int nt = 10 - nett_amt.length();
                    for (int j = 0; j < nt; j++) {
                        namt += " ";
                    }
                    dataToPrint = dataToPrint + (namt + nett_amt + "\n");
                } else {
                    dataToPrint = dataToPrint + (nett_amt + "\n");
                }
            }

            dataToPrint = dataToPrint + ("      Commercial Tax:                   ");
            if (taxamt.length() < 10) {
                String tamt = "";
                int tt = 10 - taxamt.length();
                for (int j = 0; j < tt; j++) {
                    tamt += " ";
                }
                dataToPrint = dataToPrint + (tamt + taxamountint + "\n");
            } else {
                dataToPrint = dataToPrint + (taxamountint + "\n");
            }
            dataToPrint = dataToPrint + ("------------------------------------------------\n");

            long paidamt = 0;
            long changeamt = 0;
            String rateflag = "";
            for (int i = 0; i < payment.length(); i++) {
                JSONObject p = payment.getJSONObject(i);
                String payTypeCode = p.getString("payTypeCode");
                String payTypeDesc = "";
                if (payTypeCode.equals("VISA") || payTypeCode.equals("MASTER") || payTypeCode.equals("JCB")
                        || payTypeCode.equals("MPU") || payTypeCode.equals("UPI")) {
                    payTypeDesc = payTypeCode;
                } else {
                    payTypeDesc = p.getString("t2");
                }
                // String payTypeDesc = p.getString("t2");
                double curRate = Double.parseDouble(p.getString("n4"));
                String paid = p.getString("n3");
                // Toast.makeText(getApplicationContext(), "paid " + paid.toString(),
                // Toast.LENGTH_SHORT).show();
                Long pd = Math.round(Double.parseDouble(paid));
                if (pd > 0) {
                    if (payTypeDesc.equals("KS")) {
                        paidamt += pd;
                    } else {
                        Double pamt = Double.parseDouble(paid) * curRate;
                        paidamt += pamt;
                    }
                    if (payTypeCode.equals("20")) {
                        String payCardType = "";
                        for (int c = 0; c < t2pPaymentData.length(); c++) {
                            JSONObject tPay = t2pPaymentData.getJSONObject(c);
                            payCardType = tPay.getString("paymentType");
                            if (payCardType.equals("CITYPOINT"))
                                payTypeDesc = tPay.getString("paidBy");
                        }
                        payTypeDesc = payTypeDesc + "(Points)";
                    } else if (payTypeCode.equals("19")) {
                        String payCardType = "";
                        for (int c = 0; c < t2pPaymentData.length(); c++) {
                            JSONObject tPay = t2pPaymentData.getJSONObject(c);
                            payCardType = tPay.getString("paymentType");
                            if (payCardType.equals("CITYCASH"))
                                payTypeDesc = tPay.getString("paidBy");
                        }
                        payTypeDesc = payTypeDesc + "(Ks)";
                    } else if (payTypeDesc.equals("KS")) {
                        payTypeDesc = "Cash(Ks)";
                    }
                    payTypeDesc = "Paid By: " + payTypeDesc;
                    if (Integer.parseInt(header.getString("n30")) != 1) {
                        paid = "-" + paid;
                    }
                    if (payTypeDesc.length() > 38) {
                        String RDesc_1 = payTypeDesc.substring(0, 38);
                        String RDesc_2 = payTypeDesc.substring(RDesc_1.length(), payTypeDesc.length());
                        dataToPrint = dataToPrint
                                + (RDesc_1 + getSpace(48 - (RDesc_1.length() + paid.length() + 1)) + paid + "\n");

                        if (RDesc_2.length() > 38) {
                            String First = RDesc_2.substring(0, 38);
                            String Second = RDesc_2.substring(First.length(), RDesc_2.length());
                            dataToPrint = dataToPrint + First + "\n";
                            dataToPrint = dataToPrint + Second + "\n";
                        } else {
                            dataToPrint = dataToPrint + RDesc_2 + "\n";
                        }
                    } else {
                        String rAmount = paid + "";
                        dataToPrint = dataToPrint + payTypeDesc
                                + getSpace(48 - (payTypeDesc.length() + rAmount.length())) + rAmount + "\n";
                    }

                    if (curRate > 1) {
                        // paid = payTypeDesc + " " + paid;
                        rateflag = "true";
                    }
                } else {
                    changeamt = pd;
                }
            }
            dataToPrint = dataToPrint + ("------------------------------------------------\n");

            if (rateflag.equals("true")) {
                String pdamt = Long.toString(paidamt);
                dataToPrint = dataToPrint + ("    Paid Ks                           ");
                if (pdamt.length() < 10) {
                    String v = "";
                    int clength = 10 - pdamt.length();
                    for (int i = 0; i < clength; i++) {
                        v += " ";
                    }
                    dataToPrint = dataToPrint + (v + pdamt + "\n");
                } else {
                    dataToPrint = dataToPrint + (pdamt + "\n");
                }
                dataToPrint = dataToPrint + ("------------------------------------------------\n");
            }

            String change = "";
            if (changeamt != 0) {
                change = Long.toString(changeamt);
                dataToPrint = dataToPrint + ("Changed:                           Ks ");
                if (change.length() < 10) {
                    String v = "";
                    int clength = 10 - change.length();
                    for (int i = 0; i < clength; i++) {
                        v += " ";
                    }
                    dataToPrint = dataToPrint + (v + change + "\n");
                } else {
                    dataToPrint = dataToPrint + (change + "\n");
                }
                dataToPrint = dataToPrint + ("------------------------------------------------\n");
            }
            if (!header.getString("t15").equals("") && isreprint.equals("true")) {
                String cardNumber = header.getString("t15");
                dataToPrint = dataToPrint + ("Member Card ID  :" + cardNumber + "\n");
                dataToPrint = dataToPrint + ("------------------------------------------------\n");
            }
            if (t2pPrintData != null && !t2pPrintData.isNull("cardNumber")) {
                String cardType = t2pPrintData.getString("cardType");
                String cardNumber = t2pPrintData.getString("cardNumber");
                String holderName = t2pPrintData.getString("holderName");
                // Toast.makeText(getApplicationContext(), "holderName " +
                // holderName.toString(), Toast.LENGTH_SHORT).show();

                dataToPrint = dataToPrint + ("Member Card Type:" + cardType + "\n");
                dataToPrint = dataToPrint + ("Member Card ID  :" + cardNumber + "\n");
                dataToPrint = dataToPrint + ("Name            :" + holderName + "\n");

                for (int i = 0; i < t2pPaymentData.length(); i++) {
                    JSONObject tPay = t2pPaymentData.getJSONObject(i);
                    String payCardType = tPay.getString("paymentType");
                    String paidBy = tPay.getString("paidBy");
                    String payCardNumber = tPay.getString("cardNumber");
                    // Toast.makeText(getApplicationContext(), "payCardNumber " +
                    // payCardNumber.toString(), Toast.LENGTH_SHORT).show();

                    if (payCardType.equals("CITYCASH")) {
                        dataToPrint = dataToPrint + ("------------------------------------------------\n");
                        String prevAmtStr = tPay.getString("prevAmt");
                        String cardBalStr = tPay.getString("amtBalance");
                        // Toast.makeText(getApplicationContext(), "cardBalStr " +
                        // cardBalStr.toString(), Toast.LENGTH_SHORT).show();
                        long prevAmt = Math.round(Double.parseDouble(prevAmtStr));
                        long cardBal = Math.round(Double.parseDouble(cardBalStr));
                        String prevAmtPrint = NumberFormat.getNumberInstance(Locale.US).format(prevAmt);
                        String cardBalPrint = NumberFormat.getNumberInstance(Locale.US).format(cardBal);
                        dataToPrint = dataToPrint + ("Paid By             :" + paidBy + "\n");
                        dataToPrint = dataToPrint + ("Card Number         :" + payCardNumber + "\n");
                        dataToPrint = dataToPrint + ("Previous Balance(Ks):" + fillSpace(prevAmtPrint, 27) + "\n");
                        dataToPrint = dataToPrint + ("Card Balance        :" + fillSpace(cardBalPrint, 27) + "\n");

                    } else if (payCardType.equals("CITYPOINT")) {
                        dataToPrint = dataToPrint + ("------------------------------------------------\n");
                        String prevPointStr = tPay.getString("prevPoint");
                        String pointBalStr = tPay.getString("pointBalance");
                        // Toast.makeText(getApplicationContext(), "pointBalStr " +
                        // pointBalStr.toString(), Toast.LENGTH_SHORT).show();
                        long prevPoint = Math.round(Double.parseDouble(prevPointStr));
                        long pointBal = Math.round(Double.parseDouble(pointBalStr));
                        String prevPointPrint = NumberFormat.getNumberInstance(Locale.US).format(prevPoint);
                        String pointBalPrint = NumberFormat.getNumberInstance(Locale.US).format(pointBal);
                        dataToPrint = dataToPrint + ("Paid By             :" + paidBy + "\n");
                        dataToPrint = dataToPrint + ("Card Number         :" + payCardNumber + "\n");
                        dataToPrint = dataToPrint + ("Previous Points     :" + fillSpace(prevPointPrint, 27) + "\n");
                        dataToPrint = dataToPrint + ("Point Balance       :" + fillSpace(pointBalPrint, 27) + "\n");
                    }
                }
                // dataToPrint = dataToPrint
                // + ("------------------City Rewards------------------\n");
                int PointTemp = 0;
                int CashTemp = 0;
                String PointExp = "";
                int pRewardCounts = 0;
                double l_RewardAmount = 0;
                if (t2pPrintData != null) {
                    JSONArray t2pRewards = t2pPrintData.getJSONArray("rewards");
                    for (int i = 0; i < t2pRewards.length(); ++i) {
                        JSONObject reward = t2pRewards.getJSONObject(i);
                        if (reward.getString("rewardType").equals("Credit-CITYPOINT")) {
                            pRewardCounts++;
                        }
                    }

                    for (int r = 0; r < t2pRewards.length(); r++) {
                        JSONObject reward = t2pRewards.getJSONObject(r);
                        String rewardTitle = reward.getString("rewardTitle");
                        String rewardType = reward.getString("rewardType");
                        String rewardDesc = reward.getString("rewardDescription");
                        // Toast.makeText(getApplicationContext(), "rewardDesc " +
                        // rewardDesc.toString(), Toast.LENGTH_SHORT).show();
                        double rewardAmt = Double.parseDouble(reward.get("rewardAmount").toString());
                        // String rewardAmtStr = rewardAmt+"";
                        String rewardAmtStr = NumberFormat.getNumberInstance(Locale.US).format(rewardAmt) + "";
                        // long rewardPoint = Math.round(Double.parseDouble(reward
                        // .getString("rewardPoint")));

                        JSONArray coupons = reward.getJSONArray("coupons");

                        if (rewardType.equals("Credit-CITYPOINT")) {
                            if (PointTemp == 0) {
                                dataToPrint = dataToPrint + "------------------City Rewards------------------\n";
                                dataToPrint = dataToPrint + "Points Earned\n";
                            }

                            // l_RewardAmount += rewardPoint;
                            l_RewardAmount += rewardAmt;
                            if (rewardDesc.length() > 38) {
                                String RDesc_1 = rewardDesc.substring(0, 38);
                                String RDesc_2 = rewardDesc.substring(RDesc_1.length(), rewardDesc.length());
                                dataToPrint = dataToPrint
                                        + ("*" + RDesc_1 + getSpace(47 - (RDesc_1.length() + rewardAmtStr.length() + 1))
                                                + rewardAmtStr + "\n");

                                if (RDesc_2.length() > 38) {
                                    String First = RDesc_2.substring(0, 38);
                                    String Second = RDesc_2.substring(First.length(), RDesc_2.length());
                                    dataToPrint = dataToPrint + First + "\n";
                                    dataToPrint = dataToPrint + Second + "\n";
                                } else {
                                    dataToPrint = dataToPrint + RDesc_2 + "\n";
                                }
                            } else {
                                // String rAmount = rewardAmt + "";
                                String rAmount = NumberFormat.getNumberInstance(Locale.US).format(rewardAmt) + "";
                                dataToPrint = dataToPrint + "*" + rewardDesc
                                        + getSpace(47 - (rewardDesc.length() + rAmount.length())) + rAmount + "\n";
                            }

                            PointTemp++;
                            if (PointTemp == pRewardCounts) {
                                if (PointTemp > 0) {
                                    // String rewardPointStr = NumberFormat.getNumberInstance(
                                    // Locale.US).format(rewardPoint)
                                    // + "";
                                    // if (rewardPointStr.length() < 10) {
                                    // String rw = "";
                                    // int tt = 10 - rewardPointStr.length();
                                    // for (int j = 0; j < tt; j++) {
                                    // rw += " ";
                                    // }
                                    // dataToPrint = dataToPrint + (rw + rewardPointStr + "\n");
                                    // } else {
                                    // dataToPrint = dataToPrint + (rewardPointStr + "\n");
                                    // }

                                    long pointBalance = Math
                                            .round(Double.parseDouble(t2pPrintData.getString("earnedPoint")));
                                    long creditExpirePoint = Math
                                            .round(Double.parseDouble(t2pPrintData.getString("creditExpirePoint")));
                                    String expireDate = t2pPrintData.getString("expireDate");
                                    // Toast.makeText(getApplicationContext(), "expiredDate " +
                                    // expireDate.toString(), Toast.LENGTH_SHORT).show();
                                    String eDay = expireDate.substring(8, 10);
                                    String eMon = expireDate.substring(5, 7);
                                    String eYear = expireDate.substring(0, 4);
                                    expireDate = eDay + "/" + eMon + "/" + eYear;

                                    dataToPrint = dataToPrint + ("Points Balance:                       ");
                                    String pointBalanceStr = NumberFormat.getNumberInstance(Locale.US)
                                            .format(pointBalance) + "";
                                    if (pointBalanceStr.length() < 10) {
                                        String rw = "";
                                        int tt = 10 - pointBalanceStr.length();
                                        for (int j = 0; j < tt; j++) {
                                            rw += " ";
                                        }
                                        dataToPrint = dataToPrint + (rw + pointBalanceStr + "\n");
                                    } else {
                                        dataToPrint = dataToPrint + (pointBalanceStr + "\n");
                                    }
                                    String creditExpirePointStr = NumberFormat.getNumberInstance(Locale.US)
                                            .format(creditExpirePoint) + "";
                                    dataToPrint = dataToPrint + ("*** " + creditExpirePointStr
                                            + " points will expire on " + expireDate + ".\n");
                                    dataToPrint = dataToPrint + ("------------------------------------------------\n");
                                }
                            }

                        } else if (!rewardType.equals("Coupon") && !rewardType.equals("Credit-CITYPOINT")) {
                            if (rewardAmt > 1) {
                                dataToPrint = dataToPrint + "\n";
                                String[] arrDesc = rewardDesc.split("\\|");
                                for (int d = 0; d < arrDesc.length; d++) {
                                    String descr = arrDesc[d];
                                    // String strRewardAmt = rewardAmt + "";
                                    String strRewardAmt = NumberFormat.getNumberInstance(Locale.US).format(rewardAmt)
                                            + "";

                                    if (descr.length() > 38) {
                                        String Desc_1 = descr.substring(0, 38);
                                        String Desc_2 = descr.substring(Desc_1.length(), descr.length());

                                        dataToPrint = dataToPrint
                                                + (Desc_1 + getSpace(48 - (Desc_1.length() + strRewardAmt.length()))
                                                        + strRewardAmt + "\n");
                                        if (Desc_2.length() > 38) {
                                            String Desc_2_1 = Desc_2.substring(0, 38);
                                            String Desc_2_2 = Desc_2.substring(Desc_2_1.length(), Desc_2.length());
                                            dataToPrint = dataToPrint + Desc_2_1 + "\n";
                                            dataToPrint = dataToPrint + Desc_2_2 + "\n";
                                        } else {
                                            dataToPrint = dataToPrint + Desc_2 + "\n";
                                        }
                                    } else {
                                        dataToPrint = dataToPrint + descr
                                                + getSpace(48 - (descr.length() + strRewardAmt.length())) + strRewardAmt
                                                + "\n";
                                    }
                                }
                                CashTemp++;
                            }

                        } else if (rewardType.equals("Coupon")) {
                            // dataToPrint = dataToPrint +
                            // "------------------------------------------------\n";
                            dataToPrint = dataToPrint + rewardTitle + "\n";

                            for (int j = 0; j < coupons.length(); j++) {
                                JSONObject coupon = coupons.getJSONObject(j);
                                String expDate = coupon.get("dateExpire").toString();

                                String exp3 = expDate.substring(0, 4);
                                String exp2 = expDate.substring(5, 7);
                                String exp1 = expDate.substring(8, 10);
                                expDate = exp1 + "/" + exp2 + "/" + exp3;
                                dataToPrint = dataToPrint + coupon.get("couponCode") + "\n";
                                dataToPrint = dataToPrint + "Exp Date : " + expDate + "\n";
                            }
                        }

                    }
                }
            }

            if (sys.getInt("n51") != 0) { // 2020/03/04 KN from here
                int couponCount = reader.getInt("couponCount");
                if (couponCount >= 1) {

                    String couponLocCode = reader.getString("savedLocationCode");
                    // Toast.makeText(getApplicationContext(), "savedLocationCode " +
                    // couponLocCode.toString(), Toast.LENGTH_SHORT).show();
                    if (couponLocCode.length() == 1) {
                        couponLocCode = "000" + couponLocCode;
                    } else if (couponLocCode.length() == 2) {
                        couponLocCode = "00" + couponLocCode;
                    } else if (couponLocCode.length() == 3) {
                        couponLocCode = "0" + couponLocCode;
                    }
                    // String couponLocCode = String.format("%04d",
                    // Integer.parseInt(reader.getString("locationCode"))); due to String
                    // locationCode(not int)
                    String couponCounterNo = String.format("%02d", Integer.parseInt(counter));
                    String couponSlipNo = String.format("%04d", Integer.parseInt(slipno));
                    // date
                    String strCouponCount = String.format("%03d", couponCount);

                    String strCoupon = couponLocCode + "-" + couponCounterNo + "-" + couponSlipNo + "-" + date + "-"
                            + strCouponCount;

                    dataToPrint = dataToPrint + "" + sys.getString("t40") + "\n";
                    dataToPrint = dataToPrint + strCoupon + "\n";

                    dataToPrint = dataToPrint + ("------------------------------------------------\n");
                }
            } // KN to here

            dataToPrint = dataToPrint + ("\n");
            if (Integer.parseInt(header.getString("n30")) == 1) {
                dataToPrint = dataToPrint + ("                   " + "Thank You" + "                    ");
            }
            dataToPrint = dataToPrint + ("\n\n");
            //  Toast.makeText(getApplicationContext(), "dataToPrint " +
            //  dataToPrint.toString(), Toast.LENGTH_SHORT).show();

        } catch (Exception e) {
            Toast.makeText(getApplicationContext(), "Print error... " + e.toString(), Toast.LENGTH_SHORT).show();
        }
        return dataToPrint;

    }

    public String fillSpace(String msg, int count) throws IOException {
        String result = msg;
        if (msg.length() < count) {
            String v = "";
            int clength = count - msg.length();
            for (int i = 0; i < clength; i++) {
                v += " ";
            }
            result = v + msg;
        }
        return result;
    }

    private String getSpace(int aLength) {
        String l_Result = "";

        for (int i = 0; i < aLength; i++) {
            l_Result += " ";
        }
        return l_Result;
    }

    public boolean openTerminal() {
        boolean isopened = false;

        try {
            // Toast.makeText(getApplicationContext(), "Open Terminal... ",
            // Toast.LENGTH_SHORT).show();
            isopened = openTerminalDevice();
        } catch (Exception e) {
            e.printStackTrace();
            // Toast.makeText(getApplicationContext(), "Can't Open Terminal >>" +
            // e.toString(), Toast.LENGTH_SHORT);
        }
        // Toast.makeText(getApplicationContext(), "isopened... " + isopened,
        // Toast.LENGTH_SHORT).show();

        return isopened;
    }

    public boolean openTerminalDevice() {
        boolean requested = false;
        // mManager = (UsbManager) getSystemService(Context.USB_SERVICE);
        try {
            List<UsbSerialDriver> availableDrivers = UsbSerialProber.getDefaultProber().findAllDrivers(mManager);
            // Toast.makeText(getApplicationContext(), "availableDrivers... " +
            // availableDrivers, Toast.LENGTH_SHORT).show();

            if (availableDrivers.isEmpty()) {
                // Toast.makeText(getApplicationContext(), "Available device >>",
                // Toast.LENGTH_SHORT).show();
                UsbDevice mDevice = null;
                // Toast.makeText(getApplicationContext(), "mdevicelists... " +
                // mManager.getDeviceList().values(), Toast.LENGTH_SHORT).show();
                for (UsbDevice device : mManager.getDeviceList().values()) {
                    if (device.getVendorId() == 4554 && device.getProductId() == 546) {
                        mDevice = device;
                        mManager.requestPermission(mDevice, mPermissionIntent);
                        requested = true;
                    }
                }
            } else {
                // Open a connection to the first available driver.
                driver = availableDrivers.get(0);
                UsbDeviceConnection connection = mManager.openDevice(driver.getDevice());
                if (driver != null) {
                    mManager.requestPermission(driver.getDevice(), mPermissionIntent);
                    requested = true;
                }
            }

        } catch (Exception e) {
            // Toast.makeText(getApplicationContext(), "Error Terminal Device >>" +
            // e.toString(), Toast.LENGTH_SHORT)
            // .show();
        }
        return requested;
    }

    public String terminalPayment(String mbalanceDue) {
        String result = "";
        Message msg = null;
        Double mAmount = Double.parseDouble(mbalanceDue);
        try {
            
            msg = sendMessage(mAmount);

            // Toast.makeText(getApplicationContext(),
            // "terminalPayment msg = " + msg, Toast.LENGTH_SHORT);

            TerminalResultMessage resMsg = new TerminalResultMessage();
            
                 if (msg != null) {
            //     Toast.makeText(getApplicationContext(),
            // "terminalPayment msg not null = " + msg.stx, Toast.LENGTH_SHORT);
                resMsg.setStx(msg.stx);
                resMsg.setEtx(msg.etx);
                resMsg.setLen(msg.len);
                if (msg.PaymentInfo != null) {
                    resMsg.setmRespCode(msg.PaymentInfo.mRespCode.toString());
                    resMsg.setmPAN(msg.PaymentInfo.mPAN.toString());
                    resMsg.setmSTAN(msg.PaymentInfo.mSTAN.toString());
                    resMsg.setmApprovalCode(msg.PaymentInfo.mApprovalCode.toString());
                    resMsg.setmAccountNo(msg.PaymentInfo.mAccountNo.toString());
                    resMsg.setmExpDate(msg.PaymentInfo.mExpDate.toString());
                    resMsg.setmTime(msg.PaymentInfo.mTime.toString());
                    resMsg.setmDate(msg.PaymentInfo.mDate.toString());
                    resMsg.setmAmount(msg.PaymentInfo.mAmount);
                    resMsg.setmRRN(msg.PaymentInfo.mRRN.toString());
                    resMsg.setmPOSEntry(msg.PaymentInfo.mPOSEntry.toString());
                    resMsg.setmTerminalID(msg.PaymentInfo.mTerminalID.toString());
                    resMsg.setmMerchantID(msg.PaymentInfo.mMerchantID.toString());
                    resMsg.setmInvoiceNo(msg.PaymentInfo.mInvoiceNo.toString());
                    resMsg.setmCurrencyCode(msg.PaymentInfo.mCurrencyCode.toString());
                    resMsg.setmCardType(msg.PaymentInfo.mCardType.toString());
                }
                // resMsg.setPaymentInfo(msg.PaymentInfo);
            // TerminalResultMessage resMsg = new
            // TerminalResultMessage(mAmount);
            Gson gson = new Gson();
            result = gson.toJson(resMsg);
            // Toast.makeText(getApplicationContext(),
            // "first Message >> " + resMsg,
            // Toast.LENGTH_SHORT).show();

            }

        } catch (Exception e) {
            e.printStackTrace();
            // Toast.makeText(getApplicationContext(), e.toString(),
            //         Toast.LENGTH_SHORT).show();
        }

        // Toast.makeText(getApplicationContext(),
		// 	 "result Message >> " + result,
		// 	 Toast.LENGTH_SHORT).show();

        return result;
        // String result = "";
        // TerminalResultMessage resMsg = new TerminalResultMessage();
        //  Toast.makeText(getApplicationContext(),
        //     "resMsg check = " + resMsg, Toast.LENGTH_SHORT);
        // try {
        //     // Toast.makeText(getApplicationContext(), "terminalPayment = " + mbalanceDue,
        //     // Toast.LENGTH_SHORT);

        //     Message msg = null;
        //     Double mAmount = Double.parseDouble(mbalanceDue);
        //     // Toast.makeText(getApplicationContext(),
        //     // "terminalPayment = " + mbalanceDue, Toast.LENGTH_SHORT);
        //     msg = sendMessage(mAmount);
        //     if (msg != null) {
        //         Toast.makeText(getApplicationContext(),
        //     "terminalPayment msg not null = " + msg.stx, Toast.LENGTH_SHORT);
        //         resMsg.setStx(msg.stx);
        //         resMsg.setEtx(msg.etx);
        //         resMsg.setLen(msg.len);
        //         if (msg.PaymentInfo != null) {
        //             resMsg.setmRespCode(msg.PaymentInfo.mRespCode.toString());
        //             resMsg.setmPAN(msg.PaymentInfo.mPAN.toString());
        //             resMsg.setmSTAN(msg.PaymentInfo.mSTAN.toString());
        //             resMsg.setmApprovalCode(msg.PaymentInfo.mApprovalCode.toString());
        //             resMsg.setmAccountNo(msg.PaymentInfo.mAccountNo.toString());
        //             resMsg.setmExpDate(msg.PaymentInfo.mExpDate.toString());
        //             resMsg.setmTime(msg.PaymentInfo.mTime.toString());
        //             resMsg.setmDate(msg.PaymentInfo.mDate.toString());
        //             resMsg.setmAmount(msg.PaymentInfo.mAmount);
        //             resMsg.setmRRN(msg.PaymentInfo.mRRN.toString());
        //             resMsg.setmPOSEntry(msg.PaymentInfo.mPOSEntry.toString());
        //             resMsg.setmTerminalID(msg.PaymentInfo.mTerminalID.toString());
        //             resMsg.setmMerchantID(msg.PaymentInfo.mMerchantID.toString());
        //             resMsg.setmInvoiceNo(msg.PaymentInfo.mInvoiceNo.toString());
        //             resMsg.setmCurrencyCode(msg.PaymentInfo.mCurrencyCode.toString());
        //             resMsg.setmCardType(msg.PaymentInfo.mCardType.toString());
        //         }
        //         // resMsg.setPaymentInfo(msg.PaymentInfo);

        //         // TerminalResultMessage resMsg = new
        //         // TerminalResultMessage(mAmount);

        //     }

        //     Gson gson = new Gson();
        //     result = gson.toJson(resMsg);
        //     // Toast.makeText(getApplicationContext(), "first Message >> " + result,
        //     // Toast.LENGTH_SHORT).show();

        // } catch (Exception e) {
        //     e.printStackTrace();
        //     Toast.makeText(getApplicationContext(), "terminal payment " + e.toString(), Toast.LENGTH_SHORT).show();
        // }

        // return result;

    }

    public Message sendMessage(double mbalanceDue) {
        //final Message message = null;
        mMessage = null;
        try {
            // Toast.makeText(getApplicationContext(), "sendMessage >> " + mbalanceDue,
            // Toast.LENGTH_SHORT).show();
            DecimalFormat df = new DecimalFormat("000000000000");
            String b = df.format(mbalanceDue);
            // Toast.makeText(getApplicationContext(), "b >> " + b,
            // Toast.LENGTH_SHORT).show();
            posMsg = new POSMsg(true, b);
            // Toast.makeText(getApplicationContext(), "posMsg>> " +
            // posMsg.initialBillingAmount, Toast.LENGTH_SHORT)
            // .show();
            posIntegration = new POSIntegration(V_TYPE.KBZ);

            byte[] buffer = posIntegration.sendMessage(posMsg);
            // Toast.makeText(getApplicationContext(), "buffer>> " + buffer,
            // Toast.LENGTH_SHORT).show();

            if (port != null) {
                int usbResultOut = port.write(buffer, 1000);
                // Toast.makeText(getApplicationContext(), "writeResponse >> " + usbResultOut,
                // Toast.LENGTH_SHORT).show();
                if (usbResultOut > 0) {
                    byte[] readbuff = new byte[500];
                    int usbResultIn = port.read(readbuff, 1000);
                }

                try {
                    mMessage = null;
                    boolean cancel = false;
                    int readResponse = 0;
                    long start_time = System.currentTimeMillis();
                    long wait_time = 60000;
                    long end_time = start_time + wait_time;
                    byte[] readbuff = new byte[500];
                    while (!cancel) {
                        Thread.sleep(1000);
                        readResponse = port.read(readbuff, 1000);
                        if (!(readResponse == 1 || readResponse == -1)) {
                            cancel = true;
                            mReadBuffer = Arrays.copyOfRange(mReadBuffer, 0, readResponse);
                            mMessage = posIntegration.buildResponseMessage(mReadBuffer);
                        } else if (System.currentTimeMillis() > end_time) {
                            cancel = true;
                        }
                    }

                } catch (InterruptedException e) {
                    e.printStackTrace();
                } catch (IOException e) {
                    e.printStackTrace();
                }

            } else {
                if (buffer != null) {
                    int writeResponse = write(buffer, 500);
                    // Toast.makeText(getApplicationContext(), "writeResponseN >> " + writeResponse,
                    // Toast.LENGTH_SHORT)
                    // .show();
                    if (writeResponse > 0) {
                        // int readResponse = read(new byte[4096], 4096, 500);
                        int readResponse = read(500);

                        Toast.makeText(getApplicationContext(),
								"first readResponse >> " + readResponse,
								Toast.LENGTH_SHORT).show();
                    }

                    try {
                        mMessage = null;
                        boolean cancel = false;
                        int readResponse = 0;

                        long start_time = System.currentTimeMillis();
                        long wait_time = 60000;
                        long end_time = start_time + wait_time;

                        while (!cancel) {
                            Thread.sleep(1000);
                            readResponse = read(500);
                            if (!(readResponse == 1 || readResponse == -1)) {
                                cancel = true;
                                mReadBuffer = Arrays.copyOfRange(mReadBuffer, 0, readResponse);
                                mMessage = posIntegration.buildResponseMessage(mReadBuffer);
                            } else if (System.currentTimeMillis() > end_time) {
                                cancel = true;
                            }
                        }

                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }

            }

        } catch (Exception e) {
            e.printStackTrace();
            Toast.makeText(getApplicationContext(), "send message"+e.toString(),
            Toast.LENGTH_SHORT).show();
        }

        return mMessage;
    }

    public int read(int timeoutMillis) throws IOException {
        // int numBytesRead = 0;
        // synchronized (mReadBufferLock) {
        int readNow;
        mReadBuffer = new byte[4096];
        // int bytesToBeReadTemp = bytesToBeRead;
        // while (numBytesRead < bytesToBeRead) {
        // readNow = mConnection.bulkTransfer(mWriteEndpoint, mReadBuffer,
        // mReadBuffer.length, timeoutMillis);
        // if (readNow < 0) {
        // return numBytesRead;
        // } else {
        // //Log.v(TAG, "Read something" + mReadBuffer);
        // System.arraycopy(mReadBuffer, 0, dest, numBytesRead, readNow);
        // numBytesRead += readNow;
        // bytesToBeReadTemp -= readNow;
        // mMessage = posIntegration.buildResponseMessage(mReadBuffer);
        // }
        // }
        readNow = mConnection.bulkTransfer(mWriteEndpoint, mReadBuffer, mReadBuffer.length, timeoutMillis);
        // return numBytesRead;
        // Toast.makeText(getApplicationContext(),
        // "readResponseN >> " + readNow,
        // Toast.LENGTH_SHORT).show();//DL
        return readNow;
    }

    public int write(byte[] src, int timeoutMillis) throws IOException {
        // Toast.makeText(getApplicationContext(), "src>> " + src.length,
        // Toast.LENGTH_SHORT).show();

        if (Build.VERSION.SDK_INT < 18) {
            return writeSupportAPI(src, timeoutMillis);
        }
        int written = 0;
        while (written < src.length) {
            int writeLength, amtWritten;
            // synchronized (mWriteBufferLock) {
            writeLength = Math.min(mWriteBuffer.length, src.length - written);
            // bulk transfer supports offset from API 18
            amtWritten = mConnection.bulkTransfer(mReadEndpoint, src, written, writeLength, timeoutMillis);
            // }
            if (amtWritten < 0) {
                throw new IOException(
                        "Error writing " + writeLength + " bytes at offset " + written + " length=" + src.length);
            }
            written += amtWritten;
        }
        return written;
    }

    private int writeSupportAPI(byte[] src, int timeoutMillis) throws IOException {
        int written = 0;
        while (written < src.length) {
            final int writeLength;
            final int amtWritten;
            // synchronized (mWriteBufferLock) {
            final byte[] writeBuffer;
            writeLength = Math.min(src.length - written, mWriteBuffer.length);
            if (written == 0) {
                writeBuffer = src;
            } else {
                // bulkTransfer does not support offsets for API level < 18, so
                // make a copy.
                System.arraycopy(src, written, mWriteBuffer, 0, writeLength);
                writeBuffer = mWriteBuffer;
            }
            amtWritten = mConnection.bulkTransfer(mWriteEndpoint, writeBuffer, writeLength, timeoutMillis);
            // }
            if (amtWritten <= 0) {
                throw new IOException(
                        "Error writing " + writeLength + " bytes at offset " + written + " length=" + src.length);
            }
            written += amtWritten;
        }
        return written;
    }

    public String toHexString1(int i) {
        String hexString = Integer.toHexString(i);
        if (hexString.length() % 2 != 0) {
            hexString = "0" + hexString;
        }
        return hexString.toUpperCase();
    }

    public static String getCurrentTime() {
		return new SimpleDateFormat("HHmmss").format(new Date());
	}

}
