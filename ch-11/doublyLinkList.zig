const std = @import("std");

const NodeU32 = struct {
    data: u32,
    node: std.DoublyLinkedList.Node = .{},
};

pub fn main() !void {
    var list: std.DoublyLinkedList = .{};
    
    var one: NodeU32 = .{ .data = 1 };
    var two: NodeU32 = .{ .data = 2 };
    var three: NodeU32 = .{ .data = 3 };
    var five: NodeU32 = .{ .data = 5 };
    
    list.append(&one.node); // {1}
    list.append(&three.node); // {1, 3}
    list.insertAfter(&one.node, &five.node); // {1, 5, 3}
    list.append(&two.node); // {1, 5, 3, 2}
    
    std.debug.print("Number of nodes: {d}\n", .{ list.len() });
    
    var it = list.first;
    while (it) |node|: (it = node.next) {
        const l: *NodeU32 = @fieldParentPtr("node", node);
        std.debug.print("Current value is: {}\n", .{l.data});
    }
}