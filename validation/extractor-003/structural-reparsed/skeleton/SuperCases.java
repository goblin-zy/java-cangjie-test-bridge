package fixtures;

class ParentWithArgument {
    ParentWithArgument(int value) {
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }
}

class ChildWithArgument extends ParentWithArgument {
    ChildWithArgument(int value) {
        super(value);
        throw new UnsupportedOperationException("SKELETON_PLACEHOLDER");
    }
}
