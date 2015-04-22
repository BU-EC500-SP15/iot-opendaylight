package HttpClient;

/**
 * Created by seanliu93 on 4/14/2015.
 */
import com.google.gson.JsonObject;

public class PayloadBuilder {

    JsonObject object = new JsonObject();
    JsonObject content = new JsonObject();

    /**
     * CommonAttributePairs aims to hold info related the resource defined by resourceType in commonAttribute.
     *
     * @param name
     * @param value
     * @return
     */
    public PayloadBuilder addContentAttributePair(String name, String value) {
        content.addProperty(name, value);
        return this;
    }

    /**
     * CommonAttributePairs aim to hold  info related to oneM2M request.
     * Some of them are mandatory.(e.g requestIdentifier, resourceType, from)
     *
     * @param name
     * @param value
     * @return
     */
    public PayloadBuilder addCommonAttributePair(String name, String value) {
        object.addProperty(name, value);
        return this;
    }

    /**
     * Create subscription for specified resource.
     *
     * @param notificationUri         URI of subscriber
     * @param notificationContentType it should be one of "modifiedAttribute" "wholeResource" or "referenceOnly"
     * @return
     */

    public PayloadBuilder addSubscriber(String notificationUri, String notificationContentType) {
        addCommonAttributePair("resouceType", "subscription");
        addContentAttributePair("notificationURI", notificationUri);
        addContentAttributePair("notificationContentType", notificationContentType);
        return this;
    }

    public String build() {
        object.add("content", content);
        return object.toString();
    }
}
