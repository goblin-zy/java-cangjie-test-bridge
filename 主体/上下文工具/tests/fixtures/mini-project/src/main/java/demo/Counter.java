package demo;

public class Counter {
    private int value = 0;
    static final String LABEL = "计数😀";
    static { System.getProperty("example.setting"); }
    { value = 1; }

    public Counter() { this(3); }
    public Counter(int initial) { value = initial; }
    public void add(int delta) { value += delta; }
    public void add(String delta) { add(Integer.parseInt(delta)); }
    public int value() { return value; }
}
