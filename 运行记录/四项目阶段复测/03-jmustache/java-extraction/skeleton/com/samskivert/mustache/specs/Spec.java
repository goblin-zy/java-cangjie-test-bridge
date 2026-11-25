//
// JMustache - A Java implementation of the Mustache templating language
// http://github.com/samskivert/jmustache/blob/master/LICENSE

package com.samskivert.mustache.specs;

import java.util.Collections;
import java.util.Map;
import java.util.Map.Entry;
import java.util.function.Consumer;

/**
 * @author Yoryos Valotasios
 */
public class Spec
{
    private final Map<String, Object> map;
    private final Map<String, String> partials;

    public Spec (Map<String, Object> map) {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    public String getName () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    public String getDescription () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    public String getTemplate () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    public String getExpectedOutput () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    public Object getData () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    public String getPartial (String name) {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Override
    public String toString() {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }
}
