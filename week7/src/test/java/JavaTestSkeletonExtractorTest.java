import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.net.URISyntaxException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

import static org.junit.jupiter.api.Assertions.*;

/** 在VS Code测试面板或方法旁的Run Test按钮运行；不需要手工输入命令。 */
class JavaTestSkeletonExtractorTest {
    private static final Path ROOT = findProjectRoot();
    private static final Path BUSINESS_TESTS = ROOT.resolve("src/test/java/study/translation");

    @Test
    @DisplayName("01 提取三个业务测试类：24个测试、27个成员")
    void extractsBusinessTestDirectory() throws Exception {
        RunResult result = extract(BUSINESS_TESTS, freshOutput("directory"));
        assertEquals(0, result.exitCode(), result.log());
        JsonObject summary = result.metadata().getAsJsonObject("summary");
        assertEquals(3, summary.get("files").getAsInt());
        assertEquals(27, summary.get("members").getAsInt());
        JsonObject roles = summary.getAsJsonObject("roles");
        assertEquals(24, roles.get("test").getAsInt());
        assertEquals(1, roles.get("lifecycle_BeforeEach").getAsInt());
        assertEquals(1, roles.get("helper").getAsInt());
        assertEquals(1, roles.get("field").getAsInt());
    }

    @Test
    @DisplayName("02 单文件提取：初始化、辅助方法、断言原文不遗漏")
    void extractsSingleTestFile() throws Exception {
        RunResult result = extract(BUSINESS_TESTS.resolve("AccountTest.java"), freshOutput("single"));
        assertEquals(0, result.exitCode(), result.log());
        assertEquals(12, result.metadata().getAsJsonObject("summary").get("members").getAsInt());
        JsonObject withdrawal = findMember(result.metadata(), "testWithdraw");
        assertEquals("test", withdrawal.get("role").getAsString());
        assertTrue(withdrawal.get("original_body").getAsString().contains("account.withdraw(30)"));
        assertTrue(withdrawal.get("original_body").getAsString().contains("assertEquals(70, account.getBalance())"));
        assertEquals("lifecycle_BeforeEach", findMember(result.metadata(), "setUp").get("role").getAsString());
        assertEquals("helper", findMember(result.metadata(), "prepareSequence").get("role").getAsString());
        String skeleton = Files.readString(result.output().resolve("skeleton/AccountTest.java"));
        assertTrue(skeleton.contains("@BeforeEach"));
        assertTrue(skeleton.contains("private Account account"));
        assertTrue(skeleton.contains("SKELETON_PLACEHOLDER"));
        assertFalse(skeleton.contains("account.withdraw(30)"));
    }

    @Test
    @DisplayName("03 复杂结构：重载、嵌套类、构造器委托和注解遮蔽")
    void preservesOverloadsAndConstructorDelegation() throws Exception {
        RunResult result = extract(ROOT.resolve("tests/fixtures"), freshOutput("structures"));
        assertEquals(0, result.exitCode(), result.log());
        Set<String> ids = new HashSet<>();
        int overloads = 0;
        boolean thisCall = false, superCall = false, nestedTest = false, parameterized = false;
        for (JsonElement value : result.metadata().getAsJsonArray("members")) {
            JsonObject member = value.getAsJsonObject();
            assertTrue(ids.add(member.get("id").getAsString()), "成员标识重复");
            if (member.get("name").getAsString().equals("overloaded")) overloads++;
            if (member.has("constructor_delegation") && !member.get("constructor_delegation").isJsonNull()) {
                thisCall |= member.get("constructor_delegation").getAsString().equals("this(3);");
                superCall |= member.get("constructor_delegation").getAsString().equals("super(value);");
            }
            nestedTest |= member.get("owner").getAsString().endsWith("$NestedCase")
                    && member.get("role").getAsString().equals("test");
            parameterized |= member.get("role").getAsString().equals("test_ParameterizedTest");
        }
        assertEquals(2, overloads);
        assertTrue(thisCall && superCall, "必须保留this/super构造器委托");
        assertTrue(nestedTest && parameterized);
        assertEquals("helper", findMember(result.metadata(), "customAnnotation").get("role").getAsString());
        Set<String> warnings = new HashSet<>();
        for (JsonElement value : result.metadata().getAsJsonArray("diagnostics")) {
            warnings.add(value.getAsJsonObject().get("code").getAsString());
        }
        assertTrue(warnings.contains("UNRESOLVED_TEST_ANNOTATION"));
        assertTrue(warnings.contains("LOCAL_OR_ANONYMOUS_CLASS_IN_METHOD"));
    }

    @Test
    @DisplayName("04 回填原方法体：包含中文和表情的文件逐字节一致")
    void restoresOriginalSourceExactly() throws Exception {
        RunResult result = extract(ROOT.resolve("tests/fixtures"), freshOutput("roundtrip"));
        assertEquals(0, result.exitCode(), result.log());
        for (JsonElement fileValue : result.metadata().getAsJsonArray("files")) {
            JsonObject file = fileValue.getAsJsonObject();
            String originalFile = file.get("original_file").getAsString();
            StringBuilder restored = new StringBuilder(Files.readString(
                    result.output().resolve(file.get("skeleton_file").getAsString()), StandardCharsets.UTF_8));
            List<JsonObject> bodies = new ArrayList<>();
            for (JsonElement memberValue : result.metadata().getAsJsonArray("members")) {
                JsonObject member = memberValue.getAsJsonObject();
                if (member.get("has_body").getAsBoolean()
                        && member.getAsJsonObject("source_location").get("file").getAsString().equals(originalFile)) {
                    bodies.add(member);
                }
            }
            bodies.sort(Comparator.comparingInt((JsonObject m) -> m.getAsJsonObject("skeleton_body_location")
                    .get("start_offset_utf16").getAsInt()).reversed());
            for (JsonObject body : bodies) {
                JsonObject location = body.getAsJsonObject("skeleton_body_location");
                restored.replace(location.get("start_offset_utf16").getAsInt(),
                        location.get("end_offset_utf16_exclusive").getAsInt(), body.get("original_body").getAsString());
            }
            assertArrayEquals(Files.readAllBytes(result.output().resolve(originalFile)),
                    restored.toString().getBytes(StandardCharsets.UTF_8), file.get("source_file").getAsString());
        }
    }

    @Test
    @DisplayName("05 非法Java语法：报告错误，不能生成伪成功骨架")
    void reportsBrokenJavaSyntax() throws Exception {
        RunResult result = extract(ROOT.resolve("tests/invalid/Broken.java"), freshOutput("invalid"));
        assertEquals(1, result.exitCode());
        assertTrue(result.metadata().getAsJsonObject("summary").get("errors").getAsInt() > 0);
        JsonObject file = result.metadata().getAsJsonArray("files").get(0).getAsJsonObject();
        assertEquals("syntax_error", file.get("status").getAsString());
        assertTrue(file.get("skeleton_file").isJsonNull());
        assertFalse(Files.exists(result.output().resolve("skeleton/Broken.java")));
    }

    @Test
    @DisplayName("06 输出保护：已有非空目录不能覆盖")
    void protectsExistingOutput() throws Exception {
        Path output = freshOutput("protected");
        Files.createDirectories(output);
        Path marker = output.resolve("keep.txt");
        Files.writeString(marker, "请保留已有文件", StandardCharsets.UTF_8);
        RunResult result = extract(BUSINESS_TESTS, output);
        assertNotEquals(0, result.exitCode());
        assertEquals("请保留已有文件", Files.readString(marker, StandardCharsets.UTF_8));
        assertFalse(Files.exists(output.resolve("members.json")));
    }

    // 每个测试使用独立输出目录；点击重复运行不会覆盖上一次的结果。
    private static Path freshOutput(String label) throws IOException {
        Path parent = ROOT.resolve("generated/vscode-tests");
        Files.createDirectories(parent);
        return parent.resolve(label + "-" + UUID.randomUUID());
    }

    // 使用独立JVM，防止提取器的System.exit影响VS Code中的JUnit运行器。
    private static RunResult extract(Path input, Path output) throws Exception {
        String executable = System.getProperty("os.name").startsWith("Windows") ? "java.exe" : "java";
        Path java = Path.of(System.getProperty("java.home"), "bin", executable);
        Path classes = Path.of(JavaTestSkeletonExtractor.class.getProtectionDomain().getCodeSource().getLocation().toURI());
        Path log = output.resolveSibling(output.getFileName() + ".log");
        Process process = new ProcessBuilder(java.toString(), "-Dfile.encoding=UTF-8", "--add-modules", "jdk.compiler",
                "-cp", classes.toString(), "JavaTestSkeletonExtractor", "--input", input.toString(), "--output", output.toString())
                .directory(ROOT.toFile()).redirectErrorStream(true).redirectOutput(log.toFile()).start();
        if (!process.waitFor(30, TimeUnit.SECONDS)) {
            process.destroyForcibly();
            fail("提取器运行超过30秒，日志：" + log);
        }
        String text = Files.readString(log, StandardCharsets.UTF_8);
        Path metadata = output.resolve("members.json");
        JsonObject parsed = Files.exists(metadata)
                ? JsonParser.parseString(Files.readString(metadata, StandardCharsets.UTF_8)).getAsJsonObject() : null;
        System.out.println("提取结果：" + output);
        return new RunResult(process.exitValue(), text, output, parsed);
    }

    private static JsonObject findMember(JsonObject metadata, String name) {
        for (JsonElement value : metadata.getAsJsonArray("members")) {
            JsonObject member = value.getAsJsonObject();
            if (member.get("name").getAsString().equals(name)) return member;
        }
        throw new AssertionError("未找到成员：" + name);
    }

    private static Path findProjectRoot() {
        try {
            Path current = Path.of(JavaTestSkeletonExtractorTest.class.getProtectionDomain().getCodeSource().getLocation().toURI());
            while (current != null) {
                if (Files.exists(current.resolve("src/main/java/JavaTestSkeletonExtractor.java"))) return current;
                current = current.getParent();
            }
        } catch (URISyntaxException e) {
            throw new IllegalStateException(e);
        }
        throw new IllegalStateException("请在VS Code中打开week7-skeleton-reference项目根目录。");
    }

    private record RunResult(int exitCode, String log, Path output, JsonObject metadata) { }
}
