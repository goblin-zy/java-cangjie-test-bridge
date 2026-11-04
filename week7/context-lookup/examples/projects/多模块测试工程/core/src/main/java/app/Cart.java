package app;
public class Cart {
    private int amount = 0;
    public void add(int n) { amount += n; }
    public int total() { return amount; }
    public void clear() { amount = 0; }
}
