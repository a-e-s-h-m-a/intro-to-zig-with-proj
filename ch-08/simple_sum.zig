const std = @import("std");
const Allocator = std.mem.Allocator;
const expect = std.testing.expect;
const expectError = std.testing.expectError;

fn some_memory_leak(allocator: Allocator) !void {
    const buffer = try allocator.alloc(u32, 10);
    _ = buffer;
    // Return without freeing the allocated memory
} 

// test "memory leak" {
//     const allocator = std.testing.allocator;
//     try some_memory_leak(allocator);
// }

fn alloc_error(allocator: Allocator) !void {
    var ibuffer = try allocator.alloc(u8, 100);
    defer allocator.free(ibuffer);
    ibuffer[0] = 2;
}

test "testing error" {
    var buffer: [10]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    const allocator = fba.allocator();
    
    try expectError(error.OutOfMemory, alloc_error(allocator));
}

// test "testing simple sum" {
//     const a: u8 = 2;
//     const b: u8 = 2;
//     try expect((a + b) == 4);
// }