const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var buffer = try std.ArrayList(u8).initCapacity(allocator, 100);
    defer buffer.deinit(allocator);

    // try buffer.append(allocator, 'H');
    // try buffer.append(allocator, 'e');
    // try buffer.append(allocator, 'l');
    // try buffer.append(allocator, 'l');
    // try buffer.append(allocator, 'o');
    // try buffer.appendSlice(allocator, "World!");

    // const exclamation_mark = buffer.pop();
    // _ = exclamation_mark;

    // std.debug.print("{s}\n", .{buffer.items});
    // 
    for (0..10) |i| {
        const index: u8 = @intCast(i);
        try buffer.append(allocator, index);
    }
    
    std.debug.print("{any}\n", .{buffer.items});
    
    _ = buffer.orderedRemove(3);
    _ = buffer.orderedRemove(3);
    
    std.debug.print("{any}\n", .{buffer.items});
    std.debug.print("{any}\n", .{buffer.items.len});
}
