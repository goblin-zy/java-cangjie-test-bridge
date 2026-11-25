//
// JMustache - A Java implementation of the Mustache templating language
// http://github.com/samskivert/jmustache/blob/master/LICENSE

package com.samskivert.mustache.specs;

import java.io.Reader;
import java.io.StringReader;

import com.samskivert.mustache.Mustache;

public class SpecAwareTemplateLoader implements Mustache.TemplateLoader
{
    private static final String EMPTY_STRING = "";
    private final Spec spec;

    public SpecAwareTemplateLoader(Spec spec) {
        super();
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Override public Reader getTemplate (String name) throws Exception {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }
}
