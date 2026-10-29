package fixtures;

class ParentWithArgument {
    ParentWithArgument(int value) { }
}

class ChildWithArgument extends ParentWithArgument {
    ChildWithArgument(int value) { super(value); }
}
