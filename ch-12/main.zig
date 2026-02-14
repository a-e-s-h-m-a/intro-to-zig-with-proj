const std = @import("std");

fn twice(comptime num: u32) u32 {
    return num * 2;
}

pub fn main() !void {
    
}

test "twice" {
    _ = twice(5467);
}