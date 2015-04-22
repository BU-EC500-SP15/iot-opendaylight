package seanliu93.compass_android;

/**
 * Created by seanliu93 on 4/1/2015.
 */

import com.parse.ParseObject;
import com.parse.ui.ParseLoginDispatchActivity;
import java.io.IOException;
import HttpClient.*;


public class DispatchLogin extends ParseLoginDispatchActivity {

    @Override
    protected Class<?> getTargetClass() {
        return MapsActivity.class;
    }
}