module etc.enums;

/**
 * Generic function to get enum member from its value
 */
E fromValue(E)(string s) {
    import std.traits: EnumMembers;
    switch (s) {
        foreach (c; EnumMembers!E) {
            case c: return c;
        }
        default:
            import std.format;
            throw new Exception(format("Enum %s has no member with value %s", E.stringof, s));
    }
}
