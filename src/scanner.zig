const std = @import("std");
const token = @import("token.zig");

const Self = @This();

pub fn scanTokens(allocator: std.mem.Allocator, _: *std.Io.Reader) !std.array_list.Aligned(token.Token, null) {
    var tokens = std.ArrayList(token.Token).empty;
    const l = try allocator.alloc(u8, 4);
    l[0] = 't';
    l[1] = 'e';
    l[2] = 's';
    l[3] = 't';

    try tokens.append(allocator, token.init(
        .tok_left_paren,
        l,
        .identifier_none,
        1,
    ));

    //const s = "variable";
    //const s_literal = try allocator.alloc(u8, 8);
    //@memcpy(s_literal, s[0..s.len]);
    //const literal = token.LiteralType{ .identifier_string = s_literal };

    //const l2 = try allocator.alloc(u8, 4);
    //l2[0] = 't';
    //l2[1] = 'e';
    //l2[2] = 's';
    //l2[3] = 't';

    //result[1] = token.init(
    //    .tok_identifer,
    //    l2,
    //    literal,
    //    64,
    //);

    //const l3 = try allocator.alloc(u8, 4);
    //l2[0] = 'r';
    //l2[1] = 'e';
    //l2[2] = 's';
    //l2[3] = 't';

    //result[2] = token.init(
    //    .tok_number,
    //    l3,
    //    token.LiteralType{ .identifier_number = 100 },
    //    63,
    //);

    //var current = 0;
    //var start = current;
    //var line = 0;

    //tokens.append(allocator, token.init(.tok_eof, "", .none, line));

    return tokens;
}

fn scanToken() void {}

fn isAtEnd(source: []u8) bool {
    _ = source;
    @compileError("unimplmemented");
}
