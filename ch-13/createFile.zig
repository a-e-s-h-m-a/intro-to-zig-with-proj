const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const cwd = std.Io.Dir.cwd();
    const file = try cwd.createFile(init.io, "foo1.txt", .{});
    defer file.close(init.io);

    _ = try file.writePositionalAll(init.io, "writing this line to the file", 0);
}
