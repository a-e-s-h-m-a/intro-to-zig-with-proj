const std = @import("std");

pub fn main(init: std.process.Init) !void {
    // ------------ read
    
    const cwd = std.Io.Dir.cwd();
    const file = try cwd.openFile(init.io, "foo.txt", .{ .mode = .read_only });
    defer file.close(init.io);

    var read_buffer: [1024]u8 = undefined;
    var fr = file.reader(init.io, &read_buffer);
    var reader = &fr.interface;

    var buffer: [300]u8 = undefined;
    @memset(buffer[0..], 0);
    _ = reader.readSliceAll(buffer[0..]) catch 0;

    std.debug.print("{s}\n", .{buffer});

    // ------------ write
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(init.io, &stdout_buffer);
    const stdout = &stdout_writer.interface;

    try stdout.writeAll("This message is written into stdout.\n");
    try stdout.flush();
}
