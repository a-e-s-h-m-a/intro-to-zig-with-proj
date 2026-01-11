const std = @import("std");
var stdout_buffer: [1024]u8 = undefined;
var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
const stdout = &stdout_writer.interface;
const expect = std.testing.expect;

pub fn main() !void {
    const number: i32 = 5;
    try expect(@TypeOf(number) == i32);
    try stdout.print("{any}\n", .{@TypeOf(number)});
    try stdout.flush();
}
