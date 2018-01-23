package com.min.intranet.util;

import org.apache.commons.collections.map.ListOrderedMap;

/**
 * Created by bakas.
 *
 * @author eunsebi
 * @since 2016-10-12
 */
public class EgovMap extends ListOrderedMap {
    private static final long serialVersionUID = 6723434363565852261L;

    public EgovMap() {
    }

    public Object put(Object key, Object value) {
        return super.put(CamelUtil.convert2CamelCase((String)key), value);
    }
}
