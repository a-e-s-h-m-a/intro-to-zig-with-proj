const std = @import("std");

const NodeU32 = struct {
    data: u32,
    node: std.SinglyLinkedList.Node = .{},
};

pub fn main() !void {
    var list: std.SinglyLinkedList = .{};
    
    var one: NodeU32 = .{ .data = 1 };
    var two: NodeU32 = .{ .data = 2 };
    var three: NodeU32 = .{ .data = 3 };
    var five: NodeU32 = .{ .data = 5 };
    
    list.prepend(&two.node); // {2}
    two.node.insertAfter(&five.node); // {2, 5}
    two.node.insertAfter(&three.node); // {2, 3, 5}
    list.prepend(&one.node); // {1, 2, 3, 5}
    
    std.debug.print("Number of nodes are: {d}\n", .{ list.len() });
    
    var it = list.first;
    while (it) |node| : (it = node.next) {
        const l: *NodeU32 = @fieldParentPtr("node", node);
        std.debug.print("Current value is: {}\n", .{l.data});
    }
}