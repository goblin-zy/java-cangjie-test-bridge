/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
// 片段编号：J001
// 环节：初始化与准备
// 维度：声明与准备
// 内容：保留声明、对象或操作：package org.apache.commons.text.similarity;
// 关联：供本类测试使用的包、框架、声明或辅助结构。
// 依据：LevenshteinDistanceTest.java原文第17行
// 待确认：无；完整接口前提见联合比较约定
package org.apache.commons.text.similarity;

// 片段编号：J002
// 环节：被测操作（结果检查）
// 维度：断言与操作
// 内容：保留本次调用及断言：import static org.assertj.core.api.Assertions.assertThat;
// 关联：供本类测试使用的包、框架、声明或辅助结构。
// 依据：LevenshteinDistanceTest.java原文第19行
// 待确认：无；完整接口前提见联合比较约定
import static org.assertj.core.api.Assertions.assertThat;
// 片段编号：J003
// 环节：被测操作（结果检查）
// 维度：断言与操作
// 内容：保留本次调用及断言：import static org.assertj.core.api.Assertions.assertThatIllegalArgumentException;
// 关联：供本类测试使用的包、框架、声明或辅助结构。
// 依据：LevenshteinDistanceTest.java原文第20行
// 待确认：无；完整接口前提见联合比较约定
import static org.assertj.core.api.Assertions.assertThatIllegalArgumentException;

// 片段编号：J004
// 环节：初始化与准备
// 维度：声明与准备
// 内容：保留声明、对象或操作：import org.junit.jupiter.api.Test;
// 关联：供本类测试使用的包、框架、声明或辅助结构。
// 依据：LevenshteinDistanceTest.java原文第22行
// 待确认：无；完整接口前提见联合比较约定
import org.junit.jupiter.api.Test;

/**
 * Tests {@link LevenshteinDistance}.
 */
// 片段编号：J005
// 环节：初始化与准备
// 维度：声明与准备
// 内容：保留声明、对象或操作：public class LevenshteinDistanceTest {
// 关联：供本类测试使用的包、框架、声明或辅助结构。
// 依据：LevenshteinDistanceTest.java原文第27行
// 待确认：无；完整接口前提见联合比较约定
public class LevenshteinDistanceTest {

    // 片段编号：J006
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：private static final LevenshteinDistance UNLIMITED_DISTANCE = new LevenshteinDistance();
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：LevenshteinDistanceTest.java原文第29行
    // 待确认：无；完整接口前提见联合比较约定
    private static final LevenshteinDistance UNLIMITED_DISTANCE = new LevenshteinDistance();

    // 片段编号：J007
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：LevenshteinDistanceTest.java原文第31行
    // 待确认：无；完整接口前提见联合比较约定
    @Test
    // 片段编号：J008
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：public void testApplyThrowsIllegalArgumentExceptionAndCreatesLevenshteinDistanceTakingInteger() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：LevenshteinDistanceTest.java原文第32行
    // 待确认：无；完整接口前提见联合比较约定
    public void testApplyThrowsIllegalArgumentExceptionAndCreatesLevenshteinDistanceTakingInteger() {
        // 片段编号：J009
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThatIllegalArgumentException().isThrownBy(() -> new LevenshteinDistance(0).apply(null, null));
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：LevenshteinDistanceTest.java原文第33行
        // 待确认：无；完整接口前提见联合比较约定
        assertThatIllegalArgumentException().isThrownBy(() -> new LevenshteinDistance(0).apply(null, null));
    }

    // 片段编号：J010
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：LevenshteinDistanceTest.java原文第36行
    // 待确认：无；完整接口前提见联合比较约定
    @Test
    // 片段编号：J011
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：public void testConstructorWithNegativeThreshold() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：LevenshteinDistanceTest.java原文第37行
    // 待确认：无；完整接口前提见联合比较约定
    public void testConstructorWithNegativeThreshold() {
        // 片段编号：J012
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThatIllegalArgumentException().isThrownBy(() -> new LevenshteinDistance(-1));
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：LevenshteinDistanceTest.java原文第38行
        // 待确认：无；完整接口前提见联合比较约定
        assertThatIllegalArgumentException().isThrownBy(() -> new LevenshteinDistance(-1));
    }

    // 片段编号：J013
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：LevenshteinDistanceTest.java原文第41行
    // 待确认：无；完整接口前提见联合比较约定
    @Test
    // 片段编号：J014
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：public void testGetLevenshteinDistance_NullString() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：LevenshteinDistanceTest.java原文第42行
    // 待确认：无；完整接口前提见联合比较约定
    public void testGetLevenshteinDistance_NullString() {
        // 片段编号：J015
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThatIllegalArgumentException().isThrownBy(() -> UNLIMITED_DISTANCE.apply("a", null));
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：LevenshteinDistanceTest.java原文第43行
        // 待确认：无；完整接口前提见联合比较约定
        assertThatIllegalArgumentException().isThrownBy(() -> UNLIMITED_DISTANCE.apply("a", null));
    }

    // 片段编号：J016
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：LevenshteinDistanceTest.java原文第46行
    // 待确认：无；完整接口前提见联合比较约定
    @Test
    // 片段编号：J017
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：public void testGetLevenshteinDistance_NullStringInt() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：LevenshteinDistanceTest.java原文第47行
    // 待确认：无；完整接口前提见联合比较约定
    public void testGetLevenshteinDistance_NullStringInt() {
        // 片段编号：J018
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThatIllegalArgumentException().isThrownBy(() -> UNLIMITED_DISTANCE.apply(null, "a"));
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：LevenshteinDistanceTest.java原文第48行
        // 待确认：无；完整接口前提见联合比较约定
        assertThatIllegalArgumentException().isThrownBy(() -> UNLIMITED_DISTANCE.apply(null, "a"));
    }

    // 片段编号：J019
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：LevenshteinDistanceTest.java原文第51行
    // 待确认：无；完整接口前提见联合比较约定
    @Test
    // 片段编号：J020
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：public void testGetLevenshteinDistance_StringNull() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：LevenshteinDistanceTest.java原文第52行
    // 待确认：无；完整接口前提见联合比较约定
    public void testGetLevenshteinDistance_StringNull() {
        // 片段编号：J021
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThatIllegalArgumentException().isThrownBy(() -> UNLIMITED_DISTANCE.apply(null, "a"));
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：LevenshteinDistanceTest.java原文第53行
        // 待确认：无；完整接口前提见联合比较约定
        assertThatIllegalArgumentException().isThrownBy(() -> UNLIMITED_DISTANCE.apply(null, "a"));
    }

    // 片段编号：J022
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：LevenshteinDistanceTest.java原文第56行
    // 待确认：无；完整接口前提见联合比较约定
    @Test
    // 片段编号：J023
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：public void testGetLevenshteinDistance_StringNullInt() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：LevenshteinDistanceTest.java原文第57行
    // 待确认：无；完整接口前提见联合比较约定
    public void testGetLevenshteinDistance_StringNullInt() {
        // 片段编号：J024
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThatIllegalArgumentException().isThrownBy(() -> UNLIMITED_DISTANCE.apply("a", null));
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：LevenshteinDistanceTest.java原文第58行
        // 待确认：无；完整接口前提见联合比较约定
        assertThatIllegalArgumentException().isThrownBy(() -> UNLIMITED_DISTANCE.apply("a", null));
    }

    // 片段编号：J025
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test
    // 关联：testGetLevenshteinDistance_StringString本侧的对象、调用或检查；结合本侧相邻语句阅读。
    // 依据：LevenshteinDistanceTest.java原文第61行
    // 待确认：无；完整接口前提见联合比较约定
    @Test
    // 片段编号：J026
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：public void testGetLevenshteinDistance_StringString() {
    // 关联：testGetLevenshteinDistance_StringString本侧的对象、调用或检查；结合本侧相邻语句阅读。
    // 依据：LevenshteinDistanceTest.java原文第62行
    // 待确认：无；完整接口前提见联合比较约定
    public void testGetLevenshteinDistance_StringString() {
        // 片段编号：J027
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(UNLIMITED_DISTANCE.apply("", "")).isEqualTo(0);
        // 关联：testGetLevenshteinDistance_StringString本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：LevenshteinDistanceTest.java原文第63行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(UNLIMITED_DISTANCE.apply("", "")).isEqualTo(0);
        // 片段编号：J028
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(UNLIMITED_DISTANCE.apply("", "a")).isEqualTo(1);
        // 关联：testGetLevenshteinDistance_StringString本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：LevenshteinDistanceTest.java原文第64行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(UNLIMITED_DISTANCE.apply("", "a")).isEqualTo(1);
        // 片段编号：J029
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(UNLIMITED_DISTANCE.apply("aaapppp", "")).isEqualTo(7);
        // 关联：testGetLevenshteinDistance_StringString本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：LevenshteinDistanceTest.java原文第65行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(UNLIMITED_DISTANCE.apply("aaapppp", "")).isEqualTo(7);
        // 片段编号：J030
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(UNLIMITED_DISTANCE.apply("frog", "fog")).isEqualTo(1);
        // 关联：testGetLevenshteinDistance_StringString本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：LevenshteinDistanceTest.java原文第66行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(UNLIMITED_DISTANCE.apply("frog", "fog")).isEqualTo(1);
        // 片段编号：J031
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(UNLIMITED_DISTANCE.apply("fly", "ant")).isEqualTo(3);
        // 关联：testGetLevenshteinDistance_StringString本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：LevenshteinDistanceTest.java原文第67行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(UNLIMITED_DISTANCE.apply("fly", "ant")).isEqualTo(3);
        // 片段编号：J032
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(UNLIMITED_DISTANCE.apply("elephant", "hippo")).isEqualTo(7);
        // 关联：testGetLevenshteinDistance_StringString本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：LevenshteinDistanceTest.java原文第68行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(UNLIMITED_DISTANCE.apply("elephant", "hippo")).isEqualTo(7);
        // 片段编号：J033
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(UNLIMITED_DISTANCE.apply("hippo", "elephant")).isEqualTo(7);
        // 关联：testGetLevenshteinDistance_StringString本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：LevenshteinDistanceTest.java原文第69行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(UNLIMITED_DISTANCE.apply("hippo", "elephant")).isEqualTo(7);
        // 片段编号：J034
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(UNLIMITED_DISTANCE.apply("hippo", "zzzzzzzz")).isEqualTo(8);
        // 关联：testGetLevenshteinDistance_StringString本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：LevenshteinDistanceTest.java原文第70行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(UNLIMITED_DISTANCE.apply("hippo", "zzzzzzzz")).isEqualTo(8);
        // 片段编号：J035
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(UNLIMITED_DISTANCE.apply("zzzzzzzz", "hippo")).isEqualTo(8);
        // 关联：testGetLevenshteinDistance_StringString本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：LevenshteinDistanceTest.java原文第71行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(UNLIMITED_DISTANCE.apply("zzzzzzzz", "hippo")).isEqualTo(8);
        // 片段编号：J036
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(UNLIMITED_DISTANCE.apply("hello", "hallo")).isEqualTo(1);
        // 关联：testGetLevenshteinDistance_StringString本侧的对象、调用或检查；结合本侧相邻语句阅读。
        // 依据：LevenshteinDistanceTest.java原文第72行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(UNLIMITED_DISTANCE.apply("hello", "hallo")).isEqualTo(1);
    }

    // 片段编号：J037
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：LevenshteinDistanceTest.java原文第75行
    // 待确认：无；完整接口前提见联合比较约定
    @Test
    // 片段编号：J038
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：public void testGetLevenshteinDistance_StringStringInt() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：LevenshteinDistanceTest.java原文第76行
    // 待确认：无；完整接口前提见联合比较约定
    public void testGetLevenshteinDistance_StringStringInt() {
        // empty strings
        // 片段编号：J039
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(new LevenshteinDistance(0).apply("", "")).isEqualTo(0);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：LevenshteinDistanceTest.java原文第78行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(new LevenshteinDistance(0).apply("", "")).isEqualTo(0);
        // 片段编号：J040
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(new LevenshteinDistance(8).apply("aaapppp", "")).isEqualTo(7);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：LevenshteinDistanceTest.java原文第79行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(new LevenshteinDistance(8).apply("aaapppp", "")).isEqualTo(7);
        // 片段编号：J041
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(new LevenshteinDistance(7).apply("aaapppp", "")).isEqualTo(7);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：LevenshteinDistanceTest.java原文第80行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(new LevenshteinDistance(7).apply("aaapppp", "")).isEqualTo(7);
        // 片段编号：J042
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(new LevenshteinDistance(6).apply("aaapppp", "")).isEqualTo(-1);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：LevenshteinDistanceTest.java原文第81行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(new LevenshteinDistance(6).apply("aaapppp", "")).isEqualTo(-1);

        // unequal strings, zero threshold
        // 片段编号：J043
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(new LevenshteinDistance(0).apply("b", "a")).isEqualTo(-1);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：LevenshteinDistanceTest.java原文第84行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(new LevenshteinDistance(0).apply("b", "a")).isEqualTo(-1);
        // 片段编号：J044
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(new LevenshteinDistance(0).apply("a", "b")).isEqualTo(-1);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：LevenshteinDistanceTest.java原文第85行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(new LevenshteinDistance(0).apply("a", "b")).isEqualTo(-1);

        // equal strings
        // 片段编号：J045
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(new LevenshteinDistance(0).apply("aa", "aa")).isEqualTo(0);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：LevenshteinDistanceTest.java原文第88行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(new LevenshteinDistance(0).apply("aa", "aa")).isEqualTo(0);
        // 片段编号：J046
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(new LevenshteinDistance(2).apply("aa", "aa")).isEqualTo(0);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：LevenshteinDistanceTest.java原文第89行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(new LevenshteinDistance(2).apply("aa", "aa")).isEqualTo(0);

        // same length
        // 片段编号：J047
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(new LevenshteinDistance(2).apply("aaa", "bbb")).isEqualTo(-1);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：LevenshteinDistanceTest.java原文第92行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(new LevenshteinDistance(2).apply("aaa", "bbb")).isEqualTo(-1);
        // 片段编号：J048
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(new LevenshteinDistance(3).apply("aaa", "bbb")).isEqualTo(3);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：LevenshteinDistanceTest.java原文第93行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(new LevenshteinDistance(3).apply("aaa", "bbb")).isEqualTo(3);

        // big stripe
        // 片段编号：J049
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(new LevenshteinDistance(10).apply("aaaaaa", "b")).isEqualTo(6);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：LevenshteinDistanceTest.java原文第96行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(new LevenshteinDistance(10).apply("aaaaaa", "b")).isEqualTo(6);

        // distance less than threshold
        // 片段编号：J050
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(new LevenshteinDistance(8).apply("aaapppp", "b")).isEqualTo(7);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：LevenshteinDistanceTest.java原文第99行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(new LevenshteinDistance(8).apply("aaapppp", "b")).isEqualTo(7);
        // 片段编号：J051
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(new LevenshteinDistance(4).apply("a", "bbb")).isEqualTo(3);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：LevenshteinDistanceTest.java原文第100行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(new LevenshteinDistance(4).apply("a", "bbb")).isEqualTo(3);

        // distance equal to threshold
        // 片段编号：J052
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(new LevenshteinDistance(7).apply("aaapppp", "b")).isEqualTo(7);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：LevenshteinDistanceTest.java原文第103行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(new LevenshteinDistance(7).apply("aaapppp", "b")).isEqualTo(7);
        // 片段编号：J053
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(new LevenshteinDistance(3).apply("a", "bbb")).isEqualTo(3);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：LevenshteinDistanceTest.java原文第104行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(new LevenshteinDistance(3).apply("a", "bbb")).isEqualTo(3);

        // distance greater than threshold
        // 片段编号：J054
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(new LevenshteinDistance(2).apply("a", "bbb")).isEqualTo(-1);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：LevenshteinDistanceTest.java原文第107行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(new LevenshteinDistance(2).apply("a", "bbb")).isEqualTo(-1);
        // 片段编号：J055
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(new LevenshteinDistance(2).apply("bbb", "a")).isEqualTo(-1);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：LevenshteinDistanceTest.java原文第108行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(new LevenshteinDistance(2).apply("bbb", "a")).isEqualTo(-1);
        // 片段编号：J056
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(new LevenshteinDistance(6).apply("aaapppp", "b")).isEqualTo(-1);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：LevenshteinDistanceTest.java原文第109行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(new LevenshteinDistance(6).apply("aaapppp", "b")).isEqualTo(-1);

        // stripe runs off array, strings not similar
        // 片段编号：J057
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(new LevenshteinDistance(1).apply("a", "bbb")).isEqualTo(-1);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：LevenshteinDistanceTest.java原文第112行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(new LevenshteinDistance(1).apply("a", "bbb")).isEqualTo(-1);
        // 片段编号：J058
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(new LevenshteinDistance(1).apply("bbb", "a")).isEqualTo(-1);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：LevenshteinDistanceTest.java原文第113行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(new LevenshteinDistance(1).apply("bbb", "a")).isEqualTo(-1);

        // stripe runs off array, strings are similar
        // 片段编号：J059
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(new LevenshteinDistance(1).apply("12345", "1234567")).isEqualTo(-1);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：LevenshteinDistanceTest.java原文第116行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(new LevenshteinDistance(1).apply("12345", "1234567")).isEqualTo(-1);
        // 片段编号：J060
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(new LevenshteinDistance(1).apply("1234567", "12345")).isEqualTo(-1);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：LevenshteinDistanceTest.java原文第117行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(new LevenshteinDistance(1).apply("1234567", "12345")).isEqualTo(-1);

        // old getLevenshteinDistance test cases
        // 片段编号：J061
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(new LevenshteinDistance(1).apply("frog", "fog")).isEqualTo(1);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：LevenshteinDistanceTest.java原文第120行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(new LevenshteinDistance(1).apply("frog", "fog")).isEqualTo(1);
        // 片段编号：J062
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(new LevenshteinDistance(3).apply("fly", "ant")).isEqualTo(3);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：LevenshteinDistanceTest.java原文第121行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(new LevenshteinDistance(3).apply("fly", "ant")).isEqualTo(3);
        // 片段编号：J063
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(new LevenshteinDistance(7).apply("elephant", "hippo")).isEqualTo(7);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：LevenshteinDistanceTest.java原文第122行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(new LevenshteinDistance(7).apply("elephant", "hippo")).isEqualTo(7);
        // 片段编号：J064
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(new LevenshteinDistance(6).apply("elephant", "hippo")).isEqualTo(-1);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：LevenshteinDistanceTest.java原文第123行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(new LevenshteinDistance(6).apply("elephant", "hippo")).isEqualTo(-1);
        // 片段编号：J065
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(new LevenshteinDistance(7).apply("hippo", "elephant")).isEqualTo(7);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：LevenshteinDistanceTest.java原文第124行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(new LevenshteinDistance(7).apply("hippo", "elephant")).isEqualTo(7);
        // 片段编号：J066
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(new LevenshteinDistance(6).apply("hippo", "elephant")).isEqualTo(-1);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：LevenshteinDistanceTest.java原文第125行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(new LevenshteinDistance(6).apply("hippo", "elephant")).isEqualTo(-1);
        // 片段编号：J067
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(new LevenshteinDistance(8).apply("hippo", "zzzzzzzz")).isEqualTo(8);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：LevenshteinDistanceTest.java原文第126行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(new LevenshteinDistance(8).apply("hippo", "zzzzzzzz")).isEqualTo(8);
        // 片段编号：J068
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(new LevenshteinDistance(8).apply("zzzzzzzz", "hippo")).isEqualTo(8);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：LevenshteinDistanceTest.java原文第127行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(new LevenshteinDistance(8).apply("zzzzzzzz", "hippo")).isEqualTo(8);
        // 片段编号：J069
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(new LevenshteinDistance(1).apply("hello", "hallo")).isEqualTo(1);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：LevenshteinDistanceTest.java原文第128行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(new LevenshteinDistance(1).apply("hello", "hallo")).isEqualTo(1);

        // 片段编号：J070
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(new LevenshteinDistance(Integer.MAX_VALUE).apply("frog", "fog")).isEqualTo(1);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：LevenshteinDistanceTest.java原文第130行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(new LevenshteinDistance(Integer.MAX_VALUE).apply("frog", "fog")).isEqualTo(1);
        // 片段编号：J071
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(new LevenshteinDistance(Integer.MAX_VALUE).apply("fly", "ant")).isEqualTo(3);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：LevenshteinDistanceTest.java原文第131行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(new LevenshteinDistance(Integer.MAX_VALUE).apply("fly", "ant")).isEqualTo(3);
        // 片段编号：J072
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(new LevenshteinDistance(Integer.MAX_VALUE).apply("elephant", "hippo")).isEqualTo(7);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：LevenshteinDistanceTest.java原文第132行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(new LevenshteinDistance(Integer.MAX_VALUE).apply("elephant", "hippo")).isEqualTo(7);
        // 片段编号：J073
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(new LevenshteinDistance(Integer.MAX_VALUE).apply("hippo", "elephant")).isEqualTo(7);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：LevenshteinDistanceTest.java原文第133行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(new LevenshteinDistance(Integer.MAX_VALUE).apply("hippo", "elephant")).isEqualTo(7);
        // 片段编号：J074
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(new LevenshteinDistance(Integer.MAX_VALUE).apply("hippo", "zzzzzzzz")).isEqualTo(8);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：LevenshteinDistanceTest.java原文第134行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(new LevenshteinDistance(Integer.MAX_VALUE).apply("hippo", "zzzzzzzz")).isEqualTo(8);
        // 片段编号：J075
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(new LevenshteinDistance(Integer.MAX_VALUE).apply("zzzzzzzz", "hippo")).isEqualTo(8);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：LevenshteinDistanceTest.java原文第135行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(new LevenshteinDistance(Integer.MAX_VALUE).apply("zzzzzzzz", "hippo")).isEqualTo(8);
        // 片段编号：J076
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(new LevenshteinDistance(Integer.MAX_VALUE).apply("hello", "hallo")).isEqualTo(1);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：LevenshteinDistanceTest.java原文第136行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(new LevenshteinDistance(Integer.MAX_VALUE).apply("hello", "hallo")).isEqualTo(1);
        // 片段编号：J077
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(new LevenshteinDistance(1).apply("abc", "acb")).isEqualTo(-1);
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：LevenshteinDistanceTest.java原文第137行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(new LevenshteinDistance(1).apply("abc", "acb")).isEqualTo(-1);
    }

    // 片段编号：J078
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：@Test
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：LevenshteinDistanceTest.java原文第140行
    // 待确认：无；完整接口前提见联合比较约定
    @Test
    // 片段编号：J079
    // 环节：初始化与准备
    // 维度：声明与准备
    // 内容：保留声明、对象或操作：public void testGetThresholdDirectlyAfterObjectInstantiation() {
    // 关联：供本类测试使用的包、框架、声明或辅助结构。
    // 依据：LevenshteinDistanceTest.java原文第141行
    // 待确认：无；完整接口前提见联合比较约定
    public void testGetThresholdDirectlyAfterObjectInstantiation() {
        // 片段编号：J080
        // 环节：被测操作（结果检查）
        // 维度：断言与操作
        // 内容：保留本次调用及断言：assertThat(new LevenshteinDistance().getThreshold()).isNull();
        // 关联：供本类测试使用的包、框架、声明或辅助结构。
        // 依据：LevenshteinDistanceTest.java原文第142行
        // 待确认：无；完整接口前提见联合比较约定
        assertThat(new LevenshteinDistance().getThreshold()).isNull();
    }

}
