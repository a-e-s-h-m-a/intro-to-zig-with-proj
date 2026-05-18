const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const cwd = std.Io.Dir.cwd();
    const dir = try cwd.openDir(init.io, "./", .{ .iterate = true });

    var it = dir.iterate();
    while (try it.next(init.io)) |entry| {
        std.debug.print("File name: {s}\n", .{entry.name});
    }

    //create directories
    try cwd.createDir(init.io, "testSingleDir", .default_dir);
    try cwd.createDirPath(init.io, "testSingleDir/test1/test2/");

    // Delete dir
    try cwd.deleteDir(init.io, "testSingleDir");
}