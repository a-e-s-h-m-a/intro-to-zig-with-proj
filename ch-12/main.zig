const std = @import("std");
const expect = @import("std").testing.expect;

fn fibonacci(index: u32) u32 {
    if (index < 2) return index;
    return fibonacci(index - 1) + fibonacci(index - 2);
}

fn twice(comptime num: u32) u32 {
    return num * 2;
}

pub fn main(init: std.process.Init) !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(init.io, &stdout_buffer);
    const stdout = &stdout_writer.interface;

    var stdin_buffer: [1024]u8 = undefined;
    var stdin_reader = std.Io.File.stdin().reader(init.io, &stdin_buffer);
    const stdin = &stdin_reader.interface;

    var buffer: [5]u8 = .{ 0, 0, 0, 0, 0 };
    _ = try stdout.write("Please type a 4-digit integer number:\n");
    _ = try stdin.takeDelimiterExclusive('\n');

    try stdout.print("Input: {s}", .{buffer});
    const n: u32 = try std.fmt.parseInt(u32, buffer[0 .. buffer.len - 1], 10);
    const twise_result = twice(n);

    try stdout.print("Result: {d} \n", .{twise_result});
    try stdout.flush();
}

test "twice" {
    _ = twice(5467);
}

test "fibonacci" {
    // test fibonacci at run-time
    try expect(fibonacci(7) == 13);

    // test fibonacci at comptime
    try comptime expect(fibonacci(7) == 13);
}
