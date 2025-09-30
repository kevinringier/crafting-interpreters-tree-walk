const std = @import("std");

const TokenType = union(enum) {
    // Single-character tokens.
    tok_left_paren,
    tok_right_paren,
    tok_left_brace,
    tok_right_brace,
    tok_comma,
    tok_dot,
    tok_minus,
    tok_plus,
    tok_semicolon,
    tok_slash,
    tok_star,

    // One or two character tokens.
    tok_bang,
    tok_bang_equal,
    tok_equal,
    tok_equal_equal,
    tok_greater,
    tok_greater_equal,
    tok_less,
    tok_less_equal,

    // Literals.
    tok_identifer,
    tok_string,
    tok_number,

    // Keywords.
    tok_and,
    tok_class,
    tok_else,
    tok_false,
    tok_fun,
    tok_for,
    tok_if,
    tok_nil,
    tok_or,
    tok_print,
    tok_return,
    tok_super,
    tok_this,
    tok_true,
    tok_var,
    tok_while,

    tok_eof,
};

pub const LiteralType = union(enum) {
    identifier_string: []u8,
    identifier_number: f64,
    identifier_none: void,
};

pub const Token = struct {
    tok_type: TokenType,
    lexeme: []u8,
    literal: LiteralType,
    line: u32,

    pub fn toString(self: Token, allocator: std.mem.Allocator) ![]u8 {
        return switch (self.literal) {
            .identifier_none => try std.fmt.allocPrint(allocator, "{s} {s}", .{ @tagName(self.tok_type), self.lexeme }),
            .identifier_string => |literal| try std.fmt.allocPrint(allocator, "{s} {s} {s}", .{ @tagName(self.tok_type), self.lexeme, literal }),
            .identifier_number => |literal| try std.fmt.allocPrint(allocator, "{s} {s} {d}", .{ @tagName(self.tok_type), self.lexeme, literal }),
        };
    }

    pub fn deinit(_: *Token, _: std.mem.Allocator) !void {
        // free all resources that may be attached to token
    }
};

pub fn init(tok_type: TokenType, lexeme: []u8, literal: LiteralType, line: u32) Token {
    return .{
        .tok_type = tok_type,
        .lexeme = lexeme,
        .literal = literal,
        .line = line,
    };
}
