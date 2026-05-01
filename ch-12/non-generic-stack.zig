const std = @import("std");
const Allocator = std.mem.Allocator;

const Stack = struct {
    items: []u32,
    capacity: usize,
    length: usize,
    allocator: Allocator,

    pub fn init(allocator: Allocator, capacity: usize) !Stack {
        var buf = try allocator.alloc(u32, capacity);
        return .{
            .items = buf[0..],
            .capacity = capacity,
            .length = 0,
            .allcator = allocator,
        };
    }

    pub fn push(self: *Stack, val: u32) !void {
        if ((self.length + 1) > self.capacity) {
            var new_buf = try self.allocator.alloc(u32, self.capacity * 2);
            @memcpy(new_buf[0..self.capacity], self.items);
            self.allocator.free(self.items);
            self.items = new_buf;
            self.capacity = self.capacity * 2;
        }

        self.items[self.length] = val;
        self.length += 1;
    }

    pub fn pop(self: *Stack) void {
        if (self.length == 0) return;

        self.items[self.length - 1] = undefined;
        self.length -= 1;
    }

    pub fn deinit(self: *Stack) void {
        self.allocator.free(self.items);
    }
};
