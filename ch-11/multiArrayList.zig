const std = @import("std");

const Person = struct {
    name: []const u8,
    age: u8,
    height: f32,
};

const PersonArray = std.MultiArrayList(Person);

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    
    var people = PersonArray{};
    defer people.deinit(allocator);
    
    try people.append(allocator, .{
        .name = "Malith",
        .age = 33,
        .height = 157,
    });
    
    try people.append(allocator, .{
        .name = "Jhon",
        .age = 27,
        .height = 166,
    });
    
    try people.append(allocator, .{
        .name = "Jack",
        .age = 20,
        .height = 180,
    });
    
    // iterating through
    for (people.items(.age)) |*age| {
        std.debug.print("value is: {}\n", .{age.*});
    }
    
    // better performance when accessing multiple times
    var slice = people.slice();
    for (slice.items(.age)) |*age| {
        age.* += 10;
    }
    for (slice.items(.name), slice.items(.age)) |*n, *a| {
        std.debug.print("Name: {s}, age: {d}\n", .{n.*, a.*});
    }
}