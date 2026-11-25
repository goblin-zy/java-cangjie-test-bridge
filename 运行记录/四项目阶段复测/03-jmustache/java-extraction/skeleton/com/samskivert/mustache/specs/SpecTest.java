package com.samskivert.mustache.specs;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.junit.Assert;
import org.junit.Test;
import org.yaml.snakeyaml.Yaml;
import org.yaml.snakeyaml.error.YAMLException;

import com.samskivert.mustache.Mustache;
import com.samskivert.mustache.Template;

public abstract class SpecTest {

    private static final Yaml yaml = new Yaml();

    private final Spec spec;
    private final String name;

    public SpecTest (Spec spec, String name) {
        super();
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test
    public void test () throws Exception {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    public static String showWhitespace (String s) {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    private static String uncrlf (String text) {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    public static Collection<Object[]> data (String specPath, String[] groups) {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    private static Iterable<Spec> getTestsForGroup (String specPath, String name) {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    private static Iterable<Spec> getTestsFromYaml(String name, String ymlPath) {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }
}
