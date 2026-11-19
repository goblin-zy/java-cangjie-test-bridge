package wallet;

public final class PointsWallet {
    private int points;

    public PointsWallet(int points) {
        this.points = points;
    }

    public boolean spend(int amount) {
        if (amount > points) {
            return false;
        }
        points -= amount;
        return true;
    }

    public int balance() {
        return points;
    }
}
