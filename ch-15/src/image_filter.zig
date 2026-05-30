const std = @import("std");

const c = @cImport({
    @cDefine("_NO_CRT_STDIO_INLINE", "1");
    @cInclude("stdio.h");
});

const png = @cImport({
    @cInclude("spng.h");
});

const ImageHeader = struct {
    width: u32,
    height: u32,
    bit_depth: u8,
    color_type: u8,
    compression_method: u8,
    filter_method: u8,
    interlace_method: u8,
};

const ImageData = struct {
    data: []u8,
    decoded_size: usize,
    header: ImageHeader,

    pub fn deinit(self: ImageData, allocator: std.mem.Allocator) void {
        allocator.free(self.data);
    }
};

fn get_image_header(ctx: *png.spng_ctx) !ImageHeader {
    var image_header: png.spng_ihdr = undefined;

    if (png.spng_get_ihdr(ctx, &image_header) != 0) {
        return error.CouldNotGetImageHeader;
    }

    return ImageHeader{
        .width = image_header.width,
        .height = image_header.height,
        .bit_depth = image_header.bit_depth,
        .color_type = image_header.color_type,
        .compression_method = image_header.compression_method,
        .filter_method = image_header.filter_method,
        .interlace_method = image_header.interlace_method,
    };
}

fn see_image_properties(image_header: ImageHeader) void {
    std.debug.print(
        "width: {d}, height: {d}, bit depth: {d}\n",
        .{ image_header.width, image_header.height, image_header.bit_depth },
    );
}

fn calc_output_size(ctx: *png.spng_ctx) !usize {
    var output_size: usize = 0;

    const status = png.spng_decoded_image_size(
        ctx,
        png.SPNG_FMT_RGBA8,
        &output_size,
    );

    if (status != 0) {
        return error.CouldNotCalcOutputSize;
    }

    return output_size;
}

fn read_data_to_buffer(ctx: *png.spng_ctx, buffer: []u8) !void {
    const status = png.spng_decode_image(
        ctx,
        buffer.ptr,
        buffer.len,
        png.SPNG_FMT_RGBA8,
        0,
    );

    if (status != 0) {
        return error.CouldNotDecodeImage;
    }
}

pub fn read_png(
    allocator: std.mem.Allocator,
    path: []const u8,
) !ImageData {
    const path_z = try allocator.dupeZ(u8, path);
    defer allocator.free(path_z);

    const file_descriptor = c.fopen(path_z.ptr, "rb") orelse {
        return error.CouldNotOpenFile;
    };
    defer {
        _ = c.fclose(file_descriptor);
    }

    const ctx = png.spng_ctx_new(0) orelse {
        return error.CouldNotCreateSpngContext;
    };
    defer png.spng_ctx_free(ctx);

    const set_file_status = png.spng_set_png_file(ctx, @ptrCast(file_descriptor));
    if (set_file_status != 0) {
        return error.CouldNotSetPngFile;
    }

    const image_header = try get_image_header(ctx);
    see_image_properties(image_header);

    const output_size = try calc_output_size(ctx);

    const buffer = try allocator.alloc(u8, output_size);
    @memset(buffer, 0);

    try read_data_to_buffer(ctx, buffer);

    return ImageData{
        .data = buffer,
        .decoded_size = output_size,
        .header = image_header,
    };
}

fn apply_image_filter(image_data: *ImageData) void {
    const len = image_data.data.len;

    const red_factor: f32 = 0.2126;
    const green_factor: f32 = 0.7152;
    const blue_factor: f32 = 0.0722;

    var index: usize = 0;
    while (index + 3 < len) : (index += 4) {
        const rf: f32 = @floatFromInt(image_data.data[index]);
        const gf: f32 = @floatFromInt(image_data.data[index + 1]);
        const bf: f32 = @floatFromInt(image_data.data[index + 2]);

        const y_linear: f32 =
            (rf * red_factor) +
            (gf * green_factor) +
            (bf * blue_factor);

        const gray: u8 = @intFromFloat(@min(y_linear, 255.0));

        image_data.data[index] = gray;
        image_data.data[index + 1] = gray;
        image_data.data[index + 2] = gray;
        // alpha channel stays unchanged
    }
}

fn save_png(image_data: *ImageData) !void {
    const path = "pedro_pascal_filter.png";

    const file_descriptor = c.fopen(path, "wb") orelse {
        return error.CouldNotOpenOutputFile;
    };
    defer {
        _ = c.fclose(file_descriptor);
    }

    const ctx = png.spng_ctx_new(png.SPNG_CTX_ENCODER) orelse {
        return error.CouldNotCreateSpngEncoder;
    };
    defer png.spng_ctx_free(ctx);

    const set_file_status = png.spng_set_png_file(ctx, @ptrCast(file_descriptor));
    if (set_file_status != 0) {
        return error.CouldNotSetPngOutputFile;
    }

    var image_header: png.spng_ihdr = undefined;
    image_header.height = image_data.header.height;
    image_header.width = image_data.header.width;
    image_header.bit_depth = image_data.header.bit_depth;
    image_header.color_type = image_data.header.color_type;
    image_header.compression_method = image_data.header.compression_method;
    image_header.filter_method = image_data.header.filter_method;
    image_header.interlace_method = image_data.header.interlace_method;

    std.debug.print("Decoded size: {d}\n", .{image_data.decoded_size});
    std.debug.print("Buffer size: {d}\n", .{image_data.data.len});

    const set_ihdr_status = png.spng_set_ihdr(ctx, &image_header);
    if (set_ihdr_status != 0) {
        return error.CouldNotSetImageHeader;
    }

    const encode_status = png.spng_encode_image(
        ctx,
        image_data.data.ptr,
        image_data.data.len,
        png.SPNG_FMT_PNG,
        png.SPNG_ENCODE_FINALIZE,
    );

    if (encode_status != 0) {
        std.debug.print("Encode error code: {d}\n", .{encode_status});
        std.debug.print("Is SPNG_EFMT: {}\n", .{encode_status == png.SPNG_EFMT});

        return error.CouldNotEncodeImage;
    }
}

pub fn main() !void {
    var gpa = std.heap.DebugAllocator(.{}){};
    defer {
        const status = gpa.deinit();
        if (status == .leak) {
            std.debug.print("Memory leak detected\n", .{});
        }
    }

    const allocator = gpa.allocator();

    var image_data = try read_png(allocator, "pedro_pascal.png");
    defer image_data.deinit(allocator);

    apply_image_filter(&image_data);

    try save_png(&image_data);
}
