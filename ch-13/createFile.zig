const std = @import("std");

// pub fn main(init: std.process.Init) !void {
//     const cwd = std.Io.Dir.cwd();
//     const file = try cwd.createFile(init.io, "foo1.txt", .{});
//     defer file.close(init.io);

//     _ = try file.writePositionalAll(init.io, "writing this line to the file", 0);
// }

pub fn main(init: std.process.Init) !void {
    const cwd = std.Io.Dir.cwd();
    const file = try cwd.createFile(init.io, "foo2.txt", .{ .read = true });
    defer file.close(init.io);

    _ = try file.writePositionalAll(init.io, "writing this line to the file 2", 0);

    var buffer: [300]u8 = undefined;
    @memset(buffer[0..], 0);

    var read_buffer: [1024]u8 = undefined;
    var fr = file.reader(init.io, &read_buffer);
    var reader = &fr.interface;

    _ = reader.readSliceAll(buffer[0..]) catch 0;
    std.debug.print("What we read from the file is: {s}\n", .{buffer});
    
}
