const std = @import("std");

pub fn main() void {
    const ns = [4]u8{48, 24, 12, 6};
    const sl = ns[1..3];
    std.debug.print("{any}\n", .{sl});
}