const std = @import("std");
const Request = @import("request.zig");
const Server = @import("server.zig").Server;

pub fn main() !void {
    var alloc = std.heap.GeneralPurposeAllocator(.{}){};
    const gpa = alloc.allocator();
    var threaded: std.Io.Threaded = .init(gpa);
    const io = threaded.io();
    defer threaded.deinit();

    const server = try Server.init(io);
    var listening = try server.listen();
    const connection = try listening.accept(io);
    defer connection.close(io);
    
    var request_buffer: [1000]u8 = undefined;
    @memset(request_buffer[0..], 0);
    try Request.read_request(io, connection, request_buffer[0..]);
    
    const request = Request.parse_request(request_buffer[0..]);
    std.debug.print("{any}\n", .{request});
}
