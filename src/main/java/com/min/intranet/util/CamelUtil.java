package com.min.intranet.util;

/**
 * Created by bakas.
 *
 * @author eunsebi
 * @since 2016-10-12
 */
public class CamelUtil {
    private CamelUtil() {
    }

    public static String convert2CamelCase(String underScore) {
        if(underScore.indexOf(95) < 0 && Character.isLowerCase(underScore.charAt(0))) {
            return underScore;
        } else {
            StringBuilder result = new StringBuilder();
            boolean nextUpper = false;
            int len = underScore.length();

            for(int i = 0; i < len; ++i) {
                char currentChar = underScore.charAt(i);
                if(currentChar == 95) {
                    nextUpper = true;
                } else if(nextUpper) {
                    result.append(Character.toUpperCase(currentChar));
                    nextUpper = false;
                } else {
                    result.append(Character.toLowerCase(currentChar));
                }
            }

            return result.toString();
        }
    }
}
