//
// JMustache - A Java implementation of the Mustache templating language
// http://github.com/samskivert/jmustache/blob/master/LICENSE

package com.samskivert.mustache;

import java.io.IOException;
import java.io.Reader;
import java.io.StringReader;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import java.util.concurrent.ConcurrentLinkedDeque;
import java.util.concurrent.CyclicBarrier;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;

import com.samskivert.mustache.Mustache;
import com.samskivert.mustache.Template;

import org.junit.Test;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

public class ThreadSafetyTest {

    private static final String templateA = "Template A content\n{{> templateB}}";
    private static final String templateB = "Template B content";

    private static class CountingLoader implements Mustache.TemplateLoader {
        private final AtomicInteger counter = new AtomicInteger(0);

        @Override public Reader getTemplate (String name) throws Exception {
            throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
        }

        public int counter () {
            throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
        }
    }

    @Test
    public void testTemplateLoading () throws InterruptedException {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    void templateLoadingIsThreadSafe (int nThreads) throws InterruptedException {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }

    @Test
    public void testPartialThreadSafe () throws Exception {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }
}
