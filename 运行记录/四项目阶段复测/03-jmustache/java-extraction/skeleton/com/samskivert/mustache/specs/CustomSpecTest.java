package com.samskivert.mustache.specs;

import java.util.Collection;

import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.junit.runners.Parameterized.Parameters;

@RunWith(Parameterized.class)
public class CustomSpecTest extends SpecTest {

    public CustomSpecTest(Spec spec, String name) {
        super(spec, name);
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Parameters(name = "{1}")
    public static Collection<Object[]> data () {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }
}
