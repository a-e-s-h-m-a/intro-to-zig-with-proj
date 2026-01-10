const std = @import("std");
const Allocator = std.mem.Allocator;

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
    
    pub fn encode(self: Base64, allocator: Allocator, input: []const u8) ![]u8 {
        if (input.len == 0) {
            return "";
        }
        
        const n_out = try _calc_encode_lengh(input);
        var out = try allocator.alloc(u8, n_out);
        var buf = [3]u8{0, 0, 0};
        var count: u8 = 0;
        var iout: u64 = 0;
        
        for (input, 0..) |_, i| {
            buf[count] = input[i];
            count += 1;
            if (count == 3) {
                out[iout] = self._char_at(buf[0] >> 2);
                out[iout + 1] = self._char_at(
                    ((buf[0] & 0x03) << 4) + (buf[1] >> 4)
                );
                out[iout + 2] = self._char_at(
                    ((buf[1] & 0x0f) << 2) + (buf[2] >> 6)
                );
                out[iout + 3] = self._char_at(buf[2] & 0x3f);
                iout += 1;
                count = 0;
            }
        }
        
        if (count == 1) {
            out[iout] = self._char_at(buf[0] >> 2 );
            out[iout + 1] = self._char_at(
                (buf[0] & 0x03) << 4
            );
            out[iout + 2] = '=';
            out[iout + 3] = '=';
        }
        
        if (count == 2) {
            out[iout] = self._char_at(buf[0] >> 2);
            out[iout + 1] = self._char_at(
                ((buf[0] & 0x03) << 4) + (buf[1] >> 4)
            );
            out[iout + 2] = self._char_at(
                (buf[1] & 0x0f) << 2
            );
            out[iout + 3] = '=';
        }
        
        return out;
    }
};

fn _calc_encode_lengh(input: []const u8) !usize {
    if(input.len < 3) {
        return 4;
    }
    
    const n_output: usize = try std.math.divCeil(usize, input.len, 3);
    return n_output * 4;
}

fn _calc_decode_length(input: []const u8) !usize {
    if(input.len < 4) {
        return 3;
    }
    
    const n_groups = try std.math.divFloor(usize, input.len, 4);
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
    
    // // bit shifting
    // const input = "Hi";
    // try stdout.print("{d}\n", .{ input[0] >> 2 });
    // try stdout.flush();
    
    // const bits = 0b10010111;
    // try stdout.print("{d}\n", .{ bits & 0b00110000 });
    // try stdout.flush();
    // 
    var gpa = std.heap.DebugAllocator(.{}){};
    const allocator = gpa.allocator();
    
    const base64 = Base64.init();
    const input = "Hi";
    try stdout.print("{any}\n", .{ base64.encode(allocator, input)});
    try stdout.flush();
}
