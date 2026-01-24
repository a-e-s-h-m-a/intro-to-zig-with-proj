const std = @import("std");

pub fn main() !void {
    // Prints to stderr, ignoring potential errors.
    std.debug.print("Hello world.\n", .{});
}

test "arrays are equal?" {
    const array1 = [3]u32{ 1, 2, 3 };
    const array2 = [3]u32{ 1, 2, 3 };
    try std.testing.expectEqualSlices(u32, &array1, &array2);
}
