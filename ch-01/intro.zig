const std = @import("std");

pub fn main() void {
    // const ns = [4]u8{48, 24, 12, 6};
    // const sl = ns[1..3];
    // std.debug.print("{d}\n", .{sl.len});
    const a = [_]u8{1,2,3};
    const b = [_]u8{4,5};
    const c = a ++ b;
    std.debug.print("{any}", .{c});
}