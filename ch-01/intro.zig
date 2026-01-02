const std = @import("std");
var stdout_buffer: [1024]u8 = undefined;
var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
const stdout = &stdout_writer.interface;

pub fn main() !void {
    // const ns = [4]u8{48, 24, 12, 6};
    // const sl = ns[1..3];
    // std.debug.print("{d}\n", .{sl.len});
    // const a = [_]u8{1,2,3};
    // const b = [_]u8{4,5};
    // const c = a ++ b;
    // std.debug.print("++ {any}\n", .{c});
    // const d = a ** 3;
    // std.debug.print("** {any}\n", .{d});
    // 
    // -- scope --
    // var y: i32 = 123;
    // const x = add_one: {
    //     y += 1;
    //     break :add_one y;
    // };
    // if (x == 124 and y == 124) {
    //     std.debug.print("Hey!\n", .{});
    // }
    // const str = "This is an example of string literal in Zig";
    // std.debug.print("{d}\n", .{str.len});
    // 
    const bytes = [_]u8{0x48, 0x65, 0x6C, 0x6C, 0x6F};
    try stdout.print("{s}\n", .{bytes});
    try stdout.flush();
}