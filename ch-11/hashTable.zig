const std = @import("std");
const AutoHashMap = std.hash_map.AutoHashMap;
 
pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    
    var hash_table = AutoHashMap(u32, u16).init(allocator);
    defer hash_table.deinit();
    
    try hash_table.put(54321, 89);
    try hash_table.put(50050, 55);
    try hash_table.put(57709, 41);
    
    // std.debug.print("{d} : values are stored\n", .{hash_table.count()});
    // std.debug.print("Value at key: 50050 is: {d}\n", .{hash_table.get(50050).?});
    
    // if (hash_table.remove(57709)) {
    //     std.debug.print("Value of the key 57709 is removed\n", .{});
    // }
    
    // std.debug.print("{d} : values are stored\n", .{hash_table.count()});
    
    // --------- iterating through hashtable
    var it = hash_table.iterator();
    
    while (it.next()) |kv| {
        std.debug.print("Key: {d} ", .{kv.key_ptr.*});
        std.debug.print("Val: {d}\n", .{kv.value_ptr.*});
    }
}