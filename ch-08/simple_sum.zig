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

// test "testing error" {
//     var buffer: [10]u8 = undefined;
//     var fba = std.heap.FixedBufferAllocator.init(&buffer);
//     const allocator = fba.allocator();
    
//     try expectError(error.OutOfMemory, alloc_error(allocator));
// }

// test "testing simple sum" {
//     const a: u8 = 2;
//     const b: u8 = 2;
//     try expect((a + b) == 4);
// }

// -----------------
// expectEqual()
// test "values are equal?" {
//     const v1 = 15;
//     const v2 = 18;
//     try std.testing.expectEqual(v1, v2);
// }

// expectEqualSlices
test "arrays are equal?" {
    const array1 = [3]u32{1, 2, 3};
    const array2 = [3]u32{1, 2, 3};
    try std.testing.expectEqualSlices(
        u32, &array1, &array2
    );
}

// expectEqualStrings
test "strings are equal?" {
    const str1 = "hello, world!";
    const str2 = "Hello, world!";
    try std.testing.expectEqualStrings(
        str1, str2
    );
}