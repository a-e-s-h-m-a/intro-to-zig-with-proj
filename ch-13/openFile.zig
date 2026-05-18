const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const cwd = std.Io.Dir.cwd();
    const file = try cwd.openFile(init.io, "foo.txt", .{ .mode = .write_only });
    defer file.close(init.io);

    const length = try file.length(init.io);
    _ = try file.writePositionalAll(init.io, "Some random text.\n", length);

    //Delete file
    //_ = try cwd.deleteFile(init.io, "fooDelete.txt");

    //Copy file
    _ = try cwd.copyFile("foo.txt", cwd, 
        "fooDelete.txt", init.io, .{});
}
