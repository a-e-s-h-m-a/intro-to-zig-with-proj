const std = @import("std");

const Base64 = struct {
    _table: *const [64]u8,

    pub fn init() Base64 {
        const upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        const lower = "abcdefghijklmnopqrstuvwxyz";
        const numbers_sym = "0123456789+/";
        return .{
            ._table = upper ++ lower ++ numbers_sym
        };
    }

    pub fn _char_at(self: Base64, index: usize) u8 {
        return self._table[index];
    }
};

fn _calc_encode_lengh(input: []const u8) !usize {
    if(input.len < 3) {
        return 4;
    }
    
    const n_groups = std.math.divCeil(usize, input.len, 3);
    return n_groups * 4;
}

fn _calc_decode_length(input: []const u8) !usize {
    if(input.len < 4) {
        return 3;
    }
    
    const n_groups = std.math.divFloor(usize, input.len, 4);
    var multiple_groups: usize = n_groups * 3;
    var i: usize = input.len - 1;
    while (i > 0):( i -= 1) {
        if (input[i] == '=') {
            multiple_groups -= 1;
        } else {
            break;
        }
    }
    return multiple_groups;
}

//--------------------------
var stdout_buffer: [1024]u8 = undefined;
var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
const stdout = &stdout_writer.interface;

pub fn main() !void {
    // const base64 = Base64.init();
    // std.debug.print("Character at index: 28 is {c}\n", .{ base64._char_at(28) });
    
    const input = "Hi";
    try stdout.print("{d}\n", .{ input[0] >> 2 });
    try stdout.flush();
}
