package HttpClient;

/**
 * Created by lflorit on 2/18/15.
 */
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.net.Authenticator;
import java.net.HttpURLConnection;
import java.net.PasswordAuthentication;
import java.net.URL;
import java.util.Scanner;
import com.parse.Parse;
import com.google.gson.JsonObject;
import com.parse.ParseUser;

import android.app.Activity;
import android.app.IntentService;
import android.os.AsyncTask;
import android.provider.Settings.Secure;
import android.telephony.TelephonyManager;
import android.content.Context;

import org.json.JSONException;
import org.json.JSONObject;

public class HttpClient {


    public static String CallApiOverHttp(String aVerb, String aURI, final String aLogin, final String aPassword, String jsonPayload) {

        String jsonResponse = "";
        try {

            URL url = new URL(aURI);
            HttpURLConnection httpCon = (HttpURLConnection) url.openConnection();
            httpCon.setDoOutput(true);
            httpCon.setRequestProperty("Content-Type", "application/json");
            httpCon.setRequestProperty("Accept", "application/json");
            httpCon.setRequestMethod(aVerb);
            Authenticator.setDefault(new Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(aLogin, aPassword.toCharArray());
                }
            });
            if (aVerb != "DELETE" && aVerb != "GET") {
                OutputStreamWriter out = new OutputStreamWriter(
                        httpCon.getOutputStream());
                out.write(jsonPayload);
                out.close();
            }
            Scanner incoming = new Scanner(httpCon.getInputStream());
            jsonResponse = incoming.nextLine();
            System.out.println("Response Received: " + jsonResponse);

        } catch (IOException e) {
            e.printStackTrace();
        }
        return jsonResponse;
    }

    public static String createNewUserContainer() {

        String uri = "";
        String userID = "";
        String payload = "";
        String response = "";

        //set url
        uri = "http://52.10.62.166:8282/InCSE1/SeanUserAE/?from=http:localhost:10000&requestIdentifier=12345";

        //get userID
        userID = ParseUser.getCurrentUser().getUsername();

        //json payload
        payload = new PayloadBuilder().addCommonAttributePair("from","http:52.10.62.166:10000")
                .addCommonAttributePair("requestIdentifier","12345")
                .addCommonAttributePair("resourceType","container")
                .addContentAttributePair("labels","")
                .addContentAttributePair("resourceName",userID).build();

        //return json response from http request
        response = CallApiOverHttp("POST",uri,"admin","admin",payload);
        System.out.print(response);
        return response;

    }

    public static String createNewUUIDContainer(Context context, boolean mode) {
        // get userID
        String userID = ParseUser.getCurrentUser().getUsername();
        String response = "";
        String uri = "";
        // get device UUID
        TelephonyManager tManager = (TelephonyManager)context.getSystemService(Context.TELEPHONY_SERVICE);
        String uuid = tManager.getDeviceId();


        // url for request. if mode = TRUE, creates UUID container in SeanUserAE.
        //                  if mode = FALSE, creates UUID contaier in SeanLocationAE/Things
        if (mode)
        {
            uri = "http://52.10.62.166:8282/InCSE1/SeanUserAE/" + userID + "/?from=http:localhost:10000&requestIdentifier=12345";
        }
        else
        {
            uri = "http://52.10.62.166:8282/InCSE1/SeanLocationAE/Things/?from=http:localhost:10000&requestIdentifier=12345";
        }

        //json payload
        String payload = new PayloadBuilder().addCommonAttributePair("from","http:52.10.62.166:10000")
                .addCommonAttributePair("requestIdentifier","12345")
                .addCommonAttributePair("resourceType","container")
                .addContentAttributePair("labels","")
                .addContentAttributePair("resourceName",uuid).build();

        //return json response from http request
        response = CallApiOverHttp("POST",uri,"admin","admin",payload);
        System.out.print(response);
        return response;


    }

    public static String initializeLocContainers(Context context) {
    // this creates 4 location containers in LocationAE/Things/UUID/: LocBeacon (1), LocCMX (2), LocGPS (3), AccuracyFlag (4)
        // get userID
        String userID = ParseUser.getCurrentUser().getUsername();

        // get device UUID
        TelephonyManager tManager = (TelephonyManager)context.getSystemService(Context.TELEPHONY_SERVICE);
        String uuid = tManager.getDeviceId();

        // url for request
        String uri = "http://52.10.62.166:8282/InCSE1/SeanLocationAE/Things/" + uuid + "?from=http:localhost:10000&requestIdentifier=12345";

        //json payloads
        String payload1 = new PayloadBuilder().addCommonAttributePair("from","http:52.10.62.166:10000")
                .addCommonAttributePair("requestIdentifier","12345")
                .addCommonAttributePair("resourceType","container")
                .addContentAttributePair("labels","")
                .addContentAttributePair("resourceName","LocBeacon").build();

        String payload2 = new PayloadBuilder().addCommonAttributePair("from","http:52.10.62.166:10000")
                .addCommonAttributePair("requestIdentifier","12345")
                .addCommonAttributePair("resourceType","container")
                .addContentAttributePair("labels","")
                .addContentAttributePair("resourceName","LocCMX").build();

        String payload3 = new PayloadBuilder().addCommonAttributePair("from","http:52.10.62.166:10000")
                .addCommonAttributePair("requestIdentifier","12345")
                .addCommonAttributePair("resourceType","container")
                .addContentAttributePair("labels","")
                .addContentAttributePair("resourceName","LocGPS").build();

        String payload4 = new PayloadBuilder().addCommonAttributePair("from","http:52.10.62.166:10000")
                .addCommonAttributePair("requestIdentifier","12345")
                .addCommonAttributePair("resourceType","container")
                .addContentAttributePair("labels","")
                .addContentAttributePair("resourceName","AccuracyFlag").build();

        // mmamke the 4 new containers with http POST
        String blah = CallApiOverHttp("POST",uri,"admin","admin",payload1);
        System.out.print(blah);
        blah = CallApiOverHttp("POST",uri,"admin","admin",payload2);
        System.out.print(blah);
        blah = CallApiOverHttp("POST",uri,"admin","admin",payload3);
        System.out.print(blah);
        blah = CallApiOverHttp("POST",uri,"admin","admin",payload4);
        System.out.print(blah);

        return blah;
    }

public static String getFlagEnable(Context context) {
    // get userID
    String userID = ParseUser.getCurrentUser().getUsername();

    // get device UUID
    TelephonyManager tManager = (TelephonyManager)context.getSystemService(Context.TELEPHONY_SERVICE);
    String uuid = tManager.getDeviceId();

    // url for request
    String uri = "http://52.10.62.166:8282/InCSE1/SeanLocationAE/Things/" + uuid + "/AccuracyFlag/?from=http:localhost:10000&requestIdentifier=12345";

    String jsonResponse = CallApiOverHttp("GET",uri,"admin","admin","");

    if (jsonResponse != null)
        try
        {
                JSONObject jsonObj = new JSONObject(jsonResponse);
        }

        catch (JSONException e)
        {
            e.printStackTrace();
        }


    }



}


}