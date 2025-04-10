pub const __builtin_bswap16 = @import("std").zig.c_builtins.__builtin_bswap16;
pub const __builtin_bswap32 = @import("std").zig.c_builtins.__builtin_bswap32;
pub const __builtin_bswap64 = @import("std").zig.c_builtins.__builtin_bswap64;
pub const __builtin_signbit = @import("std").zig.c_builtins.__builtin_signbit;
pub const __builtin_signbitf = @import("std").zig.c_builtins.__builtin_signbitf;
pub const __builtin_popcount = @import("std").zig.c_builtins.__builtin_popcount;
pub const __builtin_ctz = @import("std").zig.c_builtins.__builtin_ctz;
pub const __builtin_clz = @import("std").zig.c_builtins.__builtin_clz;
pub const __builtin_sqrt = @import("std").zig.c_builtins.__builtin_sqrt;
pub const __builtin_sqrtf = @import("std").zig.c_builtins.__builtin_sqrtf;
pub const __builtin_sin = @import("std").zig.c_builtins.__builtin_sin;
pub const __builtin_sinf = @import("std").zig.c_builtins.__builtin_sinf;
pub const __builtin_cos = @import("std").zig.c_builtins.__builtin_cos;
pub const __builtin_cosf = @import("std").zig.c_builtins.__builtin_cosf;
pub const __builtin_exp = @import("std").zig.c_builtins.__builtin_exp;
pub const __builtin_expf = @import("std").zig.c_builtins.__builtin_expf;
pub const __builtin_exp2 = @import("std").zig.c_builtins.__builtin_exp2;
pub const __builtin_exp2f = @import("std").zig.c_builtins.__builtin_exp2f;
pub const __builtin_log = @import("std").zig.c_builtins.__builtin_log;
pub const __builtin_logf = @import("std").zig.c_builtins.__builtin_logf;
pub const __builtin_log2 = @import("std").zig.c_builtins.__builtin_log2;
pub const __builtin_log2f = @import("std").zig.c_builtins.__builtin_log2f;
pub const __builtin_log10 = @import("std").zig.c_builtins.__builtin_log10;
pub const __builtin_log10f = @import("std").zig.c_builtins.__builtin_log10f;
pub const __builtin_abs = @import("std").zig.c_builtins.__builtin_abs;
pub const __builtin_labs = @import("std").zig.c_builtins.__builtin_labs;
pub const __builtin_llabs = @import("std").zig.c_builtins.__builtin_llabs;
pub const __builtin_fabs = @import("std").zig.c_builtins.__builtin_fabs;
pub const __builtin_fabsf = @import("std").zig.c_builtins.__builtin_fabsf;
pub const __builtin_floor = @import("std").zig.c_builtins.__builtin_floor;
pub const __builtin_floorf = @import("std").zig.c_builtins.__builtin_floorf;
pub const __builtin_ceil = @import("std").zig.c_builtins.__builtin_ceil;
pub const __builtin_ceilf = @import("std").zig.c_builtins.__builtin_ceilf;
pub const __builtin_trunc = @import("std").zig.c_builtins.__builtin_trunc;
pub const __builtin_truncf = @import("std").zig.c_builtins.__builtin_truncf;
pub const __builtin_round = @import("std").zig.c_builtins.__builtin_round;
pub const __builtin_roundf = @import("std").zig.c_builtins.__builtin_roundf;
pub const __builtin_strlen = @import("std").zig.c_builtins.__builtin_strlen;
pub const __builtin_strcmp = @import("std").zig.c_builtins.__builtin_strcmp;
pub const __builtin_object_size = @import("std").zig.c_builtins.__builtin_object_size;
pub const __builtin___memset_chk = @import("std").zig.c_builtins.__builtin___memset_chk;
pub const __builtin_memset = @import("std").zig.c_builtins.__builtin_memset;
pub const __builtin___memcpy_chk = @import("std").zig.c_builtins.__builtin___memcpy_chk;
pub const __builtin_memcpy = @import("std").zig.c_builtins.__builtin_memcpy;
pub const __builtin_expect = @import("std").zig.c_builtins.__builtin_expect;
pub const __builtin_nanf = @import("std").zig.c_builtins.__builtin_nanf;
pub const __builtin_huge_valf = @import("std").zig.c_builtins.__builtin_huge_valf;
pub const __builtin_inff = @import("std").zig.c_builtins.__builtin_inff;
pub const __builtin_isnan = @import("std").zig.c_builtins.__builtin_isnan;
pub const __builtin_isinf = @import("std").zig.c_builtins.__builtin_isinf;
pub const __builtin_isinf_sign = @import("std").zig.c_builtins.__builtin_isinf_sign;
pub const __has_builtin = @import("std").zig.c_builtins.__has_builtin;
pub const __builtin_assume = @import("std").zig.c_builtins.__builtin_assume;
pub const __builtin_unreachable = @import("std").zig.c_builtins.__builtin_unreachable;
pub const __builtin_constant_p = @import("std").zig.c_builtins.__builtin_constant_p;
pub const __builtin_mul_overflow = @import("std").zig.c_builtins.__builtin_mul_overflow;
pub const struct_gladGLversionStruct = extern struct {
    major: c_int = @import("std").mem.zeroes(c_int),
    minor: c_int = @import("std").mem.zeroes(c_int),
};
pub const GLADloadproc = ?*const fn ([*c]const u8) callconv(.c) ?*anyopaque;
pub extern var GLVersion: struct_gladGLversionStruct;
pub extern fn gladLoadGL() c_int;
pub extern fn gladLoadGLLoader(GLADloadproc) c_int;
pub const __builtin_va_list = [*c]u8;
pub const __gnuc_va_list = __builtin_va_list;
pub const va_list = __gnuc_va_list;
// C:\Zig\lib\libc\include\any-windows-any/_mingw.h:598:3: warning: TODO implement translation of stmt class GCCAsmStmtClass

// C:\Zig\lib\libc\include\any-windows-any/_mingw.h:595:36: warning: unable to translate function, demoted to extern
pub extern fn __debugbreak() void;
// C:\Zig\lib\libc\include\any-windows-any/_mingw.h:619:3: warning: TODO implement translation of stmt class GCCAsmStmtClass

// C:\Zig\lib\libc\include\any-windows-any/_mingw.h:616:60: warning: unable to translate function, demoted to extern
pub extern fn __fastfail(arg_code: c_uint) noreturn;
pub extern fn __mingw_get_crt_info() [*c]const u8;
pub const rsize_t = usize;
pub const ptrdiff_t = c_longlong;
pub const wchar_t = c_ushort;
pub const wint_t = c_ushort;
pub const wctype_t = c_ushort;
pub const errno_t = c_int;
pub const __time32_t = c_long;
pub const __time64_t = c_longlong;
pub const time_t = __time64_t;
pub const struct_threadlocaleinfostruct = extern struct {
    _locale_pctype: [*c]const c_ushort = @import("std").mem.zeroes([*c]const c_ushort),
    _locale_mb_cur_max: c_int = @import("std").mem.zeroes(c_int),
    _locale_lc_codepage: c_uint = @import("std").mem.zeroes(c_uint),
};
pub const struct_threadmbcinfostruct = opaque {};
pub const pthreadlocinfo = [*c]struct_threadlocaleinfostruct;
pub const pthreadmbcinfo = ?*struct_threadmbcinfostruct;
pub const struct___lc_time_data = opaque {};
pub const struct_localeinfo_struct = extern struct {
    locinfo: pthreadlocinfo = @import("std").mem.zeroes(pthreadlocinfo),
    mbcinfo: pthreadmbcinfo = @import("std").mem.zeroes(pthreadmbcinfo),
};
pub const _locale_tstruct = struct_localeinfo_struct;
pub const _locale_t = [*c]struct_localeinfo_struct;
pub const struct_tagLC_ID = extern struct {
    wLanguage: c_ushort = @import("std").mem.zeroes(c_ushort),
    wCountry: c_ushort = @import("std").mem.zeroes(c_ushort),
    wCodePage: c_ushort = @import("std").mem.zeroes(c_ushort),
};
pub const LC_ID = struct_tagLC_ID;
pub const LPLC_ID = [*c]struct_tagLC_ID;
pub const threadlocinfo = struct_threadlocaleinfostruct;
pub const int_least8_t = i8;
pub const uint_least8_t = u8;
pub const int_least16_t = c_short;
pub const uint_least16_t = c_ushort;
pub const int_least32_t = c_int;
pub const uint_least32_t = c_uint;
pub const int_least64_t = c_longlong;
pub const uint_least64_t = c_ulonglong;
pub const int_fast8_t = i8;
pub const uint_fast8_t = u8;
pub const int_fast16_t = c_short;
pub const uint_fast16_t = c_ushort;
pub const int_fast32_t = c_int;
pub const uint_fast32_t = c_uint;
pub const int_fast64_t = c_longlong;
pub const uint_fast64_t = c_ulonglong;
pub const intmax_t = c_longlong;
pub const uintmax_t = c_ulonglong;
pub const khronos_int32_t = i32;
pub const khronos_uint32_t = u32;
pub const khronos_int64_t = i64;
pub const khronos_uint64_t = u64;
pub const khronos_int8_t = i8;
pub const khronos_uint8_t = u8;
pub const khronos_int16_t = c_short;
pub const khronos_uint16_t = c_ushort;
pub const khronos_intptr_t = isize;
pub const khronos_uintptr_t = usize;
pub const khronos_ssize_t = c_longlong;
pub const khronos_usize_t = c_ulonglong;
pub const khronos_float_t = f32;
pub const khronos_utime_nanoseconds_t = khronos_uint64_t;
pub const khronos_stime_nanoseconds_t = khronos_int64_t;
pub const KHRONOS_FALSE: c_int = 0;
pub const KHRONOS_TRUE: c_int = 1;
pub const KHRONOS_BOOLEAN_ENUM_FORCE_SIZE: c_int = 2147483647;
pub const khronos_boolean_enum_t = c_uint;
pub const GLenum = c_uint;
pub const GLboolean = u8;
pub const GLbitfield = c_uint;
pub const GLvoid = anyopaque;
pub const GLbyte = khronos_int8_t;
pub const GLubyte = khronos_uint8_t;
pub const GLshort = khronos_int16_t;
pub const GLushort = khronos_uint16_t;
pub const GLint = c_int;
pub const GLuint = c_uint;
pub const GLclampx = khronos_int32_t;
pub const GLsizei = c_int;
pub const GLfloat = khronos_float_t;
pub const GLclampf = khronos_float_t;
pub const GLdouble = f64;
pub const GLclampd = f64;
pub const GLeglClientBufferEXT = ?*anyopaque;
pub const GLeglImageOES = ?*anyopaque;
pub const GLchar = u8;
pub const GLcharARB = u8;
pub const GLhandleARB = c_uint;
pub const GLhalf = khronos_uint16_t;
pub const GLhalfARB = khronos_uint16_t;
pub const GLfixed = khronos_int32_t;
pub const GLintptr = khronos_intptr_t;
pub const GLintptrARB = khronos_intptr_t;
pub const GLsizeiptr = khronos_ssize_t;
pub const GLsizeiptrARB = khronos_ssize_t;
pub const GLint64 = khronos_int64_t;
pub const GLint64EXT = khronos_int64_t;
pub const GLuint64 = khronos_uint64_t;
pub const GLuint64EXT = khronos_uint64_t;
pub const struct___GLsync = opaque {};
pub const GLsync = ?*struct___GLsync;
pub const struct__cl_context = opaque {};
pub const struct__cl_event = opaque {};
pub const GLDEBUGPROC = ?*const fn (GLenum, GLenum, GLuint, GLenum, GLsizei, [*c]const GLchar, ?*const anyopaque) callconv(.c) void;
pub const GLDEBUGPROCARB = ?*const fn (GLenum, GLenum, GLuint, GLenum, GLsizei, [*c]const GLchar, ?*const anyopaque) callconv(.c) void;
pub const GLDEBUGPROCKHR = ?*const fn (GLenum, GLenum, GLuint, GLenum, GLsizei, [*c]const GLchar, ?*const anyopaque) callconv(.c) void;
pub const GLDEBUGPROCAMD = ?*const fn (GLuint, GLenum, GLenum, GLsizei, [*c]const GLchar, ?*anyopaque) callconv(.c) void;
pub const GLhalfNV = c_ushort;
pub const GLvdpauSurfaceNV = GLintptr;
pub const GLVULKANPROCNV = ?*const fn () callconv(.c) void;
pub extern var GLAD_GL_VERSION_1_0: c_int;
pub const PFNGLCULLFACEPROC = ?*const fn (GLenum) callconv(.c) void;
pub extern var glad_glCullFace: PFNGLCULLFACEPROC;
pub const PFNGLFRONTFACEPROC = ?*const fn (GLenum) callconv(.c) void;
pub extern var glad_glFrontFace: PFNGLFRONTFACEPROC;
pub const PFNGLHINTPROC = ?*const fn (GLenum, GLenum) callconv(.c) void;
pub extern var glad_glHint: PFNGLHINTPROC;
pub const PFNGLLINEWIDTHPROC = ?*const fn (GLfloat) callconv(.c) void;
pub extern var glad_glLineWidth: PFNGLLINEWIDTHPROC;
pub const PFNGLPOINTSIZEPROC = ?*const fn (GLfloat) callconv(.c) void;
pub extern var glad_glPointSize: PFNGLPOINTSIZEPROC;
pub const PFNGLPOLYGONMODEPROC = ?*const fn (GLenum, GLenum) callconv(.c) void;
pub extern var glad_glPolygonMode: PFNGLPOLYGONMODEPROC;
pub const PFNGLSCISSORPROC = ?*const fn (GLint, GLint, GLsizei, GLsizei) callconv(.c) void;
pub extern var glad_glScissor: PFNGLSCISSORPROC;
pub const PFNGLTEXPARAMETERFPROC = ?*const fn (GLenum, GLenum, GLfloat) callconv(.c) void;
pub extern var glad_glTexParameterf: PFNGLTEXPARAMETERFPROC;
pub const PFNGLTEXPARAMETERFVPROC = ?*const fn (GLenum, GLenum, [*c]const GLfloat) callconv(.c) void;
pub extern var glad_glTexParameterfv: PFNGLTEXPARAMETERFVPROC;
pub const PFNGLTEXPARAMETERIPROC = ?*const fn (GLenum, GLenum, GLint) callconv(.c) void;
pub extern var glad_glTexParameteri: PFNGLTEXPARAMETERIPROC;
pub const PFNGLTEXPARAMETERIVPROC = ?*const fn (GLenum, GLenum, [*c]const GLint) callconv(.c) void;
pub extern var glad_glTexParameteriv: PFNGLTEXPARAMETERIVPROC;
pub const PFNGLTEXIMAGE1DPROC = ?*const fn (GLenum, GLint, GLint, GLsizei, GLint, GLenum, GLenum, ?*const anyopaque) callconv(.c) void;
pub extern var glad_glTexImage1D: PFNGLTEXIMAGE1DPROC;
pub const PFNGLTEXIMAGE2DPROC = ?*const fn (GLenum, GLint, GLint, GLsizei, GLsizei, GLint, GLenum, GLenum, ?*const anyopaque) callconv(.c) void;
pub extern var glad_glTexImage2D: PFNGLTEXIMAGE2DPROC;
pub const PFNGLDRAWBUFFERPROC = ?*const fn (GLenum) callconv(.c) void;
pub extern var glad_glDrawBuffer: PFNGLDRAWBUFFERPROC;
pub const PFNGLCLEARPROC = ?*const fn (GLbitfield) callconv(.c) void;
pub extern var glad_glClear: PFNGLCLEARPROC;
pub const PFNGLCLEARCOLORPROC = ?*const fn (GLfloat, GLfloat, GLfloat, GLfloat) callconv(.c) void;
pub extern var glad_glClearColor: PFNGLCLEARCOLORPROC;
pub const PFNGLCLEARSTENCILPROC = ?*const fn (GLint) callconv(.c) void;
pub extern var glad_glClearStencil: PFNGLCLEARSTENCILPROC;
pub const PFNGLCLEARDEPTHPROC = ?*const fn (GLdouble) callconv(.c) void;
pub extern var glad_glClearDepth: PFNGLCLEARDEPTHPROC;
pub const PFNGLSTENCILMASKPROC = ?*const fn (GLuint) callconv(.c) void;
pub extern var glad_glStencilMask: PFNGLSTENCILMASKPROC;
pub const PFNGLCOLORMASKPROC = ?*const fn (GLboolean, GLboolean, GLboolean, GLboolean) callconv(.c) void;
pub extern var glad_glColorMask: PFNGLCOLORMASKPROC;
pub const PFNGLDEPTHMASKPROC = ?*const fn (GLboolean) callconv(.c) void;
pub extern var glad_glDepthMask: PFNGLDEPTHMASKPROC;
pub const PFNGLDISABLEPROC = ?*const fn (GLenum) callconv(.c) void;
pub extern var glad_glDisable: PFNGLDISABLEPROC;
pub const PFNGLENABLEPROC = ?*const fn (GLenum) callconv(.c) void;
pub extern var glad_glEnable: PFNGLENABLEPROC;
pub const PFNGLFINISHPROC = ?*const fn () callconv(.c) void;
pub extern var glad_glFinish: PFNGLFINISHPROC;
pub const PFNGLFLUSHPROC = ?*const fn () callconv(.c) void;
pub extern var glad_glFlush: PFNGLFLUSHPROC;
pub const PFNGLBLENDFUNCPROC = ?*const fn (GLenum, GLenum) callconv(.c) void;
pub extern var glad_glBlendFunc: PFNGLBLENDFUNCPROC;
pub const PFNGLLOGICOPPROC = ?*const fn (GLenum) callconv(.c) void;
pub extern var glad_glLogicOp: PFNGLLOGICOPPROC;
pub const PFNGLSTENCILFUNCPROC = ?*const fn (GLenum, GLint, GLuint) callconv(.c) void;
pub extern var glad_glStencilFunc: PFNGLSTENCILFUNCPROC;
pub const PFNGLSTENCILOPPROC = ?*const fn (GLenum, GLenum, GLenum) callconv(.c) void;
pub extern var glad_glStencilOp: PFNGLSTENCILOPPROC;
pub const PFNGLDEPTHFUNCPROC = ?*const fn (GLenum) callconv(.c) void;
pub extern var glad_glDepthFunc: PFNGLDEPTHFUNCPROC;
pub const PFNGLPIXELSTOREFPROC = ?*const fn (GLenum, GLfloat) callconv(.c) void;
pub extern var glad_glPixelStoref: PFNGLPIXELSTOREFPROC;
pub const PFNGLPIXELSTOREIPROC = ?*const fn (GLenum, GLint) callconv(.c) void;
pub extern var glad_glPixelStorei: PFNGLPIXELSTOREIPROC;
pub const PFNGLREADBUFFERPROC = ?*const fn (GLenum) callconv(.c) void;
pub extern var glad_glReadBuffer: PFNGLREADBUFFERPROC;
pub const PFNGLREADPIXELSPROC = ?*const fn (GLint, GLint, GLsizei, GLsizei, GLenum, GLenum, ?*anyopaque) callconv(.c) void;
pub extern var glad_glReadPixels: PFNGLREADPIXELSPROC;
pub const PFNGLGETBOOLEANVPROC = ?*const fn (GLenum, [*c]GLboolean) callconv(.c) void;
pub extern var glad_glGetBooleanv: PFNGLGETBOOLEANVPROC;
pub const PFNGLGETDOUBLEVPROC = ?*const fn (GLenum, [*c]GLdouble) callconv(.c) void;
pub extern var glad_glGetDoublev: PFNGLGETDOUBLEVPROC;
pub const PFNGLGETERRORPROC = ?*const fn () callconv(.c) GLenum;
pub extern var glad_glGetError: PFNGLGETERRORPROC;
pub const PFNGLGETFLOATVPROC = ?*const fn (GLenum, [*c]GLfloat) callconv(.c) void;
pub extern var glad_glGetFloatv: PFNGLGETFLOATVPROC;
pub const PFNGLGETINTEGERVPROC = ?*const fn (GLenum, [*c]GLint) callconv(.c) void;
pub extern var glad_glGetIntegerv: PFNGLGETINTEGERVPROC;
pub const PFNGLGETSTRINGPROC = ?*const fn (GLenum) callconv(.c) [*c]const GLubyte;
pub extern var glad_glGetString: PFNGLGETSTRINGPROC;
pub const PFNGLGETTEXIMAGEPROC = ?*const fn (GLenum, GLint, GLenum, GLenum, ?*anyopaque) callconv(.c) void;
pub extern var glad_glGetTexImage: PFNGLGETTEXIMAGEPROC;
pub const PFNGLGETTEXPARAMETERFVPROC = ?*const fn (GLenum, GLenum, [*c]GLfloat) callconv(.c) void;
pub extern var glad_glGetTexParameterfv: PFNGLGETTEXPARAMETERFVPROC;
pub const PFNGLGETTEXPARAMETERIVPROC = ?*const fn (GLenum, GLenum, [*c]GLint) callconv(.c) void;
pub extern var glad_glGetTexParameteriv: PFNGLGETTEXPARAMETERIVPROC;
pub const PFNGLGETTEXLEVELPARAMETERFVPROC = ?*const fn (GLenum, GLint, GLenum, [*c]GLfloat) callconv(.c) void;
pub extern var glad_glGetTexLevelParameterfv: PFNGLGETTEXLEVELPARAMETERFVPROC;
pub const PFNGLGETTEXLEVELPARAMETERIVPROC = ?*const fn (GLenum, GLint, GLenum, [*c]GLint) callconv(.c) void;
pub extern var glad_glGetTexLevelParameteriv: PFNGLGETTEXLEVELPARAMETERIVPROC;
pub const PFNGLISENABLEDPROC = ?*const fn (GLenum) callconv(.c) GLboolean;
pub extern var glad_glIsEnabled: PFNGLISENABLEDPROC;
pub const PFNGLDEPTHRANGEPROC = ?*const fn (GLdouble, GLdouble) callconv(.c) void;
pub extern var glad_glDepthRange: PFNGLDEPTHRANGEPROC;
pub const PFNGLVIEWPORTPROC = ?*const fn (GLint, GLint, GLsizei, GLsizei) callconv(.c) void;
pub extern var glad_glViewport: PFNGLVIEWPORTPROC;
pub extern var GLAD_GL_VERSION_1_1: c_int;
pub const PFNGLDRAWARRAYSPROC = ?*const fn (GLenum, GLint, GLsizei) callconv(.c) void;
pub extern var glad_glDrawArrays: PFNGLDRAWARRAYSPROC;
pub const PFNGLDRAWELEMENTSPROC = ?*const fn (GLenum, GLsizei, GLenum, ?*const anyopaque) callconv(.c) void;
pub extern var glad_glDrawElements: PFNGLDRAWELEMENTSPROC;
pub const PFNGLPOLYGONOFFSETPROC = ?*const fn (GLfloat, GLfloat) callconv(.c) void;
pub extern var glad_glPolygonOffset: PFNGLPOLYGONOFFSETPROC;
pub const PFNGLCOPYTEXIMAGE1DPROC = ?*const fn (GLenum, GLint, GLenum, GLint, GLint, GLsizei, GLint) callconv(.c) void;
pub extern var glad_glCopyTexImage1D: PFNGLCOPYTEXIMAGE1DPROC;
pub const PFNGLCOPYTEXIMAGE2DPROC = ?*const fn (GLenum, GLint, GLenum, GLint, GLint, GLsizei, GLsizei, GLint) callconv(.c) void;
pub extern var glad_glCopyTexImage2D: PFNGLCOPYTEXIMAGE2DPROC;
pub const PFNGLCOPYTEXSUBIMAGE1DPROC = ?*const fn (GLenum, GLint, GLint, GLint, GLint, GLsizei) callconv(.c) void;
pub extern var glad_glCopyTexSubImage1D: PFNGLCOPYTEXSUBIMAGE1DPROC;
pub const PFNGLCOPYTEXSUBIMAGE2DPROC = ?*const fn (GLenum, GLint, GLint, GLint, GLint, GLint, GLsizei, GLsizei) callconv(.c) void;
pub extern var glad_glCopyTexSubImage2D: PFNGLCOPYTEXSUBIMAGE2DPROC;
pub const PFNGLTEXSUBIMAGE1DPROC = ?*const fn (GLenum, GLint, GLint, GLsizei, GLenum, GLenum, ?*const anyopaque) callconv(.c) void;
pub extern var glad_glTexSubImage1D: PFNGLTEXSUBIMAGE1DPROC;
pub const PFNGLTEXSUBIMAGE2DPROC = ?*const fn (GLenum, GLint, GLint, GLint, GLsizei, GLsizei, GLenum, GLenum, ?*const anyopaque) callconv(.c) void;
pub extern var glad_glTexSubImage2D: PFNGLTEXSUBIMAGE2DPROC;
pub const PFNGLBINDTEXTUREPROC = ?*const fn (GLenum, GLuint) callconv(.c) void;
pub extern var glad_glBindTexture: PFNGLBINDTEXTUREPROC;
pub const PFNGLDELETETEXTURESPROC = ?*const fn (GLsizei, [*c]const GLuint) callconv(.c) void;
pub extern var glad_glDeleteTextures: PFNGLDELETETEXTURESPROC;
pub const PFNGLGENTEXTURESPROC = ?*const fn (GLsizei, [*c]GLuint) callconv(.c) void;
pub extern var glad_glGenTextures: PFNGLGENTEXTURESPROC;
pub const PFNGLISTEXTUREPROC = ?*const fn (GLuint) callconv(.c) GLboolean;
pub extern var glad_glIsTexture: PFNGLISTEXTUREPROC;
pub extern var GLAD_GL_VERSION_1_2: c_int;
pub const PFNGLDRAWRANGEELEMENTSPROC = ?*const fn (GLenum, GLuint, GLuint, GLsizei, GLenum, ?*const anyopaque) callconv(.c) void;
pub extern var glad_glDrawRangeElements: PFNGLDRAWRANGEELEMENTSPROC;
pub const PFNGLTEXIMAGE3DPROC = ?*const fn (GLenum, GLint, GLint, GLsizei, GLsizei, GLsizei, GLint, GLenum, GLenum, ?*const anyopaque) callconv(.c) void;
pub extern var glad_glTexImage3D: PFNGLTEXIMAGE3DPROC;
pub const PFNGLTEXSUBIMAGE3DPROC = ?*const fn (GLenum, GLint, GLint, GLint, GLint, GLsizei, GLsizei, GLsizei, GLenum, GLenum, ?*const anyopaque) callconv(.c) void;
pub extern var glad_glTexSubImage3D: PFNGLTEXSUBIMAGE3DPROC;
pub const PFNGLCOPYTEXSUBIMAGE3DPROC = ?*const fn (GLenum, GLint, GLint, GLint, GLint, GLint, GLint, GLsizei, GLsizei) callconv(.c) void;
pub extern var glad_glCopyTexSubImage3D: PFNGLCOPYTEXSUBIMAGE3DPROC;
pub extern var GLAD_GL_VERSION_1_3: c_int;
pub const PFNGLACTIVETEXTUREPROC = ?*const fn (GLenum) callconv(.c) void;
pub extern var glad_glActiveTexture: PFNGLACTIVETEXTUREPROC;
pub const PFNGLSAMPLECOVERAGEPROC = ?*const fn (GLfloat, GLboolean) callconv(.c) void;
pub extern var glad_glSampleCoverage: PFNGLSAMPLECOVERAGEPROC;
pub const PFNGLCOMPRESSEDTEXIMAGE3DPROC = ?*const fn (GLenum, GLint, GLenum, GLsizei, GLsizei, GLsizei, GLint, GLsizei, ?*const anyopaque) callconv(.c) void;
pub extern var glad_glCompressedTexImage3D: PFNGLCOMPRESSEDTEXIMAGE3DPROC;
pub const PFNGLCOMPRESSEDTEXIMAGE2DPROC = ?*const fn (GLenum, GLint, GLenum, GLsizei, GLsizei, GLint, GLsizei, ?*const anyopaque) callconv(.c) void;
pub extern var glad_glCompressedTexImage2D: PFNGLCOMPRESSEDTEXIMAGE2DPROC;
pub const PFNGLCOMPRESSEDTEXIMAGE1DPROC = ?*const fn (GLenum, GLint, GLenum, GLsizei, GLint, GLsizei, ?*const anyopaque) callconv(.c) void;
pub extern var glad_glCompressedTexImage1D: PFNGLCOMPRESSEDTEXIMAGE1DPROC;
pub const PFNGLCOMPRESSEDTEXSUBIMAGE3DPROC = ?*const fn (GLenum, GLint, GLint, GLint, GLint, GLsizei, GLsizei, GLsizei, GLenum, GLsizei, ?*const anyopaque) callconv(.c) void;
pub extern var glad_glCompressedTexSubImage3D: PFNGLCOMPRESSEDTEXSUBIMAGE3DPROC;
pub const PFNGLCOMPRESSEDTEXSUBIMAGE2DPROC = ?*const fn (GLenum, GLint, GLint, GLint, GLsizei, GLsizei, GLenum, GLsizei, ?*const anyopaque) callconv(.c) void;
pub extern var glad_glCompressedTexSubImage2D: PFNGLCOMPRESSEDTEXSUBIMAGE2DPROC;
pub const PFNGLCOMPRESSEDTEXSUBIMAGE1DPROC = ?*const fn (GLenum, GLint, GLint, GLsizei, GLenum, GLsizei, ?*const anyopaque) callconv(.c) void;
pub extern var glad_glCompressedTexSubImage1D: PFNGLCOMPRESSEDTEXSUBIMAGE1DPROC;
pub const PFNGLGETCOMPRESSEDTEXIMAGEPROC = ?*const fn (GLenum, GLint, ?*anyopaque) callconv(.c) void;
pub extern var glad_glGetCompressedTexImage: PFNGLGETCOMPRESSEDTEXIMAGEPROC;
pub extern var GLAD_GL_VERSION_1_4: c_int;
pub const PFNGLBLENDFUNCSEPARATEPROC = ?*const fn (GLenum, GLenum, GLenum, GLenum) callconv(.c) void;
pub extern var glad_glBlendFuncSeparate: PFNGLBLENDFUNCSEPARATEPROC;
pub const PFNGLMULTIDRAWARRAYSPROC = ?*const fn (GLenum, [*c]const GLint, [*c]const GLsizei, GLsizei) callconv(.c) void;
pub extern var glad_glMultiDrawArrays: PFNGLMULTIDRAWARRAYSPROC;
pub const PFNGLMULTIDRAWELEMENTSPROC = ?*const fn (GLenum, [*c]const GLsizei, GLenum, [*c]const ?*const anyopaque, GLsizei) callconv(.c) void;
pub extern var glad_glMultiDrawElements: PFNGLMULTIDRAWELEMENTSPROC;
pub const PFNGLPOINTPARAMETERFPROC = ?*const fn (GLenum, GLfloat) callconv(.c) void;
pub extern var glad_glPointParameterf: PFNGLPOINTPARAMETERFPROC;
pub const PFNGLPOINTPARAMETERFVPROC = ?*const fn (GLenum, [*c]const GLfloat) callconv(.c) void;
pub extern var glad_glPointParameterfv: PFNGLPOINTPARAMETERFVPROC;
pub const PFNGLPOINTPARAMETERIPROC = ?*const fn (GLenum, GLint) callconv(.c) void;
pub extern var glad_glPointParameteri: PFNGLPOINTPARAMETERIPROC;
pub const PFNGLPOINTPARAMETERIVPROC = ?*const fn (GLenum, [*c]const GLint) callconv(.c) void;
pub extern var glad_glPointParameteriv: PFNGLPOINTPARAMETERIVPROC;
pub const PFNGLBLENDCOLORPROC = ?*const fn (GLfloat, GLfloat, GLfloat, GLfloat) callconv(.c) void;
pub extern var glad_glBlendColor: PFNGLBLENDCOLORPROC;
pub const PFNGLBLENDEQUATIONPROC = ?*const fn (GLenum) callconv(.c) void;
pub extern var glad_glBlendEquation: PFNGLBLENDEQUATIONPROC;
pub extern var GLAD_GL_VERSION_1_5: c_int;
pub const PFNGLGENQUERIESPROC = ?*const fn (GLsizei, [*c]GLuint) callconv(.c) void;
pub extern var glad_glGenQueries: PFNGLGENQUERIESPROC;
pub const PFNGLDELETEQUERIESPROC = ?*const fn (GLsizei, [*c]const GLuint) callconv(.c) void;
pub extern var glad_glDeleteQueries: PFNGLDELETEQUERIESPROC;
pub const PFNGLISQUERYPROC = ?*const fn (GLuint) callconv(.c) GLboolean;
pub extern var glad_glIsQuery: PFNGLISQUERYPROC;
pub const PFNGLBEGINQUERYPROC = ?*const fn (GLenum, GLuint) callconv(.c) void;
pub extern var glad_glBeginQuery: PFNGLBEGINQUERYPROC;
pub const PFNGLENDQUERYPROC = ?*const fn (GLenum) callconv(.c) void;
pub extern var glad_glEndQuery: PFNGLENDQUERYPROC;
pub const PFNGLGETQUERYIVPROC = ?*const fn (GLenum, GLenum, [*c]GLint) callconv(.c) void;
pub extern var glad_glGetQueryiv: PFNGLGETQUERYIVPROC;
pub const PFNGLGETQUERYOBJECTIVPROC = ?*const fn (GLuint, GLenum, [*c]GLint) callconv(.c) void;
pub extern var glad_glGetQueryObjectiv: PFNGLGETQUERYOBJECTIVPROC;
pub const PFNGLGETQUERYOBJECTUIVPROC = ?*const fn (GLuint, GLenum, [*c]GLuint) callconv(.c) void;
pub extern var glad_glGetQueryObjectuiv: PFNGLGETQUERYOBJECTUIVPROC;
pub const PFNGLBINDBUFFERPROC = ?*const fn (GLenum, GLuint) callconv(.c) void;
pub extern var glad_glBindBuffer: PFNGLBINDBUFFERPROC;
pub const PFNGLDELETEBUFFERSPROC = ?*const fn (GLsizei, [*c]const GLuint) callconv(.c) void;
pub extern var glad_glDeleteBuffers: PFNGLDELETEBUFFERSPROC;
pub const PFNGLGENBUFFERSPROC = ?*const fn (GLsizei, [*c]GLuint) callconv(.c) void;
pub extern var glad_glGenBuffers: PFNGLGENBUFFERSPROC;
pub const PFNGLISBUFFERPROC = ?*const fn (GLuint) callconv(.c) GLboolean;
pub extern var glad_glIsBuffer: PFNGLISBUFFERPROC;
pub const PFNGLBUFFERDATAPROC = ?*const fn (GLenum, GLsizeiptr, ?*const anyopaque, GLenum) callconv(.c) void;
pub extern var glad_glBufferData: PFNGLBUFFERDATAPROC;
pub const PFNGLBUFFERSUBDATAPROC = ?*const fn (GLenum, GLintptr, GLsizeiptr, ?*const anyopaque) callconv(.c) void;
pub extern var glad_glBufferSubData: PFNGLBUFFERSUBDATAPROC;
pub const PFNGLGETBUFFERSUBDATAPROC = ?*const fn (GLenum, GLintptr, GLsizeiptr, ?*anyopaque) callconv(.c) void;
pub extern var glad_glGetBufferSubData: PFNGLGETBUFFERSUBDATAPROC;
pub const PFNGLMAPBUFFERPROC = ?*const fn (GLenum, GLenum) callconv(.c) ?*anyopaque;
pub extern var glad_glMapBuffer: PFNGLMAPBUFFERPROC;
pub const PFNGLUNMAPBUFFERPROC = ?*const fn (GLenum) callconv(.c) GLboolean;
pub extern var glad_glUnmapBuffer: PFNGLUNMAPBUFFERPROC;
pub const PFNGLGETBUFFERPARAMETERIVPROC = ?*const fn (GLenum, GLenum, [*c]GLint) callconv(.c) void;
pub extern var glad_glGetBufferParameteriv: PFNGLGETBUFFERPARAMETERIVPROC;
pub const PFNGLGETBUFFERPOINTERVPROC = ?*const fn (GLenum, GLenum, [*c]?*anyopaque) callconv(.c) void;
pub extern var glad_glGetBufferPointerv: PFNGLGETBUFFERPOINTERVPROC;
pub extern var GLAD_GL_VERSION_2_0: c_int;
pub const PFNGLBLENDEQUATIONSEPARATEPROC = ?*const fn (GLenum, GLenum) callconv(.c) void;
pub extern var glad_glBlendEquationSeparate: PFNGLBLENDEQUATIONSEPARATEPROC;
pub const PFNGLDRAWBUFFERSPROC = ?*const fn (GLsizei, [*c]const GLenum) callconv(.c) void;
pub extern var glad_glDrawBuffers: PFNGLDRAWBUFFERSPROC;
pub const PFNGLSTENCILOPSEPARATEPROC = ?*const fn (GLenum, GLenum, GLenum, GLenum) callconv(.c) void;
pub extern var glad_glStencilOpSeparate: PFNGLSTENCILOPSEPARATEPROC;
pub const PFNGLSTENCILFUNCSEPARATEPROC = ?*const fn (GLenum, GLenum, GLint, GLuint) callconv(.c) void;
pub extern var glad_glStencilFuncSeparate: PFNGLSTENCILFUNCSEPARATEPROC;
pub const PFNGLSTENCILMASKSEPARATEPROC = ?*const fn (GLenum, GLuint) callconv(.c) void;
pub extern var glad_glStencilMaskSeparate: PFNGLSTENCILMASKSEPARATEPROC;
pub const PFNGLATTACHSHADERPROC = ?*const fn (GLuint, GLuint) callconv(.c) void;
pub extern var glad_glAttachShader: PFNGLATTACHSHADERPROC;
pub const PFNGLBINDATTRIBLOCATIONPROC = ?*const fn (GLuint, GLuint, [*c]const GLchar) callconv(.c) void;
pub extern var glad_glBindAttribLocation: PFNGLBINDATTRIBLOCATIONPROC;
pub const PFNGLCOMPILESHADERPROC = ?*const fn (GLuint) callconv(.c) void;
pub extern var glad_glCompileShader: PFNGLCOMPILESHADERPROC;
pub const PFNGLCREATEPROGRAMPROC = ?*const fn () callconv(.c) GLuint;
pub extern var glad_glCreateProgram: PFNGLCREATEPROGRAMPROC;
pub const PFNGLCREATESHADERPROC = ?*const fn (GLenum) callconv(.c) GLuint;
pub extern var glad_glCreateShader: PFNGLCREATESHADERPROC;
pub const PFNGLDELETEPROGRAMPROC = ?*const fn (GLuint) callconv(.c) void;
pub extern var glad_glDeleteProgram: PFNGLDELETEPROGRAMPROC;
pub const PFNGLDELETESHADERPROC = ?*const fn (GLuint) callconv(.c) void;
pub extern var glad_glDeleteShader: PFNGLDELETESHADERPROC;
pub const PFNGLDETACHSHADERPROC = ?*const fn (GLuint, GLuint) callconv(.c) void;
pub extern var glad_glDetachShader: PFNGLDETACHSHADERPROC;
pub const PFNGLDISABLEVERTEXATTRIBARRAYPROC = ?*const fn (GLuint) callconv(.c) void;
pub extern var glad_glDisableVertexAttribArray: PFNGLDISABLEVERTEXATTRIBARRAYPROC;
pub const PFNGLENABLEVERTEXATTRIBARRAYPROC = ?*const fn (GLuint) callconv(.c) void;
pub extern var glad_glEnableVertexAttribArray: PFNGLENABLEVERTEXATTRIBARRAYPROC;
pub const PFNGLGETACTIVEATTRIBPROC = ?*const fn (GLuint, GLuint, GLsizei, [*c]GLsizei, [*c]GLint, [*c]GLenum, [*c]GLchar) callconv(.c) void;
pub extern var glad_glGetActiveAttrib: PFNGLGETACTIVEATTRIBPROC;
pub const PFNGLGETACTIVEUNIFORMPROC = ?*const fn (GLuint, GLuint, GLsizei, [*c]GLsizei, [*c]GLint, [*c]GLenum, [*c]GLchar) callconv(.c) void;
pub extern var glad_glGetActiveUniform: PFNGLGETACTIVEUNIFORMPROC;
pub const PFNGLGETATTACHEDSHADERSPROC = ?*const fn (GLuint, GLsizei, [*c]GLsizei, [*c]GLuint) callconv(.c) void;
pub extern var glad_glGetAttachedShaders: PFNGLGETATTACHEDSHADERSPROC;
pub const PFNGLGETATTRIBLOCATIONPROC = ?*const fn (GLuint, [*c]const GLchar) callconv(.c) GLint;
pub extern var glad_glGetAttribLocation: PFNGLGETATTRIBLOCATIONPROC;
pub const PFNGLGETPROGRAMIVPROC = ?*const fn (GLuint, GLenum, [*c]GLint) callconv(.c) void;
pub extern var glad_glGetProgramiv: PFNGLGETPROGRAMIVPROC;
pub const PFNGLGETPROGRAMINFOLOGPROC = ?*const fn (GLuint, GLsizei, [*c]GLsizei, [*c]GLchar) callconv(.c) void;
pub extern var glad_glGetProgramInfoLog: PFNGLGETPROGRAMINFOLOGPROC;
pub const PFNGLGETSHADERIVPROC = ?*const fn (GLuint, GLenum, [*c]GLint) callconv(.c) void;
pub extern var glad_glGetShaderiv: PFNGLGETSHADERIVPROC;
pub const PFNGLGETSHADERINFOLOGPROC = ?*const fn (GLuint, GLsizei, [*c]GLsizei, [*c]GLchar) callconv(.c) void;
pub extern var glad_glGetShaderInfoLog: PFNGLGETSHADERINFOLOGPROC;
pub const PFNGLGETSHADERSOURCEPROC = ?*const fn (GLuint, GLsizei, [*c]GLsizei, [*c]GLchar) callconv(.c) void;
pub extern var glad_glGetShaderSource: PFNGLGETSHADERSOURCEPROC;
pub const PFNGLGETUNIFORMLOCATIONPROC = ?*const fn (GLuint, [*c]const GLchar) callconv(.c) GLint;
pub extern var glad_glGetUniformLocation: PFNGLGETUNIFORMLOCATIONPROC;
pub const PFNGLGETUNIFORMFVPROC = ?*const fn (GLuint, GLint, [*c]GLfloat) callconv(.c) void;
pub extern var glad_glGetUniformfv: PFNGLGETUNIFORMFVPROC;
pub const PFNGLGETUNIFORMIVPROC = ?*const fn (GLuint, GLint, [*c]GLint) callconv(.c) void;
pub extern var glad_glGetUniformiv: PFNGLGETUNIFORMIVPROC;
pub const PFNGLGETVERTEXATTRIBDVPROC = ?*const fn (GLuint, GLenum, [*c]GLdouble) callconv(.c) void;
pub extern var glad_glGetVertexAttribdv: PFNGLGETVERTEXATTRIBDVPROC;
pub const PFNGLGETVERTEXATTRIBFVPROC = ?*const fn (GLuint, GLenum, [*c]GLfloat) callconv(.c) void;
pub extern var glad_glGetVertexAttribfv: PFNGLGETVERTEXATTRIBFVPROC;
pub const PFNGLGETVERTEXATTRIBIVPROC = ?*const fn (GLuint, GLenum, [*c]GLint) callconv(.c) void;
pub extern var glad_glGetVertexAttribiv: PFNGLGETVERTEXATTRIBIVPROC;
pub const PFNGLGETVERTEXATTRIBPOINTERVPROC = ?*const fn (GLuint, GLenum, [*c]?*anyopaque) callconv(.c) void;
pub extern var glad_glGetVertexAttribPointerv: PFNGLGETVERTEXATTRIBPOINTERVPROC;
pub const PFNGLISPROGRAMPROC = ?*const fn (GLuint) callconv(.c) GLboolean;
pub extern var glad_glIsProgram: PFNGLISPROGRAMPROC;
pub const PFNGLISSHADERPROC = ?*const fn (GLuint) callconv(.c) GLboolean;
pub extern var glad_glIsShader: PFNGLISSHADERPROC;
pub const PFNGLLINKPROGRAMPROC = ?*const fn (GLuint) callconv(.c) void;
pub extern var glad_glLinkProgram: PFNGLLINKPROGRAMPROC;
pub const PFNGLSHADERSOURCEPROC = ?*const fn (GLuint, GLsizei, [*c]const [*c]const GLchar, [*c]const GLint) callconv(.c) void;
pub extern var glad_glShaderSource: PFNGLSHADERSOURCEPROC;
pub const PFNGLUSEPROGRAMPROC = ?*const fn (GLuint) callconv(.c) void;
pub extern var glad_glUseProgram: PFNGLUSEPROGRAMPROC;
pub const PFNGLUNIFORM1FPROC = ?*const fn (GLint, GLfloat) callconv(.c) void;
pub extern var glad_glUniform1f: PFNGLUNIFORM1FPROC;
pub const PFNGLUNIFORM2FPROC = ?*const fn (GLint, GLfloat, GLfloat) callconv(.c) void;
pub extern var glad_glUniform2f: PFNGLUNIFORM2FPROC;
pub const PFNGLUNIFORM3FPROC = ?*const fn (GLint, GLfloat, GLfloat, GLfloat) callconv(.c) void;
pub extern var glad_glUniform3f: PFNGLUNIFORM3FPROC;
pub const PFNGLUNIFORM4FPROC = ?*const fn (GLint, GLfloat, GLfloat, GLfloat, GLfloat) callconv(.c) void;
pub extern var glad_glUniform4f: PFNGLUNIFORM4FPROC;
pub const PFNGLUNIFORM1IPROC = ?*const fn (GLint, GLint) callconv(.c) void;
pub extern var glad_glUniform1i: PFNGLUNIFORM1IPROC;
pub const PFNGLUNIFORM2IPROC = ?*const fn (GLint, GLint, GLint) callconv(.c) void;
pub extern var glad_glUniform2i: PFNGLUNIFORM2IPROC;
pub const PFNGLUNIFORM3IPROC = ?*const fn (GLint, GLint, GLint, GLint) callconv(.c) void;
pub extern var glad_glUniform3i: PFNGLUNIFORM3IPROC;
pub const PFNGLUNIFORM4IPROC = ?*const fn (GLint, GLint, GLint, GLint, GLint) callconv(.c) void;
pub extern var glad_glUniform4i: PFNGLUNIFORM4IPROC;
pub const PFNGLUNIFORM1FVPROC = ?*const fn (GLint, GLsizei, [*c]const GLfloat) callconv(.c) void;
pub extern var glad_glUniform1fv: PFNGLUNIFORM1FVPROC;
pub const PFNGLUNIFORM2FVPROC = ?*const fn (GLint, GLsizei, [*c]const GLfloat) callconv(.c) void;
pub extern var glad_glUniform2fv: PFNGLUNIFORM2FVPROC;
pub const PFNGLUNIFORM3FVPROC = ?*const fn (GLint, GLsizei, [*c]const GLfloat) callconv(.c) void;
pub extern var glad_glUniform3fv: PFNGLUNIFORM3FVPROC;
pub const PFNGLUNIFORM4FVPROC = ?*const fn (GLint, GLsizei, [*c]const GLfloat) callconv(.c) void;
pub extern var glad_glUniform4fv: PFNGLUNIFORM4FVPROC;
pub const PFNGLUNIFORM1IVPROC = ?*const fn (GLint, GLsizei, [*c]const GLint) callconv(.c) void;
pub extern var glad_glUniform1iv: PFNGLUNIFORM1IVPROC;
pub const PFNGLUNIFORM2IVPROC = ?*const fn (GLint, GLsizei, [*c]const GLint) callconv(.c) void;
pub extern var glad_glUniform2iv: PFNGLUNIFORM2IVPROC;
pub const PFNGLUNIFORM3IVPROC = ?*const fn (GLint, GLsizei, [*c]const GLint) callconv(.c) void;
pub extern var glad_glUniform3iv: PFNGLUNIFORM3IVPROC;
pub const PFNGLUNIFORM4IVPROC = ?*const fn (GLint, GLsizei, [*c]const GLint) callconv(.c) void;
pub extern var glad_glUniform4iv: PFNGLUNIFORM4IVPROC;
pub const PFNGLUNIFORMMATRIX2FVPROC = ?*const fn (GLint, GLsizei, GLboolean, [*c]const GLfloat) callconv(.c) void;
pub extern var glad_glUniformMatrix2fv: PFNGLUNIFORMMATRIX2FVPROC;
pub const PFNGLUNIFORMMATRIX3FVPROC = ?*const fn (GLint, GLsizei, GLboolean, [*c]const GLfloat) callconv(.c) void;
pub extern var glad_glUniformMatrix3fv: PFNGLUNIFORMMATRIX3FVPROC;
pub const PFNGLUNIFORMMATRIX4FVPROC = ?*const fn (GLint, GLsizei, GLboolean, [*c]const GLfloat) callconv(.c) void;
pub extern var glad_glUniformMatrix4fv: PFNGLUNIFORMMATRIX4FVPROC;
pub const PFNGLVALIDATEPROGRAMPROC = ?*const fn (GLuint) callconv(.c) void;
pub extern var glad_glValidateProgram: PFNGLVALIDATEPROGRAMPROC;
pub const PFNGLVERTEXATTRIB1DPROC = ?*const fn (GLuint, GLdouble) callconv(.c) void;
pub extern var glad_glVertexAttrib1d: PFNGLVERTEXATTRIB1DPROC;
pub const PFNGLVERTEXATTRIB1DVPROC = ?*const fn (GLuint, [*c]const GLdouble) callconv(.c) void;
pub extern var glad_glVertexAttrib1dv: PFNGLVERTEXATTRIB1DVPROC;
pub const PFNGLVERTEXATTRIB1FPROC = ?*const fn (GLuint, GLfloat) callconv(.c) void;
pub extern var glad_glVertexAttrib1f: PFNGLVERTEXATTRIB1FPROC;
pub const PFNGLVERTEXATTRIB1FVPROC = ?*const fn (GLuint, [*c]const GLfloat) callconv(.c) void;
pub extern var glad_glVertexAttrib1fv: PFNGLVERTEXATTRIB1FVPROC;
pub const PFNGLVERTEXATTRIB1SPROC = ?*const fn (GLuint, GLshort) callconv(.c) void;
pub extern var glad_glVertexAttrib1s: PFNGLVERTEXATTRIB1SPROC;
pub const PFNGLVERTEXATTRIB1SVPROC = ?*const fn (GLuint, [*c]const GLshort) callconv(.c) void;
pub extern var glad_glVertexAttrib1sv: PFNGLVERTEXATTRIB1SVPROC;
pub const PFNGLVERTEXATTRIB2DPROC = ?*const fn (GLuint, GLdouble, GLdouble) callconv(.c) void;
pub extern var glad_glVertexAttrib2d: PFNGLVERTEXATTRIB2DPROC;
pub const PFNGLVERTEXATTRIB2DVPROC = ?*const fn (GLuint, [*c]const GLdouble) callconv(.c) void;
pub extern var glad_glVertexAttrib2dv: PFNGLVERTEXATTRIB2DVPROC;
pub const PFNGLVERTEXATTRIB2FPROC = ?*const fn (GLuint, GLfloat, GLfloat) callconv(.c) void;
pub extern var glad_glVertexAttrib2f: PFNGLVERTEXATTRIB2FPROC;
pub const PFNGLVERTEXATTRIB2FVPROC = ?*const fn (GLuint, [*c]const GLfloat) callconv(.c) void;
pub extern var glad_glVertexAttrib2fv: PFNGLVERTEXATTRIB2FVPROC;
pub const PFNGLVERTEXATTRIB2SPROC = ?*const fn (GLuint, GLshort, GLshort) callconv(.c) void;
pub extern var glad_glVertexAttrib2s: PFNGLVERTEXATTRIB2SPROC;
pub const PFNGLVERTEXATTRIB2SVPROC = ?*const fn (GLuint, [*c]const GLshort) callconv(.c) void;
pub extern var glad_glVertexAttrib2sv: PFNGLVERTEXATTRIB2SVPROC;
pub const PFNGLVERTEXATTRIB3DPROC = ?*const fn (GLuint, GLdouble, GLdouble, GLdouble) callconv(.c) void;
pub extern var glad_glVertexAttrib3d: PFNGLVERTEXATTRIB3DPROC;
pub const PFNGLVERTEXATTRIB3DVPROC = ?*const fn (GLuint, [*c]const GLdouble) callconv(.c) void;
pub extern var glad_glVertexAttrib3dv: PFNGLVERTEXATTRIB3DVPROC;
pub const PFNGLVERTEXATTRIB3FPROC = ?*const fn (GLuint, GLfloat, GLfloat, GLfloat) callconv(.c) void;
pub extern var glad_glVertexAttrib3f: PFNGLVERTEXATTRIB3FPROC;
pub const PFNGLVERTEXATTRIB3FVPROC = ?*const fn (GLuint, [*c]const GLfloat) callconv(.c) void;
pub extern var glad_glVertexAttrib3fv: PFNGLVERTEXATTRIB3FVPROC;
pub const PFNGLVERTEXATTRIB3SPROC = ?*const fn (GLuint, GLshort, GLshort, GLshort) callconv(.c) void;
pub extern var glad_glVertexAttrib3s: PFNGLVERTEXATTRIB3SPROC;
pub const PFNGLVERTEXATTRIB3SVPROC = ?*const fn (GLuint, [*c]const GLshort) callconv(.c) void;
pub extern var glad_glVertexAttrib3sv: PFNGLVERTEXATTRIB3SVPROC;
pub const PFNGLVERTEXATTRIB4NBVPROC = ?*const fn (GLuint, [*c]const GLbyte) callconv(.c) void;
pub extern var glad_glVertexAttrib4Nbv: PFNGLVERTEXATTRIB4NBVPROC;
pub const PFNGLVERTEXATTRIB4NIVPROC = ?*const fn (GLuint, [*c]const GLint) callconv(.c) void;
pub extern var glad_glVertexAttrib4Niv: PFNGLVERTEXATTRIB4NIVPROC;
pub const PFNGLVERTEXATTRIB4NSVPROC = ?*const fn (GLuint, [*c]const GLshort) callconv(.c) void;
pub extern var glad_glVertexAttrib4Nsv: PFNGLVERTEXATTRIB4NSVPROC;
pub const PFNGLVERTEXATTRIB4NUBPROC = ?*const fn (GLuint, GLubyte, GLubyte, GLubyte, GLubyte) callconv(.c) void;
pub extern var glad_glVertexAttrib4Nub: PFNGLVERTEXATTRIB4NUBPROC;
pub const PFNGLVERTEXATTRIB4NUBVPROC = ?*const fn (GLuint, [*c]const GLubyte) callconv(.c) void;
pub extern var glad_glVertexAttrib4Nubv: PFNGLVERTEXATTRIB4NUBVPROC;
pub const PFNGLVERTEXATTRIB4NUIVPROC = ?*const fn (GLuint, [*c]const GLuint) callconv(.c) void;
pub extern var glad_glVertexAttrib4Nuiv: PFNGLVERTEXATTRIB4NUIVPROC;
pub const PFNGLVERTEXATTRIB4NUSVPROC = ?*const fn (GLuint, [*c]const GLushort) callconv(.c) void;
pub extern var glad_glVertexAttrib4Nusv: PFNGLVERTEXATTRIB4NUSVPROC;
pub const PFNGLVERTEXATTRIB4BVPROC = ?*const fn (GLuint, [*c]const GLbyte) callconv(.c) void;
pub extern var glad_glVertexAttrib4bv: PFNGLVERTEXATTRIB4BVPROC;
pub const PFNGLVERTEXATTRIB4DPROC = ?*const fn (GLuint, GLdouble, GLdouble, GLdouble, GLdouble) callconv(.c) void;
pub extern var glad_glVertexAttrib4d: PFNGLVERTEXATTRIB4DPROC;
pub const PFNGLVERTEXATTRIB4DVPROC = ?*const fn (GLuint, [*c]const GLdouble) callconv(.c) void;
pub extern var glad_glVertexAttrib4dv: PFNGLVERTEXATTRIB4DVPROC;
pub const PFNGLVERTEXATTRIB4FPROC = ?*const fn (GLuint, GLfloat, GLfloat, GLfloat, GLfloat) callconv(.c) void;
pub extern var glad_glVertexAttrib4f: PFNGLVERTEXATTRIB4FPROC;
pub const PFNGLVERTEXATTRIB4FVPROC = ?*const fn (GLuint, [*c]const GLfloat) callconv(.c) void;
pub extern var glad_glVertexAttrib4fv: PFNGLVERTEXATTRIB4FVPROC;
pub const PFNGLVERTEXATTRIB4IVPROC = ?*const fn (GLuint, [*c]const GLint) callconv(.c) void;
pub extern var glad_glVertexAttrib4iv: PFNGLVERTEXATTRIB4IVPROC;
pub const PFNGLVERTEXATTRIB4SPROC = ?*const fn (GLuint, GLshort, GLshort, GLshort, GLshort) callconv(.c) void;
pub extern var glad_glVertexAttrib4s: PFNGLVERTEXATTRIB4SPROC;
pub const PFNGLVERTEXATTRIB4SVPROC = ?*const fn (GLuint, [*c]const GLshort) callconv(.c) void;
pub extern var glad_glVertexAttrib4sv: PFNGLVERTEXATTRIB4SVPROC;
pub const PFNGLVERTEXATTRIB4UBVPROC = ?*const fn (GLuint, [*c]const GLubyte) callconv(.c) void;
pub extern var glad_glVertexAttrib4ubv: PFNGLVERTEXATTRIB4UBVPROC;
pub const PFNGLVERTEXATTRIB4UIVPROC = ?*const fn (GLuint, [*c]const GLuint) callconv(.c) void;
pub extern var glad_glVertexAttrib4uiv: PFNGLVERTEXATTRIB4UIVPROC;
pub const PFNGLVERTEXATTRIB4USVPROC = ?*const fn (GLuint, [*c]const GLushort) callconv(.c) void;
pub extern var glad_glVertexAttrib4usv: PFNGLVERTEXATTRIB4USVPROC;
pub const PFNGLVERTEXATTRIBPOINTERPROC = ?*const fn (GLuint, GLint, GLenum, GLboolean, GLsizei, ?*const anyopaque) callconv(.c) void;
pub extern var glad_glVertexAttribPointer: PFNGLVERTEXATTRIBPOINTERPROC;
pub extern var GLAD_GL_VERSION_2_1: c_int;
pub const PFNGLUNIFORMMATRIX2X3FVPROC = ?*const fn (GLint, GLsizei, GLboolean, [*c]const GLfloat) callconv(.c) void;
pub extern var glad_glUniformMatrix2x3fv: PFNGLUNIFORMMATRIX2X3FVPROC;
pub const PFNGLUNIFORMMATRIX3X2FVPROC = ?*const fn (GLint, GLsizei, GLboolean, [*c]const GLfloat) callconv(.c) void;
pub extern var glad_glUniformMatrix3x2fv: PFNGLUNIFORMMATRIX3X2FVPROC;
pub const PFNGLUNIFORMMATRIX2X4FVPROC = ?*const fn (GLint, GLsizei, GLboolean, [*c]const GLfloat) callconv(.c) void;
pub extern var glad_glUniformMatrix2x4fv: PFNGLUNIFORMMATRIX2X4FVPROC;
pub const PFNGLUNIFORMMATRIX4X2FVPROC = ?*const fn (GLint, GLsizei, GLboolean, [*c]const GLfloat) callconv(.c) void;
pub extern var glad_glUniformMatrix4x2fv: PFNGLUNIFORMMATRIX4X2FVPROC;
pub const PFNGLUNIFORMMATRIX3X4FVPROC = ?*const fn (GLint, GLsizei, GLboolean, [*c]const GLfloat) callconv(.c) void;
pub extern var glad_glUniformMatrix3x4fv: PFNGLUNIFORMMATRIX3X4FVPROC;
pub const PFNGLUNIFORMMATRIX4X3FVPROC = ?*const fn (GLint, GLsizei, GLboolean, [*c]const GLfloat) callconv(.c) void;
pub extern var glad_glUniformMatrix4x3fv: PFNGLUNIFORMMATRIX4X3FVPROC;
pub extern var GLAD_GL_VERSION_3_0: c_int;
pub const PFNGLCOLORMASKIPROC = ?*const fn (GLuint, GLboolean, GLboolean, GLboolean, GLboolean) callconv(.c) void;
pub extern var glad_glColorMaski: PFNGLCOLORMASKIPROC;
pub const PFNGLGETBOOLEANI_VPROC = ?*const fn (GLenum, GLuint, [*c]GLboolean) callconv(.c) void;
pub extern var glad_glGetBooleani_v: PFNGLGETBOOLEANI_VPROC;
pub const PFNGLGETINTEGERI_VPROC = ?*const fn (GLenum, GLuint, [*c]GLint) callconv(.c) void;
pub extern var glad_glGetIntegeri_v: PFNGLGETINTEGERI_VPROC;
pub const PFNGLENABLEIPROC = ?*const fn (GLenum, GLuint) callconv(.c) void;
pub extern var glad_glEnablei: PFNGLENABLEIPROC;
pub const PFNGLDISABLEIPROC = ?*const fn (GLenum, GLuint) callconv(.c) void;
pub extern var glad_glDisablei: PFNGLDISABLEIPROC;
pub const PFNGLISENABLEDIPROC = ?*const fn (GLenum, GLuint) callconv(.c) GLboolean;
pub extern var glad_glIsEnabledi: PFNGLISENABLEDIPROC;
pub const PFNGLBEGINTRANSFORMFEEDBACKPROC = ?*const fn (GLenum) callconv(.c) void;
pub extern var glad_glBeginTransformFeedback: PFNGLBEGINTRANSFORMFEEDBACKPROC;
pub const PFNGLENDTRANSFORMFEEDBACKPROC = ?*const fn () callconv(.c) void;
pub extern var glad_glEndTransformFeedback: PFNGLENDTRANSFORMFEEDBACKPROC;
pub const PFNGLBINDBUFFERRANGEPROC = ?*const fn (GLenum, GLuint, GLuint, GLintptr, GLsizeiptr) callconv(.c) void;
pub extern var glad_glBindBufferRange: PFNGLBINDBUFFERRANGEPROC;
pub const PFNGLBINDBUFFERBASEPROC = ?*const fn (GLenum, GLuint, GLuint) callconv(.c) void;
pub extern var glad_glBindBufferBase: PFNGLBINDBUFFERBASEPROC;
pub const PFNGLTRANSFORMFEEDBACKVARYINGSPROC = ?*const fn (GLuint, GLsizei, [*c]const [*c]const GLchar, GLenum) callconv(.c) void;
pub extern var glad_glTransformFeedbackVaryings: PFNGLTRANSFORMFEEDBACKVARYINGSPROC;
pub const PFNGLGETTRANSFORMFEEDBACKVARYINGPROC = ?*const fn (GLuint, GLuint, GLsizei, [*c]GLsizei, [*c]GLsizei, [*c]GLenum, [*c]GLchar) callconv(.c) void;
pub extern var glad_glGetTransformFeedbackVarying: PFNGLGETTRANSFORMFEEDBACKVARYINGPROC;
pub const PFNGLCLAMPCOLORPROC = ?*const fn (GLenum, GLenum) callconv(.c) void;
pub extern var glad_glClampColor: PFNGLCLAMPCOLORPROC;
pub const PFNGLBEGINCONDITIONALRENDERPROC = ?*const fn (GLuint, GLenum) callconv(.c) void;
pub extern var glad_glBeginConditionalRender: PFNGLBEGINCONDITIONALRENDERPROC;
pub const PFNGLENDCONDITIONALRENDERPROC = ?*const fn () callconv(.c) void;
pub extern var glad_glEndConditionalRender: PFNGLENDCONDITIONALRENDERPROC;
pub const PFNGLVERTEXATTRIBIPOINTERPROC = ?*const fn (GLuint, GLint, GLenum, GLsizei, ?*const anyopaque) callconv(.c) void;
pub extern var glad_glVertexAttribIPointer: PFNGLVERTEXATTRIBIPOINTERPROC;
pub const PFNGLGETVERTEXATTRIBIIVPROC = ?*const fn (GLuint, GLenum, [*c]GLint) callconv(.c) void;
pub extern var glad_glGetVertexAttribIiv: PFNGLGETVERTEXATTRIBIIVPROC;
pub const PFNGLGETVERTEXATTRIBIUIVPROC = ?*const fn (GLuint, GLenum, [*c]GLuint) callconv(.c) void;
pub extern var glad_glGetVertexAttribIuiv: PFNGLGETVERTEXATTRIBIUIVPROC;
pub const PFNGLVERTEXATTRIBI1IPROC = ?*const fn (GLuint, GLint) callconv(.c) void;
pub extern var glad_glVertexAttribI1i: PFNGLVERTEXATTRIBI1IPROC;
pub const PFNGLVERTEXATTRIBI2IPROC = ?*const fn (GLuint, GLint, GLint) callconv(.c) void;
pub extern var glad_glVertexAttribI2i: PFNGLVERTEXATTRIBI2IPROC;
pub const PFNGLVERTEXATTRIBI3IPROC = ?*const fn (GLuint, GLint, GLint, GLint) callconv(.c) void;
pub extern var glad_glVertexAttribI3i: PFNGLVERTEXATTRIBI3IPROC;
pub const PFNGLVERTEXATTRIBI4IPROC = ?*const fn (GLuint, GLint, GLint, GLint, GLint) callconv(.c) void;
pub extern var glad_glVertexAttribI4i: PFNGLVERTEXATTRIBI4IPROC;
pub const PFNGLVERTEXATTRIBI1UIPROC = ?*const fn (GLuint, GLuint) callconv(.c) void;
pub extern var glad_glVertexAttribI1ui: PFNGLVERTEXATTRIBI1UIPROC;
pub const PFNGLVERTEXATTRIBI2UIPROC = ?*const fn (GLuint, GLuint, GLuint) callconv(.c) void;
pub extern var glad_glVertexAttribI2ui: PFNGLVERTEXATTRIBI2UIPROC;
pub const PFNGLVERTEXATTRIBI3UIPROC = ?*const fn (GLuint, GLuint, GLuint, GLuint) callconv(.c) void;
pub extern var glad_glVertexAttribI3ui: PFNGLVERTEXATTRIBI3UIPROC;
pub const PFNGLVERTEXATTRIBI4UIPROC = ?*const fn (GLuint, GLuint, GLuint, GLuint, GLuint) callconv(.c) void;
pub extern var glad_glVertexAttribI4ui: PFNGLVERTEXATTRIBI4UIPROC;
pub const PFNGLVERTEXATTRIBI1IVPROC = ?*const fn (GLuint, [*c]const GLint) callconv(.c) void;
pub extern var glad_glVertexAttribI1iv: PFNGLVERTEXATTRIBI1IVPROC;
pub const PFNGLVERTEXATTRIBI2IVPROC = ?*const fn (GLuint, [*c]const GLint) callconv(.c) void;
pub extern var glad_glVertexAttribI2iv: PFNGLVERTEXATTRIBI2IVPROC;
pub const PFNGLVERTEXATTRIBI3IVPROC = ?*const fn (GLuint, [*c]const GLint) callconv(.c) void;
pub extern var glad_glVertexAttribI3iv: PFNGLVERTEXATTRIBI3IVPROC;
pub const PFNGLVERTEXATTRIBI4IVPROC = ?*const fn (GLuint, [*c]const GLint) callconv(.c) void;
pub extern var glad_glVertexAttribI4iv: PFNGLVERTEXATTRIBI4IVPROC;
pub const PFNGLVERTEXATTRIBI1UIVPROC = ?*const fn (GLuint, [*c]const GLuint) callconv(.c) void;
pub extern var glad_glVertexAttribI1uiv: PFNGLVERTEXATTRIBI1UIVPROC;
pub const PFNGLVERTEXATTRIBI2UIVPROC = ?*const fn (GLuint, [*c]const GLuint) callconv(.c) void;
pub extern var glad_glVertexAttribI2uiv: PFNGLVERTEXATTRIBI2UIVPROC;
pub const PFNGLVERTEXATTRIBI3UIVPROC = ?*const fn (GLuint, [*c]const GLuint) callconv(.c) void;
pub extern var glad_glVertexAttribI3uiv: PFNGLVERTEXATTRIBI3UIVPROC;
pub const PFNGLVERTEXATTRIBI4UIVPROC = ?*const fn (GLuint, [*c]const GLuint) callconv(.c) void;
pub extern var glad_glVertexAttribI4uiv: PFNGLVERTEXATTRIBI4UIVPROC;
pub const PFNGLVERTEXATTRIBI4BVPROC = ?*const fn (GLuint, [*c]const GLbyte) callconv(.c) void;
pub extern var glad_glVertexAttribI4bv: PFNGLVERTEXATTRIBI4BVPROC;
pub const PFNGLVERTEXATTRIBI4SVPROC = ?*const fn (GLuint, [*c]const GLshort) callconv(.c) void;
pub extern var glad_glVertexAttribI4sv: PFNGLVERTEXATTRIBI4SVPROC;
pub const PFNGLVERTEXATTRIBI4UBVPROC = ?*const fn (GLuint, [*c]const GLubyte) callconv(.c) void;
pub extern var glad_glVertexAttribI4ubv: PFNGLVERTEXATTRIBI4UBVPROC;
pub const PFNGLVERTEXATTRIBI4USVPROC = ?*const fn (GLuint, [*c]const GLushort) callconv(.c) void;
pub extern var glad_glVertexAttribI4usv: PFNGLVERTEXATTRIBI4USVPROC;
pub const PFNGLGETUNIFORMUIVPROC = ?*const fn (GLuint, GLint, [*c]GLuint) callconv(.c) void;
pub extern var glad_glGetUniformuiv: PFNGLGETUNIFORMUIVPROC;
pub const PFNGLBINDFRAGDATALOCATIONPROC = ?*const fn (GLuint, GLuint, [*c]const GLchar) callconv(.c) void;
pub extern var glad_glBindFragDataLocation: PFNGLBINDFRAGDATALOCATIONPROC;
pub const PFNGLGETFRAGDATALOCATIONPROC = ?*const fn (GLuint, [*c]const GLchar) callconv(.c) GLint;
pub extern var glad_glGetFragDataLocation: PFNGLGETFRAGDATALOCATIONPROC;
pub const PFNGLUNIFORM1UIPROC = ?*const fn (GLint, GLuint) callconv(.c) void;
pub extern var glad_glUniform1ui: PFNGLUNIFORM1UIPROC;
pub const PFNGLUNIFORM2UIPROC = ?*const fn (GLint, GLuint, GLuint) callconv(.c) void;
pub extern var glad_glUniform2ui: PFNGLUNIFORM2UIPROC;
pub const PFNGLUNIFORM3UIPROC = ?*const fn (GLint, GLuint, GLuint, GLuint) callconv(.c) void;
pub extern var glad_glUniform3ui: PFNGLUNIFORM3UIPROC;
pub const PFNGLUNIFORM4UIPROC = ?*const fn (GLint, GLuint, GLuint, GLuint, GLuint) callconv(.c) void;
pub extern var glad_glUniform4ui: PFNGLUNIFORM4UIPROC;
pub const PFNGLUNIFORM1UIVPROC = ?*const fn (GLint, GLsizei, [*c]const GLuint) callconv(.c) void;
pub extern var glad_glUniform1uiv: PFNGLUNIFORM1UIVPROC;
pub const PFNGLUNIFORM2UIVPROC = ?*const fn (GLint, GLsizei, [*c]const GLuint) callconv(.c) void;
pub extern var glad_glUniform2uiv: PFNGLUNIFORM2UIVPROC;
pub const PFNGLUNIFORM3UIVPROC = ?*const fn (GLint, GLsizei, [*c]const GLuint) callconv(.c) void;
pub extern var glad_glUniform3uiv: PFNGLUNIFORM3UIVPROC;
pub const PFNGLUNIFORM4UIVPROC = ?*const fn (GLint, GLsizei, [*c]const GLuint) callconv(.c) void;
pub extern var glad_glUniform4uiv: PFNGLUNIFORM4UIVPROC;
pub const PFNGLTEXPARAMETERIIVPROC = ?*const fn (GLenum, GLenum, [*c]const GLint) callconv(.c) void;
pub extern var glad_glTexParameterIiv: PFNGLTEXPARAMETERIIVPROC;
pub const PFNGLTEXPARAMETERIUIVPROC = ?*const fn (GLenum, GLenum, [*c]const GLuint) callconv(.c) void;
pub extern var glad_glTexParameterIuiv: PFNGLTEXPARAMETERIUIVPROC;
pub const PFNGLGETTEXPARAMETERIIVPROC = ?*const fn (GLenum, GLenum, [*c]GLint) callconv(.c) void;
pub extern var glad_glGetTexParameterIiv: PFNGLGETTEXPARAMETERIIVPROC;
pub const PFNGLGETTEXPARAMETERIUIVPROC = ?*const fn (GLenum, GLenum, [*c]GLuint) callconv(.c) void;
pub extern var glad_glGetTexParameterIuiv: PFNGLGETTEXPARAMETERIUIVPROC;
pub const PFNGLCLEARBUFFERIVPROC = ?*const fn (GLenum, GLint, [*c]const GLint) callconv(.c) void;
pub extern var glad_glClearBufferiv: PFNGLCLEARBUFFERIVPROC;
pub const PFNGLCLEARBUFFERUIVPROC = ?*const fn (GLenum, GLint, [*c]const GLuint) callconv(.c) void;
pub extern var glad_glClearBufferuiv: PFNGLCLEARBUFFERUIVPROC;
pub const PFNGLCLEARBUFFERFVPROC = ?*const fn (GLenum, GLint, [*c]const GLfloat) callconv(.c) void;
pub extern var glad_glClearBufferfv: PFNGLCLEARBUFFERFVPROC;
pub const PFNGLCLEARBUFFERFIPROC = ?*const fn (GLenum, GLint, GLfloat, GLint) callconv(.c) void;
pub extern var glad_glClearBufferfi: PFNGLCLEARBUFFERFIPROC;
pub const PFNGLGETSTRINGIPROC = ?*const fn (GLenum, GLuint) callconv(.c) [*c]const GLubyte;
pub extern var glad_glGetStringi: PFNGLGETSTRINGIPROC;
pub const PFNGLISRENDERBUFFERPROC = ?*const fn (GLuint) callconv(.c) GLboolean;
pub extern var glad_glIsRenderbuffer: PFNGLISRENDERBUFFERPROC;
pub const PFNGLBINDRENDERBUFFERPROC = ?*const fn (GLenum, GLuint) callconv(.c) void;
pub extern var glad_glBindRenderbuffer: PFNGLBINDRENDERBUFFERPROC;
pub const PFNGLDELETERENDERBUFFERSPROC = ?*const fn (GLsizei, [*c]const GLuint) callconv(.c) void;
pub extern var glad_glDeleteRenderbuffers: PFNGLDELETERENDERBUFFERSPROC;
pub const PFNGLGENRENDERBUFFERSPROC = ?*const fn (GLsizei, [*c]GLuint) callconv(.c) void;
pub extern var glad_glGenRenderbuffers: PFNGLGENRENDERBUFFERSPROC;
pub const PFNGLRENDERBUFFERSTORAGEPROC = ?*const fn (GLenum, GLenum, GLsizei, GLsizei) callconv(.c) void;
pub extern var glad_glRenderbufferStorage: PFNGLRENDERBUFFERSTORAGEPROC;
pub const PFNGLGETRENDERBUFFERPARAMETERIVPROC = ?*const fn (GLenum, GLenum, [*c]GLint) callconv(.c) void;
pub extern var glad_glGetRenderbufferParameteriv: PFNGLGETRENDERBUFFERPARAMETERIVPROC;
pub const PFNGLISFRAMEBUFFERPROC = ?*const fn (GLuint) callconv(.c) GLboolean;
pub extern var glad_glIsFramebuffer: PFNGLISFRAMEBUFFERPROC;
pub const PFNGLBINDFRAMEBUFFERPROC = ?*const fn (GLenum, GLuint) callconv(.c) void;
pub extern var glad_glBindFramebuffer: PFNGLBINDFRAMEBUFFERPROC;
pub const PFNGLDELETEFRAMEBUFFERSPROC = ?*const fn (GLsizei, [*c]const GLuint) callconv(.c) void;
pub extern var glad_glDeleteFramebuffers: PFNGLDELETEFRAMEBUFFERSPROC;
pub const PFNGLGENFRAMEBUFFERSPROC = ?*const fn (GLsizei, [*c]GLuint) callconv(.c) void;
pub extern var glad_glGenFramebuffers: PFNGLGENFRAMEBUFFERSPROC;
pub const PFNGLCHECKFRAMEBUFFERSTATUSPROC = ?*const fn (GLenum) callconv(.c) GLenum;
pub extern var glad_glCheckFramebufferStatus: PFNGLCHECKFRAMEBUFFERSTATUSPROC;
pub const PFNGLFRAMEBUFFERTEXTURE1DPROC = ?*const fn (GLenum, GLenum, GLenum, GLuint, GLint) callconv(.c) void;
pub extern var glad_glFramebufferTexture1D: PFNGLFRAMEBUFFERTEXTURE1DPROC;
pub const PFNGLFRAMEBUFFERTEXTURE2DPROC = ?*const fn (GLenum, GLenum, GLenum, GLuint, GLint) callconv(.c) void;
pub extern var glad_glFramebufferTexture2D: PFNGLFRAMEBUFFERTEXTURE2DPROC;
pub const PFNGLFRAMEBUFFERTEXTURE3DPROC = ?*const fn (GLenum, GLenum, GLenum, GLuint, GLint, GLint) callconv(.c) void;
pub extern var glad_glFramebufferTexture3D: PFNGLFRAMEBUFFERTEXTURE3DPROC;
pub const PFNGLFRAMEBUFFERRENDERBUFFERPROC = ?*const fn (GLenum, GLenum, GLenum, GLuint) callconv(.c) void;
pub extern var glad_glFramebufferRenderbuffer: PFNGLFRAMEBUFFERRENDERBUFFERPROC;
pub const PFNGLGETFRAMEBUFFERATTACHMENTPARAMETERIVPROC = ?*const fn (GLenum, GLenum, GLenum, [*c]GLint) callconv(.c) void;
pub extern var glad_glGetFramebufferAttachmentParameteriv: PFNGLGETFRAMEBUFFERATTACHMENTPARAMETERIVPROC;
pub const PFNGLGENERATEMIPMAPPROC = ?*const fn (GLenum) callconv(.c) void;
pub extern var glad_glGenerateMipmap: PFNGLGENERATEMIPMAPPROC;
pub const PFNGLBLITFRAMEBUFFERPROC = ?*const fn (GLint, GLint, GLint, GLint, GLint, GLint, GLint, GLint, GLbitfield, GLenum) callconv(.c) void;
pub extern var glad_glBlitFramebuffer: PFNGLBLITFRAMEBUFFERPROC;
pub const PFNGLRENDERBUFFERSTORAGEMULTISAMPLEPROC = ?*const fn (GLenum, GLsizei, GLenum, GLsizei, GLsizei) callconv(.c) void;
pub extern var glad_glRenderbufferStorageMultisample: PFNGLRENDERBUFFERSTORAGEMULTISAMPLEPROC;
pub const PFNGLFRAMEBUFFERTEXTURELAYERPROC = ?*const fn (GLenum, GLenum, GLuint, GLint, GLint) callconv(.c) void;
pub extern var glad_glFramebufferTextureLayer: PFNGLFRAMEBUFFERTEXTURELAYERPROC;
pub const PFNGLMAPBUFFERRANGEPROC = ?*const fn (GLenum, GLintptr, GLsizeiptr, GLbitfield) callconv(.c) ?*anyopaque;
pub extern var glad_glMapBufferRange: PFNGLMAPBUFFERRANGEPROC;
pub const PFNGLFLUSHMAPPEDBUFFERRANGEPROC = ?*const fn (GLenum, GLintptr, GLsizeiptr) callconv(.c) void;
pub extern var glad_glFlushMappedBufferRange: PFNGLFLUSHMAPPEDBUFFERRANGEPROC;
pub const PFNGLBINDVERTEXARRAYPROC = ?*const fn (GLuint) callconv(.c) void;
pub extern var glad_glBindVertexArray: PFNGLBINDVERTEXARRAYPROC;
pub const PFNGLDELETEVERTEXARRAYSPROC = ?*const fn (GLsizei, [*c]const GLuint) callconv(.c) void;
pub extern var glad_glDeleteVertexArrays: PFNGLDELETEVERTEXARRAYSPROC;
pub const PFNGLGENVERTEXARRAYSPROC = ?*const fn (GLsizei, [*c]GLuint) callconv(.c) void;
pub extern var glad_glGenVertexArrays: PFNGLGENVERTEXARRAYSPROC;
pub const PFNGLISVERTEXARRAYPROC = ?*const fn (GLuint) callconv(.c) GLboolean;
pub extern var glad_glIsVertexArray: PFNGLISVERTEXARRAYPROC;
pub extern var GLAD_GL_VERSION_3_1: c_int;
pub const PFNGLDRAWARRAYSINSTANCEDPROC = ?*const fn (GLenum, GLint, GLsizei, GLsizei) callconv(.c) void;
pub extern var glad_glDrawArraysInstanced: PFNGLDRAWARRAYSINSTANCEDPROC;
pub const PFNGLDRAWELEMENTSINSTANCEDPROC = ?*const fn (GLenum, GLsizei, GLenum, ?*const anyopaque, GLsizei) callconv(.c) void;
pub extern var glad_glDrawElementsInstanced: PFNGLDRAWELEMENTSINSTANCEDPROC;
pub const PFNGLTEXBUFFERPROC = ?*const fn (GLenum, GLenum, GLuint) callconv(.c) void;
pub extern var glad_glTexBuffer: PFNGLTEXBUFFERPROC;
pub const PFNGLPRIMITIVERESTARTINDEXPROC = ?*const fn (GLuint) callconv(.c) void;
pub extern var glad_glPrimitiveRestartIndex: PFNGLPRIMITIVERESTARTINDEXPROC;
pub const PFNGLCOPYBUFFERSUBDATAPROC = ?*const fn (GLenum, GLenum, GLintptr, GLintptr, GLsizeiptr) callconv(.c) void;
pub extern var glad_glCopyBufferSubData: PFNGLCOPYBUFFERSUBDATAPROC;
pub const PFNGLGETUNIFORMINDICESPROC = ?*const fn (GLuint, GLsizei, [*c]const [*c]const GLchar, [*c]GLuint) callconv(.c) void;
pub extern var glad_glGetUniformIndices: PFNGLGETUNIFORMINDICESPROC;
pub const PFNGLGETACTIVEUNIFORMSIVPROC = ?*const fn (GLuint, GLsizei, [*c]const GLuint, GLenum, [*c]GLint) callconv(.c) void;
pub extern var glad_glGetActiveUniformsiv: PFNGLGETACTIVEUNIFORMSIVPROC;
pub const PFNGLGETACTIVEUNIFORMNAMEPROC = ?*const fn (GLuint, GLuint, GLsizei, [*c]GLsizei, [*c]GLchar) callconv(.c) void;
pub extern var glad_glGetActiveUniformName: PFNGLGETACTIVEUNIFORMNAMEPROC;
pub const PFNGLGETUNIFORMBLOCKINDEXPROC = ?*const fn (GLuint, [*c]const GLchar) callconv(.c) GLuint;
pub extern var glad_glGetUniformBlockIndex: PFNGLGETUNIFORMBLOCKINDEXPROC;
pub const PFNGLGETACTIVEUNIFORMBLOCKIVPROC = ?*const fn (GLuint, GLuint, GLenum, [*c]GLint) callconv(.c) void;
pub extern var glad_glGetActiveUniformBlockiv: PFNGLGETACTIVEUNIFORMBLOCKIVPROC;
pub const PFNGLGETACTIVEUNIFORMBLOCKNAMEPROC = ?*const fn (GLuint, GLuint, GLsizei, [*c]GLsizei, [*c]GLchar) callconv(.c) void;
pub extern var glad_glGetActiveUniformBlockName: PFNGLGETACTIVEUNIFORMBLOCKNAMEPROC;
pub const PFNGLUNIFORMBLOCKBINDINGPROC = ?*const fn (GLuint, GLuint, GLuint) callconv(.c) void;
pub extern var glad_glUniformBlockBinding: PFNGLUNIFORMBLOCKBINDINGPROC;
pub extern var GLAD_GL_VERSION_3_2: c_int;
pub const PFNGLDRAWELEMENTSBASEVERTEXPROC = ?*const fn (GLenum, GLsizei, GLenum, ?*const anyopaque, GLint) callconv(.c) void;
pub extern var glad_glDrawElementsBaseVertex: PFNGLDRAWELEMENTSBASEVERTEXPROC;
pub const PFNGLDRAWRANGEELEMENTSBASEVERTEXPROC = ?*const fn (GLenum, GLuint, GLuint, GLsizei, GLenum, ?*const anyopaque, GLint) callconv(.c) void;
pub extern var glad_glDrawRangeElementsBaseVertex: PFNGLDRAWRANGEELEMENTSBASEVERTEXPROC;
pub const PFNGLDRAWELEMENTSINSTANCEDBASEVERTEXPROC = ?*const fn (GLenum, GLsizei, GLenum, ?*const anyopaque, GLsizei, GLint) callconv(.c) void;
pub extern var glad_glDrawElementsInstancedBaseVertex: PFNGLDRAWELEMENTSINSTANCEDBASEVERTEXPROC;
pub const PFNGLMULTIDRAWELEMENTSBASEVERTEXPROC = ?*const fn (GLenum, [*c]const GLsizei, GLenum, [*c]const ?*const anyopaque, GLsizei, [*c]const GLint) callconv(.c) void;
pub extern var glad_glMultiDrawElementsBaseVertex: PFNGLMULTIDRAWELEMENTSBASEVERTEXPROC;
pub const PFNGLPROVOKINGVERTEXPROC = ?*const fn (GLenum) callconv(.c) void;
pub extern var glad_glProvokingVertex: PFNGLPROVOKINGVERTEXPROC;
pub const PFNGLFENCESYNCPROC = ?*const fn (GLenum, GLbitfield) callconv(.c) GLsync;
pub extern var glad_glFenceSync: PFNGLFENCESYNCPROC;
pub const PFNGLISSYNCPROC = ?*const fn (GLsync) callconv(.c) GLboolean;
pub extern var glad_glIsSync: PFNGLISSYNCPROC;
pub const PFNGLDELETESYNCPROC = ?*const fn (GLsync) callconv(.c) void;
pub extern var glad_glDeleteSync: PFNGLDELETESYNCPROC;
pub const PFNGLCLIENTWAITSYNCPROC = ?*const fn (GLsync, GLbitfield, GLuint64) callconv(.c) GLenum;
pub extern var glad_glClientWaitSync: PFNGLCLIENTWAITSYNCPROC;
pub const PFNGLWAITSYNCPROC = ?*const fn (GLsync, GLbitfield, GLuint64) callconv(.c) void;
pub extern var glad_glWaitSync: PFNGLWAITSYNCPROC;
pub const PFNGLGETINTEGER64VPROC = ?*const fn (GLenum, [*c]GLint64) callconv(.c) void;
pub extern var glad_glGetInteger64v: PFNGLGETINTEGER64VPROC;
pub const PFNGLGETSYNCIVPROC = ?*const fn (GLsync, GLenum, GLsizei, [*c]GLsizei, [*c]GLint) callconv(.c) void;
pub extern var glad_glGetSynciv: PFNGLGETSYNCIVPROC;
pub const PFNGLGETINTEGER64I_VPROC = ?*const fn (GLenum, GLuint, [*c]GLint64) callconv(.c) void;
pub extern var glad_glGetInteger64i_v: PFNGLGETINTEGER64I_VPROC;
pub const PFNGLGETBUFFERPARAMETERI64VPROC = ?*const fn (GLenum, GLenum, [*c]GLint64) callconv(.c) void;
pub extern var glad_glGetBufferParameteri64v: PFNGLGETBUFFERPARAMETERI64VPROC;
pub const PFNGLFRAMEBUFFERTEXTUREPROC = ?*const fn (GLenum, GLenum, GLuint, GLint) callconv(.c) void;
pub extern var glad_glFramebufferTexture: PFNGLFRAMEBUFFERTEXTUREPROC;
pub const PFNGLTEXIMAGE2DMULTISAMPLEPROC = ?*const fn (GLenum, GLsizei, GLenum, GLsizei, GLsizei, GLboolean) callconv(.c) void;
pub extern var glad_glTexImage2DMultisample: PFNGLTEXIMAGE2DMULTISAMPLEPROC;
pub const PFNGLTEXIMAGE3DMULTISAMPLEPROC = ?*const fn (GLenum, GLsizei, GLenum, GLsizei, GLsizei, GLsizei, GLboolean) callconv(.c) void;
pub extern var glad_glTexImage3DMultisample: PFNGLTEXIMAGE3DMULTISAMPLEPROC;
pub const PFNGLGETMULTISAMPLEFVPROC = ?*const fn (GLenum, GLuint, [*c]GLfloat) callconv(.c) void;
pub extern var glad_glGetMultisamplefv: PFNGLGETMULTISAMPLEFVPROC;
pub const PFNGLSAMPLEMASKIPROC = ?*const fn (GLuint, GLbitfield) callconv(.c) void;
pub extern var glad_glSampleMaski: PFNGLSAMPLEMASKIPROC;
pub extern var GLAD_GL_VERSION_3_3: c_int;
pub const PFNGLBINDFRAGDATALOCATIONINDEXEDPROC = ?*const fn (GLuint, GLuint, GLuint, [*c]const GLchar) callconv(.c) void;
pub extern var glad_glBindFragDataLocationIndexed: PFNGLBINDFRAGDATALOCATIONINDEXEDPROC;
pub const PFNGLGETFRAGDATAINDEXPROC = ?*const fn (GLuint, [*c]const GLchar) callconv(.c) GLint;
pub extern var glad_glGetFragDataIndex: PFNGLGETFRAGDATAINDEXPROC;
pub const PFNGLGENSAMPLERSPROC = ?*const fn (GLsizei, [*c]GLuint) callconv(.c) void;
pub extern var glad_glGenSamplers: PFNGLGENSAMPLERSPROC;
pub const PFNGLDELETESAMPLERSPROC = ?*const fn (GLsizei, [*c]const GLuint) callconv(.c) void;
pub extern var glad_glDeleteSamplers: PFNGLDELETESAMPLERSPROC;
pub const PFNGLISSAMPLERPROC = ?*const fn (GLuint) callconv(.c) GLboolean;
pub extern var glad_glIsSampler: PFNGLISSAMPLERPROC;
pub const PFNGLBINDSAMPLERPROC = ?*const fn (GLuint, GLuint) callconv(.c) void;
pub extern var glad_glBindSampler: PFNGLBINDSAMPLERPROC;
pub const PFNGLSAMPLERPARAMETERIPROC = ?*const fn (GLuint, GLenum, GLint) callconv(.c) void;
pub extern var glad_glSamplerParameteri: PFNGLSAMPLERPARAMETERIPROC;
pub const PFNGLSAMPLERPARAMETERIVPROC = ?*const fn (GLuint, GLenum, [*c]const GLint) callconv(.c) void;
pub extern var glad_glSamplerParameteriv: PFNGLSAMPLERPARAMETERIVPROC;
pub const PFNGLSAMPLERPARAMETERFPROC = ?*const fn (GLuint, GLenum, GLfloat) callconv(.c) void;
pub extern var glad_glSamplerParameterf: PFNGLSAMPLERPARAMETERFPROC;
pub const PFNGLSAMPLERPARAMETERFVPROC = ?*const fn (GLuint, GLenum, [*c]const GLfloat) callconv(.c) void;
pub extern var glad_glSamplerParameterfv: PFNGLSAMPLERPARAMETERFVPROC;
pub const PFNGLSAMPLERPARAMETERIIVPROC = ?*const fn (GLuint, GLenum, [*c]const GLint) callconv(.c) void;
pub extern var glad_glSamplerParameterIiv: PFNGLSAMPLERPARAMETERIIVPROC;
pub const PFNGLSAMPLERPARAMETERIUIVPROC = ?*const fn (GLuint, GLenum, [*c]const GLuint) callconv(.c) void;
pub extern var glad_glSamplerParameterIuiv: PFNGLSAMPLERPARAMETERIUIVPROC;
pub const PFNGLGETSAMPLERPARAMETERIVPROC = ?*const fn (GLuint, GLenum, [*c]GLint) callconv(.c) void;
pub extern var glad_glGetSamplerParameteriv: PFNGLGETSAMPLERPARAMETERIVPROC;
pub const PFNGLGETSAMPLERPARAMETERIIVPROC = ?*const fn (GLuint, GLenum, [*c]GLint) callconv(.c) void;
pub extern var glad_glGetSamplerParameterIiv: PFNGLGETSAMPLERPARAMETERIIVPROC;
pub const PFNGLGETSAMPLERPARAMETERFVPROC = ?*const fn (GLuint, GLenum, [*c]GLfloat) callconv(.c) void;
pub extern var glad_glGetSamplerParameterfv: PFNGLGETSAMPLERPARAMETERFVPROC;
pub const PFNGLGETSAMPLERPARAMETERIUIVPROC = ?*const fn (GLuint, GLenum, [*c]GLuint) callconv(.c) void;
pub extern var glad_glGetSamplerParameterIuiv: PFNGLGETSAMPLERPARAMETERIUIVPROC;
pub const PFNGLQUERYCOUNTERPROC = ?*const fn (GLuint, GLenum) callconv(.c) void;
pub extern var glad_glQueryCounter: PFNGLQUERYCOUNTERPROC;
pub const PFNGLGETQUERYOBJECTI64VPROC = ?*const fn (GLuint, GLenum, [*c]GLint64) callconv(.c) void;
pub extern var glad_glGetQueryObjecti64v: PFNGLGETQUERYOBJECTI64VPROC;
pub const PFNGLGETQUERYOBJECTUI64VPROC = ?*const fn (GLuint, GLenum, [*c]GLuint64) callconv(.c) void;
pub extern var glad_glGetQueryObjectui64v: PFNGLGETQUERYOBJECTUI64VPROC;
pub const PFNGLVERTEXATTRIBDIVISORPROC = ?*const fn (GLuint, GLuint) callconv(.c) void;
pub extern var glad_glVertexAttribDivisor: PFNGLVERTEXATTRIBDIVISORPROC;
pub const PFNGLVERTEXATTRIBP1UIPROC = ?*const fn (GLuint, GLenum, GLboolean, GLuint) callconv(.c) void;
pub extern var glad_glVertexAttribP1ui: PFNGLVERTEXATTRIBP1UIPROC;
pub const PFNGLVERTEXATTRIBP1UIVPROC = ?*const fn (GLuint, GLenum, GLboolean, [*c]const GLuint) callconv(.c) void;
pub extern var glad_glVertexAttribP1uiv: PFNGLVERTEXATTRIBP1UIVPROC;
pub const PFNGLVERTEXATTRIBP2UIPROC = ?*const fn (GLuint, GLenum, GLboolean, GLuint) callconv(.c) void;
pub extern var glad_glVertexAttribP2ui: PFNGLVERTEXATTRIBP2UIPROC;
pub const PFNGLVERTEXATTRIBP2UIVPROC = ?*const fn (GLuint, GLenum, GLboolean, [*c]const GLuint) callconv(.c) void;
pub extern var glad_glVertexAttribP2uiv: PFNGLVERTEXATTRIBP2UIVPROC;
pub const PFNGLVERTEXATTRIBP3UIPROC = ?*const fn (GLuint, GLenum, GLboolean, GLuint) callconv(.c) void;
pub extern var glad_glVertexAttribP3ui: PFNGLVERTEXATTRIBP3UIPROC;
pub const PFNGLVERTEXATTRIBP3UIVPROC = ?*const fn (GLuint, GLenum, GLboolean, [*c]const GLuint) callconv(.c) void;
pub extern var glad_glVertexAttribP3uiv: PFNGLVERTEXATTRIBP3UIVPROC;
pub const PFNGLVERTEXATTRIBP4UIPROC = ?*const fn (GLuint, GLenum, GLboolean, GLuint) callconv(.c) void;
pub extern var glad_glVertexAttribP4ui: PFNGLVERTEXATTRIBP4UIPROC;
pub const PFNGLVERTEXATTRIBP4UIVPROC = ?*const fn (GLuint, GLenum, GLboolean, [*c]const GLuint) callconv(.c) void;
pub extern var glad_glVertexAttribP4uiv: PFNGLVERTEXATTRIBP4UIVPROC;
pub const PFNGLVERTEXP2UIPROC = ?*const fn (GLenum, GLuint) callconv(.c) void;
pub extern var glad_glVertexP2ui: PFNGLVERTEXP2UIPROC;
pub const PFNGLVERTEXP2UIVPROC = ?*const fn (GLenum, [*c]const GLuint) callconv(.c) void;
pub extern var glad_glVertexP2uiv: PFNGLVERTEXP2UIVPROC;
pub const PFNGLVERTEXP3UIPROC = ?*const fn (GLenum, GLuint) callconv(.c) void;
pub extern var glad_glVertexP3ui: PFNGLVERTEXP3UIPROC;
pub const PFNGLVERTEXP3UIVPROC = ?*const fn (GLenum, [*c]const GLuint) callconv(.c) void;
pub extern var glad_glVertexP3uiv: PFNGLVERTEXP3UIVPROC;
pub const PFNGLVERTEXP4UIPROC = ?*const fn (GLenum, GLuint) callconv(.c) void;
pub extern var glad_glVertexP4ui: PFNGLVERTEXP4UIPROC;
pub const PFNGLVERTEXP4UIVPROC = ?*const fn (GLenum, [*c]const GLuint) callconv(.c) void;
pub extern var glad_glVertexP4uiv: PFNGLVERTEXP4UIVPROC;
pub const PFNGLTEXCOORDP1UIPROC = ?*const fn (GLenum, GLuint) callconv(.c) void;
pub extern var glad_glTexCoordP1ui: PFNGLTEXCOORDP1UIPROC;
pub const PFNGLTEXCOORDP1UIVPROC = ?*const fn (GLenum, [*c]const GLuint) callconv(.c) void;
pub extern var glad_glTexCoordP1uiv: PFNGLTEXCOORDP1UIVPROC;
pub const PFNGLTEXCOORDP2UIPROC = ?*const fn (GLenum, GLuint) callconv(.c) void;
pub extern var glad_glTexCoordP2ui: PFNGLTEXCOORDP2UIPROC;
pub const PFNGLTEXCOORDP2UIVPROC = ?*const fn (GLenum, [*c]const GLuint) callconv(.c) void;
pub extern var glad_glTexCoordP2uiv: PFNGLTEXCOORDP2UIVPROC;
pub const PFNGLTEXCOORDP3UIPROC = ?*const fn (GLenum, GLuint) callconv(.c) void;
pub extern var glad_glTexCoordP3ui: PFNGLTEXCOORDP3UIPROC;
pub const PFNGLTEXCOORDP3UIVPROC = ?*const fn (GLenum, [*c]const GLuint) callconv(.c) void;
pub extern var glad_glTexCoordP3uiv: PFNGLTEXCOORDP3UIVPROC;
pub const PFNGLTEXCOORDP4UIPROC = ?*const fn (GLenum, GLuint) callconv(.c) void;
pub extern var glad_glTexCoordP4ui: PFNGLTEXCOORDP4UIPROC;
pub const PFNGLTEXCOORDP4UIVPROC = ?*const fn (GLenum, [*c]const GLuint) callconv(.c) void;
pub extern var glad_glTexCoordP4uiv: PFNGLTEXCOORDP4UIVPROC;
pub const PFNGLMULTITEXCOORDP1UIPROC = ?*const fn (GLenum, GLenum, GLuint) callconv(.c) void;
pub extern var glad_glMultiTexCoordP1ui: PFNGLMULTITEXCOORDP1UIPROC;
pub const PFNGLMULTITEXCOORDP1UIVPROC = ?*const fn (GLenum, GLenum, [*c]const GLuint) callconv(.c) void;
pub extern var glad_glMultiTexCoordP1uiv: PFNGLMULTITEXCOORDP1UIVPROC;
pub const PFNGLMULTITEXCOORDP2UIPROC = ?*const fn (GLenum, GLenum, GLuint) callconv(.c) void;
pub extern var glad_glMultiTexCoordP2ui: PFNGLMULTITEXCOORDP2UIPROC;
pub const PFNGLMULTITEXCOORDP2UIVPROC = ?*const fn (GLenum, GLenum, [*c]const GLuint) callconv(.c) void;
pub extern var glad_glMultiTexCoordP2uiv: PFNGLMULTITEXCOORDP2UIVPROC;
pub const PFNGLMULTITEXCOORDP3UIPROC = ?*const fn (GLenum, GLenum, GLuint) callconv(.c) void;
pub extern var glad_glMultiTexCoordP3ui: PFNGLMULTITEXCOORDP3UIPROC;
pub const PFNGLMULTITEXCOORDP3UIVPROC = ?*const fn (GLenum, GLenum, [*c]const GLuint) callconv(.c) void;
pub extern var glad_glMultiTexCoordP3uiv: PFNGLMULTITEXCOORDP3UIVPROC;
pub const PFNGLMULTITEXCOORDP4UIPROC = ?*const fn (GLenum, GLenum, GLuint) callconv(.c) void;
pub extern var glad_glMultiTexCoordP4ui: PFNGLMULTITEXCOORDP4UIPROC;
pub const PFNGLMULTITEXCOORDP4UIVPROC = ?*const fn (GLenum, GLenum, [*c]const GLuint) callconv(.c) void;
pub extern var glad_glMultiTexCoordP4uiv: PFNGLMULTITEXCOORDP4UIVPROC;
pub const PFNGLNORMALP3UIPROC = ?*const fn (GLenum, GLuint) callconv(.c) void;
pub extern var glad_glNormalP3ui: PFNGLNORMALP3UIPROC;
pub const PFNGLNORMALP3UIVPROC = ?*const fn (GLenum, [*c]const GLuint) callconv(.c) void;
pub extern var glad_glNormalP3uiv: PFNGLNORMALP3UIVPROC;
pub const PFNGLCOLORP3UIPROC = ?*const fn (GLenum, GLuint) callconv(.c) void;
pub extern var glad_glColorP3ui: PFNGLCOLORP3UIPROC;
pub const PFNGLCOLORP3UIVPROC = ?*const fn (GLenum, [*c]const GLuint) callconv(.c) void;
pub extern var glad_glColorP3uiv: PFNGLCOLORP3UIVPROC;
pub const PFNGLCOLORP4UIPROC = ?*const fn (GLenum, GLuint) callconv(.c) void;
pub extern var glad_glColorP4ui: PFNGLCOLORP4UIPROC;
pub const PFNGLCOLORP4UIVPROC = ?*const fn (GLenum, [*c]const GLuint) callconv(.c) void;
pub extern var glad_glColorP4uiv: PFNGLCOLORP4UIVPROC;
pub const PFNGLSECONDARYCOLORP3UIPROC = ?*const fn (GLenum, GLuint) callconv(.c) void;
pub extern var glad_glSecondaryColorP3ui: PFNGLSECONDARYCOLORP3UIPROC;
pub const PFNGLSECONDARYCOLORP3UIVPROC = ?*const fn (GLenum, [*c]const GLuint) callconv(.c) void;
pub extern var glad_glSecondaryColorP3uiv: PFNGLSECONDARYCOLORP3UIVPROC;
pub const max_align_t = extern struct {
    __clang_max_align_nonce1: c_longlong align(8) = @import("std").mem.zeroes(c_longlong),
    __clang_max_align_nonce2: c_longdouble align(16) = @import("std").mem.zeroes(c_longdouble),
};
pub const GLFWglproc = ?*const fn () callconv(.c) void;
pub const GLFWvkproc = ?*const fn () callconv(.c) void;
pub const struct_GLFWmonitor = opaque {};
pub const GLFWmonitor = struct_GLFWmonitor;
pub const struct_GLFWwindow = opaque {};
pub const GLFWwindow = struct_GLFWwindow;
pub const struct_GLFWcursor = opaque {};
pub const GLFWcursor = struct_GLFWcursor;
pub const GLFWallocatefun = ?*const fn (usize, ?*anyopaque) callconv(.c) ?*anyopaque;
pub const GLFWreallocatefun = ?*const fn (?*anyopaque, usize, ?*anyopaque) callconv(.c) ?*anyopaque;
pub const GLFWdeallocatefun = ?*const fn (?*anyopaque, ?*anyopaque) callconv(.c) void;
pub const GLFWerrorfun = ?*const fn (c_int, [*c]const u8) callconv(.c) void;
pub const GLFWwindowposfun = ?*const fn (?*GLFWwindow, c_int, c_int) callconv(.c) void;
pub const GLFWwindowsizefun = ?*const fn (?*GLFWwindow, c_int, c_int) callconv(.c) void;
pub const GLFWwindowclosefun = ?*const fn (?*GLFWwindow) callconv(.c) void;
pub const GLFWwindowrefreshfun = ?*const fn (?*GLFWwindow) callconv(.c) void;
pub const GLFWwindowfocusfun = ?*const fn (?*GLFWwindow, c_int) callconv(.c) void;
pub const GLFWwindowiconifyfun = ?*const fn (?*GLFWwindow, c_int) callconv(.c) void;
pub const GLFWwindowmaximizefun = ?*const fn (?*GLFWwindow, c_int) callconv(.c) void;
pub const GLFWframebuffersizefun = ?*const fn (?*GLFWwindow, c_int, c_int) callconv(.c) void;
pub const GLFWwindowcontentscalefun = ?*const fn (?*GLFWwindow, f32, f32) callconv(.c) void;
pub const GLFWmousebuttonfun = ?*const fn (?*GLFWwindow, c_int, c_int, c_int) callconv(.c) void;
pub const GLFWcursorposfun = ?*const fn (?*GLFWwindow, f64, f64) callconv(.c) void;
pub const GLFWcursorenterfun = ?*const fn (?*GLFWwindow, c_int) callconv(.c) void;
pub const GLFWscrollfun = ?*const fn (?*GLFWwindow, f64, f64) callconv(.c) void;
pub const GLFWkeyfun = ?*const fn (?*GLFWwindow, c_int, c_int, c_int, c_int) callconv(.c) void;
pub const GLFWcharfun = ?*const fn (?*GLFWwindow, c_uint) callconv(.c) void;
pub const GLFWcharmodsfun = ?*const fn (?*GLFWwindow, c_uint, c_int) callconv(.c) void;
pub const GLFWdropfun = ?*const fn (?*GLFWwindow, c_int, [*c][*c]const u8) callconv(.c) void;
pub const GLFWmonitorfun = ?*const fn (?*GLFWmonitor, c_int) callconv(.c) void;
pub const GLFWjoystickfun = ?*const fn (c_int, c_int) callconv(.c) void;
pub const struct_GLFWvidmode = extern struct {
    width: c_int = @import("std").mem.zeroes(c_int),
    height: c_int = @import("std").mem.zeroes(c_int),
    redBits: c_int = @import("std").mem.zeroes(c_int),
    greenBits: c_int = @import("std").mem.zeroes(c_int),
    blueBits: c_int = @import("std").mem.zeroes(c_int),
    refreshRate: c_int = @import("std").mem.zeroes(c_int),
};
pub const GLFWvidmode = struct_GLFWvidmode;
pub const struct_GLFWgammaramp = extern struct {
    red: [*c]c_ushort = @import("std").mem.zeroes([*c]c_ushort),
    green: [*c]c_ushort = @import("std").mem.zeroes([*c]c_ushort),
    blue: [*c]c_ushort = @import("std").mem.zeroes([*c]c_ushort),
    size: c_uint = @import("std").mem.zeroes(c_uint),
};
pub const GLFWgammaramp = struct_GLFWgammaramp;
pub const struct_GLFWimage = extern struct {
    width: c_int = @import("std").mem.zeroes(c_int),
    height: c_int = @import("std").mem.zeroes(c_int),
    pixels: [*c]u8 = @import("std").mem.zeroes([*c]u8),
};
pub const GLFWimage = struct_GLFWimage;
pub const struct_GLFWgamepadstate = extern struct {
    buttons: [15]u8 = @import("std").mem.zeroes([15]u8),
    axes: [6]f32 = @import("std").mem.zeroes([6]f32),
};
pub const GLFWgamepadstate = struct_GLFWgamepadstate;
pub const struct_GLFWallocator = extern struct {
    allocate: GLFWallocatefun = @import("std").mem.zeroes(GLFWallocatefun),
    reallocate: GLFWreallocatefun = @import("std").mem.zeroes(GLFWreallocatefun),
    deallocate: GLFWdeallocatefun = @import("std").mem.zeroes(GLFWdeallocatefun),
    user: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
};
pub const GLFWallocator = struct_GLFWallocator;
pub extern fn glfwInit() c_int;
pub extern fn glfwTerminate() void;
pub extern fn glfwInitHint(hint: c_int, value: c_int) void;
pub extern fn glfwInitAllocator(allocator: [*c]const GLFWallocator) void;
pub extern fn glfwGetVersion(major: [*c]c_int, minor: [*c]c_int, rev: [*c]c_int) void;
pub extern fn glfwGetVersionString() [*c]const u8;
pub extern fn glfwGetError(description: [*c][*c]const u8) c_int;
pub extern fn glfwSetErrorCallback(callback: GLFWerrorfun) GLFWerrorfun;
pub extern fn glfwGetPlatform() c_int;
pub extern fn glfwPlatformSupported(platform: c_int) c_int;
pub extern fn glfwGetMonitors(count: [*c]c_int) [*c]?*GLFWmonitor;
pub extern fn glfwGetPrimaryMonitor() ?*GLFWmonitor;
pub extern fn glfwGetMonitorPos(monitor: ?*GLFWmonitor, xpos: [*c]c_int, ypos: [*c]c_int) void;
pub extern fn glfwGetMonitorWorkarea(monitor: ?*GLFWmonitor, xpos: [*c]c_int, ypos: [*c]c_int, width: [*c]c_int, height: [*c]c_int) void;
pub extern fn glfwGetMonitorPhysicalSize(monitor: ?*GLFWmonitor, widthMM: [*c]c_int, heightMM: [*c]c_int) void;
pub extern fn glfwGetMonitorContentScale(monitor: ?*GLFWmonitor, xscale: [*c]f32, yscale: [*c]f32) void;
pub extern fn glfwGetMonitorName(monitor: ?*GLFWmonitor) [*c]const u8;
pub extern fn glfwSetMonitorUserPointer(monitor: ?*GLFWmonitor, pointer: ?*anyopaque) void;
pub extern fn glfwGetMonitorUserPointer(monitor: ?*GLFWmonitor) ?*anyopaque;
pub extern fn glfwSetMonitorCallback(callback: GLFWmonitorfun) GLFWmonitorfun;
pub extern fn glfwGetVideoModes(monitor: ?*GLFWmonitor, count: [*c]c_int) [*c]const GLFWvidmode;
pub extern fn glfwGetVideoMode(monitor: ?*GLFWmonitor) [*c]const GLFWvidmode;
pub extern fn glfwSetGamma(monitor: ?*GLFWmonitor, gamma: f32) void;
pub extern fn glfwGetGammaRamp(monitor: ?*GLFWmonitor) [*c]const GLFWgammaramp;
pub extern fn glfwSetGammaRamp(monitor: ?*GLFWmonitor, ramp: [*c]const GLFWgammaramp) void;
pub extern fn glfwDefaultWindowHints() void;
pub extern fn glfwWindowHint(hint: c_int, value: c_int) void;
pub extern fn glfwWindowHintString(hint: c_int, value: [*c]const u8) void;
pub extern fn glfwCreateWindow(width: c_int, height: c_int, title: [*c]const u8, monitor: ?*GLFWmonitor, share: ?*GLFWwindow) ?*GLFWwindow;
pub extern fn glfwDestroyWindow(window: ?*GLFWwindow) void;
pub extern fn glfwWindowShouldClose(window: ?*GLFWwindow) c_int;
pub extern fn glfwSetWindowShouldClose(window: ?*GLFWwindow, value: c_int) void;
pub extern fn glfwGetWindowTitle(window: ?*GLFWwindow) [*c]const u8;
pub extern fn glfwSetWindowTitle(window: ?*GLFWwindow, title: [*c]const u8) void;
pub extern fn glfwSetWindowIcon(window: ?*GLFWwindow, count: c_int, images: [*c]const GLFWimage) void;
pub extern fn glfwGetWindowPos(window: ?*GLFWwindow, xpos: [*c]c_int, ypos: [*c]c_int) void;
pub extern fn glfwSetWindowPos(window: ?*GLFWwindow, xpos: c_int, ypos: c_int) void;
pub extern fn glfwGetWindowSize(window: ?*GLFWwindow, width: [*c]c_int, height: [*c]c_int) void;
pub extern fn glfwSetWindowSizeLimits(window: ?*GLFWwindow, minwidth: c_int, minheight: c_int, maxwidth: c_int, maxheight: c_int) void;
pub extern fn glfwSetWindowAspectRatio(window: ?*GLFWwindow, numer: c_int, denom: c_int) void;
pub extern fn glfwSetWindowSize(window: ?*GLFWwindow, width: c_int, height: c_int) void;
pub extern fn glfwGetFramebufferSize(window: ?*GLFWwindow, width: [*c]c_int, height: [*c]c_int) void;
pub extern fn glfwGetWindowFrameSize(window: ?*GLFWwindow, left: [*c]c_int, top: [*c]c_int, right: [*c]c_int, bottom: [*c]c_int) void;
pub extern fn glfwGetWindowContentScale(window: ?*GLFWwindow, xscale: [*c]f32, yscale: [*c]f32) void;
pub extern fn glfwGetWindowOpacity(window: ?*GLFWwindow) f32;
pub extern fn glfwSetWindowOpacity(window: ?*GLFWwindow, opacity: f32) void;
pub extern fn glfwIconifyWindow(window: ?*GLFWwindow) void;
pub extern fn glfwRestoreWindow(window: ?*GLFWwindow) void;
pub extern fn glfwMaximizeWindow(window: ?*GLFWwindow) void;
pub extern fn glfwShowWindow(window: ?*GLFWwindow) void;
pub extern fn glfwHideWindow(window: ?*GLFWwindow) void;
pub extern fn glfwFocusWindow(window: ?*GLFWwindow) void;
pub extern fn glfwRequestWindowAttention(window: ?*GLFWwindow) void;
pub extern fn glfwGetWindowMonitor(window: ?*GLFWwindow) ?*GLFWmonitor;
pub extern fn glfwSetWindowMonitor(window: ?*GLFWwindow, monitor: ?*GLFWmonitor, xpos: c_int, ypos: c_int, width: c_int, height: c_int, refreshRate: c_int) void;
pub extern fn glfwGetWindowAttrib(window: ?*GLFWwindow, attrib: c_int) c_int;
pub extern fn glfwSetWindowAttrib(window: ?*GLFWwindow, attrib: c_int, value: c_int) void;
pub extern fn glfwSetWindowUserPointer(window: ?*GLFWwindow, pointer: ?*anyopaque) void;
pub extern fn glfwGetWindowUserPointer(window: ?*GLFWwindow) ?*anyopaque;
pub extern fn glfwSetWindowPosCallback(window: ?*GLFWwindow, callback: GLFWwindowposfun) GLFWwindowposfun;
pub extern fn glfwSetWindowSizeCallback(window: ?*GLFWwindow, callback: GLFWwindowsizefun) GLFWwindowsizefun;
pub extern fn glfwSetWindowCloseCallback(window: ?*GLFWwindow, callback: GLFWwindowclosefun) GLFWwindowclosefun;
pub extern fn glfwSetWindowRefreshCallback(window: ?*GLFWwindow, callback: GLFWwindowrefreshfun) GLFWwindowrefreshfun;
pub extern fn glfwSetWindowFocusCallback(window: ?*GLFWwindow, callback: GLFWwindowfocusfun) GLFWwindowfocusfun;
pub extern fn glfwSetWindowIconifyCallback(window: ?*GLFWwindow, callback: GLFWwindowiconifyfun) GLFWwindowiconifyfun;
pub extern fn glfwSetWindowMaximizeCallback(window: ?*GLFWwindow, callback: GLFWwindowmaximizefun) GLFWwindowmaximizefun;
pub extern fn glfwSetFramebufferSizeCallback(window: ?*GLFWwindow, callback: GLFWframebuffersizefun) GLFWframebuffersizefun;
pub extern fn glfwSetWindowContentScaleCallback(window: ?*GLFWwindow, callback: GLFWwindowcontentscalefun) GLFWwindowcontentscalefun;
pub extern fn glfwPollEvents() void;
pub extern fn glfwWaitEvents() void;
pub extern fn glfwWaitEventsTimeout(timeout: f64) void;
pub extern fn glfwPostEmptyEvent() void;
pub extern fn glfwGetInputMode(window: ?*GLFWwindow, mode: c_int) c_int;
pub extern fn glfwSetInputMode(window: ?*GLFWwindow, mode: c_int, value: c_int) void;
pub extern fn glfwRawMouseMotionSupported() c_int;
pub extern fn glfwGetKeyName(key: c_int, scancode: c_int) [*c]const u8;
pub extern fn glfwGetKeyScancode(key: c_int) c_int;
pub extern fn glfwGetKey(window: ?*GLFWwindow, key: c_int) c_int;
pub extern fn glfwGetMouseButton(window: ?*GLFWwindow, button: c_int) c_int;
pub extern fn glfwGetCursorPos(window: ?*GLFWwindow, xpos: [*c]f64, ypos: [*c]f64) void;
pub extern fn glfwSetCursorPos(window: ?*GLFWwindow, xpos: f64, ypos: f64) void;
pub extern fn glfwCreateCursor(image: [*c]const GLFWimage, xhot: c_int, yhot: c_int) ?*GLFWcursor;
pub extern fn glfwCreateStandardCursor(shape: c_int) ?*GLFWcursor;
pub extern fn glfwDestroyCursor(cursor: ?*GLFWcursor) void;
pub extern fn glfwSetCursor(window: ?*GLFWwindow, cursor: ?*GLFWcursor) void;
pub extern fn glfwSetKeyCallback(window: ?*GLFWwindow, callback: GLFWkeyfun) GLFWkeyfun;
pub extern fn glfwSetCharCallback(window: ?*GLFWwindow, callback: GLFWcharfun) GLFWcharfun;
pub extern fn glfwSetCharModsCallback(window: ?*GLFWwindow, callback: GLFWcharmodsfun) GLFWcharmodsfun;
pub extern fn glfwSetMouseButtonCallback(window: ?*GLFWwindow, callback: GLFWmousebuttonfun) GLFWmousebuttonfun;
pub extern fn glfwSetCursorPosCallback(window: ?*GLFWwindow, callback: GLFWcursorposfun) GLFWcursorposfun;
pub extern fn glfwSetCursorEnterCallback(window: ?*GLFWwindow, callback: GLFWcursorenterfun) GLFWcursorenterfun;
pub extern fn glfwSetScrollCallback(window: ?*GLFWwindow, callback: GLFWscrollfun) GLFWscrollfun;
pub extern fn glfwSetDropCallback(window: ?*GLFWwindow, callback: GLFWdropfun) GLFWdropfun;
pub extern fn glfwJoystickPresent(jid: c_int) c_int;
pub extern fn glfwGetJoystickAxes(jid: c_int, count: [*c]c_int) [*c]const f32;
pub extern fn glfwGetJoystickButtons(jid: c_int, count: [*c]c_int) [*c]const u8;
pub extern fn glfwGetJoystickHats(jid: c_int, count: [*c]c_int) [*c]const u8;
pub extern fn glfwGetJoystickName(jid: c_int) [*c]const u8;
pub extern fn glfwGetJoystickGUID(jid: c_int) [*c]const u8;
pub extern fn glfwSetJoystickUserPointer(jid: c_int, pointer: ?*anyopaque) void;
pub extern fn glfwGetJoystickUserPointer(jid: c_int) ?*anyopaque;
pub extern fn glfwJoystickIsGamepad(jid: c_int) c_int;
pub extern fn glfwSetJoystickCallback(callback: GLFWjoystickfun) GLFWjoystickfun;
pub extern fn glfwUpdateGamepadMappings(string: [*c]const u8) c_int;
pub extern fn glfwGetGamepadName(jid: c_int) [*c]const u8;
pub extern fn glfwGetGamepadState(jid: c_int, state: [*c]GLFWgamepadstate) c_int;
pub extern fn glfwSetClipboardString(window: ?*GLFWwindow, string: [*c]const u8) void;
pub extern fn glfwGetClipboardString(window: ?*GLFWwindow) [*c]const u8;
pub extern fn glfwGetTime() f64;
pub extern fn glfwSetTime(time: f64) void;
pub extern fn glfwGetTimerValue() u64;
pub extern fn glfwGetTimerFrequency() u64;
pub extern fn glfwMakeContextCurrent(window: ?*GLFWwindow) void;
pub extern fn glfwGetCurrentContext() ?*GLFWwindow;
pub extern fn glfwSwapBuffers(window: ?*GLFWwindow) void;
pub extern fn glfwSwapInterval(interval: c_int) void;
pub extern fn glfwExtensionSupported(extension: [*c]const u8) c_int;
pub extern fn glfwGetProcAddress(procname: [*c]const u8) GLFWglproc;
pub extern fn glfwVulkanSupported() c_int;
pub extern fn glfwGetRequiredInstanceExtensions(count: [*c]u32) [*c][*c]const u8;
pub const __llvm__ = @as(c_int, 1);
pub const __clang__ = @as(c_int, 1);
pub const __clang_major__ = @as(c_int, 19);
pub const __clang_minor__ = @as(c_int, 1);
pub const __clang_patchlevel__ = @as(c_int, 0);
pub const __clang_version__ = "19.1.0 (https://github.com/ziglang/zig-bootstrap 3f9c0f8f8b6e09280507d5445f6c971ec7776f10)";
pub const __GNUC__ = @as(c_int, 4);
pub const __GNUC_MINOR__ = @as(c_int, 2);
pub const __GNUC_PATCHLEVEL__ = @as(c_int, 1);
pub const __GXX_ABI_VERSION = @as(c_int, 1002);
pub const __ATOMIC_RELAXED = @as(c_int, 0);
pub const __ATOMIC_CONSUME = @as(c_int, 1);
pub const __ATOMIC_ACQUIRE = @as(c_int, 2);
pub const __ATOMIC_RELEASE = @as(c_int, 3);
pub const __ATOMIC_ACQ_REL = @as(c_int, 4);
pub const __ATOMIC_SEQ_CST = @as(c_int, 5);
pub const __MEMORY_SCOPE_SYSTEM = @as(c_int, 0);
pub const __MEMORY_SCOPE_DEVICE = @as(c_int, 1);
pub const __MEMORY_SCOPE_WRKGRP = @as(c_int, 2);
pub const __MEMORY_SCOPE_WVFRNT = @as(c_int, 3);
pub const __MEMORY_SCOPE_SINGLE = @as(c_int, 4);
pub const __OPENCL_MEMORY_SCOPE_WORK_ITEM = @as(c_int, 0);
pub const __OPENCL_MEMORY_SCOPE_WORK_GROUP = @as(c_int, 1);
pub const __OPENCL_MEMORY_SCOPE_DEVICE = @as(c_int, 2);
pub const __OPENCL_MEMORY_SCOPE_ALL_SVM_DEVICES = @as(c_int, 3);
pub const __OPENCL_MEMORY_SCOPE_SUB_GROUP = @as(c_int, 4);
pub const __FPCLASS_SNAN = @as(c_int, 0x0001);
pub const __FPCLASS_QNAN = @as(c_int, 0x0002);
pub const __FPCLASS_NEGINF = @as(c_int, 0x0004);
pub const __FPCLASS_NEGNORMAL = @as(c_int, 0x0008);
pub const __FPCLASS_NEGSUBNORMAL = @as(c_int, 0x0010);
pub const __FPCLASS_NEGZERO = @as(c_int, 0x0020);
pub const __FPCLASS_POSZERO = @as(c_int, 0x0040);
pub const __FPCLASS_POSSUBNORMAL = @as(c_int, 0x0080);
pub const __FPCLASS_POSNORMAL = @as(c_int, 0x0100);
pub const __FPCLASS_POSINF = @as(c_int, 0x0200);
pub const __PRAGMA_REDEFINE_EXTNAME = @as(c_int, 1);
pub const __VERSION__ = "Clang 19.1.0 (https://github.com/ziglang/zig-bootstrap 3f9c0f8f8b6e09280507d5445f6c971ec7776f10)";
pub const __GXX_TYPEINFO_EQUALITY_INLINE = @as(c_int, 0);
pub const __OBJC_BOOL_IS_BOOL = @as(c_int, 0);
pub const __CONSTANT_CFSTRINGS__ = @as(c_int, 1);
pub const __SEH__ = @as(c_int, 1);
pub const __clang_literal_encoding__ = "UTF-8";
pub const __clang_wide_literal_encoding__ = "UTF-16";
pub const __ORDER_LITTLE_ENDIAN__ = @as(c_int, 1234);
pub const __ORDER_BIG_ENDIAN__ = @as(c_int, 4321);
pub const __ORDER_PDP_ENDIAN__ = @as(c_int, 3412);
pub const __BYTE_ORDER__ = __ORDER_LITTLE_ENDIAN__;
pub const __LITTLE_ENDIAN__ = @as(c_int, 1);
pub const __CHAR_BIT__ = @as(c_int, 8);
pub const __BOOL_WIDTH__ = @as(c_int, 8);
pub const __SHRT_WIDTH__ = @as(c_int, 16);
pub const __INT_WIDTH__ = @as(c_int, 32);
pub const __LONG_WIDTH__ = @as(c_int, 32);
pub const __LLONG_WIDTH__ = @as(c_int, 64);
pub const __BITINT_MAXWIDTH__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 8388608, .decimal);
pub const __SCHAR_MAX__ = @as(c_int, 127);
pub const __SHRT_MAX__ = @as(c_int, 32767);
pub const __INT_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __LONG_MAX__ = @as(c_long, 2147483647);
pub const __LONG_LONG_MAX__ = @as(c_longlong, 9223372036854775807);
pub const __WCHAR_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 65535, .decimal);
pub const __WCHAR_WIDTH__ = @as(c_int, 16);
pub const __WINT_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 65535, .decimal);
pub const __WINT_WIDTH__ = @as(c_int, 16);
pub const __INTMAX_MAX__ = @as(c_longlong, 9223372036854775807);
pub const __INTMAX_WIDTH__ = @as(c_int, 64);
pub const __SIZE_MAX__ = @as(c_ulonglong, 18446744073709551615);
pub const __SIZE_WIDTH__ = @as(c_int, 64);
pub const __UINTMAX_MAX__ = @as(c_ulonglong, 18446744073709551615);
pub const __UINTMAX_WIDTH__ = @as(c_int, 64);
pub const __PTRDIFF_MAX__ = @as(c_longlong, 9223372036854775807);
pub const __PTRDIFF_WIDTH__ = @as(c_int, 64);
pub const __INTPTR_MAX__ = @as(c_longlong, 9223372036854775807);
pub const __INTPTR_WIDTH__ = @as(c_int, 64);
pub const __UINTPTR_MAX__ = @as(c_ulonglong, 18446744073709551615);
pub const __UINTPTR_WIDTH__ = @as(c_int, 64);
pub const __SIZEOF_DOUBLE__ = @as(c_int, 8);
pub const __SIZEOF_FLOAT__ = @as(c_int, 4);
pub const __SIZEOF_INT__ = @as(c_int, 4);
pub const __SIZEOF_LONG__ = @as(c_int, 4);
pub const __SIZEOF_LONG_DOUBLE__ = @as(c_int, 16);
pub const __SIZEOF_LONG_LONG__ = @as(c_int, 8);
pub const __SIZEOF_POINTER__ = @as(c_int, 8);
pub const __SIZEOF_SHORT__ = @as(c_int, 2);
pub const __SIZEOF_PTRDIFF_T__ = @as(c_int, 8);
pub const __SIZEOF_SIZE_T__ = @as(c_int, 8);
pub const __SIZEOF_WCHAR_T__ = @as(c_int, 2);
pub const __SIZEOF_WINT_T__ = @as(c_int, 2);
pub const __SIZEOF_INT128__ = @as(c_int, 16);
pub const __INTMAX_TYPE__ = c_longlong;
pub const __INTMAX_FMTd__ = "lld";
pub const __INTMAX_FMTi__ = "lli";
pub const __INTMAX_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `LL`");
// (no file):95:9
pub const __UINTMAX_TYPE__ = c_ulonglong;
pub const __UINTMAX_FMTo__ = "llo";
pub const __UINTMAX_FMTu__ = "llu";
pub const __UINTMAX_FMTx__ = "llx";
pub const __UINTMAX_FMTX__ = "llX";
pub const __UINTMAX_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `ULL`");
// (no file):101:9
pub const __PTRDIFF_TYPE__ = c_longlong;
pub const __PTRDIFF_FMTd__ = "lld";
pub const __PTRDIFF_FMTi__ = "lli";
pub const __INTPTR_TYPE__ = c_longlong;
pub const __INTPTR_FMTd__ = "lld";
pub const __INTPTR_FMTi__ = "lli";
pub const __SIZE_TYPE__ = c_ulonglong;
pub const __SIZE_FMTo__ = "llo";
pub const __SIZE_FMTu__ = "llu";
pub const __SIZE_FMTx__ = "llx";
pub const __SIZE_FMTX__ = "llX";
pub const __WCHAR_TYPE__ = c_ushort;
pub const __WINT_TYPE__ = c_ushort;
pub const __SIG_ATOMIC_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __SIG_ATOMIC_WIDTH__ = @as(c_int, 32);
pub const __CHAR16_TYPE__ = c_ushort;
pub const __CHAR32_TYPE__ = c_uint;
pub const __UINTPTR_TYPE__ = c_ulonglong;
pub const __UINTPTR_FMTo__ = "llo";
pub const __UINTPTR_FMTu__ = "llu";
pub const __UINTPTR_FMTx__ = "llx";
pub const __UINTPTR_FMTX__ = "llX";
pub const __FLT16_DENORM_MIN__ = @as(f16, 5.9604644775390625e-8);
pub const __FLT16_NORM_MAX__ = @as(f16, 6.5504e+4);
pub const __FLT16_HAS_DENORM__ = @as(c_int, 1);
pub const __FLT16_DIG__ = @as(c_int, 3);
pub const __FLT16_DECIMAL_DIG__ = @as(c_int, 5);
pub const __FLT16_EPSILON__ = @as(f16, 9.765625e-4);
pub const __FLT16_HAS_INFINITY__ = @as(c_int, 1);
pub const __FLT16_HAS_QUIET_NAN__ = @as(c_int, 1);
pub const __FLT16_MANT_DIG__ = @as(c_int, 11);
pub const __FLT16_MAX_10_EXP__ = @as(c_int, 4);
pub const __FLT16_MAX_EXP__ = @as(c_int, 16);
pub const __FLT16_MAX__ = @as(f16, 6.5504e+4);
pub const __FLT16_MIN_10_EXP__ = -@as(c_int, 4);
pub const __FLT16_MIN_EXP__ = -@as(c_int, 13);
pub const __FLT16_MIN__ = @as(f16, 6.103515625e-5);
pub const __FLT_DENORM_MIN__ = @as(f32, 1.40129846e-45);
pub const __FLT_NORM_MAX__ = @as(f32, 3.40282347e+38);
pub const __FLT_HAS_DENORM__ = @as(c_int, 1);
pub const __FLT_DIG__ = @as(c_int, 6);
pub const __FLT_DECIMAL_DIG__ = @as(c_int, 9);
pub const __FLT_EPSILON__ = @as(f32, 1.19209290e-7);
pub const __FLT_HAS_INFINITY__ = @as(c_int, 1);
pub const __FLT_HAS_QUIET_NAN__ = @as(c_int, 1);
pub const __FLT_MANT_DIG__ = @as(c_int, 24);
pub const __FLT_MAX_10_EXP__ = @as(c_int, 38);
pub const __FLT_MAX_EXP__ = @as(c_int, 128);
pub const __FLT_MAX__ = @as(f32, 3.40282347e+38);
pub const __FLT_MIN_10_EXP__ = -@as(c_int, 37);
pub const __FLT_MIN_EXP__ = -@as(c_int, 125);
pub const __FLT_MIN__ = @as(f32, 1.17549435e-38);
pub const __DBL_DENORM_MIN__ = @as(f64, 4.9406564584124654e-324);
pub const __DBL_NORM_MAX__ = @as(f64, 1.7976931348623157e+308);
pub const __DBL_HAS_DENORM__ = @as(c_int, 1);
pub const __DBL_DIG__ = @as(c_int, 15);
pub const __DBL_DECIMAL_DIG__ = @as(c_int, 17);
pub const __DBL_EPSILON__ = @as(f64, 2.2204460492503131e-16);
pub const __DBL_HAS_INFINITY__ = @as(c_int, 1);
pub const __DBL_HAS_QUIET_NAN__ = @as(c_int, 1);
pub const __DBL_MANT_DIG__ = @as(c_int, 53);
pub const __DBL_MAX_10_EXP__ = @as(c_int, 308);
pub const __DBL_MAX_EXP__ = @as(c_int, 1024);
pub const __DBL_MAX__ = @as(f64, 1.7976931348623157e+308);
pub const __DBL_MIN_10_EXP__ = -@as(c_int, 307);
pub const __DBL_MIN_EXP__ = -@as(c_int, 1021);
pub const __DBL_MIN__ = @as(f64, 2.2250738585072014e-308);
pub const __LDBL_DENORM_MIN__ = @as(c_longdouble, 3.64519953188247460253e-4951);
pub const __LDBL_NORM_MAX__ = @as(c_longdouble, 1.18973149535723176502e+4932);
pub const __LDBL_HAS_DENORM__ = @as(c_int, 1);
pub const __LDBL_DIG__ = @as(c_int, 18);
pub const __LDBL_DECIMAL_DIG__ = @as(c_int, 21);
pub const __LDBL_EPSILON__ = @as(c_longdouble, 1.08420217248550443401e-19);
pub const __LDBL_HAS_INFINITY__ = @as(c_int, 1);
pub const __LDBL_HAS_QUIET_NAN__ = @as(c_int, 1);
pub const __LDBL_MANT_DIG__ = @as(c_int, 64);
pub const __LDBL_MAX_10_EXP__ = @as(c_int, 4932);
pub const __LDBL_MAX_EXP__ = @as(c_int, 16384);
pub const __LDBL_MAX__ = @as(c_longdouble, 1.18973149535723176502e+4932);
pub const __LDBL_MIN_10_EXP__ = -@as(c_int, 4931);
pub const __LDBL_MIN_EXP__ = -@as(c_int, 16381);
pub const __LDBL_MIN__ = @as(c_longdouble, 3.36210314311209350626e-4932);
pub const __POINTER_WIDTH__ = @as(c_int, 64);
pub const __BIGGEST_ALIGNMENT__ = @as(c_int, 16);
pub const __WCHAR_UNSIGNED__ = @as(c_int, 1);
pub const __WINT_UNSIGNED__ = @as(c_int, 1);
pub const __INT8_TYPE__ = i8;
pub const __INT8_FMTd__ = "hhd";
pub const __INT8_FMTi__ = "hhi";
pub const __INT8_C_SUFFIX__ = "";
pub const __INT16_TYPE__ = c_short;
pub const __INT16_FMTd__ = "hd";
pub const __INT16_FMTi__ = "hi";
pub const __INT16_C_SUFFIX__ = "";
pub const __INT32_TYPE__ = c_int;
pub const __INT32_FMTd__ = "d";
pub const __INT32_FMTi__ = "i";
pub const __INT32_C_SUFFIX__ = "";
pub const __INT64_TYPE__ = c_longlong;
pub const __INT64_FMTd__ = "lld";
pub const __INT64_FMTi__ = "lli";
pub const __INT64_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `LL`");
// (no file):203:9
pub const __UINT8_TYPE__ = u8;
pub const __UINT8_FMTo__ = "hho";
pub const __UINT8_FMTu__ = "hhu";
pub const __UINT8_FMTx__ = "hhx";
pub const __UINT8_FMTX__ = "hhX";
pub const __UINT8_C_SUFFIX__ = "";
pub const __UINT8_MAX__ = @as(c_int, 255);
pub const __INT8_MAX__ = @as(c_int, 127);
pub const __UINT16_TYPE__ = c_ushort;
pub const __UINT16_FMTo__ = "ho";
pub const __UINT16_FMTu__ = "hu";
pub const __UINT16_FMTx__ = "hx";
pub const __UINT16_FMTX__ = "hX";
pub const __UINT16_C_SUFFIX__ = "";
pub const __UINT16_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 65535, .decimal);
pub const __INT16_MAX__ = @as(c_int, 32767);
pub const __UINT32_TYPE__ = c_uint;
pub const __UINT32_FMTo__ = "o";
pub const __UINT32_FMTu__ = "u";
pub const __UINT32_FMTx__ = "x";
pub const __UINT32_FMTX__ = "X";
pub const __UINT32_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `U`");
// (no file):225:9
pub const __UINT32_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const __INT32_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __UINT64_TYPE__ = c_ulonglong;
pub const __UINT64_FMTo__ = "llo";
pub const __UINT64_FMTu__ = "llu";
pub const __UINT64_FMTx__ = "llx";
pub const __UINT64_FMTX__ = "llX";
pub const __UINT64_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `ULL`");
// (no file):233:9
pub const __UINT64_MAX__ = @as(c_ulonglong, 18446744073709551615);
pub const __INT64_MAX__ = @as(c_longlong, 9223372036854775807);
pub const __INT_LEAST8_TYPE__ = i8;
pub const __INT_LEAST8_MAX__ = @as(c_int, 127);
pub const __INT_LEAST8_WIDTH__ = @as(c_int, 8);
pub const __INT_LEAST8_FMTd__ = "hhd";
pub const __INT_LEAST8_FMTi__ = "hhi";
pub const __UINT_LEAST8_TYPE__ = u8;
pub const __UINT_LEAST8_MAX__ = @as(c_int, 255);
pub const __UINT_LEAST8_FMTo__ = "hho";
pub const __UINT_LEAST8_FMTu__ = "hhu";
pub const __UINT_LEAST8_FMTx__ = "hhx";
pub const __UINT_LEAST8_FMTX__ = "hhX";
pub const __INT_LEAST16_TYPE__ = c_short;
pub const __INT_LEAST16_MAX__ = @as(c_int, 32767);
pub const __INT_LEAST16_WIDTH__ = @as(c_int, 16);
pub const __INT_LEAST16_FMTd__ = "hd";
pub const __INT_LEAST16_FMTi__ = "hi";
pub const __UINT_LEAST16_TYPE__ = c_ushort;
pub const __UINT_LEAST16_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 65535, .decimal);
pub const __UINT_LEAST16_FMTo__ = "ho";
pub const __UINT_LEAST16_FMTu__ = "hu";
pub const __UINT_LEAST16_FMTx__ = "hx";
pub const __UINT_LEAST16_FMTX__ = "hX";
pub const __INT_LEAST32_TYPE__ = c_int;
pub const __INT_LEAST32_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __INT_LEAST32_WIDTH__ = @as(c_int, 32);
pub const __INT_LEAST32_FMTd__ = "d";
pub const __INT_LEAST32_FMTi__ = "i";
pub const __UINT_LEAST32_TYPE__ = c_uint;
pub const __UINT_LEAST32_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const __UINT_LEAST32_FMTo__ = "o";
pub const __UINT_LEAST32_FMTu__ = "u";
pub const __UINT_LEAST32_FMTx__ = "x";
pub const __UINT_LEAST32_FMTX__ = "X";
pub const __INT_LEAST64_TYPE__ = c_longlong;
pub const __INT_LEAST64_MAX__ = @as(c_longlong, 9223372036854775807);
pub const __INT_LEAST64_WIDTH__ = @as(c_int, 64);
pub const __INT_LEAST64_FMTd__ = "lld";
pub const __INT_LEAST64_FMTi__ = "lli";
pub const __UINT_LEAST64_TYPE__ = c_ulonglong;
pub const __UINT_LEAST64_MAX__ = @as(c_ulonglong, 18446744073709551615);
pub const __UINT_LEAST64_FMTo__ = "llo";
pub const __UINT_LEAST64_FMTu__ = "llu";
pub const __UINT_LEAST64_FMTx__ = "llx";
pub const __UINT_LEAST64_FMTX__ = "llX";
pub const __INT_FAST8_TYPE__ = i8;
pub const __INT_FAST8_MAX__ = @as(c_int, 127);
pub const __INT_FAST8_WIDTH__ = @as(c_int, 8);
pub const __INT_FAST8_FMTd__ = "hhd";
pub const __INT_FAST8_FMTi__ = "hhi";
pub const __UINT_FAST8_TYPE__ = u8;
pub const __UINT_FAST8_MAX__ = @as(c_int, 255);
pub const __UINT_FAST8_FMTo__ = "hho";
pub const __UINT_FAST8_FMTu__ = "hhu";
pub const __UINT_FAST8_FMTx__ = "hhx";
pub const __UINT_FAST8_FMTX__ = "hhX";
pub const __INT_FAST16_TYPE__ = c_short;
pub const __INT_FAST16_MAX__ = @as(c_int, 32767);
pub const __INT_FAST16_WIDTH__ = @as(c_int, 16);
pub const __INT_FAST16_FMTd__ = "hd";
pub const __INT_FAST16_FMTi__ = "hi";
pub const __UINT_FAST16_TYPE__ = c_ushort;
pub const __UINT_FAST16_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 65535, .decimal);
pub const __UINT_FAST16_FMTo__ = "ho";
pub const __UINT_FAST16_FMTu__ = "hu";
pub const __UINT_FAST16_FMTx__ = "hx";
pub const __UINT_FAST16_FMTX__ = "hX";
pub const __INT_FAST32_TYPE__ = c_int;
pub const __INT_FAST32_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __INT_FAST32_WIDTH__ = @as(c_int, 32);
pub const __INT_FAST32_FMTd__ = "d";
pub const __INT_FAST32_FMTi__ = "i";
pub const __UINT_FAST32_TYPE__ = c_uint;
pub const __UINT_FAST32_MAX__ = @import("std").zig.c_translation.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const __UINT_FAST32_FMTo__ = "o";
pub const __UINT_FAST32_FMTu__ = "u";
pub const __UINT_FAST32_FMTx__ = "x";
pub const __UINT_FAST32_FMTX__ = "X";
pub const __INT_FAST64_TYPE__ = c_longlong;
pub const __INT_FAST64_MAX__ = @as(c_longlong, 9223372036854775807);
pub const __INT_FAST64_WIDTH__ = @as(c_int, 64);
pub const __INT_FAST64_FMTd__ = "lld";
pub const __INT_FAST64_FMTi__ = "lli";
pub const __UINT_FAST64_TYPE__ = c_ulonglong;
pub const __UINT_FAST64_MAX__ = @as(c_ulonglong, 18446744073709551615);
pub const __UINT_FAST64_FMTo__ = "llo";
pub const __UINT_FAST64_FMTu__ = "llu";
pub const __UINT_FAST64_FMTx__ = "llx";
pub const __UINT_FAST64_FMTX__ = "llX";
pub const __USER_LABEL_PREFIX__ = "";
pub const __FINITE_MATH_ONLY__ = @as(c_int, 0);
pub const __GNUC_STDC_INLINE__ = @as(c_int, 1);
pub const __GCC_ATOMIC_TEST_AND_SET_TRUEVAL = @as(c_int, 1);
pub const __GCC_DESTRUCTIVE_SIZE = @as(c_int, 64);
pub const __GCC_CONSTRUCTIVE_SIZE = @as(c_int, 64);
pub const __CLANG_ATOMIC_BOOL_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_CHAR_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_CHAR16_T_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_CHAR32_T_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_WCHAR_T_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_SHORT_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_INT_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_LONG_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_LLONG_LOCK_FREE = @as(c_int, 2);
pub const __CLANG_ATOMIC_POINTER_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_BOOL_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_CHAR_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_CHAR16_T_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_CHAR32_T_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_WCHAR_T_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_SHORT_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_INT_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_LONG_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_LLONG_LOCK_FREE = @as(c_int, 2);
pub const __GCC_ATOMIC_POINTER_LOCK_FREE = @as(c_int, 2);
pub const __NO_INLINE__ = @as(c_int, 1);
pub const __PIC__ = @as(c_int, 2);
pub const __pic__ = @as(c_int, 2);
pub const __FLT_RADIX__ = @as(c_int, 2);
pub const __DECIMAL_DIG__ = __LDBL_DECIMAL_DIG__;
pub const __SSP_STRONG__ = @as(c_int, 2);
pub const __GCC_ASM_FLAG_OUTPUTS__ = @as(c_int, 1);
pub const __code_model_small__ = @as(c_int, 1);
pub const __amd64__ = @as(c_int, 1);
pub const __amd64 = @as(c_int, 1);
pub const __x86_64 = @as(c_int, 1);
pub const __x86_64__ = @as(c_int, 1);
pub const __SEG_GS = @as(c_int, 1);
pub const __SEG_FS = @as(c_int, 1);
pub const __seg_gs = @compileError("unable to translate macro: undefined identifier `address_space`");
// (no file):366:9
pub const __seg_fs = @compileError("unable to translate macro: undefined identifier `address_space`");
// (no file):367:9
pub const __znver3 = @as(c_int, 1);
pub const __znver3__ = @as(c_int, 1);
pub const __tune_znver3__ = @as(c_int, 1);
pub const __REGISTER_PREFIX__ = "";
pub const __NO_MATH_INLINES = @as(c_int, 1);
pub const __AES__ = @as(c_int, 1);
pub const __VAES__ = @as(c_int, 1);
pub const __PCLMUL__ = @as(c_int, 1);
pub const __VPCLMULQDQ__ = @as(c_int, 1);
pub const __LAHF_SAHF__ = @as(c_int, 1);
pub const __LZCNT__ = @as(c_int, 1);
pub const __RDRND__ = @as(c_int, 1);
pub const __FSGSBASE__ = @as(c_int, 1);
pub const __BMI__ = @as(c_int, 1);
pub const __BMI2__ = @as(c_int, 1);
pub const __POPCNT__ = @as(c_int, 1);
pub const __PRFCHW__ = @as(c_int, 1);
pub const __RDSEED__ = @as(c_int, 1);
pub const __ADX__ = @as(c_int, 1);
pub const __MWAITX__ = @as(c_int, 1);
pub const __MOVBE__ = @as(c_int, 1);
pub const __SSE4A__ = @as(c_int, 1);
pub const __FMA__ = @as(c_int, 1);
pub const __F16C__ = @as(c_int, 1);
pub const __SHA__ = @as(c_int, 1);
pub const __FXSR__ = @as(c_int, 1);
pub const __XSAVE__ = @as(c_int, 1);
pub const __XSAVEOPT__ = @as(c_int, 1);
pub const __XSAVEC__ = @as(c_int, 1);
pub const __XSAVES__ = @as(c_int, 1);
pub const __CLFLUSHOPT__ = @as(c_int, 1);
pub const __CLWB__ = @as(c_int, 1);
pub const __WBNOINVD__ = @as(c_int, 1);
pub const __SHSTK__ = @as(c_int, 1);
pub const __CLZERO__ = @as(c_int, 1);
pub const __RDPID__ = @as(c_int, 1);
pub const __RDPRU__ = @as(c_int, 1);
pub const __INVPCID__ = @as(c_int, 1);
pub const __CRC32__ = @as(c_int, 1);
pub const __AVX2__ = @as(c_int, 1);
pub const __AVX__ = @as(c_int, 1);
pub const __SSE4_2__ = @as(c_int, 1);
pub const __SSE4_1__ = @as(c_int, 1);
pub const __SSSE3__ = @as(c_int, 1);
pub const __SSE3__ = @as(c_int, 1);
pub const __SSE2__ = @as(c_int, 1);
pub const __SSE2_MATH__ = @as(c_int, 1);
pub const __SSE__ = @as(c_int, 1);
pub const __SSE_MATH__ = @as(c_int, 1);
pub const __MMX__ = @as(c_int, 1);
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_1 = @as(c_int, 1);
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_2 = @as(c_int, 1);
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_4 = @as(c_int, 1);
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_8 = @as(c_int, 1);
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_16 = @as(c_int, 1);
pub const __SIZEOF_FLOAT128__ = @as(c_int, 16);
pub const _WIN32 = @as(c_int, 1);
pub const _WIN64 = @as(c_int, 1);
pub const WIN32 = @as(c_int, 1);
pub const __WIN32 = @as(c_int, 1);
pub const __WIN32__ = @as(c_int, 1);
pub const WINNT = @as(c_int, 1);
pub const __WINNT = @as(c_int, 1);
pub const __WINNT__ = @as(c_int, 1);
pub const WIN64 = @as(c_int, 1);
pub const __WIN64 = @as(c_int, 1);
pub const __WIN64__ = @as(c_int, 1);
pub const __MINGW64__ = @as(c_int, 1);
pub const __MSVCRT__ = @as(c_int, 1);
pub const __MINGW32__ = @as(c_int, 1);
pub const __declspec = @compileError("unable to translate C expr: unexpected token '__attribute__'");
// (no file):438:9
pub const _cdecl = @compileError("unable to translate macro: undefined identifier `__cdecl__`");
// (no file):439:9
pub const __cdecl = @compileError("unable to translate macro: undefined identifier `__cdecl__`");
// (no file):440:9
pub const _stdcall = @compileError("unable to translate macro: undefined identifier `__stdcall__`");
// (no file):441:9
pub const __stdcall = @compileError("unable to translate macro: undefined identifier `__stdcall__`");
// (no file):442:9
pub const _fastcall = @compileError("unable to translate macro: undefined identifier `__fastcall__`");
// (no file):443:9
pub const __fastcall = @compileError("unable to translate macro: undefined identifier `__fastcall__`");
// (no file):444:9
pub const _thiscall = @compileError("unable to translate macro: undefined identifier `__thiscall__`");
// (no file):445:9
pub const __thiscall = @compileError("unable to translate macro: undefined identifier `__thiscall__`");
// (no file):446:9
pub const _pascal = @compileError("unable to translate macro: undefined identifier `__pascal__`");
// (no file):447:9
pub const __pascal = @compileError("unable to translate macro: undefined identifier `__pascal__`");
// (no file):448:9
pub const __STDC__ = @as(c_int, 1);
pub const __STDC_HOSTED__ = @as(c_int, 1);
pub const __STDC_VERSION__ = @as(c_long, 201710);
pub const __STDC_UTF_16__ = @as(c_int, 1);
pub const __STDC_UTF_32__ = @as(c_int, 1);
pub const __STDC_EMBED_NOT_FOUND__ = @as(c_int, 0);
pub const __STDC_EMBED_FOUND__ = @as(c_int, 1);
pub const __STDC_EMBED_EMPTY__ = @as(c_int, 2);
pub const __MSVCRT_VERSION__ = @as(c_int, 0xE00);
pub const _WIN32_WINNT = @as(c_int, 0x0a00);
pub const _DEBUG = @as(c_int, 1);
pub const __glad_h_ = "";
pub const __gl_h_ = "";
pub const APIENTRY = @compileError("unable to translate C expr: unexpected token '__stdcall'");
// deps\glad\include/glad/glad.h:32:9
pub const APIENTRYP = @compileError("unable to translate C expr: unexpected token ''");
// deps\glad\include/glad/glad.h:39:9
pub const GLAPIENTRY = APIENTRY;
pub const GLAPI = @compileError("unable to translate C expr: unexpected token 'extern'");
// deps\glad\include/glad/glad.h:79:11
pub const __khrplatform_h_ = "";
pub const KHRONOS_APICALL = @compileError("unable to translate macro: undefined identifier `dllimport`");
// deps\glad\include/KHR/khrplatform.h:107:12
pub const KHRONOS_APIENTRY = @compileError("unable to translate C expr: unexpected token '__stdcall'");
// deps\glad\include/KHR/khrplatform.h:124:12
pub const KHRONOS_APIATTRIBUTES = "";
pub const __CLANG_STDINT_H = "";
pub const _STDINT_H = "";
pub const _INC_CRTDEFS = "";
pub const _INC_CORECRT = "";
pub const _INC__MINGW_H = "";
pub const _INC_CRTDEFS_MACRO = "";
pub const __STRINGIFY = @compileError("unable to translate C expr: unexpected token '#'");
// C:\Zig\lib\libc\include\any-windows-any/_mingw_mac.h:10:9
pub inline fn __MINGW64_STRINGIFY(x: anytype) @TypeOf(__STRINGIFY(x)) {
    _ = &x;
    return __STRINGIFY(x);
}
pub const __MINGW64_VERSION_MAJOR = @as(c_int, 13);
pub const __MINGW64_VERSION_MINOR = @as(c_int, 0);
pub const __MINGW64_VERSION_BUGFIX = @as(c_int, 0);
pub const __MINGW64_VERSION_RC = @as(c_int, 0);
pub const __MINGW64_VERSION_STR = __MINGW64_STRINGIFY(__MINGW64_VERSION_MAJOR) ++ "." ++ __MINGW64_STRINGIFY(__MINGW64_VERSION_MINOR) ++ "." ++ __MINGW64_STRINGIFY(__MINGW64_VERSION_BUGFIX);
pub const __MINGW64_VERSION_STATE = "alpha";
pub const __MINGW32_MAJOR_VERSION = @as(c_int, 3);
pub const __MINGW32_MINOR_VERSION = @as(c_int, 11);
pub const _M_AMD64 = @as(c_int, 100);
pub const _M_X64 = @as(c_int, 100);
pub const @"_" = @as(c_int, 1);
pub const __MINGW_USE_UNDERSCORE_PREFIX = @as(c_int, 0);
pub const __MINGW_IMP_SYMBOL = @compileError("unable to translate macro: undefined identifier `__imp_`");
// C:\Zig\lib\libc\include\any-windows-any/_mingw_mac.h:119:11
pub const __MINGW_IMP_LSYMBOL = @compileError("unable to translate macro: undefined identifier `__imp_`");
// C:\Zig\lib\libc\include\any-windows-any/_mingw_mac.h:120:11
pub inline fn __MINGW_USYMBOL(sym: anytype) @TypeOf(sym) {
    _ = &sym;
    return sym;
}
pub const __MINGW_LSYMBOL = @compileError("unable to translate C expr: unexpected token '##'");
// C:\Zig\lib\libc\include\any-windows-any/_mingw_mac.h:122:11
pub const __MINGW_ASM_CALL = @compileError("unable to translate C expr: unexpected token '__asm__'");
// C:\Zig\lib\libc\include\any-windows-any/_mingw_mac.h:130:9
pub const __MINGW_ASM_CRT_CALL = @compileError("unable to translate C expr: unexpected token '__asm__'");
// C:\Zig\lib\libc\include\any-windows-any/_mingw_mac.h:131:9
pub const __MINGW_EXTENSION = @compileError("unable to translate C expr: unexpected token '__extension__'");
// C:\Zig\lib\libc\include\any-windows-any/_mingw_mac.h:163:13
pub const __C89_NAMELESS = __MINGW_EXTENSION;
pub const __C89_NAMELESSSTRUCTNAME = "";
pub const __C89_NAMELESSSTRUCTNAME1 = "";
pub const __C89_NAMELESSSTRUCTNAME2 = "";
pub const __C89_NAMELESSSTRUCTNAME3 = "";
pub const __C89_NAMELESSSTRUCTNAME4 = "";
pub const __C89_NAMELESSSTRUCTNAME5 = "";
pub const __C89_NAMELESSUNIONNAME = "";
pub const __C89_NAMELESSUNIONNAME1 = "";
pub const __C89_NAMELESSUNIONNAME2 = "";
pub const __C89_NAMELESSUNIONNAME3 = "";
pub const __C89_NAMELESSUNIONNAME4 = "";
pub const __C89_NAMELESSUNIONNAME5 = "";
pub const __C89_NAMELESSUNIONNAME6 = "";
pub const __C89_NAMELESSUNIONNAME7 = "";
pub const __C89_NAMELESSUNIONNAME8 = "";
pub const __GNU_EXTENSION = __MINGW_EXTENSION;
pub const __MINGW_HAVE_ANSI_C99_PRINTF = @as(c_int, 1);
pub const __MINGW_HAVE_WIDE_C99_PRINTF = @as(c_int, 1);
pub const __MINGW_HAVE_ANSI_C99_SCANF = @as(c_int, 1);
pub const __MINGW_HAVE_WIDE_C99_SCANF = @as(c_int, 1);
pub const __MINGW_POISON_NAME = @compileError("unable to translate macro: undefined identifier `_layout_has_not_been_verified_and_its_declaration_is_most_likely_incorrect`");
// C:\Zig\lib\libc\include\any-windows-any/_mingw_mac.h:203:11
pub const __MSABI_LONG = @import("std").zig.c_translation.Macros.L_SUFFIX;
pub const __MINGW_GCC_VERSION = ((__GNUC__ * @as(c_int, 10000)) + (__GNUC_MINOR__ * @as(c_int, 100))) + __GNUC_PATCHLEVEL__;
pub inline fn __MINGW_GNUC_PREREQ(major: anytype, minor: anytype) @TypeOf((__GNUC__ > major) or ((__GNUC__ == major) and (__GNUC_MINOR__ >= minor))) {
    _ = &major;
    _ = &minor;
    return (__GNUC__ > major) or ((__GNUC__ == major) and (__GNUC_MINOR__ >= minor));
}
pub inline fn __MINGW_MSC_PREREQ(major: anytype, minor: anytype) @TypeOf(@as(c_int, 0)) {
    _ = &major;
    _ = &minor;
    return @as(c_int, 0);
}
pub const __MINGW_ATTRIB_DEPRECATED_STR = @compileError("unable to translate C expr: unexpected token ''");
// C:\Zig\lib\libc\include\any-windows-any/_mingw_mac.h:247:11
pub const __MINGW_SEC_WARN_STR = "This function or variable may be unsafe, use _CRT_SECURE_NO_WARNINGS to disable deprecation";
pub const __MINGW_MSVC2005_DEPREC_STR = "This POSIX function is deprecated beginning in Visual C++ 2005, use _CRT_NONSTDC_NO_DEPRECATE to disable deprecation";
pub const __MINGW_ATTRIB_DEPRECATED_MSVC2005 = __MINGW_ATTRIB_DEPRECATED_STR(__MINGW_MSVC2005_DEPREC_STR);
pub const __MINGW_ATTRIB_DEPRECATED_SEC_WARN = __MINGW_ATTRIB_DEPRECATED_STR(__MINGW_SEC_WARN_STR);
pub const __MINGW_MS_PRINTF = @compileError("unable to translate macro: undefined identifier `__format__`");
// C:\Zig\lib\libc\include\any-windows-any/_mingw_mac.h:271:9
pub const __MINGW_MS_SCANF = @compileError("unable to translate macro: undefined identifier `__format__`");
// C:\Zig\lib\libc\include\any-windows-any/_mingw_mac.h:274:9
pub const __MINGW_GNU_PRINTF = @compileError("unable to translate macro: undefined identifier `__format__`");
// C:\Zig\lib\libc\include\any-windows-any/_mingw_mac.h:277:9
pub const __MINGW_GNU_SCANF = @compileError("unable to translate macro: undefined identifier `__format__`");
// C:\Zig\lib\libc\include\any-windows-any/_mingw_mac.h:280:9
pub const __mingw_ovr = @compileError("unable to translate macro: undefined identifier `__unused__`");
// C:\Zig\lib\libc\include\any-windows-any/_mingw_mac.h:301:11
pub const __mingw_attribute_artificial = @compileError("unable to translate macro: undefined identifier `__artificial__`");
// C:\Zig\lib\libc\include\any-windows-any/_mingw_mac.h:308:11
pub const __MINGW_SELECTANY = @compileError("unable to translate macro: undefined identifier `__selectany__`");
// C:\Zig\lib\libc\include\any-windows-any/_mingw_mac.h:314:9
pub const __MINGW_FORTIFY_LEVEL = @as(c_int, 0);
pub const __mingw_bos_ovr = __mingw_ovr;
pub const __MINGW_FORTIFY_VA_ARG = @as(c_int, 0);
pub const _INC_MINGW_SECAPI = "";
pub const _CRT_SECURE_CPP_OVERLOAD_SECURE_NAMES = @as(c_int, 0);
pub const _CRT_SECURE_CPP_OVERLOAD_SECURE_NAMES_MEMORY = @as(c_int, 0);
pub const _CRT_SECURE_CPP_OVERLOAD_STANDARD_NAMES = @as(c_int, 0);
pub const _CRT_SECURE_CPP_OVERLOAD_STANDARD_NAMES_COUNT = @as(c_int, 0);
pub const _CRT_SECURE_CPP_OVERLOAD_STANDARD_NAMES_MEMORY = @as(c_int, 0);
pub const __MINGW_CRT_NAME_CONCAT2 = @compileError("unable to translate macro: undefined identifier `_s`");
// C:\Zig\lib\libc\include\any-windows-any/_mingw_secapi.h:41:9
pub const __CRT_SECURE_CPP_OVERLOAD_STANDARD_NAMES_MEMORY_0_3_ = @compileError("unable to translate C expr: unexpected token ';'");
// C:\Zig\lib\libc\include\any-windows-any/_mingw_secapi.h:69:9
pub const __LONG32 = c_long;
pub const __MINGW_IMPORT = @compileError("unable to translate macro: undefined identifier `__dllimport__`");
// C:\Zig\lib\libc\include\any-windows-any/_mingw.h:44:12
pub const __USE_CRTIMP = @as(c_int, 1);
pub const _CRTIMP = @compileError("unable to translate macro: undefined identifier `__dllimport__`");
// C:\Zig\lib\libc\include\any-windows-any/_mingw.h:52:15
pub const __DECLSPEC_SUPPORTED = "";
pub const USE___UUIDOF = @as(c_int, 0);
pub const _inline = @compileError("unable to translate C expr: unexpected token '__inline'");
// C:\Zig\lib\libc\include\any-windows-any/_mingw.h:74:9
pub const __CRT_INLINE = @compileError("unable to translate macro: undefined identifier `__gnu_inline__`");
// C:\Zig\lib\libc\include\any-windows-any/_mingw.h:83:11
pub const __MINGW_INTRIN_INLINE = @compileError("unable to translate macro: undefined identifier `__always_inline__`");
// C:\Zig\lib\libc\include\any-windows-any/_mingw.h:90:9
pub const __CRT__NO_INLINE = @as(c_int, 1);
pub const __MINGW_CXX11_CONSTEXPR = "";
pub const __MINGW_CXX14_CONSTEXPR = "";
pub const __UNUSED_PARAM = @compileError("unable to translate macro: undefined identifier `__unused__`");
// C:\Zig\lib\libc\include\any-windows-any/_mingw.h:118:11
pub const __restrict_arr = @compileError("unable to translate C expr: unexpected token '__restrict'");
// C:\Zig\lib\libc\include\any-windows-any/_mingw.h:133:10
pub const __MINGW_ATTRIB_NORETURN = @compileError("unable to translate macro: undefined identifier `__noreturn__`");
// C:\Zig\lib\libc\include\any-windows-any/_mingw.h:149:9
pub const __MINGW_ATTRIB_CONST = @compileError("unable to translate C expr: unexpected token '__attribute__'");
// C:\Zig\lib\libc\include\any-windows-any/_mingw.h:150:9
pub const __MINGW_ATTRIB_MALLOC = @compileError("unable to translate macro: undefined identifier `__malloc__`");
// C:\Zig\lib\libc\include\any-windows-any/_mingw.h:160:9
pub const __MINGW_ATTRIB_PURE = @compileError("unable to translate macro: undefined identifier `__pure__`");
// C:\Zig\lib\libc\include\any-windows-any/_mingw.h:161:9
pub const __MINGW_ATTRIB_NONNULL = @compileError("unable to translate macro: undefined identifier `__nonnull__`");
// C:\Zig\lib\libc\include\any-windows-any/_mingw.h:174:9
pub const __MINGW_ATTRIB_UNUSED = @compileError("unable to translate macro: undefined identifier `__unused__`");
// C:\Zig\lib\libc\include\any-windows-any/_mingw.h:180:9
pub const __MINGW_ATTRIB_USED = @compileError("unable to translate macro: undefined identifier `__used__`");
// C:\Zig\lib\libc\include\any-windows-any/_mingw.h:186:9
pub const __MINGW_ATTRIB_DEPRECATED = @compileError("unable to translate macro: undefined identifier `__deprecated__`");
// C:\Zig\lib\libc\include\any-windows-any/_mingw.h:187:9
pub const __MINGW_ATTRIB_DEPRECATED_MSG = @compileError("unable to translate macro: undefined identifier `__deprecated__`");
// C:\Zig\lib\libc\include\any-windows-any/_mingw.h:189:9
pub const __MINGW_NOTHROW = @compileError("unable to translate macro: undefined identifier `__nothrow__`");
// C:\Zig\lib\libc\include\any-windows-any/_mingw.h:204:9
pub const __MINGW_ATTRIB_NO_OPTIMIZE = "";
pub const __MINGW_PRAGMA_PARAM = @compileError("unable to translate C expr: unexpected token ''");
// C:\Zig\lib\libc\include\any-windows-any/_mingw.h:222:9
pub const __MINGW_BROKEN_INTERFACE = @compileError("unable to translate macro: undefined identifier `message`");
// C:\Zig\lib\libc\include\any-windows-any/_mingw.h:225:9
pub const _UCRT = "";
pub const _INT128_DEFINED = "";
pub const __int8 = u8;
pub const __int16 = c_short;
pub const __int32 = c_int;
pub const __int64 = c_longlong;
pub const __ptr32 = "";
pub const __ptr64 = "";
pub const __unaligned = "";
pub const __w64 = "";
pub const __forceinline = @compileError("unable to translate macro: undefined identifier `__always_inline__`");
// C:\Zig\lib\libc\include\any-windows-any/_mingw.h:280:9
pub const __nothrow = "";
pub const _INC_VADEFS = "";
pub const MINGW_SDK_INIT = "";
pub const MINGW_HAS_SECURE_API = @as(c_int, 1);
pub const __STDC_SECURE_LIB__ = @as(c_long, 200411);
pub const __GOT_SECURE_LIB__ = __STDC_SECURE_LIB__;
pub const MINGW_DDK_H = "";
pub const MINGW_HAS_DDK_H = @as(c_int, 1);
pub const _CRT_PACKING = @as(c_int, 8);
pub const __GNUC_VA_LIST = "";
pub const _VA_LIST_DEFINED = "";
pub inline fn _ADDRESSOF(v: anytype) @TypeOf(&v) {
    _ = &v;
    return &v;
}
pub const _crt_va_start = @compileError("unable to translate macro: undefined identifier `__builtin_va_start`");
// C:\Zig\lib\libc\include\any-windows-any/vadefs.h:48:9
pub const _crt_va_arg = @compileError("unable to translate C expr: unexpected token 'an identifier'");
// C:\Zig\lib\libc\include\any-windows-any/vadefs.h:49:9
pub const _crt_va_end = @compileError("unable to translate macro: undefined identifier `__builtin_va_end`");
// C:\Zig\lib\libc\include\any-windows-any/vadefs.h:50:9
pub const _crt_va_copy = @compileError("unable to translate macro: undefined identifier `__builtin_va_copy`");
// C:\Zig\lib\libc\include\any-windows-any/vadefs.h:51:9
pub const __CRT_STRINGIZE = @compileError("unable to translate C expr: unexpected token '#'");
// C:\Zig\lib\libc\include\any-windows-any/_mingw.h:299:9
pub inline fn _CRT_STRINGIZE(_Value: anytype) @TypeOf(__CRT_STRINGIZE(_Value)) {
    _ = &_Value;
    return __CRT_STRINGIZE(_Value);
}
pub const __CRT_WIDE = @compileError("unable to translate macro: undefined identifier `L`");
// C:\Zig\lib\libc\include\any-windows-any/_mingw.h:304:9
pub inline fn _CRT_WIDE(_String: anytype) @TypeOf(__CRT_WIDE(_String)) {
    _ = &_String;
    return __CRT_WIDE(_String);
}
pub const _W64 = "";
pub const _CRTIMP_NOIA64 = _CRTIMP;
pub const _CRTIMP2 = _CRTIMP;
pub const _CRTIMP_ALTERNATIVE = _CRTIMP;
pub const _CRT_ALTERNATIVE_IMPORTED = "";
pub const _MRTIMP2 = _CRTIMP;
pub const _DLL = "";
pub const _MT = "";
pub const _MCRTIMP = _CRTIMP;
pub const _CRTIMP_PURE = _CRTIMP;
pub const _PGLOBAL = "";
pub const _AGLOBAL = "";
pub const _SECURECRT_FILL_BUFFER_PATTERN = @as(c_int, 0xFD);
pub const _CRT_DEPRECATE_TEXT = @compileError("unable to translate macro: undefined identifier `deprecated`");
// C:\Zig\lib\libc\include\any-windows-any/_mingw.h:363:9
pub const _CRT_INSECURE_DEPRECATE_MEMORY = @compileError("unable to translate C expr: unexpected token ''");
// C:\Zig\lib\libc\include\any-windows-any/_mingw.h:366:9
pub const _CRT_INSECURE_DEPRECATE_GLOBALS = @compileError("unable to translate C expr: unexpected token ''");
// C:\Zig\lib\libc\include\any-windows-any/_mingw.h:370:9
pub const _CRT_MANAGED_HEAP_DEPRECATE = "";
pub const _CRT_OBSOLETE = @compileError("unable to translate C expr: unexpected token ''");
// C:\Zig\lib\libc\include\any-windows-any/_mingw.h:378:9
pub const _CONST_RETURN = "";
pub const UNALIGNED = "";
pub const _CRT_ALIGN = @compileError("unable to translate macro: undefined identifier `__aligned__`");
// C:\Zig\lib\libc\include\any-windows-any/_mingw.h:405:9
pub const __CRTDECL = __cdecl;
pub const _ARGMAX = @as(c_int, 100);
pub const _TRUNCATE = @import("std").zig.c_translation.cast(usize, -@as(c_int, 1));
pub inline fn _CRT_UNUSED(x: anytype) anyopaque {
    _ = &x;
    return @import("std").zig.c_translation.cast(anyopaque, x);
}
pub const __USE_MINGW_ANSI_STDIO = @as(c_int, 0);
pub const _CRT_glob = @compileError("unable to translate macro: undefined identifier `_dowildcard`");
// C:\Zig\lib\libc\include\any-windows-any/_mingw.h:469:9
pub const __ANONYMOUS_DEFINED = "";
pub const _ANONYMOUS_UNION = __MINGW_EXTENSION;
pub const _ANONYMOUS_STRUCT = __MINGW_EXTENSION;
pub const _UNION_NAME = @compileError("unable to translate C expr: unexpected token ''");
// C:\Zig\lib\libc\include\any-windows-any/_mingw.h:489:9
pub const _STRUCT_NAME = @compileError("unable to translate C expr: unexpected token ''");
// C:\Zig\lib\libc\include\any-windows-any/_mingw.h:490:9
pub const DUMMYUNIONNAME = "";
pub const DUMMYUNIONNAME1 = "";
pub const DUMMYUNIONNAME2 = "";
pub const DUMMYUNIONNAME3 = "";
pub const DUMMYUNIONNAME4 = "";
pub const DUMMYUNIONNAME5 = "";
pub const DUMMYUNIONNAME6 = "";
pub const DUMMYUNIONNAME7 = "";
pub const DUMMYUNIONNAME8 = "";
pub const DUMMYUNIONNAME9 = "";
pub const DUMMYSTRUCTNAME = "";
pub const DUMMYSTRUCTNAME1 = "";
pub const DUMMYSTRUCTNAME2 = "";
pub const DUMMYSTRUCTNAME3 = "";
pub const DUMMYSTRUCTNAME4 = "";
pub const DUMMYSTRUCTNAME5 = "";
pub const __CRT_UUID_DECL = @compileError("unable to translate C expr: unexpected token ''");
// C:\Zig\lib\libc\include\any-windows-any/_mingw.h:577:9
pub const __MINGW_DEBUGBREAK_IMPL = !(__has_builtin(__debugbreak) != 0);
pub const __MINGW_FASTFAIL_IMPL = !(__has_builtin(__fastfail) != 0);
pub const __MINGW_PREFETCH_IMPL = @compileError("unable to translate macro: undefined identifier `__prefetch`");
// C:\Zig\lib\libc\include\any-windows-any/_mingw.h:634:9
pub const _CRTNOALIAS = "";
pub const _CRTRESTRICT = "";
pub const _SIZE_T_DEFINED = "";
pub const _SSIZE_T_DEFINED = "";
pub const _RSIZE_T_DEFINED = "";
pub const _INTPTR_T_DEFINED = "";
pub const __intptr_t_defined = "";
pub const _UINTPTR_T_DEFINED = "";
pub const __uintptr_t_defined = "";
pub const _PTRDIFF_T_DEFINED = "";
pub const _PTRDIFF_T_ = "";
pub const _WCHAR_T_DEFINED = "";
pub const _WCTYPE_T_DEFINED = "";
pub const _WINT_T = "";
pub const _ERRCODE_DEFINED = "";
pub const _TIME32_T_DEFINED = "";
pub const _TIME64_T_DEFINED = "";
pub const _TIME_T_DEFINED = "";
pub const _CRT_SECURE_CPP_NOTHROW = @compileError("unable to translate macro: undefined identifier `throw`");
// C:\Zig\lib\libc\include\any-windows-any/corecrt.h:143:9
pub const __DEFINE_CPP_OVERLOAD_SECURE_FUNC_0_0 = @compileError("unable to translate C expr: unexpected token ''");
// C:\Zig\lib\libc\include\any-windows-any/corecrt.h:262:9
pub const __DEFINE_CPP_OVERLOAD_SECURE_FUNC_0_1 = @compileError("unable to translate C expr: unexpected token ''");
// C:\Zig\lib\libc\include\any-windows-any/corecrt.h:263:9
pub const __DEFINE_CPP_OVERLOAD_SECURE_FUNC_0_2 = @compileError("unable to translate C expr: unexpected token ''");
// C:\Zig\lib\libc\include\any-windows-any/corecrt.h:264:9
pub const __DEFINE_CPP_OVERLOAD_SECURE_FUNC_0_3 = @compileError("unable to translate C expr: unexpected token ''");
// C:\Zig\lib\libc\include\any-windows-any/corecrt.h:265:9
pub const __DEFINE_CPP_OVERLOAD_SECURE_FUNC_0_4 = @compileError("unable to translate C expr: unexpected token ''");
// C:\Zig\lib\libc\include\any-windows-any/corecrt.h:266:9
pub const __DEFINE_CPP_OVERLOAD_SECURE_FUNC_1_1 = @compileError("unable to translate C expr: unexpected token ''");
// C:\Zig\lib\libc\include\any-windows-any/corecrt.h:267:9
pub const __DEFINE_CPP_OVERLOAD_SECURE_FUNC_1_2 = @compileError("unable to translate C expr: unexpected token ''");
// C:\Zig\lib\libc\include\any-windows-any/corecrt.h:268:9
pub const __DEFINE_CPP_OVERLOAD_SECURE_FUNC_1_3 = @compileError("unable to translate C expr: unexpected token ''");
// C:\Zig\lib\libc\include\any-windows-any/corecrt.h:269:9
pub const __DEFINE_CPP_OVERLOAD_SECURE_FUNC_2_0 = @compileError("unable to translate C expr: unexpected token ''");
// C:\Zig\lib\libc\include\any-windows-any/corecrt.h:270:9
pub const __DEFINE_CPP_OVERLOAD_SECURE_FUNC_0_1_ARGLIST = @compileError("unable to translate C expr: unexpected token ''");
// C:\Zig\lib\libc\include\any-windows-any/corecrt.h:271:9
pub const __DEFINE_CPP_OVERLOAD_SECURE_FUNC_0_2_ARGLIST = @compileError("unable to translate C expr: unexpected token ''");
// C:\Zig\lib\libc\include\any-windows-any/corecrt.h:272:9
pub const __DEFINE_CPP_OVERLOAD_SECURE_FUNC_SPLITPATH = @compileError("unable to translate C expr: unexpected token ''");
// C:\Zig\lib\libc\include\any-windows-any/corecrt.h:273:9
pub const __DEFINE_CPP_OVERLOAD_STANDARD_FUNC_0_0 = @compileError("unable to translate macro: undefined identifier `__func_name`");
// C:\Zig\lib\libc\include\any-windows-any/corecrt.h:277:9
pub const __DEFINE_CPP_OVERLOAD_STANDARD_FUNC_0_1 = @compileError("unable to translate macro: undefined identifier `__func_name`");
// C:\Zig\lib\libc\include\any-windows-any/corecrt.h:279:9
pub const __DEFINE_CPP_OVERLOAD_STANDARD_FUNC_0_2 = @compileError("unable to translate macro: undefined identifier `__func_name`");
// C:\Zig\lib\libc\include\any-windows-any/corecrt.h:281:9
pub const __DEFINE_CPP_OVERLOAD_STANDARD_FUNC_0_3 = @compileError("unable to translate macro: undefined identifier `__func_name`");
// C:\Zig\lib\libc\include\any-windows-any/corecrt.h:283:9
pub const __DEFINE_CPP_OVERLOAD_STANDARD_FUNC_0_4 = @compileError("unable to translate macro: undefined identifier `__func_name`");
// C:\Zig\lib\libc\include\any-windows-any/corecrt.h:285:9
pub const __DEFINE_CPP_OVERLOAD_STANDARD_FUNC_0_0_EX = @compileError("unable to translate C expr: unexpected token ''");
// C:\Zig\lib\libc\include\any-windows-any/corecrt.h:422:9
pub const __DEFINE_CPP_OVERLOAD_STANDARD_FUNC_0_1_EX = @compileError("unable to translate C expr: unexpected token ''");
// C:\Zig\lib\libc\include\any-windows-any/corecrt.h:423:9
pub const __DEFINE_CPP_OVERLOAD_STANDARD_FUNC_0_2_EX = @compileError("unable to translate C expr: unexpected token ''");
// C:\Zig\lib\libc\include\any-windows-any/corecrt.h:424:9
pub const __DEFINE_CPP_OVERLOAD_STANDARD_FUNC_0_3_EX = @compileError("unable to translate C expr: unexpected token ''");
// C:\Zig\lib\libc\include\any-windows-any/corecrt.h:425:9
pub const __DEFINE_CPP_OVERLOAD_STANDARD_FUNC_0_4_EX = @compileError("unable to translate C expr: unexpected token ''");
// C:\Zig\lib\libc\include\any-windows-any/corecrt.h:426:9
pub const _TAGLC_ID_DEFINED = "";
pub const _THREADLOCALEINFO = "";
pub const __crt_typefix = @compileError("unable to translate C expr: unexpected token ''");
// C:\Zig\lib\libc\include\any-windows-any/corecrt.h:486:9
pub const _CRT_USE_WINAPI_FAMILY_DESKTOP_APP = "";
pub const __need_wint_t = "";
pub const __need_wchar_t = "";
pub const _WCHAR_T = "";
pub const INT8_MIN = -@as(c_int, 128);
pub const INT16_MIN = -@import("std").zig.c_translation.promoteIntLiteral(c_int, 32768, .decimal);
pub const INT32_MIN = -@import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal) - @as(c_int, 1);
pub const INT64_MIN = -@as(c_longlong, 9223372036854775807) - @as(c_int, 1);
pub const INT8_MAX = @as(c_int, 127);
pub const INT16_MAX = @as(c_int, 32767);
pub const INT32_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const INT64_MAX = @as(c_longlong, 9223372036854775807);
pub const UINT8_MAX = @as(c_int, 255);
pub const UINT16_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_int, 65535, .decimal);
pub const UINT32_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_uint, 0xffffffff, .hex);
pub const UINT64_MAX = @as(c_ulonglong, 0xffffffffffffffff);
pub const INT_LEAST8_MIN = INT8_MIN;
pub const INT_LEAST16_MIN = INT16_MIN;
pub const INT_LEAST32_MIN = INT32_MIN;
pub const INT_LEAST64_MIN = INT64_MIN;
pub const INT_LEAST8_MAX = INT8_MAX;
pub const INT_LEAST16_MAX = INT16_MAX;
pub const INT_LEAST32_MAX = INT32_MAX;
pub const INT_LEAST64_MAX = INT64_MAX;
pub const UINT_LEAST8_MAX = UINT8_MAX;
pub const UINT_LEAST16_MAX = UINT16_MAX;
pub const UINT_LEAST32_MAX = UINT32_MAX;
pub const UINT_LEAST64_MAX = UINT64_MAX;
pub const INT_FAST8_MIN = INT8_MIN;
pub const INT_FAST16_MIN = INT16_MIN;
pub const INT_FAST32_MIN = INT32_MIN;
pub const INT_FAST64_MIN = INT64_MIN;
pub const INT_FAST8_MAX = INT8_MAX;
pub const INT_FAST16_MAX = INT16_MAX;
pub const INT_FAST32_MAX = INT32_MAX;
pub const INT_FAST64_MAX = INT64_MAX;
pub const UINT_FAST8_MAX = UINT8_MAX;
pub const UINT_FAST16_MAX = UINT16_MAX;
pub const UINT_FAST32_MAX = UINT32_MAX;
pub const UINT_FAST64_MAX = UINT64_MAX;
pub const INTPTR_MIN = INT64_MIN;
pub const INTPTR_MAX = INT64_MAX;
pub const UINTPTR_MAX = UINT64_MAX;
pub const INTMAX_MIN = INT64_MIN;
pub const INTMAX_MAX = INT64_MAX;
pub const UINTMAX_MAX = UINT64_MAX;
pub const PTRDIFF_MIN = INT64_MIN;
pub const PTRDIFF_MAX = INT64_MAX;
pub const SIG_ATOMIC_MIN = INT32_MIN;
pub const SIG_ATOMIC_MAX = INT32_MAX;
pub const SIZE_MAX = UINT64_MAX;
pub const WCHAR_MIN = @as(c_uint, 0);
pub const WCHAR_MAX = @as(c_uint, 0xffff);
pub const WINT_MIN = @as(c_uint, 0);
pub const WINT_MAX = @as(c_uint, 0xffff);
pub inline fn INT8_C(val: anytype) @TypeOf((INT_LEAST8_MAX - INT_LEAST8_MAX) + val) {
    _ = &val;
    return (INT_LEAST8_MAX - INT_LEAST8_MAX) + val;
}
pub inline fn INT16_C(val: anytype) @TypeOf((INT_LEAST16_MAX - INT_LEAST16_MAX) + val) {
    _ = &val;
    return (INT_LEAST16_MAX - INT_LEAST16_MAX) + val;
}
pub inline fn INT32_C(val: anytype) @TypeOf((INT_LEAST32_MAX - INT_LEAST32_MAX) + val) {
    _ = &val;
    return (INT_LEAST32_MAX - INT_LEAST32_MAX) + val;
}
pub const INT64_C = @import("std").zig.c_translation.Macros.LL_SUFFIX;
pub inline fn UINT8_C(val: anytype) @TypeOf(val) {
    _ = &val;
    return val;
}
pub inline fn UINT16_C(val: anytype) @TypeOf(val) {
    _ = &val;
    return val;
}
pub const UINT32_C = @import("std").zig.c_translation.Macros.U_SUFFIX;
pub const UINT64_C = @import("std").zig.c_translation.Macros.ULL_SUFFIX;
pub const INTMAX_C = @import("std").zig.c_translation.Macros.LL_SUFFIX;
pub const UINTMAX_C = @import("std").zig.c_translation.Macros.ULL_SUFFIX;
pub const KHRONOS_SUPPORT_INT64 = @as(c_int, 1);
pub const KHRONOS_SUPPORT_FLOAT = @as(c_int, 1);
pub const KHRONOS_USE_INTPTR_T = "";
pub const KHRONOS_MAX_ENUM = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x7FFFFFFF, .hex);
pub const GL_DEPTH_BUFFER_BIT = @as(c_int, 0x00000100);
pub const GL_STENCIL_BUFFER_BIT = @as(c_int, 0x00000400);
pub const GL_COLOR_BUFFER_BIT = @as(c_int, 0x00004000);
pub const GL_FALSE = @as(c_int, 0);
pub const GL_TRUE = @as(c_int, 1);
pub const GL_POINTS = @as(c_int, 0x0000);
pub const GL_LINES = @as(c_int, 0x0001);
pub const GL_LINE_LOOP = @as(c_int, 0x0002);
pub const GL_LINE_STRIP = @as(c_int, 0x0003);
pub const GL_TRIANGLES = @as(c_int, 0x0004);
pub const GL_TRIANGLE_STRIP = @as(c_int, 0x0005);
pub const GL_TRIANGLE_FAN = @as(c_int, 0x0006);
pub const GL_NEVER = @as(c_int, 0x0200);
pub const GL_LESS = @as(c_int, 0x0201);
pub const GL_EQUAL = @as(c_int, 0x0202);
pub const GL_LEQUAL = @as(c_int, 0x0203);
pub const GL_GREATER = @as(c_int, 0x0204);
pub const GL_NOTEQUAL = @as(c_int, 0x0205);
pub const GL_GEQUAL = @as(c_int, 0x0206);
pub const GL_ALWAYS = @as(c_int, 0x0207);
pub const GL_ZERO = @as(c_int, 0);
pub const GL_ONE = @as(c_int, 1);
pub const GL_SRC_COLOR = @as(c_int, 0x0300);
pub const GL_ONE_MINUS_SRC_COLOR = @as(c_int, 0x0301);
pub const GL_SRC_ALPHA = @as(c_int, 0x0302);
pub const GL_ONE_MINUS_SRC_ALPHA = @as(c_int, 0x0303);
pub const GL_DST_ALPHA = @as(c_int, 0x0304);
pub const GL_ONE_MINUS_DST_ALPHA = @as(c_int, 0x0305);
pub const GL_DST_COLOR = @as(c_int, 0x0306);
pub const GL_ONE_MINUS_DST_COLOR = @as(c_int, 0x0307);
pub const GL_SRC_ALPHA_SATURATE = @as(c_int, 0x0308);
pub const GL_NONE = @as(c_int, 0);
pub const GL_FRONT_LEFT = @as(c_int, 0x0400);
pub const GL_FRONT_RIGHT = @as(c_int, 0x0401);
pub const GL_BACK_LEFT = @as(c_int, 0x0402);
pub const GL_BACK_RIGHT = @as(c_int, 0x0403);
pub const GL_FRONT = @as(c_int, 0x0404);
pub const GL_BACK = @as(c_int, 0x0405);
pub const GL_LEFT = @as(c_int, 0x0406);
pub const GL_RIGHT = @as(c_int, 0x0407);
pub const GL_FRONT_AND_BACK = @as(c_int, 0x0408);
pub const GL_NO_ERROR = @as(c_int, 0);
pub const GL_INVALID_ENUM = @as(c_int, 0x0500);
pub const GL_INVALID_VALUE = @as(c_int, 0x0501);
pub const GL_INVALID_OPERATION = @as(c_int, 0x0502);
pub const GL_OUT_OF_MEMORY = @as(c_int, 0x0505);
pub const GL_CW = @as(c_int, 0x0900);
pub const GL_CCW = @as(c_int, 0x0901);
pub const GL_POINT_SIZE = @as(c_int, 0x0B11);
pub const GL_POINT_SIZE_RANGE = @as(c_int, 0x0B12);
pub const GL_POINT_SIZE_GRANULARITY = @as(c_int, 0x0B13);
pub const GL_LINE_SMOOTH = @as(c_int, 0x0B20);
pub const GL_LINE_WIDTH = @as(c_int, 0x0B21);
pub const GL_LINE_WIDTH_RANGE = @as(c_int, 0x0B22);
pub const GL_LINE_WIDTH_GRANULARITY = @as(c_int, 0x0B23);
pub const GL_POLYGON_MODE = @as(c_int, 0x0B40);
pub const GL_POLYGON_SMOOTH = @as(c_int, 0x0B41);
pub const GL_CULL_FACE = @as(c_int, 0x0B44);
pub const GL_CULL_FACE_MODE = @as(c_int, 0x0B45);
pub const GL_FRONT_FACE = @as(c_int, 0x0B46);
pub const GL_DEPTH_RANGE = @as(c_int, 0x0B70);
pub const GL_DEPTH_TEST = @as(c_int, 0x0B71);
pub const GL_DEPTH_WRITEMASK = @as(c_int, 0x0B72);
pub const GL_DEPTH_CLEAR_VALUE = @as(c_int, 0x0B73);
pub const GL_DEPTH_FUNC = @as(c_int, 0x0B74);
pub const GL_STENCIL_TEST = @as(c_int, 0x0B90);
pub const GL_STENCIL_CLEAR_VALUE = @as(c_int, 0x0B91);
pub const GL_STENCIL_FUNC = @as(c_int, 0x0B92);
pub const GL_STENCIL_VALUE_MASK = @as(c_int, 0x0B93);
pub const GL_STENCIL_FAIL = @as(c_int, 0x0B94);
pub const GL_STENCIL_PASS_DEPTH_FAIL = @as(c_int, 0x0B95);
pub const GL_STENCIL_PASS_DEPTH_PASS = @as(c_int, 0x0B96);
pub const GL_STENCIL_REF = @as(c_int, 0x0B97);
pub const GL_STENCIL_WRITEMASK = @as(c_int, 0x0B98);
pub const GL_VIEWPORT = @as(c_int, 0x0BA2);
pub const GL_DITHER = @as(c_int, 0x0BD0);
pub const GL_BLEND_DST = @as(c_int, 0x0BE0);
pub const GL_BLEND_SRC = @as(c_int, 0x0BE1);
pub const GL_BLEND = @as(c_int, 0x0BE2);
pub const GL_LOGIC_OP_MODE = @as(c_int, 0x0BF0);
pub const GL_DRAW_BUFFER = @as(c_int, 0x0C01);
pub const GL_READ_BUFFER = @as(c_int, 0x0C02);
pub const GL_SCISSOR_BOX = @as(c_int, 0x0C10);
pub const GL_SCISSOR_TEST = @as(c_int, 0x0C11);
pub const GL_COLOR_CLEAR_VALUE = @as(c_int, 0x0C22);
pub const GL_COLOR_WRITEMASK = @as(c_int, 0x0C23);
pub const GL_DOUBLEBUFFER = @as(c_int, 0x0C32);
pub const GL_STEREO = @as(c_int, 0x0C33);
pub const GL_LINE_SMOOTH_HINT = @as(c_int, 0x0C52);
pub const GL_POLYGON_SMOOTH_HINT = @as(c_int, 0x0C53);
pub const GL_UNPACK_SWAP_BYTES = @as(c_int, 0x0CF0);
pub const GL_UNPACK_LSB_FIRST = @as(c_int, 0x0CF1);
pub const GL_UNPACK_ROW_LENGTH = @as(c_int, 0x0CF2);
pub const GL_UNPACK_SKIP_ROWS = @as(c_int, 0x0CF3);
pub const GL_UNPACK_SKIP_PIXELS = @as(c_int, 0x0CF4);
pub const GL_UNPACK_ALIGNMENT = @as(c_int, 0x0CF5);
pub const GL_PACK_SWAP_BYTES = @as(c_int, 0x0D00);
pub const GL_PACK_LSB_FIRST = @as(c_int, 0x0D01);
pub const GL_PACK_ROW_LENGTH = @as(c_int, 0x0D02);
pub const GL_PACK_SKIP_ROWS = @as(c_int, 0x0D03);
pub const GL_PACK_SKIP_PIXELS = @as(c_int, 0x0D04);
pub const GL_PACK_ALIGNMENT = @as(c_int, 0x0D05);
pub const GL_MAX_TEXTURE_SIZE = @as(c_int, 0x0D33);
pub const GL_MAX_VIEWPORT_DIMS = @as(c_int, 0x0D3A);
pub const GL_SUBPIXEL_BITS = @as(c_int, 0x0D50);
pub const GL_TEXTURE_1D = @as(c_int, 0x0DE0);
pub const GL_TEXTURE_2D = @as(c_int, 0x0DE1);
pub const GL_TEXTURE_WIDTH = @as(c_int, 0x1000);
pub const GL_TEXTURE_HEIGHT = @as(c_int, 0x1001);
pub const GL_TEXTURE_BORDER_COLOR = @as(c_int, 0x1004);
pub const GL_DONT_CARE = @as(c_int, 0x1100);
pub const GL_FASTEST = @as(c_int, 0x1101);
pub const GL_NICEST = @as(c_int, 0x1102);
pub const GL_BYTE = @as(c_int, 0x1400);
pub const GL_UNSIGNED_BYTE = @as(c_int, 0x1401);
pub const GL_SHORT = @as(c_int, 0x1402);
pub const GL_UNSIGNED_SHORT = @as(c_int, 0x1403);
pub const GL_INT = @as(c_int, 0x1404);
pub const GL_UNSIGNED_INT = @as(c_int, 0x1405);
pub const GL_FLOAT = @as(c_int, 0x1406);
pub const GL_CLEAR = @as(c_int, 0x1500);
pub const GL_AND = @as(c_int, 0x1501);
pub const GL_AND_REVERSE = @as(c_int, 0x1502);
pub const GL_COPY = @as(c_int, 0x1503);
pub const GL_AND_INVERTED = @as(c_int, 0x1504);
pub const GL_NOOP = @as(c_int, 0x1505);
pub const GL_XOR = @as(c_int, 0x1506);
pub const GL_OR = @as(c_int, 0x1507);
pub const GL_NOR = @as(c_int, 0x1508);
pub const GL_EQUIV = @as(c_int, 0x1509);
pub const GL_INVERT = @as(c_int, 0x150A);
pub const GL_OR_REVERSE = @as(c_int, 0x150B);
pub const GL_COPY_INVERTED = @as(c_int, 0x150C);
pub const GL_OR_INVERTED = @as(c_int, 0x150D);
pub const GL_NAND = @as(c_int, 0x150E);
pub const GL_SET = @as(c_int, 0x150F);
pub const GL_TEXTURE = @as(c_int, 0x1702);
pub const GL_COLOR = @as(c_int, 0x1800);
pub const GL_DEPTH = @as(c_int, 0x1801);
pub const GL_STENCIL = @as(c_int, 0x1802);
pub const GL_STENCIL_INDEX = @as(c_int, 0x1901);
pub const GL_DEPTH_COMPONENT = @as(c_int, 0x1902);
pub const GL_RED = @as(c_int, 0x1903);
pub const GL_GREEN = @as(c_int, 0x1904);
pub const GL_BLUE = @as(c_int, 0x1905);
pub const GL_ALPHA = @as(c_int, 0x1906);
pub const GL_RGB = @as(c_int, 0x1907);
pub const GL_RGBA = @as(c_int, 0x1908);
pub const GL_POINT = @as(c_int, 0x1B00);
pub const GL_LINE = @as(c_int, 0x1B01);
pub const GL_FILL = @as(c_int, 0x1B02);
pub const GL_KEEP = @as(c_int, 0x1E00);
pub const GL_REPLACE = @as(c_int, 0x1E01);
pub const GL_INCR = @as(c_int, 0x1E02);
pub const GL_DECR = @as(c_int, 0x1E03);
pub const GL_VENDOR = @as(c_int, 0x1F00);
pub const GL_RENDERER = @as(c_int, 0x1F01);
pub const GL_VERSION = @as(c_int, 0x1F02);
pub const GL_EXTENSIONS = @as(c_int, 0x1F03);
pub const GL_NEAREST = @as(c_int, 0x2600);
pub const GL_LINEAR = @as(c_int, 0x2601);
pub const GL_NEAREST_MIPMAP_NEAREST = @as(c_int, 0x2700);
pub const GL_LINEAR_MIPMAP_NEAREST = @as(c_int, 0x2701);
pub const GL_NEAREST_MIPMAP_LINEAR = @as(c_int, 0x2702);
pub const GL_LINEAR_MIPMAP_LINEAR = @as(c_int, 0x2703);
pub const GL_TEXTURE_MAG_FILTER = @as(c_int, 0x2800);
pub const GL_TEXTURE_MIN_FILTER = @as(c_int, 0x2801);
pub const GL_TEXTURE_WRAP_S = @as(c_int, 0x2802);
pub const GL_TEXTURE_WRAP_T = @as(c_int, 0x2803);
pub const GL_REPEAT = @as(c_int, 0x2901);
pub const GL_COLOR_LOGIC_OP = @as(c_int, 0x0BF2);
pub const GL_POLYGON_OFFSET_UNITS = @as(c_int, 0x2A00);
pub const GL_POLYGON_OFFSET_POINT = @as(c_int, 0x2A01);
pub const GL_POLYGON_OFFSET_LINE = @as(c_int, 0x2A02);
pub const GL_POLYGON_OFFSET_FILL = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8037, .hex);
pub const GL_POLYGON_OFFSET_FACTOR = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8038, .hex);
pub const GL_TEXTURE_BINDING_1D = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8068, .hex);
pub const GL_TEXTURE_BINDING_2D = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8069, .hex);
pub const GL_TEXTURE_INTERNAL_FORMAT = @as(c_int, 0x1003);
pub const GL_TEXTURE_RED_SIZE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x805C, .hex);
pub const GL_TEXTURE_GREEN_SIZE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x805D, .hex);
pub const GL_TEXTURE_BLUE_SIZE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x805E, .hex);
pub const GL_TEXTURE_ALPHA_SIZE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x805F, .hex);
pub const GL_DOUBLE = @as(c_int, 0x140A);
pub const GL_PROXY_TEXTURE_1D = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8063, .hex);
pub const GL_PROXY_TEXTURE_2D = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8064, .hex);
pub const GL_R3_G3_B2 = @as(c_int, 0x2A10);
pub const GL_RGB4 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x804F, .hex);
pub const GL_RGB5 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8050, .hex);
pub const GL_RGB8 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8051, .hex);
pub const GL_RGB10 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8052, .hex);
pub const GL_RGB12 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8053, .hex);
pub const GL_RGB16 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8054, .hex);
pub const GL_RGBA2 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8055, .hex);
pub const GL_RGBA4 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8056, .hex);
pub const GL_RGB5_A1 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8057, .hex);
pub const GL_RGBA8 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8058, .hex);
pub const GL_RGB10_A2 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8059, .hex);
pub const GL_RGBA12 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x805A, .hex);
pub const GL_RGBA16 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x805B, .hex);
pub const GL_UNSIGNED_BYTE_3_3_2 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8032, .hex);
pub const GL_UNSIGNED_SHORT_4_4_4_4 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8033, .hex);
pub const GL_UNSIGNED_SHORT_5_5_5_1 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8034, .hex);
pub const GL_UNSIGNED_INT_8_8_8_8 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8035, .hex);
pub const GL_UNSIGNED_INT_10_10_10_2 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8036, .hex);
pub const GL_TEXTURE_BINDING_3D = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x806A, .hex);
pub const GL_PACK_SKIP_IMAGES = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x806B, .hex);
pub const GL_PACK_IMAGE_HEIGHT = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x806C, .hex);
pub const GL_UNPACK_SKIP_IMAGES = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x806D, .hex);
pub const GL_UNPACK_IMAGE_HEIGHT = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x806E, .hex);
pub const GL_TEXTURE_3D = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x806F, .hex);
pub const GL_PROXY_TEXTURE_3D = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8070, .hex);
pub const GL_TEXTURE_DEPTH = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8071, .hex);
pub const GL_TEXTURE_WRAP_R = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8072, .hex);
pub const GL_MAX_3D_TEXTURE_SIZE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8073, .hex);
pub const GL_UNSIGNED_BYTE_2_3_3_REV = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8362, .hex);
pub const GL_UNSIGNED_SHORT_5_6_5 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8363, .hex);
pub const GL_UNSIGNED_SHORT_5_6_5_REV = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8364, .hex);
pub const GL_UNSIGNED_SHORT_4_4_4_4_REV = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8365, .hex);
pub const GL_UNSIGNED_SHORT_1_5_5_5_REV = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8366, .hex);
pub const GL_UNSIGNED_INT_8_8_8_8_REV = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8367, .hex);
pub const GL_UNSIGNED_INT_2_10_10_10_REV = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8368, .hex);
pub const GL_BGR = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x80E0, .hex);
pub const GL_BGRA = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x80E1, .hex);
pub const GL_MAX_ELEMENTS_VERTICES = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x80E8, .hex);
pub const GL_MAX_ELEMENTS_INDICES = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x80E9, .hex);
pub const GL_CLAMP_TO_EDGE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x812F, .hex);
pub const GL_TEXTURE_MIN_LOD = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x813A, .hex);
pub const GL_TEXTURE_MAX_LOD = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x813B, .hex);
pub const GL_TEXTURE_BASE_LEVEL = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x813C, .hex);
pub const GL_TEXTURE_MAX_LEVEL = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x813D, .hex);
pub const GL_SMOOTH_POINT_SIZE_RANGE = @as(c_int, 0x0B12);
pub const GL_SMOOTH_POINT_SIZE_GRANULARITY = @as(c_int, 0x0B13);
pub const GL_SMOOTH_LINE_WIDTH_RANGE = @as(c_int, 0x0B22);
pub const GL_SMOOTH_LINE_WIDTH_GRANULARITY = @as(c_int, 0x0B23);
pub const GL_ALIASED_LINE_WIDTH_RANGE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x846E, .hex);
pub const GL_TEXTURE0 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x84C0, .hex);
pub const GL_TEXTURE1 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x84C1, .hex);
pub const GL_TEXTURE2 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x84C2, .hex);
pub const GL_TEXTURE3 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x84C3, .hex);
pub const GL_TEXTURE4 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x84C4, .hex);
pub const GL_TEXTURE5 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x84C5, .hex);
pub const GL_TEXTURE6 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x84C6, .hex);
pub const GL_TEXTURE7 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x84C7, .hex);
pub const GL_TEXTURE8 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x84C8, .hex);
pub const GL_TEXTURE9 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x84C9, .hex);
pub const GL_TEXTURE10 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x84CA, .hex);
pub const GL_TEXTURE11 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x84CB, .hex);
pub const GL_TEXTURE12 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x84CC, .hex);
pub const GL_TEXTURE13 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x84CD, .hex);
pub const GL_TEXTURE14 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x84CE, .hex);
pub const GL_TEXTURE15 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x84CF, .hex);
pub const GL_TEXTURE16 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x84D0, .hex);
pub const GL_TEXTURE17 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x84D1, .hex);
pub const GL_TEXTURE18 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x84D2, .hex);
pub const GL_TEXTURE19 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x84D3, .hex);
pub const GL_TEXTURE20 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x84D4, .hex);
pub const GL_TEXTURE21 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x84D5, .hex);
pub const GL_TEXTURE22 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x84D6, .hex);
pub const GL_TEXTURE23 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x84D7, .hex);
pub const GL_TEXTURE24 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x84D8, .hex);
pub const GL_TEXTURE25 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x84D9, .hex);
pub const GL_TEXTURE26 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x84DA, .hex);
pub const GL_TEXTURE27 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x84DB, .hex);
pub const GL_TEXTURE28 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x84DC, .hex);
pub const GL_TEXTURE29 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x84DD, .hex);
pub const GL_TEXTURE30 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x84DE, .hex);
pub const GL_TEXTURE31 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x84DF, .hex);
pub const GL_ACTIVE_TEXTURE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x84E0, .hex);
pub const GL_MULTISAMPLE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x809D, .hex);
pub const GL_SAMPLE_ALPHA_TO_COVERAGE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x809E, .hex);
pub const GL_SAMPLE_ALPHA_TO_ONE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x809F, .hex);
pub const GL_SAMPLE_COVERAGE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x80A0, .hex);
pub const GL_SAMPLE_BUFFERS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x80A8, .hex);
pub const GL_SAMPLES = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x80A9, .hex);
pub const GL_SAMPLE_COVERAGE_VALUE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x80AA, .hex);
pub const GL_SAMPLE_COVERAGE_INVERT = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x80AB, .hex);
pub const GL_TEXTURE_CUBE_MAP = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8513, .hex);
pub const GL_TEXTURE_BINDING_CUBE_MAP = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8514, .hex);
pub const GL_TEXTURE_CUBE_MAP_POSITIVE_X = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8515, .hex);
pub const GL_TEXTURE_CUBE_MAP_NEGATIVE_X = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8516, .hex);
pub const GL_TEXTURE_CUBE_MAP_POSITIVE_Y = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8517, .hex);
pub const GL_TEXTURE_CUBE_MAP_NEGATIVE_Y = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8518, .hex);
pub const GL_TEXTURE_CUBE_MAP_POSITIVE_Z = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8519, .hex);
pub const GL_TEXTURE_CUBE_MAP_NEGATIVE_Z = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x851A, .hex);
pub const GL_PROXY_TEXTURE_CUBE_MAP = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x851B, .hex);
pub const GL_MAX_CUBE_MAP_TEXTURE_SIZE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x851C, .hex);
pub const GL_COMPRESSED_RGB = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x84ED, .hex);
pub const GL_COMPRESSED_RGBA = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x84EE, .hex);
pub const GL_TEXTURE_COMPRESSION_HINT = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x84EF, .hex);
pub const GL_TEXTURE_COMPRESSED_IMAGE_SIZE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x86A0, .hex);
pub const GL_TEXTURE_COMPRESSED = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x86A1, .hex);
pub const GL_NUM_COMPRESSED_TEXTURE_FORMATS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x86A2, .hex);
pub const GL_COMPRESSED_TEXTURE_FORMATS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x86A3, .hex);
pub const GL_CLAMP_TO_BORDER = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x812D, .hex);
pub const GL_BLEND_DST_RGB = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x80C8, .hex);
pub const GL_BLEND_SRC_RGB = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x80C9, .hex);
pub const GL_BLEND_DST_ALPHA = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x80CA, .hex);
pub const GL_BLEND_SRC_ALPHA = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x80CB, .hex);
pub const GL_POINT_FADE_THRESHOLD_SIZE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8128, .hex);
pub const GL_DEPTH_COMPONENT16 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x81A5, .hex);
pub const GL_DEPTH_COMPONENT24 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x81A6, .hex);
pub const GL_DEPTH_COMPONENT32 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x81A7, .hex);
pub const GL_MIRRORED_REPEAT = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8370, .hex);
pub const GL_MAX_TEXTURE_LOD_BIAS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x84FD, .hex);
pub const GL_TEXTURE_LOD_BIAS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8501, .hex);
pub const GL_INCR_WRAP = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8507, .hex);
pub const GL_DECR_WRAP = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8508, .hex);
pub const GL_TEXTURE_DEPTH_SIZE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x884A, .hex);
pub const GL_TEXTURE_COMPARE_MODE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x884C, .hex);
pub const GL_TEXTURE_COMPARE_FUNC = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x884D, .hex);
pub const GL_BLEND_COLOR = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8005, .hex);
pub const GL_BLEND_EQUATION = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8009, .hex);
pub const GL_CONSTANT_COLOR = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8001, .hex);
pub const GL_ONE_MINUS_CONSTANT_COLOR = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8002, .hex);
pub const GL_CONSTANT_ALPHA = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8003, .hex);
pub const GL_ONE_MINUS_CONSTANT_ALPHA = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8004, .hex);
pub const GL_FUNC_ADD = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8006, .hex);
pub const GL_FUNC_REVERSE_SUBTRACT = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x800B, .hex);
pub const GL_FUNC_SUBTRACT = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x800A, .hex);
pub const GL_MIN = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8007, .hex);
pub const GL_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8008, .hex);
pub const GL_BUFFER_SIZE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8764, .hex);
pub const GL_BUFFER_USAGE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8765, .hex);
pub const GL_QUERY_COUNTER_BITS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8864, .hex);
pub const GL_CURRENT_QUERY = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8865, .hex);
pub const GL_QUERY_RESULT = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8866, .hex);
pub const GL_QUERY_RESULT_AVAILABLE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8867, .hex);
pub const GL_ARRAY_BUFFER = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8892, .hex);
pub const GL_ELEMENT_ARRAY_BUFFER = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8893, .hex);
pub const GL_ARRAY_BUFFER_BINDING = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8894, .hex);
pub const GL_ELEMENT_ARRAY_BUFFER_BINDING = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8895, .hex);
pub const GL_VERTEX_ATTRIB_ARRAY_BUFFER_BINDING = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x889F, .hex);
pub const GL_READ_ONLY = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x88B8, .hex);
pub const GL_WRITE_ONLY = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x88B9, .hex);
pub const GL_READ_WRITE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x88BA, .hex);
pub const GL_BUFFER_ACCESS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x88BB, .hex);
pub const GL_BUFFER_MAPPED = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x88BC, .hex);
pub const GL_BUFFER_MAP_POINTER = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x88BD, .hex);
pub const GL_STREAM_DRAW = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x88E0, .hex);
pub const GL_STREAM_READ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x88E1, .hex);
pub const GL_STREAM_COPY = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x88E2, .hex);
pub const GL_STATIC_DRAW = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x88E4, .hex);
pub const GL_STATIC_READ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x88E5, .hex);
pub const GL_STATIC_COPY = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x88E6, .hex);
pub const GL_DYNAMIC_DRAW = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x88E8, .hex);
pub const GL_DYNAMIC_READ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x88E9, .hex);
pub const GL_DYNAMIC_COPY = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x88EA, .hex);
pub const GL_SAMPLES_PASSED = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8914, .hex);
pub const GL_SRC1_ALPHA = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8589, .hex);
pub const GL_BLEND_EQUATION_RGB = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8009, .hex);
pub const GL_VERTEX_ATTRIB_ARRAY_ENABLED = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8622, .hex);
pub const GL_VERTEX_ATTRIB_ARRAY_SIZE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8623, .hex);
pub const GL_VERTEX_ATTRIB_ARRAY_STRIDE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8624, .hex);
pub const GL_VERTEX_ATTRIB_ARRAY_TYPE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8625, .hex);
pub const GL_CURRENT_VERTEX_ATTRIB = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8626, .hex);
pub const GL_VERTEX_PROGRAM_POINT_SIZE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8642, .hex);
pub const GL_VERTEX_ATTRIB_ARRAY_POINTER = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8645, .hex);
pub const GL_STENCIL_BACK_FUNC = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8800, .hex);
pub const GL_STENCIL_BACK_FAIL = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8801, .hex);
pub const GL_STENCIL_BACK_PASS_DEPTH_FAIL = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8802, .hex);
pub const GL_STENCIL_BACK_PASS_DEPTH_PASS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8803, .hex);
pub const GL_MAX_DRAW_BUFFERS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8824, .hex);
pub const GL_DRAW_BUFFER0 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8825, .hex);
pub const GL_DRAW_BUFFER1 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8826, .hex);
pub const GL_DRAW_BUFFER2 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8827, .hex);
pub const GL_DRAW_BUFFER3 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8828, .hex);
pub const GL_DRAW_BUFFER4 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8829, .hex);
pub const GL_DRAW_BUFFER5 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x882A, .hex);
pub const GL_DRAW_BUFFER6 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x882B, .hex);
pub const GL_DRAW_BUFFER7 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x882C, .hex);
pub const GL_DRAW_BUFFER8 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x882D, .hex);
pub const GL_DRAW_BUFFER9 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x882E, .hex);
pub const GL_DRAW_BUFFER10 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x882F, .hex);
pub const GL_DRAW_BUFFER11 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8830, .hex);
pub const GL_DRAW_BUFFER12 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8831, .hex);
pub const GL_DRAW_BUFFER13 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8832, .hex);
pub const GL_DRAW_BUFFER14 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8833, .hex);
pub const GL_DRAW_BUFFER15 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8834, .hex);
pub const GL_BLEND_EQUATION_ALPHA = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x883D, .hex);
pub const GL_MAX_VERTEX_ATTRIBS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8869, .hex);
pub const GL_VERTEX_ATTRIB_ARRAY_NORMALIZED = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x886A, .hex);
pub const GL_MAX_TEXTURE_IMAGE_UNITS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8872, .hex);
pub const GL_FRAGMENT_SHADER = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B30, .hex);
pub const GL_VERTEX_SHADER = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B31, .hex);
pub const GL_MAX_FRAGMENT_UNIFORM_COMPONENTS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B49, .hex);
pub const GL_MAX_VERTEX_UNIFORM_COMPONENTS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B4A, .hex);
pub const GL_MAX_VARYING_FLOATS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B4B, .hex);
pub const GL_MAX_VERTEX_TEXTURE_IMAGE_UNITS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B4C, .hex);
pub const GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B4D, .hex);
pub const GL_SHADER_TYPE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B4F, .hex);
pub const GL_FLOAT_VEC2 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B50, .hex);
pub const GL_FLOAT_VEC3 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B51, .hex);
pub const GL_FLOAT_VEC4 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B52, .hex);
pub const GL_INT_VEC2 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B53, .hex);
pub const GL_INT_VEC3 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B54, .hex);
pub const GL_INT_VEC4 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B55, .hex);
pub const GL_BOOL = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B56, .hex);
pub const GL_BOOL_VEC2 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B57, .hex);
pub const GL_BOOL_VEC3 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B58, .hex);
pub const GL_BOOL_VEC4 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B59, .hex);
pub const GL_FLOAT_MAT2 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B5A, .hex);
pub const GL_FLOAT_MAT3 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B5B, .hex);
pub const GL_FLOAT_MAT4 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B5C, .hex);
pub const GL_SAMPLER_1D = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B5D, .hex);
pub const GL_SAMPLER_2D = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B5E, .hex);
pub const GL_SAMPLER_3D = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B5F, .hex);
pub const GL_SAMPLER_CUBE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B60, .hex);
pub const GL_SAMPLER_1D_SHADOW = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B61, .hex);
pub const GL_SAMPLER_2D_SHADOW = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B62, .hex);
pub const GL_DELETE_STATUS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B80, .hex);
pub const GL_COMPILE_STATUS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B81, .hex);
pub const GL_LINK_STATUS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B82, .hex);
pub const GL_VALIDATE_STATUS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B83, .hex);
pub const GL_INFO_LOG_LENGTH = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B84, .hex);
pub const GL_ATTACHED_SHADERS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B85, .hex);
pub const GL_ACTIVE_UNIFORMS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B86, .hex);
pub const GL_ACTIVE_UNIFORM_MAX_LENGTH = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B87, .hex);
pub const GL_SHADER_SOURCE_LENGTH = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B88, .hex);
pub const GL_ACTIVE_ATTRIBUTES = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B89, .hex);
pub const GL_ACTIVE_ATTRIBUTE_MAX_LENGTH = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B8A, .hex);
pub const GL_FRAGMENT_SHADER_DERIVATIVE_HINT = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B8B, .hex);
pub const GL_SHADING_LANGUAGE_VERSION = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B8C, .hex);
pub const GL_CURRENT_PROGRAM = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B8D, .hex);
pub const GL_POINT_SPRITE_COORD_ORIGIN = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CA0, .hex);
pub const GL_LOWER_LEFT = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CA1, .hex);
pub const GL_UPPER_LEFT = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CA2, .hex);
pub const GL_STENCIL_BACK_REF = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CA3, .hex);
pub const GL_STENCIL_BACK_VALUE_MASK = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CA4, .hex);
pub const GL_STENCIL_BACK_WRITEMASK = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CA5, .hex);
pub const GL_PIXEL_PACK_BUFFER = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x88EB, .hex);
pub const GL_PIXEL_UNPACK_BUFFER = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x88EC, .hex);
pub const GL_PIXEL_PACK_BUFFER_BINDING = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x88ED, .hex);
pub const GL_PIXEL_UNPACK_BUFFER_BINDING = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x88EF, .hex);
pub const GL_FLOAT_MAT2x3 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B65, .hex);
pub const GL_FLOAT_MAT2x4 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B66, .hex);
pub const GL_FLOAT_MAT3x2 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B67, .hex);
pub const GL_FLOAT_MAT3x4 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B68, .hex);
pub const GL_FLOAT_MAT4x2 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B69, .hex);
pub const GL_FLOAT_MAT4x3 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B6A, .hex);
pub const GL_SRGB = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8C40, .hex);
pub const GL_SRGB8 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8C41, .hex);
pub const GL_SRGB_ALPHA = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8C42, .hex);
pub const GL_SRGB8_ALPHA8 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8C43, .hex);
pub const GL_COMPRESSED_SRGB = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8C48, .hex);
pub const GL_COMPRESSED_SRGB_ALPHA = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8C49, .hex);
pub const GL_COMPARE_REF_TO_TEXTURE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x884E, .hex);
pub const GL_CLIP_DISTANCE0 = @as(c_int, 0x3000);
pub const GL_CLIP_DISTANCE1 = @as(c_int, 0x3001);
pub const GL_CLIP_DISTANCE2 = @as(c_int, 0x3002);
pub const GL_CLIP_DISTANCE3 = @as(c_int, 0x3003);
pub const GL_CLIP_DISTANCE4 = @as(c_int, 0x3004);
pub const GL_CLIP_DISTANCE5 = @as(c_int, 0x3005);
pub const GL_CLIP_DISTANCE6 = @as(c_int, 0x3006);
pub const GL_CLIP_DISTANCE7 = @as(c_int, 0x3007);
pub const GL_MAX_CLIP_DISTANCES = @as(c_int, 0x0D32);
pub const GL_MAJOR_VERSION = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x821B, .hex);
pub const GL_MINOR_VERSION = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x821C, .hex);
pub const GL_NUM_EXTENSIONS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x821D, .hex);
pub const GL_CONTEXT_FLAGS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x821E, .hex);
pub const GL_COMPRESSED_RED = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8225, .hex);
pub const GL_COMPRESSED_RG = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8226, .hex);
pub const GL_CONTEXT_FLAG_FORWARD_COMPATIBLE_BIT = @as(c_int, 0x00000001);
pub const GL_RGBA32F = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8814, .hex);
pub const GL_RGB32F = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8815, .hex);
pub const GL_RGBA16F = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x881A, .hex);
pub const GL_RGB16F = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x881B, .hex);
pub const GL_VERTEX_ATTRIB_ARRAY_INTEGER = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x88FD, .hex);
pub const GL_MAX_ARRAY_TEXTURE_LAYERS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x88FF, .hex);
pub const GL_MIN_PROGRAM_TEXEL_OFFSET = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8904, .hex);
pub const GL_MAX_PROGRAM_TEXEL_OFFSET = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8905, .hex);
pub const GL_CLAMP_READ_COLOR = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x891C, .hex);
pub const GL_FIXED_ONLY = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x891D, .hex);
pub const GL_MAX_VARYING_COMPONENTS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B4B, .hex);
pub const GL_TEXTURE_1D_ARRAY = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8C18, .hex);
pub const GL_PROXY_TEXTURE_1D_ARRAY = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8C19, .hex);
pub const GL_TEXTURE_2D_ARRAY = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8C1A, .hex);
pub const GL_PROXY_TEXTURE_2D_ARRAY = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8C1B, .hex);
pub const GL_TEXTURE_BINDING_1D_ARRAY = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8C1C, .hex);
pub const GL_TEXTURE_BINDING_2D_ARRAY = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8C1D, .hex);
pub const GL_R11F_G11F_B10F = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8C3A, .hex);
pub const GL_UNSIGNED_INT_10F_11F_11F_REV = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8C3B, .hex);
pub const GL_RGB9_E5 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8C3D, .hex);
pub const GL_UNSIGNED_INT_5_9_9_9_REV = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8C3E, .hex);
pub const GL_TEXTURE_SHARED_SIZE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8C3F, .hex);
pub const GL_TRANSFORM_FEEDBACK_VARYING_MAX_LENGTH = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8C76, .hex);
pub const GL_TRANSFORM_FEEDBACK_BUFFER_MODE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8C7F, .hex);
pub const GL_MAX_TRANSFORM_FEEDBACK_SEPARATE_COMPONENTS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8C80, .hex);
pub const GL_TRANSFORM_FEEDBACK_VARYINGS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8C83, .hex);
pub const GL_TRANSFORM_FEEDBACK_BUFFER_START = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8C84, .hex);
pub const GL_TRANSFORM_FEEDBACK_BUFFER_SIZE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8C85, .hex);
pub const GL_PRIMITIVES_GENERATED = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8C87, .hex);
pub const GL_TRANSFORM_FEEDBACK_PRIMITIVES_WRITTEN = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8C88, .hex);
pub const GL_RASTERIZER_DISCARD = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8C89, .hex);
pub const GL_MAX_TRANSFORM_FEEDBACK_INTERLEAVED_COMPONENTS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8C8A, .hex);
pub const GL_MAX_TRANSFORM_FEEDBACK_SEPARATE_ATTRIBS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8C8B, .hex);
pub const GL_INTERLEAVED_ATTRIBS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8C8C, .hex);
pub const GL_SEPARATE_ATTRIBS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8C8D, .hex);
pub const GL_TRANSFORM_FEEDBACK_BUFFER = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8C8E, .hex);
pub const GL_TRANSFORM_FEEDBACK_BUFFER_BINDING = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8C8F, .hex);
pub const GL_RGBA32UI = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8D70, .hex);
pub const GL_RGB32UI = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8D71, .hex);
pub const GL_RGBA16UI = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8D76, .hex);
pub const GL_RGB16UI = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8D77, .hex);
pub const GL_RGBA8UI = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8D7C, .hex);
pub const GL_RGB8UI = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8D7D, .hex);
pub const GL_RGBA32I = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8D82, .hex);
pub const GL_RGB32I = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8D83, .hex);
pub const GL_RGBA16I = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8D88, .hex);
pub const GL_RGB16I = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8D89, .hex);
pub const GL_RGBA8I = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8D8E, .hex);
pub const GL_RGB8I = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8D8F, .hex);
pub const GL_RED_INTEGER = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8D94, .hex);
pub const GL_GREEN_INTEGER = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8D95, .hex);
pub const GL_BLUE_INTEGER = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8D96, .hex);
pub const GL_RGB_INTEGER = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8D98, .hex);
pub const GL_RGBA_INTEGER = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8D99, .hex);
pub const GL_BGR_INTEGER = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8D9A, .hex);
pub const GL_BGRA_INTEGER = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8D9B, .hex);
pub const GL_SAMPLER_1D_ARRAY = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8DC0, .hex);
pub const GL_SAMPLER_2D_ARRAY = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8DC1, .hex);
pub const GL_SAMPLER_1D_ARRAY_SHADOW = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8DC3, .hex);
pub const GL_SAMPLER_2D_ARRAY_SHADOW = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8DC4, .hex);
pub const GL_SAMPLER_CUBE_SHADOW = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8DC5, .hex);
pub const GL_UNSIGNED_INT_VEC2 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8DC6, .hex);
pub const GL_UNSIGNED_INT_VEC3 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8DC7, .hex);
pub const GL_UNSIGNED_INT_VEC4 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8DC8, .hex);
pub const GL_INT_SAMPLER_1D = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8DC9, .hex);
pub const GL_INT_SAMPLER_2D = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8DCA, .hex);
pub const GL_INT_SAMPLER_3D = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8DCB, .hex);
pub const GL_INT_SAMPLER_CUBE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8DCC, .hex);
pub const GL_INT_SAMPLER_1D_ARRAY = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8DCE, .hex);
pub const GL_INT_SAMPLER_2D_ARRAY = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8DCF, .hex);
pub const GL_UNSIGNED_INT_SAMPLER_1D = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8DD1, .hex);
pub const GL_UNSIGNED_INT_SAMPLER_2D = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8DD2, .hex);
pub const GL_UNSIGNED_INT_SAMPLER_3D = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8DD3, .hex);
pub const GL_UNSIGNED_INT_SAMPLER_CUBE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8DD4, .hex);
pub const GL_UNSIGNED_INT_SAMPLER_1D_ARRAY = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8DD6, .hex);
pub const GL_UNSIGNED_INT_SAMPLER_2D_ARRAY = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8DD7, .hex);
pub const GL_QUERY_WAIT = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8E13, .hex);
pub const GL_QUERY_NO_WAIT = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8E14, .hex);
pub const GL_QUERY_BY_REGION_WAIT = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8E15, .hex);
pub const GL_QUERY_BY_REGION_NO_WAIT = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8E16, .hex);
pub const GL_BUFFER_ACCESS_FLAGS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x911F, .hex);
pub const GL_BUFFER_MAP_LENGTH = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x9120, .hex);
pub const GL_BUFFER_MAP_OFFSET = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x9121, .hex);
pub const GL_DEPTH_COMPONENT32F = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CAC, .hex);
pub const GL_DEPTH32F_STENCIL8 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CAD, .hex);
pub const GL_FLOAT_32_UNSIGNED_INT_24_8_REV = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8DAD, .hex);
pub const GL_INVALID_FRAMEBUFFER_OPERATION = @as(c_int, 0x0506);
pub const GL_FRAMEBUFFER_ATTACHMENT_COLOR_ENCODING = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8210, .hex);
pub const GL_FRAMEBUFFER_ATTACHMENT_COMPONENT_TYPE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8211, .hex);
pub const GL_FRAMEBUFFER_ATTACHMENT_RED_SIZE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8212, .hex);
pub const GL_FRAMEBUFFER_ATTACHMENT_GREEN_SIZE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8213, .hex);
pub const GL_FRAMEBUFFER_ATTACHMENT_BLUE_SIZE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8214, .hex);
pub const GL_FRAMEBUFFER_ATTACHMENT_ALPHA_SIZE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8215, .hex);
pub const GL_FRAMEBUFFER_ATTACHMENT_DEPTH_SIZE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8216, .hex);
pub const GL_FRAMEBUFFER_ATTACHMENT_STENCIL_SIZE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8217, .hex);
pub const GL_FRAMEBUFFER_DEFAULT = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8218, .hex);
pub const GL_FRAMEBUFFER_UNDEFINED = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8219, .hex);
pub const GL_DEPTH_STENCIL_ATTACHMENT = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x821A, .hex);
pub const GL_MAX_RENDERBUFFER_SIZE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x84E8, .hex);
pub const GL_DEPTH_STENCIL = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x84F9, .hex);
pub const GL_UNSIGNED_INT_24_8 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x84FA, .hex);
pub const GL_DEPTH24_STENCIL8 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x88F0, .hex);
pub const GL_TEXTURE_STENCIL_SIZE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x88F1, .hex);
pub const GL_TEXTURE_RED_TYPE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8C10, .hex);
pub const GL_TEXTURE_GREEN_TYPE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8C11, .hex);
pub const GL_TEXTURE_BLUE_TYPE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8C12, .hex);
pub const GL_TEXTURE_ALPHA_TYPE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8C13, .hex);
pub const GL_TEXTURE_DEPTH_TYPE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8C16, .hex);
pub const GL_UNSIGNED_NORMALIZED = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8C17, .hex);
pub const GL_FRAMEBUFFER_BINDING = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CA6, .hex);
pub const GL_DRAW_FRAMEBUFFER_BINDING = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CA6, .hex);
pub const GL_RENDERBUFFER_BINDING = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CA7, .hex);
pub const GL_READ_FRAMEBUFFER = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CA8, .hex);
pub const GL_DRAW_FRAMEBUFFER = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CA9, .hex);
pub const GL_READ_FRAMEBUFFER_BINDING = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CAA, .hex);
pub const GL_RENDERBUFFER_SAMPLES = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CAB, .hex);
pub const GL_FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CD0, .hex);
pub const GL_FRAMEBUFFER_ATTACHMENT_OBJECT_NAME = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CD1, .hex);
pub const GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CD2, .hex);
pub const GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CD3, .hex);
pub const GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CD4, .hex);
pub const GL_FRAMEBUFFER_COMPLETE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CD5, .hex);
pub const GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CD6, .hex);
pub const GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CD7, .hex);
pub const GL_FRAMEBUFFER_INCOMPLETE_DRAW_BUFFER = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CDB, .hex);
pub const GL_FRAMEBUFFER_INCOMPLETE_READ_BUFFER = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CDC, .hex);
pub const GL_FRAMEBUFFER_UNSUPPORTED = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CDD, .hex);
pub const GL_MAX_COLOR_ATTACHMENTS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CDF, .hex);
pub const GL_COLOR_ATTACHMENT0 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CE0, .hex);
pub const GL_COLOR_ATTACHMENT1 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CE1, .hex);
pub const GL_COLOR_ATTACHMENT2 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CE2, .hex);
pub const GL_COLOR_ATTACHMENT3 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CE3, .hex);
pub const GL_COLOR_ATTACHMENT4 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CE4, .hex);
pub const GL_COLOR_ATTACHMENT5 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CE5, .hex);
pub const GL_COLOR_ATTACHMENT6 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CE6, .hex);
pub const GL_COLOR_ATTACHMENT7 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CE7, .hex);
pub const GL_COLOR_ATTACHMENT8 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CE8, .hex);
pub const GL_COLOR_ATTACHMENT9 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CE9, .hex);
pub const GL_COLOR_ATTACHMENT10 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CEA, .hex);
pub const GL_COLOR_ATTACHMENT11 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CEB, .hex);
pub const GL_COLOR_ATTACHMENT12 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CEC, .hex);
pub const GL_COLOR_ATTACHMENT13 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CED, .hex);
pub const GL_COLOR_ATTACHMENT14 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CEE, .hex);
pub const GL_COLOR_ATTACHMENT15 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CEF, .hex);
pub const GL_COLOR_ATTACHMENT16 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CF0, .hex);
pub const GL_COLOR_ATTACHMENT17 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CF1, .hex);
pub const GL_COLOR_ATTACHMENT18 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CF2, .hex);
pub const GL_COLOR_ATTACHMENT19 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CF3, .hex);
pub const GL_COLOR_ATTACHMENT20 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CF4, .hex);
pub const GL_COLOR_ATTACHMENT21 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CF5, .hex);
pub const GL_COLOR_ATTACHMENT22 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CF6, .hex);
pub const GL_COLOR_ATTACHMENT23 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CF7, .hex);
pub const GL_COLOR_ATTACHMENT24 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CF8, .hex);
pub const GL_COLOR_ATTACHMENT25 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CF9, .hex);
pub const GL_COLOR_ATTACHMENT26 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CFA, .hex);
pub const GL_COLOR_ATTACHMENT27 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CFB, .hex);
pub const GL_COLOR_ATTACHMENT28 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CFC, .hex);
pub const GL_COLOR_ATTACHMENT29 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CFD, .hex);
pub const GL_COLOR_ATTACHMENT30 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CFE, .hex);
pub const GL_COLOR_ATTACHMENT31 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8CFF, .hex);
pub const GL_DEPTH_ATTACHMENT = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8D00, .hex);
pub const GL_STENCIL_ATTACHMENT = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8D20, .hex);
pub const GL_FRAMEBUFFER = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8D40, .hex);
pub const GL_RENDERBUFFER = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8D41, .hex);
pub const GL_RENDERBUFFER_WIDTH = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8D42, .hex);
pub const GL_RENDERBUFFER_HEIGHT = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8D43, .hex);
pub const GL_RENDERBUFFER_INTERNAL_FORMAT = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8D44, .hex);
pub const GL_STENCIL_INDEX1 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8D46, .hex);
pub const GL_STENCIL_INDEX4 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8D47, .hex);
pub const GL_STENCIL_INDEX8 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8D48, .hex);
pub const GL_STENCIL_INDEX16 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8D49, .hex);
pub const GL_RENDERBUFFER_RED_SIZE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8D50, .hex);
pub const GL_RENDERBUFFER_GREEN_SIZE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8D51, .hex);
pub const GL_RENDERBUFFER_BLUE_SIZE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8D52, .hex);
pub const GL_RENDERBUFFER_ALPHA_SIZE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8D53, .hex);
pub const GL_RENDERBUFFER_DEPTH_SIZE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8D54, .hex);
pub const GL_RENDERBUFFER_STENCIL_SIZE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8D55, .hex);
pub const GL_FRAMEBUFFER_INCOMPLETE_MULTISAMPLE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8D56, .hex);
pub const GL_MAX_SAMPLES = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8D57, .hex);
pub const GL_FRAMEBUFFER_SRGB = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8DB9, .hex);
pub const GL_HALF_FLOAT = @as(c_int, 0x140B);
pub const GL_MAP_READ_BIT = @as(c_int, 0x0001);
pub const GL_MAP_WRITE_BIT = @as(c_int, 0x0002);
pub const GL_MAP_INVALIDATE_RANGE_BIT = @as(c_int, 0x0004);
pub const GL_MAP_INVALIDATE_BUFFER_BIT = @as(c_int, 0x0008);
pub const GL_MAP_FLUSH_EXPLICIT_BIT = @as(c_int, 0x0010);
pub const GL_MAP_UNSYNCHRONIZED_BIT = @as(c_int, 0x0020);
pub const GL_COMPRESSED_RED_RGTC1 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8DBB, .hex);
pub const GL_COMPRESSED_SIGNED_RED_RGTC1 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8DBC, .hex);
pub const GL_COMPRESSED_RG_RGTC2 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8DBD, .hex);
pub const GL_COMPRESSED_SIGNED_RG_RGTC2 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8DBE, .hex);
pub const GL_RG = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8227, .hex);
pub const GL_RG_INTEGER = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8228, .hex);
pub const GL_R8 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8229, .hex);
pub const GL_R16 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x822A, .hex);
pub const GL_RG8 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x822B, .hex);
pub const GL_RG16 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x822C, .hex);
pub const GL_R16F = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x822D, .hex);
pub const GL_R32F = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x822E, .hex);
pub const GL_RG16F = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x822F, .hex);
pub const GL_RG32F = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8230, .hex);
pub const GL_R8I = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8231, .hex);
pub const GL_R8UI = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8232, .hex);
pub const GL_R16I = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8233, .hex);
pub const GL_R16UI = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8234, .hex);
pub const GL_R32I = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8235, .hex);
pub const GL_R32UI = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8236, .hex);
pub const GL_RG8I = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8237, .hex);
pub const GL_RG8UI = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8238, .hex);
pub const GL_RG16I = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8239, .hex);
pub const GL_RG16UI = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x823A, .hex);
pub const GL_RG32I = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x823B, .hex);
pub const GL_RG32UI = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x823C, .hex);
pub const GL_VERTEX_ARRAY_BINDING = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x85B5, .hex);
pub const GL_SAMPLER_2D_RECT = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B63, .hex);
pub const GL_SAMPLER_2D_RECT_SHADOW = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8B64, .hex);
pub const GL_SAMPLER_BUFFER = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8DC2, .hex);
pub const GL_INT_SAMPLER_2D_RECT = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8DCD, .hex);
pub const GL_INT_SAMPLER_BUFFER = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8DD0, .hex);
pub const GL_UNSIGNED_INT_SAMPLER_2D_RECT = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8DD5, .hex);
pub const GL_UNSIGNED_INT_SAMPLER_BUFFER = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8DD8, .hex);
pub const GL_TEXTURE_BUFFER = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8C2A, .hex);
pub const GL_MAX_TEXTURE_BUFFER_SIZE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8C2B, .hex);
pub const GL_TEXTURE_BINDING_BUFFER = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8C2C, .hex);
pub const GL_TEXTURE_BUFFER_DATA_STORE_BINDING = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8C2D, .hex);
pub const GL_TEXTURE_RECTANGLE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x84F5, .hex);
pub const GL_TEXTURE_BINDING_RECTANGLE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x84F6, .hex);
pub const GL_PROXY_TEXTURE_RECTANGLE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x84F7, .hex);
pub const GL_MAX_RECTANGLE_TEXTURE_SIZE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x84F8, .hex);
pub const GL_R8_SNORM = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8F94, .hex);
pub const GL_RG8_SNORM = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8F95, .hex);
pub const GL_RGB8_SNORM = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8F96, .hex);
pub const GL_RGBA8_SNORM = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8F97, .hex);
pub const GL_R16_SNORM = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8F98, .hex);
pub const GL_RG16_SNORM = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8F99, .hex);
pub const GL_RGB16_SNORM = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8F9A, .hex);
pub const GL_RGBA16_SNORM = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8F9B, .hex);
pub const GL_SIGNED_NORMALIZED = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8F9C, .hex);
pub const GL_PRIMITIVE_RESTART = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8F9D, .hex);
pub const GL_PRIMITIVE_RESTART_INDEX = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8F9E, .hex);
pub const GL_COPY_READ_BUFFER = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8F36, .hex);
pub const GL_COPY_WRITE_BUFFER = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8F37, .hex);
pub const GL_UNIFORM_BUFFER = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8A11, .hex);
pub const GL_UNIFORM_BUFFER_BINDING = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8A28, .hex);
pub const GL_UNIFORM_BUFFER_START = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8A29, .hex);
pub const GL_UNIFORM_BUFFER_SIZE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8A2A, .hex);
pub const GL_MAX_VERTEX_UNIFORM_BLOCKS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8A2B, .hex);
pub const GL_MAX_GEOMETRY_UNIFORM_BLOCKS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8A2C, .hex);
pub const GL_MAX_FRAGMENT_UNIFORM_BLOCKS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8A2D, .hex);
pub const GL_MAX_COMBINED_UNIFORM_BLOCKS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8A2E, .hex);
pub const GL_MAX_UNIFORM_BUFFER_BINDINGS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8A2F, .hex);
pub const GL_MAX_UNIFORM_BLOCK_SIZE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8A30, .hex);
pub const GL_MAX_COMBINED_VERTEX_UNIFORM_COMPONENTS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8A31, .hex);
pub const GL_MAX_COMBINED_GEOMETRY_UNIFORM_COMPONENTS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8A32, .hex);
pub const GL_MAX_COMBINED_FRAGMENT_UNIFORM_COMPONENTS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8A33, .hex);
pub const GL_UNIFORM_BUFFER_OFFSET_ALIGNMENT = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8A34, .hex);
pub const GL_ACTIVE_UNIFORM_BLOCK_MAX_NAME_LENGTH = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8A35, .hex);
pub const GL_ACTIVE_UNIFORM_BLOCKS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8A36, .hex);
pub const GL_UNIFORM_TYPE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8A37, .hex);
pub const GL_UNIFORM_SIZE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8A38, .hex);
pub const GL_UNIFORM_NAME_LENGTH = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8A39, .hex);
pub const GL_UNIFORM_BLOCK_INDEX = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8A3A, .hex);
pub const GL_UNIFORM_OFFSET = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8A3B, .hex);
pub const GL_UNIFORM_ARRAY_STRIDE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8A3C, .hex);
pub const GL_UNIFORM_MATRIX_STRIDE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8A3D, .hex);
pub const GL_UNIFORM_IS_ROW_MAJOR = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8A3E, .hex);
pub const GL_UNIFORM_BLOCK_BINDING = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8A3F, .hex);
pub const GL_UNIFORM_BLOCK_DATA_SIZE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8A40, .hex);
pub const GL_UNIFORM_BLOCK_NAME_LENGTH = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8A41, .hex);
pub const GL_UNIFORM_BLOCK_ACTIVE_UNIFORMS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8A42, .hex);
pub const GL_UNIFORM_BLOCK_ACTIVE_UNIFORM_INDICES = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8A43, .hex);
pub const GL_UNIFORM_BLOCK_REFERENCED_BY_VERTEX_SHADER = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8A44, .hex);
pub const GL_UNIFORM_BLOCK_REFERENCED_BY_GEOMETRY_SHADER = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8A45, .hex);
pub const GL_UNIFORM_BLOCK_REFERENCED_BY_FRAGMENT_SHADER = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8A46, .hex);
pub const GL_INVALID_INDEX = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0xFFFFFFFF, .hex);
pub const GL_CONTEXT_CORE_PROFILE_BIT = @as(c_int, 0x00000001);
pub const GL_CONTEXT_COMPATIBILITY_PROFILE_BIT = @as(c_int, 0x00000002);
pub const GL_LINES_ADJACENCY = @as(c_int, 0x000A);
pub const GL_LINE_STRIP_ADJACENCY = @as(c_int, 0x000B);
pub const GL_TRIANGLES_ADJACENCY = @as(c_int, 0x000C);
pub const GL_TRIANGLE_STRIP_ADJACENCY = @as(c_int, 0x000D);
pub const GL_PROGRAM_POINT_SIZE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8642, .hex);
pub const GL_MAX_GEOMETRY_TEXTURE_IMAGE_UNITS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8C29, .hex);
pub const GL_FRAMEBUFFER_ATTACHMENT_LAYERED = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8DA7, .hex);
pub const GL_FRAMEBUFFER_INCOMPLETE_LAYER_TARGETS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8DA8, .hex);
pub const GL_GEOMETRY_SHADER = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8DD9, .hex);
pub const GL_GEOMETRY_VERTICES_OUT = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8916, .hex);
pub const GL_GEOMETRY_INPUT_TYPE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8917, .hex);
pub const GL_GEOMETRY_OUTPUT_TYPE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8918, .hex);
pub const GL_MAX_GEOMETRY_UNIFORM_COMPONENTS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8DDF, .hex);
pub const GL_MAX_GEOMETRY_OUTPUT_VERTICES = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8DE0, .hex);
pub const GL_MAX_GEOMETRY_TOTAL_OUTPUT_COMPONENTS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8DE1, .hex);
pub const GL_MAX_VERTEX_OUTPUT_COMPONENTS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x9122, .hex);
pub const GL_MAX_GEOMETRY_INPUT_COMPONENTS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x9123, .hex);
pub const GL_MAX_GEOMETRY_OUTPUT_COMPONENTS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x9124, .hex);
pub const GL_MAX_FRAGMENT_INPUT_COMPONENTS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x9125, .hex);
pub const GL_CONTEXT_PROFILE_MASK = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x9126, .hex);
pub const GL_DEPTH_CLAMP = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x864F, .hex);
pub const GL_QUADS_FOLLOW_PROVOKING_VERTEX_CONVENTION = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8E4C, .hex);
pub const GL_FIRST_VERTEX_CONVENTION = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8E4D, .hex);
pub const GL_LAST_VERTEX_CONVENTION = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8E4E, .hex);
pub const GL_PROVOKING_VERTEX = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8E4F, .hex);
pub const GL_TEXTURE_CUBE_MAP_SEAMLESS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x884F, .hex);
pub const GL_MAX_SERVER_WAIT_TIMEOUT = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x9111, .hex);
pub const GL_OBJECT_TYPE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x9112, .hex);
pub const GL_SYNC_CONDITION = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x9113, .hex);
pub const GL_SYNC_STATUS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x9114, .hex);
pub const GL_SYNC_FLAGS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x9115, .hex);
pub const GL_SYNC_FENCE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x9116, .hex);
pub const GL_SYNC_GPU_COMMANDS_COMPLETE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x9117, .hex);
pub const GL_UNSIGNALED = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x9118, .hex);
pub const GL_SIGNALED = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x9119, .hex);
pub const GL_ALREADY_SIGNALED = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x911A, .hex);
pub const GL_TIMEOUT_EXPIRED = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x911B, .hex);
pub const GL_CONDITION_SATISFIED = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x911C, .hex);
pub const GL_WAIT_FAILED = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x911D, .hex);
pub const GL_TIMEOUT_IGNORED = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0xFFFFFFFFFFFFFFFF, .hex);
pub const GL_SYNC_FLUSH_COMMANDS_BIT = @as(c_int, 0x00000001);
pub const GL_SAMPLE_POSITION = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8E50, .hex);
pub const GL_SAMPLE_MASK = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8E51, .hex);
pub const GL_SAMPLE_MASK_VALUE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8E52, .hex);
pub const GL_MAX_SAMPLE_MASK_WORDS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8E59, .hex);
pub const GL_TEXTURE_2D_MULTISAMPLE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x9100, .hex);
pub const GL_PROXY_TEXTURE_2D_MULTISAMPLE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x9101, .hex);
pub const GL_TEXTURE_2D_MULTISAMPLE_ARRAY = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x9102, .hex);
pub const GL_PROXY_TEXTURE_2D_MULTISAMPLE_ARRAY = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x9103, .hex);
pub const GL_TEXTURE_BINDING_2D_MULTISAMPLE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x9104, .hex);
pub const GL_TEXTURE_BINDING_2D_MULTISAMPLE_ARRAY = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x9105, .hex);
pub const GL_TEXTURE_SAMPLES = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x9106, .hex);
pub const GL_TEXTURE_FIXED_SAMPLE_LOCATIONS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x9107, .hex);
pub const GL_SAMPLER_2D_MULTISAMPLE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x9108, .hex);
pub const GL_INT_SAMPLER_2D_MULTISAMPLE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x9109, .hex);
pub const GL_UNSIGNED_INT_SAMPLER_2D_MULTISAMPLE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x910A, .hex);
pub const GL_SAMPLER_2D_MULTISAMPLE_ARRAY = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x910B, .hex);
pub const GL_INT_SAMPLER_2D_MULTISAMPLE_ARRAY = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x910C, .hex);
pub const GL_UNSIGNED_INT_SAMPLER_2D_MULTISAMPLE_ARRAY = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x910D, .hex);
pub const GL_MAX_COLOR_TEXTURE_SAMPLES = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x910E, .hex);
pub const GL_MAX_DEPTH_TEXTURE_SAMPLES = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x910F, .hex);
pub const GL_MAX_INTEGER_SAMPLES = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x9110, .hex);
pub const GL_VERTEX_ATTRIB_ARRAY_DIVISOR = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x88FE, .hex);
pub const GL_SRC1_COLOR = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x88F9, .hex);
pub const GL_ONE_MINUS_SRC1_COLOR = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x88FA, .hex);
pub const GL_ONE_MINUS_SRC1_ALPHA = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x88FB, .hex);
pub const GL_MAX_DUAL_SOURCE_DRAW_BUFFERS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x88FC, .hex);
pub const GL_ANY_SAMPLES_PASSED = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8C2F, .hex);
pub const GL_SAMPLER_BINDING = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8919, .hex);
pub const GL_RGB10_A2UI = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x906F, .hex);
pub const GL_TEXTURE_SWIZZLE_R = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8E42, .hex);
pub const GL_TEXTURE_SWIZZLE_G = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8E43, .hex);
pub const GL_TEXTURE_SWIZZLE_B = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8E44, .hex);
pub const GL_TEXTURE_SWIZZLE_A = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8E45, .hex);
pub const GL_TEXTURE_SWIZZLE_RGBA = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8E46, .hex);
pub const GL_TIME_ELAPSED = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x88BF, .hex);
pub const GL_TIMESTAMP = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8E28, .hex);
pub const GL_INT_2_10_10_10_REV = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8D9F, .hex);
pub const GL_VERSION_1_0 = @as(c_int, 1);
pub inline fn glCullFace(arg_1: GLenum) void {
    return glad_glCullFace.?(arg_1);
}
pub inline fn glFrontFace(arg_2: GLenum) void {
    return glad_glFrontFace.?(arg_2);
}
pub inline fn glHint(arg_3: GLenum, arg_4: GLenum) void {
    return glad_glHint.?(arg_3, arg_4);
}
pub inline fn glLineWidth(arg_5: GLfloat) void {
    return glad_glLineWidth.?(arg_5);
}
pub inline fn glPointSize(arg_6: GLfloat) void {
    return glad_glPointSize.?(arg_6);
}
pub inline fn glPolygonMode(arg_7: GLenum, arg_8: GLenum) void {
    return glad_glPolygonMode.?(arg_7, arg_8);
}
pub inline fn glScissor(arg_9: GLint, arg_10: GLint, arg_11: GLsizei, arg_12: GLsizei) void {
    return glad_glScissor.?(arg_9, arg_10, arg_11, arg_12);
}
pub inline fn glTexParameterf(arg_13: GLenum, arg_14: GLenum, arg_15: GLfloat) void {
    return glad_glTexParameterf.?(arg_13, arg_14, arg_15);
}
pub inline fn glTexParameterfv(arg_16: GLenum, arg_17: GLenum, arg_18: [*c]const GLfloat) void {
    return glad_glTexParameterfv.?(arg_16, arg_17, arg_18);
}
pub inline fn glTexParameteri(arg_19: GLenum, arg_20: GLenum, arg_21: GLint) void {
    return glad_glTexParameteri.?(arg_19, arg_20, arg_21);
}
pub inline fn glTexParameteriv(arg_22: GLenum, arg_23: GLenum, arg_24: [*c]const GLint) void {
    return glad_glTexParameteriv.?(arg_22, arg_23, arg_24);
}
pub inline fn glTexImage1D(arg_25: GLenum, arg_26: GLint, arg_27: GLint, arg_28: GLsizei, arg_29: GLint, arg_30: GLenum, arg_31: GLenum, arg_32: ?*const anyopaque) void {
    return glad_glTexImage1D.?(arg_25, arg_26, arg_27, arg_28, arg_29, arg_30, arg_31, arg_32);
}
pub inline fn glTexImage2D(arg_33: GLenum, arg_34: GLint, arg_35: GLint, arg_36: GLsizei, arg_37: GLsizei, arg_38: GLint, arg_39: GLenum, arg_40: GLenum, arg_41: ?*const anyopaque) void {
    return glad_glTexImage2D.?(arg_33, arg_34, arg_35, arg_36, arg_37, arg_38, arg_39, arg_40, arg_41);
}
pub inline fn glDrawBuffer(arg_42: GLenum) void {
    return glad_glDrawBuffer.?(arg_42);
}
pub inline fn glClear(arg_43: GLbitfield) void {
    return glad_glClear.?(arg_43);
}
pub inline fn glClearColor(arg_44: GLfloat, arg_45: GLfloat, arg_46: GLfloat, arg_47: GLfloat) void {
    return glad_glClearColor.?(arg_44, arg_45, arg_46, arg_47);
}
pub inline fn glClearStencil(arg_48: GLint) void {
    return glad_glClearStencil.?(arg_48);
}
pub inline fn glClearDepth(arg_49: GLdouble) void {
    return glad_glClearDepth.?(arg_49);
}
pub inline fn glStencilMask(arg_50: GLuint) void {
    return glad_glStencilMask.?(arg_50);
}
pub inline fn glColorMask(arg_51: GLboolean, arg_52: GLboolean, arg_53: GLboolean, arg_54: GLboolean) void {
    return glad_glColorMask.?(arg_51, arg_52, arg_53, arg_54);
}
pub inline fn glDepthMask(arg_55: GLboolean) void {
    return glad_glDepthMask.?(arg_55);
}
pub inline fn glDisable(arg_56: GLenum) void {
    return glad_glDisable.?(arg_56);
}
pub inline fn glEnable(arg_57: GLenum) void {
    return glad_glEnable.?(arg_57);
}
pub inline fn glFinish() void {
    return glad_glFinish.?();
}
pub inline fn glFlush() void {
    return glad_glFlush.?();
}
pub inline fn glBlendFunc(arg_58: GLenum, arg_59: GLenum) void {
    return glad_glBlendFunc.?(arg_58, arg_59);
}
pub inline fn glLogicOp(arg_60: GLenum) void {
    return glad_glLogicOp.?(arg_60);
}
pub inline fn glStencilFunc(arg_61: GLenum, arg_62: GLint, arg_63: GLuint) void {
    return glad_glStencilFunc.?(arg_61, arg_62, arg_63);
}
pub inline fn glStencilOp(arg_64: GLenum, arg_65: GLenum, arg_66: GLenum) void {
    return glad_glStencilOp.?(arg_64, arg_65, arg_66);
}
pub inline fn glDepthFunc(arg_67: GLenum) void {
    return glad_glDepthFunc.?(arg_67);
}
pub inline fn glPixelStoref(arg_68: GLenum, arg_69: GLfloat) void {
    return glad_glPixelStoref.?(arg_68, arg_69);
}
pub inline fn glPixelStorei(arg_70: GLenum, arg_71: GLint) void {
    return glad_glPixelStorei.?(arg_70, arg_71);
}
pub inline fn glReadBuffer(arg_72: GLenum) void {
    return glad_glReadBuffer.?(arg_72);
}
pub inline fn glReadPixels(arg_73: GLint, arg_74: GLint, arg_75: GLsizei, arg_76: GLsizei, arg_77: GLenum, arg_78: GLenum, arg_79: ?*anyopaque) void {
    return glad_glReadPixels.?(arg_73, arg_74, arg_75, arg_76, arg_77, arg_78, arg_79);
}
pub inline fn glGetBooleanv(arg_80: GLenum, arg_81: [*c]GLboolean) void {
    return glad_glGetBooleanv.?(arg_80, arg_81);
}
pub inline fn glGetDoublev(arg_82: GLenum, arg_83: [*c]GLdouble) void {
    return glad_glGetDoublev.?(arg_82, arg_83);
}
pub inline fn glGetError() GLenum {
    return glad_glGetError.?();
}
pub inline fn glGetFloatv(arg_84: GLenum, arg_85: [*c]GLfloat) void {
    return glad_glGetFloatv.?(arg_84, arg_85);
}
pub inline fn glGetIntegerv(arg_86: GLenum, arg_87: [*c]GLint) void {
    return glad_glGetIntegerv.?(arg_86, arg_87);
}
pub inline fn glGetString(arg_88: GLenum) [*c]const GLubyte {
    return glad_glGetString.?(arg_88);
}
pub inline fn glGetTexImage(arg_89: GLenum, arg_90: GLint, arg_91: GLenum, arg_92: GLenum, arg_93: ?*anyopaque) void {
    return glad_glGetTexImage.?(arg_89, arg_90, arg_91, arg_92, arg_93);
}
pub inline fn glGetTexParameterfv(arg_94: GLenum, arg_95: GLenum, arg_96: [*c]GLfloat) void {
    return glad_glGetTexParameterfv.?(arg_94, arg_95, arg_96);
}
pub inline fn glGetTexParameteriv(arg_97: GLenum, arg_98: GLenum, arg_99: [*c]GLint) void {
    return glad_glGetTexParameteriv.?(arg_97, arg_98, arg_99);
}
pub inline fn glGetTexLevelParameterfv(arg_100: GLenum, arg_101: GLint, arg_102: GLenum, arg_103: [*c]GLfloat) void {
    return glad_glGetTexLevelParameterfv.?(arg_100, arg_101, arg_102, arg_103);
}
pub inline fn glGetTexLevelParameteriv(arg_104: GLenum, arg_105: GLint, arg_106: GLenum, arg_107: [*c]GLint) void {
    return glad_glGetTexLevelParameteriv.?(arg_104, arg_105, arg_106, arg_107);
}
pub inline fn glIsEnabled(arg_108: GLenum) GLboolean {
    return glad_glIsEnabled.?(arg_108);
}
pub inline fn glDepthRange(arg_109: GLdouble, arg_110: GLdouble) void {
    return glad_glDepthRange.?(arg_109, arg_110);
}
pub inline fn glViewport(arg_111: GLint, arg_112: GLint, arg_113: GLsizei, arg_114: GLsizei) void {
    return glad_glViewport.?(arg_111, arg_112, arg_113, arg_114);
}
pub const GL_VERSION_1_1 = @as(c_int, 1);
pub inline fn glDrawArrays(arg_115: GLenum, arg_116: GLint, arg_117: GLsizei) void {
    return glad_glDrawArrays.?(arg_115, arg_116, arg_117);
}
pub inline fn glDrawElements(arg_118: GLenum, arg_119: GLsizei, arg_120: GLenum, arg_121: ?*const anyopaque) void {
    return glad_glDrawElements.?(arg_118, arg_119, arg_120, arg_121);
}
pub inline fn glPolygonOffset(arg_122: GLfloat, arg_123: GLfloat) void {
    return glad_glPolygonOffset.?(arg_122, arg_123);
}
pub inline fn glCopyTexImage1D(arg_124: GLenum, arg_125: GLint, arg_126: GLenum, arg_127: GLint, arg_128: GLint, arg_129: GLsizei, arg_130: GLint) void {
    return glad_glCopyTexImage1D.?(arg_124, arg_125, arg_126, arg_127, arg_128, arg_129, arg_130);
}
pub inline fn glCopyTexImage2D(arg_131: GLenum, arg_132: GLint, arg_133: GLenum, arg_134: GLint, arg_135: GLint, arg_136: GLsizei, arg_137: GLsizei, arg_138: GLint) void {
    return glad_glCopyTexImage2D.?(arg_131, arg_132, arg_133, arg_134, arg_135, arg_136, arg_137, arg_138);
}
pub inline fn glCopyTexSubImage1D(arg_139: GLenum, arg_140: GLint, arg_141: GLint, arg_142: GLint, arg_143: GLint, arg_144: GLsizei) void {
    return glad_glCopyTexSubImage1D.?(arg_139, arg_140, arg_141, arg_142, arg_143, arg_144);
}
pub inline fn glCopyTexSubImage2D(arg_145: GLenum, arg_146: GLint, arg_147: GLint, arg_148: GLint, arg_149: GLint, arg_150: GLint, arg_151: GLsizei, arg_152: GLsizei) void {
    return glad_glCopyTexSubImage2D.?(arg_145, arg_146, arg_147, arg_148, arg_149, arg_150, arg_151, arg_152);
}
pub inline fn glTexSubImage1D(arg_153: GLenum, arg_154: GLint, arg_155: GLint, arg_156: GLsizei, arg_157: GLenum, arg_158: GLenum, arg_159: ?*const anyopaque) void {
    return glad_glTexSubImage1D.?(arg_153, arg_154, arg_155, arg_156, arg_157, arg_158, arg_159);
}
pub inline fn glTexSubImage2D(arg_160: GLenum, arg_161: GLint, arg_162: GLint, arg_163: GLint, arg_164: GLsizei, arg_165: GLsizei, arg_166: GLenum, arg_167: GLenum, arg_168: ?*const anyopaque) void {
    return glad_glTexSubImage2D.?(arg_160, arg_161, arg_162, arg_163, arg_164, arg_165, arg_166, arg_167, arg_168);
}
pub inline fn glBindTexture(arg_169: GLenum, arg_170: GLuint) void {
    return glad_glBindTexture.?(arg_169, arg_170);
}
pub inline fn glDeleteTextures(arg_171: GLsizei, arg_172: [*c]const GLuint) void {
    return glad_glDeleteTextures.?(arg_171, arg_172);
}
pub inline fn glGenTextures(arg_173: GLsizei, arg_174: [*c]GLuint) void {
    return glad_glGenTextures.?(arg_173, arg_174);
}
pub inline fn glIsTexture(arg_175: GLuint) GLboolean {
    return glad_glIsTexture.?(arg_175);
}
pub const GL_VERSION_1_2 = @as(c_int, 1);
pub inline fn glDrawRangeElements(arg_176: GLenum, arg_177: GLuint, arg_178: GLuint, arg_179: GLsizei, arg_180: GLenum, arg_181: ?*const anyopaque) void {
    return glad_glDrawRangeElements.?(arg_176, arg_177, arg_178, arg_179, arg_180, arg_181);
}
pub inline fn glTexImage3D(arg_182: GLenum, arg_183: GLint, arg_184: GLint, arg_185: GLsizei, arg_186: GLsizei, arg_187: GLsizei, arg_188: GLint, arg_189: GLenum, arg_190: GLenum, arg_191: ?*const anyopaque) void {
    return glad_glTexImage3D.?(arg_182, arg_183, arg_184, arg_185, arg_186, arg_187, arg_188, arg_189, arg_190, arg_191);
}
pub inline fn glTexSubImage3D(arg_192: GLenum, arg_193: GLint, arg_194: GLint, arg_195: GLint, arg_196: GLint, arg_197: GLsizei, arg_198: GLsizei, arg_199: GLsizei, arg_200: GLenum, arg_201: GLenum, arg_202: ?*const anyopaque) void {
    return glad_glTexSubImage3D.?(arg_192, arg_193, arg_194, arg_195, arg_196, arg_197, arg_198, arg_199, arg_200, arg_201, arg_202);
}
pub inline fn glCopyTexSubImage3D(arg_203: GLenum, arg_204: GLint, arg_205: GLint, arg_206: GLint, arg_207: GLint, arg_208: GLint, arg_209: GLint, arg_210: GLsizei, arg_211: GLsizei) void {
    return glad_glCopyTexSubImage3D.?(arg_203, arg_204, arg_205, arg_206, arg_207, arg_208, arg_209, arg_210, arg_211);
}
pub const GL_VERSION_1_3 = @as(c_int, 1);
pub inline fn glActiveTexture(arg_212: GLenum) void {
    return glad_glActiveTexture.?(arg_212);
}
pub inline fn glSampleCoverage(arg_213: GLfloat, arg_214: GLboolean) void {
    return glad_glSampleCoverage.?(arg_213, arg_214);
}
pub inline fn glCompressedTexImage3D(arg_215: GLenum, arg_216: GLint, arg_217: GLenum, arg_218: GLsizei, arg_219: GLsizei, arg_220: GLsizei, arg_221: GLint, arg_222: GLsizei, arg_223: ?*const anyopaque) void {
    return glad_glCompressedTexImage3D.?(arg_215, arg_216, arg_217, arg_218, arg_219, arg_220, arg_221, arg_222, arg_223);
}
pub inline fn glCompressedTexImage2D(arg_224: GLenum, arg_225: GLint, arg_226: GLenum, arg_227: GLsizei, arg_228: GLsizei, arg_229: GLint, arg_230: GLsizei, arg_231: ?*const anyopaque) void {
    return glad_glCompressedTexImage2D.?(arg_224, arg_225, arg_226, arg_227, arg_228, arg_229, arg_230, arg_231);
}
pub inline fn glCompressedTexImage1D(arg_232: GLenum, arg_233: GLint, arg_234: GLenum, arg_235: GLsizei, arg_236: GLint, arg_237: GLsizei, arg_238: ?*const anyopaque) void {
    return glad_glCompressedTexImage1D.?(arg_232, arg_233, arg_234, arg_235, arg_236, arg_237, arg_238);
}
pub inline fn glCompressedTexSubImage3D(arg_239: GLenum, arg_240: GLint, arg_241: GLint, arg_242: GLint, arg_243: GLint, arg_244: GLsizei, arg_245: GLsizei, arg_246: GLsizei, arg_247: GLenum, arg_248: GLsizei, arg_249: ?*const anyopaque) void {
    return glad_glCompressedTexSubImage3D.?(arg_239, arg_240, arg_241, arg_242, arg_243, arg_244, arg_245, arg_246, arg_247, arg_248, arg_249);
}
pub inline fn glCompressedTexSubImage2D(arg_250: GLenum, arg_251: GLint, arg_252: GLint, arg_253: GLint, arg_254: GLsizei, arg_255: GLsizei, arg_256: GLenum, arg_257: GLsizei, arg_258: ?*const anyopaque) void {
    return glad_glCompressedTexSubImage2D.?(arg_250, arg_251, arg_252, arg_253, arg_254, arg_255, arg_256, arg_257, arg_258);
}
pub inline fn glCompressedTexSubImage1D(arg_259: GLenum, arg_260: GLint, arg_261: GLint, arg_262: GLsizei, arg_263: GLenum, arg_264: GLsizei, arg_265: ?*const anyopaque) void {
    return glad_glCompressedTexSubImage1D.?(arg_259, arg_260, arg_261, arg_262, arg_263, arg_264, arg_265);
}
pub inline fn glGetCompressedTexImage(arg_266: GLenum, arg_267: GLint, arg_268: ?*anyopaque) void {
    return glad_glGetCompressedTexImage.?(arg_266, arg_267, arg_268);
}
pub const GL_VERSION_1_4 = @as(c_int, 1);
pub inline fn glBlendFuncSeparate(arg_269: GLenum, arg_270: GLenum, arg_271: GLenum, arg_272: GLenum) void {
    return glad_glBlendFuncSeparate.?(arg_269, arg_270, arg_271, arg_272);
}
pub inline fn glMultiDrawArrays(arg_273: GLenum, arg_274: [*c]const GLint, arg_275: [*c]const GLsizei, arg_276: GLsizei) void {
    return glad_glMultiDrawArrays.?(arg_273, arg_274, arg_275, arg_276);
}
pub inline fn glMultiDrawElements(arg_277: GLenum, arg_278: [*c]const GLsizei, arg_279: GLenum, arg_280: [*c]const ?*const anyopaque, arg_281: GLsizei) void {
    return glad_glMultiDrawElements.?(arg_277, arg_278, arg_279, arg_280, arg_281);
}
pub inline fn glPointParameterf(arg_282: GLenum, arg_283: GLfloat) void {
    return glad_glPointParameterf.?(arg_282, arg_283);
}
pub inline fn glPointParameterfv(arg_284: GLenum, arg_285: [*c]const GLfloat) void {
    return glad_glPointParameterfv.?(arg_284, arg_285);
}
pub inline fn glPointParameteri(arg_286: GLenum, arg_287: GLint) void {
    return glad_glPointParameteri.?(arg_286, arg_287);
}
pub inline fn glPointParameteriv(arg_288: GLenum, arg_289: [*c]const GLint) void {
    return glad_glPointParameteriv.?(arg_288, arg_289);
}
pub inline fn glBlendColor(arg_290: GLfloat, arg_291: GLfloat, arg_292: GLfloat, arg_293: GLfloat) void {
    return glad_glBlendColor.?(arg_290, arg_291, arg_292, arg_293);
}
pub inline fn glBlendEquation(arg_294: GLenum) void {
    return glad_glBlendEquation.?(arg_294);
}
pub const GL_VERSION_1_5 = @as(c_int, 1);
pub inline fn glGenQueries(arg_295: GLsizei, arg_296: [*c]GLuint) void {
    return glad_glGenQueries.?(arg_295, arg_296);
}
pub inline fn glDeleteQueries(arg_297: GLsizei, arg_298: [*c]const GLuint) void {
    return glad_glDeleteQueries.?(arg_297, arg_298);
}
pub inline fn glIsQuery(arg_299: GLuint) GLboolean {
    return glad_glIsQuery.?(arg_299);
}
pub inline fn glBeginQuery(arg_300: GLenum, arg_301: GLuint) void {
    return glad_glBeginQuery.?(arg_300, arg_301);
}
pub inline fn glEndQuery(arg_302: GLenum) void {
    return glad_glEndQuery.?(arg_302);
}
pub inline fn glGetQueryiv(arg_303: GLenum, arg_304: GLenum, arg_305: [*c]GLint) void {
    return glad_glGetQueryiv.?(arg_303, arg_304, arg_305);
}
pub inline fn glGetQueryObjectiv(arg_306: GLuint, arg_307: GLenum, arg_308: [*c]GLint) void {
    return glad_glGetQueryObjectiv.?(arg_306, arg_307, arg_308);
}
pub inline fn glGetQueryObjectuiv(arg_309: GLuint, arg_310: GLenum, arg_311: [*c]GLuint) void {
    return glad_glGetQueryObjectuiv.?(arg_309, arg_310, arg_311);
}
pub inline fn glBindBuffer(arg_312: GLenum, arg_313: GLuint) void {
    return glad_glBindBuffer.?(arg_312, arg_313);
}
pub inline fn glDeleteBuffers(arg_314: GLsizei, arg_315: [*c]const GLuint) void {
    return glad_glDeleteBuffers.?(arg_314, arg_315);
}
pub inline fn glGenBuffers(arg_316: GLsizei, arg_317: [*c]GLuint) void {
    return glad_glGenBuffers.?(arg_316, arg_317);
}
pub inline fn glIsBuffer(arg_318: GLuint) GLboolean {
    return glad_glIsBuffer.?(arg_318);
}
pub inline fn glBufferData(arg_319: GLenum, arg_320: GLsizeiptr, arg_321: ?*const anyopaque, arg_322: GLenum) void {
    return glad_glBufferData.?(arg_319, arg_320, arg_321, arg_322);
}
pub inline fn glBufferSubData(arg_323: GLenum, arg_324: GLintptr, arg_325: GLsizeiptr, arg_326: ?*const anyopaque) void {
    return glad_glBufferSubData.?(arg_323, arg_324, arg_325, arg_326);
}
pub inline fn glGetBufferSubData(arg_327: GLenum, arg_328: GLintptr, arg_329: GLsizeiptr, arg_330: ?*anyopaque) void {
    return glad_glGetBufferSubData.?(arg_327, arg_328, arg_329, arg_330);
}
pub inline fn glMapBuffer(arg_331: GLenum, arg_332: GLenum) ?*anyopaque {
    return glad_glMapBuffer.?(arg_331, arg_332);
}
pub inline fn glUnmapBuffer(arg_333: GLenum) GLboolean {
    return glad_glUnmapBuffer.?(arg_333);
}
pub inline fn glGetBufferParameteriv(arg_334: GLenum, arg_335: GLenum, arg_336: [*c]GLint) void {
    return glad_glGetBufferParameteriv.?(arg_334, arg_335, arg_336);
}
pub inline fn glGetBufferPointerv(arg_337: GLenum, arg_338: GLenum, arg_339: [*c]?*anyopaque) void {
    return glad_glGetBufferPointerv.?(arg_337, arg_338, arg_339);
}
pub const GL_VERSION_2_0 = @as(c_int, 1);
pub inline fn glBlendEquationSeparate(arg_340: GLenum, arg_341: GLenum) void {
    return glad_glBlendEquationSeparate.?(arg_340, arg_341);
}
pub inline fn glDrawBuffers(arg_342: GLsizei, arg_343: [*c]const GLenum) void {
    return glad_glDrawBuffers.?(arg_342, arg_343);
}
pub inline fn glStencilOpSeparate(arg_344: GLenum, arg_345: GLenum, arg_346: GLenum, arg_347: GLenum) void {
    return glad_glStencilOpSeparate.?(arg_344, arg_345, arg_346, arg_347);
}
pub inline fn glStencilFuncSeparate(arg_348: GLenum, arg_349: GLenum, arg_350: GLint, arg_351: GLuint) void {
    return glad_glStencilFuncSeparate.?(arg_348, arg_349, arg_350, arg_351);
}
pub inline fn glStencilMaskSeparate(arg_352: GLenum, arg_353: GLuint) void {
    return glad_glStencilMaskSeparate.?(arg_352, arg_353);
}
pub inline fn glAttachShader(arg_354: GLuint, arg_355: GLuint) void {
    return glad_glAttachShader.?(arg_354, arg_355);
}
pub inline fn glBindAttribLocation(arg_356: GLuint, arg_357: GLuint, arg_358: [*c]const GLchar) void {
    return glad_glBindAttribLocation.?(arg_356, arg_357, arg_358);
}
pub inline fn glCompileShader(arg_359: GLuint) void {
    return glad_glCompileShader.?(arg_359);
}
pub inline fn glCreateProgram() GLuint {
    return glad_glCreateProgram.?();
}
pub inline fn glCreateShader(arg_360: GLenum) GLuint {
    return glad_glCreateShader.?(arg_360);
}
pub inline fn glDeleteProgram(arg_361: GLuint) void {
    return glad_glDeleteProgram.?(arg_361);
}
pub inline fn glDeleteShader(arg_362: GLuint) void {
    return glad_glDeleteShader.?(arg_362);
}
pub inline fn glDetachShader(arg_363: GLuint, arg_364: GLuint) void {
    return glad_glDetachShader.?(arg_363, arg_364);
}
pub inline fn glDisableVertexAttribArray(arg_365: GLuint) void {
    return glad_glDisableVertexAttribArray.?(arg_365);
}
pub inline fn glEnableVertexAttribArray(arg_366: GLuint) void {
    return glad_glEnableVertexAttribArray.?(arg_366);
}
pub inline fn glGetActiveAttrib(arg_367: GLuint, arg_368: GLuint, arg_369: GLsizei, arg_370: [*c]GLsizei, arg_371: [*c]GLint, arg_372: [*c]GLenum, arg_373: [*c]GLchar) void {
    return glad_glGetActiveAttrib.?(arg_367, arg_368, arg_369, arg_370, arg_371, arg_372, arg_373);
}
pub inline fn glGetActiveUniform(arg_374: GLuint, arg_375: GLuint, arg_376: GLsizei, arg_377: [*c]GLsizei, arg_378: [*c]GLint, arg_379: [*c]GLenum, arg_380: [*c]GLchar) void {
    return glad_glGetActiveUniform.?(arg_374, arg_375, arg_376, arg_377, arg_378, arg_379, arg_380);
}
pub inline fn glGetAttachedShaders(arg_381: GLuint, arg_382: GLsizei, arg_383: [*c]GLsizei, arg_384: [*c]GLuint) void {
    return glad_glGetAttachedShaders.?(arg_381, arg_382, arg_383, arg_384);
}
pub inline fn glGetAttribLocation(arg_385: GLuint, arg_386: [*c]const GLchar) GLint {
    return glad_glGetAttribLocation.?(arg_385, arg_386);
}
pub inline fn glGetProgramiv(arg_387: GLuint, arg_388: GLenum, arg_389: [*c]GLint) void {
    return glad_glGetProgramiv.?(arg_387, arg_388, arg_389);
}
pub inline fn glGetProgramInfoLog(arg_390: GLuint, arg_391: GLsizei, arg_392: [*c]GLsizei, arg_393: [*c]GLchar) void {
    return glad_glGetProgramInfoLog.?(arg_390, arg_391, arg_392, arg_393);
}
pub inline fn glGetShaderiv(arg_394: GLuint, arg_395: GLenum, arg_396: [*c]GLint) void {
    return glad_glGetShaderiv.?(arg_394, arg_395, arg_396);
}
pub inline fn glGetShaderInfoLog(arg_397: GLuint, arg_398: GLsizei, arg_399: [*c]GLsizei, arg_400: [*c]GLchar) void {
    return glad_glGetShaderInfoLog.?(arg_397, arg_398, arg_399, arg_400);
}
pub inline fn glGetShaderSource(arg_401: GLuint, arg_402: GLsizei, arg_403: [*c]GLsizei, arg_404: [*c]GLchar) void {
    return glad_glGetShaderSource.?(arg_401, arg_402, arg_403, arg_404);
}
pub inline fn glGetUniformLocation(arg_405: GLuint, arg_406: [*c]const GLchar) GLint {
    return glad_glGetUniformLocation.?(arg_405, arg_406);
}
pub inline fn glGetUniformfv(arg_407: GLuint, arg_408: GLint, arg_409: [*c]GLfloat) void {
    return glad_glGetUniformfv.?(arg_407, arg_408, arg_409);
}
pub inline fn glGetUniformiv(arg_410: GLuint, arg_411: GLint, arg_412: [*c]GLint) void {
    return glad_glGetUniformiv.?(arg_410, arg_411, arg_412);
}
pub inline fn glGetVertexAttribdv(arg_413: GLuint, arg_414: GLenum, arg_415: [*c]GLdouble) void {
    return glad_glGetVertexAttribdv.?(arg_413, arg_414, arg_415);
}
pub inline fn glGetVertexAttribfv(arg_416: GLuint, arg_417: GLenum, arg_418: [*c]GLfloat) void {
    return glad_glGetVertexAttribfv.?(arg_416, arg_417, arg_418);
}
pub inline fn glGetVertexAttribiv(arg_419: GLuint, arg_420: GLenum, arg_421: [*c]GLint) void {
    return glad_glGetVertexAttribiv.?(arg_419, arg_420, arg_421);
}
pub inline fn glGetVertexAttribPointerv(arg_422: GLuint, arg_423: GLenum, arg_424: [*c]?*anyopaque) void {
    return glad_glGetVertexAttribPointerv.?(arg_422, arg_423, arg_424);
}
pub inline fn glIsProgram(arg_425: GLuint) GLboolean {
    return glad_glIsProgram.?(arg_425);
}
pub inline fn glIsShader(arg_426: GLuint) GLboolean {
    return glad_glIsShader.?(arg_426);
}
pub inline fn glLinkProgram(arg_427: GLuint) void {
    return glad_glLinkProgram.?(arg_427);
}
pub inline fn glShaderSource(arg_428: GLuint, arg_429: GLsizei, arg_430: [*c]const [*c]const GLchar, arg_431: [*c]const GLint) void {
    return glad_glShaderSource.?(arg_428, arg_429, arg_430, arg_431);
}
pub inline fn glUseProgram(arg_432: GLuint) void {
    return glad_glUseProgram.?(arg_432);
}
pub inline fn glUniform1f(arg_433: GLint, arg_434: GLfloat) void {
    return glad_glUniform1f.?(arg_433, arg_434);
}
pub inline fn glUniform2f(arg_435: GLint, arg_436: GLfloat, arg_437: GLfloat) void {
    return glad_glUniform2f.?(arg_435, arg_436, arg_437);
}
pub inline fn glUniform3f(arg_438: GLint, arg_439: GLfloat, arg_440: GLfloat, arg_441: GLfloat) void {
    return glad_glUniform3f.?(arg_438, arg_439, arg_440, arg_441);
}
pub inline fn glUniform4f(arg_442: GLint, arg_443: GLfloat, arg_444: GLfloat, arg_445: GLfloat, arg_446: GLfloat) void {
    return glad_glUniform4f.?(arg_442, arg_443, arg_444, arg_445, arg_446);
}
pub inline fn glUniform1i(arg_447: GLint, arg_448: GLint) void {
    return glad_glUniform1i.?(arg_447, arg_448);
}
pub inline fn glUniform2i(arg_449: GLint, arg_450: GLint, arg_451: GLint) void {
    return glad_glUniform2i.?(arg_449, arg_450, arg_451);
}
pub inline fn glUniform3i(arg_452: GLint, arg_453: GLint, arg_454: GLint, arg_455: GLint) void {
    return glad_glUniform3i.?(arg_452, arg_453, arg_454, arg_455);
}
pub inline fn glUniform4i(arg_456: GLint, arg_457: GLint, arg_458: GLint, arg_459: GLint, arg_460: GLint) void {
    return glad_glUniform4i.?(arg_456, arg_457, arg_458, arg_459, arg_460);
}
pub inline fn glUniform1fv(arg_461: GLint, arg_462: GLsizei, arg_463: [*c]const GLfloat) void {
    return glad_glUniform1fv.?(arg_461, arg_462, arg_463);
}
pub inline fn glUniform2fv(arg_464: GLint, arg_465: GLsizei, arg_466: [*c]const GLfloat) void {
    return glad_glUniform2fv.?(arg_464, arg_465, arg_466);
}
pub inline fn glUniform3fv(arg_467: GLint, arg_468: GLsizei, arg_469: [*c]const GLfloat) void {
    return glad_glUniform3fv.?(arg_467, arg_468, arg_469);
}
pub inline fn glUniform4fv(arg_470: GLint, arg_471: GLsizei, arg_472: [*c]const GLfloat) void {
    return glad_glUniform4fv.?(arg_470, arg_471, arg_472);
}
pub inline fn glUniform1iv(arg_473: GLint, arg_474: GLsizei, arg_475: [*c]const GLint) void {
    return glad_glUniform1iv.?(arg_473, arg_474, arg_475);
}
pub inline fn glUniform2iv(arg_476: GLint, arg_477: GLsizei, arg_478: [*c]const GLint) void {
    return glad_glUniform2iv.?(arg_476, arg_477, arg_478);
}
pub inline fn glUniform3iv(arg_479: GLint, arg_480: GLsizei, arg_481: [*c]const GLint) void {
    return glad_glUniform3iv.?(arg_479, arg_480, arg_481);
}
pub inline fn glUniform4iv(arg_482: GLint, arg_483: GLsizei, arg_484: [*c]const GLint) void {
    return glad_glUniform4iv.?(arg_482, arg_483, arg_484);
}
pub inline fn glUniformMatrix2fv(arg_485: GLint, arg_486: GLsizei, arg_487: GLboolean, arg_488: [*c]const GLfloat) void {
    return glad_glUniformMatrix2fv.?(arg_485, arg_486, arg_487, arg_488);
}
pub inline fn glUniformMatrix3fv(arg_489: GLint, arg_490: GLsizei, arg_491: GLboolean, arg_492: [*c]const GLfloat) void {
    return glad_glUniformMatrix3fv.?(arg_489, arg_490, arg_491, arg_492);
}
pub inline fn glUniformMatrix4fv(arg_493: GLint, arg_494: GLsizei, arg_495: GLboolean, arg_496: [*c]const GLfloat) void {
    return glad_glUniformMatrix4fv.?(arg_493, arg_494, arg_495, arg_496);
}
pub inline fn glValidateProgram(arg_497: GLuint) void {
    return glad_glValidateProgram.?(arg_497);
}
pub inline fn glVertexAttrib1d(arg_498: GLuint, arg_499: GLdouble) void {
    return glad_glVertexAttrib1d.?(arg_498, arg_499);
}
pub inline fn glVertexAttrib1dv(arg_500: GLuint, arg_501: [*c]const GLdouble) void {
    return glad_glVertexAttrib1dv.?(arg_500, arg_501);
}
pub inline fn glVertexAttrib1f(arg_502: GLuint, arg_503: GLfloat) void {
    return glad_glVertexAttrib1f.?(arg_502, arg_503);
}
pub inline fn glVertexAttrib1fv(arg_504: GLuint, arg_505: [*c]const GLfloat) void {
    return glad_glVertexAttrib1fv.?(arg_504, arg_505);
}
pub inline fn glVertexAttrib1s(arg_506: GLuint, arg_507: GLshort) void {
    return glad_glVertexAttrib1s.?(arg_506, arg_507);
}
pub inline fn glVertexAttrib1sv(arg_508: GLuint, arg_509: [*c]const GLshort) void {
    return glad_glVertexAttrib1sv.?(arg_508, arg_509);
}
pub inline fn glVertexAttrib2d(arg_510: GLuint, arg_511: GLdouble, arg_512: GLdouble) void {
    return glad_glVertexAttrib2d.?(arg_510, arg_511, arg_512);
}
pub inline fn glVertexAttrib2dv(arg_513: GLuint, arg_514: [*c]const GLdouble) void {
    return glad_glVertexAttrib2dv.?(arg_513, arg_514);
}
pub inline fn glVertexAttrib2f(arg_515: GLuint, arg_516: GLfloat, arg_517: GLfloat) void {
    return glad_glVertexAttrib2f.?(arg_515, arg_516, arg_517);
}
pub inline fn glVertexAttrib2fv(arg_518: GLuint, arg_519: [*c]const GLfloat) void {
    return glad_glVertexAttrib2fv.?(arg_518, arg_519);
}
pub inline fn glVertexAttrib2s(arg_520: GLuint, arg_521: GLshort, arg_522: GLshort) void {
    return glad_glVertexAttrib2s.?(arg_520, arg_521, arg_522);
}
pub inline fn glVertexAttrib2sv(arg_523: GLuint, arg_524: [*c]const GLshort) void {
    return glad_glVertexAttrib2sv.?(arg_523, arg_524);
}
pub inline fn glVertexAttrib3d(arg_525: GLuint, arg_526: GLdouble, arg_527: GLdouble, arg_528: GLdouble) void {
    return glad_glVertexAttrib3d.?(arg_525, arg_526, arg_527, arg_528);
}
pub inline fn glVertexAttrib3dv(arg_529: GLuint, arg_530: [*c]const GLdouble) void {
    return glad_glVertexAttrib3dv.?(arg_529, arg_530);
}
pub inline fn glVertexAttrib3f(arg_531: GLuint, arg_532: GLfloat, arg_533: GLfloat, arg_534: GLfloat) void {
    return glad_glVertexAttrib3f.?(arg_531, arg_532, arg_533, arg_534);
}
pub inline fn glVertexAttrib3fv(arg_535: GLuint, arg_536: [*c]const GLfloat) void {
    return glad_glVertexAttrib3fv.?(arg_535, arg_536);
}
pub inline fn glVertexAttrib3s(arg_537: GLuint, arg_538: GLshort, arg_539: GLshort, arg_540: GLshort) void {
    return glad_glVertexAttrib3s.?(arg_537, arg_538, arg_539, arg_540);
}
pub inline fn glVertexAttrib3sv(arg_541: GLuint, arg_542: [*c]const GLshort) void {
    return glad_glVertexAttrib3sv.?(arg_541, arg_542);
}
pub inline fn glVertexAttrib4Nbv(arg_543: GLuint, arg_544: [*c]const GLbyte) void {
    return glad_glVertexAttrib4Nbv.?(arg_543, arg_544);
}
pub inline fn glVertexAttrib4Niv(arg_545: GLuint, arg_546: [*c]const GLint) void {
    return glad_glVertexAttrib4Niv.?(arg_545, arg_546);
}
pub inline fn glVertexAttrib4Nsv(arg_547: GLuint, arg_548: [*c]const GLshort) void {
    return glad_glVertexAttrib4Nsv.?(arg_547, arg_548);
}
pub inline fn glVertexAttrib4Nub(arg_549: GLuint, arg_550: GLubyte, arg_551: GLubyte, arg_552: GLubyte, arg_553: GLubyte) void {
    return glad_glVertexAttrib4Nub.?(arg_549, arg_550, arg_551, arg_552, arg_553);
}
pub inline fn glVertexAttrib4Nubv(arg_554: GLuint, arg_555: [*c]const GLubyte) void {
    return glad_glVertexAttrib4Nubv.?(arg_554, arg_555);
}
pub inline fn glVertexAttrib4Nuiv(arg_556: GLuint, arg_557: [*c]const GLuint) void {
    return glad_glVertexAttrib4Nuiv.?(arg_556, arg_557);
}
pub inline fn glVertexAttrib4Nusv(arg_558: GLuint, arg_559: [*c]const GLushort) void {
    return glad_glVertexAttrib4Nusv.?(arg_558, arg_559);
}
pub inline fn glVertexAttrib4bv(arg_560: GLuint, arg_561: [*c]const GLbyte) void {
    return glad_glVertexAttrib4bv.?(arg_560, arg_561);
}
pub inline fn glVertexAttrib4d(arg_562: GLuint, arg_563: GLdouble, arg_564: GLdouble, arg_565: GLdouble, arg_566: GLdouble) void {
    return glad_glVertexAttrib4d.?(arg_562, arg_563, arg_564, arg_565, arg_566);
}
pub inline fn glVertexAttrib4dv(arg_567: GLuint, arg_568: [*c]const GLdouble) void {
    return glad_glVertexAttrib4dv.?(arg_567, arg_568);
}
pub inline fn glVertexAttrib4f(arg_569: GLuint, arg_570: GLfloat, arg_571: GLfloat, arg_572: GLfloat, arg_573: GLfloat) void {
    return glad_glVertexAttrib4f.?(arg_569, arg_570, arg_571, arg_572, arg_573);
}
pub inline fn glVertexAttrib4fv(arg_574: GLuint, arg_575: [*c]const GLfloat) void {
    return glad_glVertexAttrib4fv.?(arg_574, arg_575);
}
pub inline fn glVertexAttrib4iv(arg_576: GLuint, arg_577: [*c]const GLint) void {
    return glad_glVertexAttrib4iv.?(arg_576, arg_577);
}
pub inline fn glVertexAttrib4s(arg_578: GLuint, arg_579: GLshort, arg_580: GLshort, arg_581: GLshort, arg_582: GLshort) void {
    return glad_glVertexAttrib4s.?(arg_578, arg_579, arg_580, arg_581, arg_582);
}
pub inline fn glVertexAttrib4sv(arg_583: GLuint, arg_584: [*c]const GLshort) void {
    return glad_glVertexAttrib4sv.?(arg_583, arg_584);
}
pub inline fn glVertexAttrib4ubv(arg_585: GLuint, arg_586: [*c]const GLubyte) void {
    return glad_glVertexAttrib4ubv.?(arg_585, arg_586);
}
pub inline fn glVertexAttrib4uiv(arg_587: GLuint, arg_588: [*c]const GLuint) void {
    return glad_glVertexAttrib4uiv.?(arg_587, arg_588);
}
pub inline fn glVertexAttrib4usv(arg_589: GLuint, arg_590: [*c]const GLushort) void {
    return glad_glVertexAttrib4usv.?(arg_589, arg_590);
}
pub inline fn glVertexAttribPointer(arg_591: GLuint, arg_592: GLint, arg_593: GLenum, arg_594: GLboolean, arg_595: GLsizei, arg_596: ?*const anyopaque) void {
    return glad_glVertexAttribPointer.?(arg_591, arg_592, arg_593, arg_594, arg_595, arg_596);
}
pub const GL_VERSION_2_1 = @as(c_int, 1);
pub inline fn glUniformMatrix2x3fv(arg_597: GLint, arg_598: GLsizei, arg_599: GLboolean, arg_600: [*c]const GLfloat) void {
    return glad_glUniformMatrix2x3fv.?(arg_597, arg_598, arg_599, arg_600);
}
pub inline fn glUniformMatrix3x2fv(arg_601: GLint, arg_602: GLsizei, arg_603: GLboolean, arg_604: [*c]const GLfloat) void {
    return glad_glUniformMatrix3x2fv.?(arg_601, arg_602, arg_603, arg_604);
}
pub inline fn glUniformMatrix2x4fv(arg_605: GLint, arg_606: GLsizei, arg_607: GLboolean, arg_608: [*c]const GLfloat) void {
    return glad_glUniformMatrix2x4fv.?(arg_605, arg_606, arg_607, arg_608);
}
pub inline fn glUniformMatrix4x2fv(arg_609: GLint, arg_610: GLsizei, arg_611: GLboolean, arg_612: [*c]const GLfloat) void {
    return glad_glUniformMatrix4x2fv.?(arg_609, arg_610, arg_611, arg_612);
}
pub inline fn glUniformMatrix3x4fv(arg_613: GLint, arg_614: GLsizei, arg_615: GLboolean, arg_616: [*c]const GLfloat) void {
    return glad_glUniformMatrix3x4fv.?(arg_613, arg_614, arg_615, arg_616);
}
pub inline fn glUniformMatrix4x3fv(arg_617: GLint, arg_618: GLsizei, arg_619: GLboolean, arg_620: [*c]const GLfloat) void {
    return glad_glUniformMatrix4x3fv.?(arg_617, arg_618, arg_619, arg_620);
}
pub const GL_VERSION_3_0 = @as(c_int, 1);
pub inline fn glColorMaski(arg_621: GLuint, arg_622: GLboolean, arg_623: GLboolean, arg_624: GLboolean, arg_625: GLboolean) void {
    return glad_glColorMaski.?(arg_621, arg_622, arg_623, arg_624, arg_625);
}
pub inline fn glGetBooleani_v(arg_626: GLenum, arg_627: GLuint, arg_628: [*c]GLboolean) void {
    return glad_glGetBooleani_v.?(arg_626, arg_627, arg_628);
}
pub inline fn glGetIntegeri_v(arg_629: GLenum, arg_630: GLuint, arg_631: [*c]GLint) void {
    return glad_glGetIntegeri_v.?(arg_629, arg_630, arg_631);
}
pub inline fn glEnablei(arg_632: GLenum, arg_633: GLuint) void {
    return glad_glEnablei.?(arg_632, arg_633);
}
pub inline fn glDisablei(arg_634: GLenum, arg_635: GLuint) void {
    return glad_glDisablei.?(arg_634, arg_635);
}
pub inline fn glIsEnabledi(arg_636: GLenum, arg_637: GLuint) GLboolean {
    return glad_glIsEnabledi.?(arg_636, arg_637);
}
pub inline fn glBeginTransformFeedback(arg_638: GLenum) void {
    return glad_glBeginTransformFeedback.?(arg_638);
}
pub inline fn glEndTransformFeedback() void {
    return glad_glEndTransformFeedback.?();
}
pub inline fn glBindBufferRange(arg_639: GLenum, arg_640: GLuint, arg_641: GLuint, arg_642: GLintptr, arg_643: GLsizeiptr) void {
    return glad_glBindBufferRange.?(arg_639, arg_640, arg_641, arg_642, arg_643);
}
pub inline fn glBindBufferBase(arg_644: GLenum, arg_645: GLuint, arg_646: GLuint) void {
    return glad_glBindBufferBase.?(arg_644, arg_645, arg_646);
}
pub inline fn glTransformFeedbackVaryings(arg_647: GLuint, arg_648: GLsizei, arg_649: [*c]const [*c]const GLchar, arg_650: GLenum) void {
    return glad_glTransformFeedbackVaryings.?(arg_647, arg_648, arg_649, arg_650);
}
pub inline fn glGetTransformFeedbackVarying(arg_651: GLuint, arg_652: GLuint, arg_653: GLsizei, arg_654: [*c]GLsizei, arg_655: [*c]GLsizei, arg_656: [*c]GLenum, arg_657: [*c]GLchar) void {
    return glad_glGetTransformFeedbackVarying.?(arg_651, arg_652, arg_653, arg_654, arg_655, arg_656, arg_657);
}
pub inline fn glClampColor(arg_658: GLenum, arg_659: GLenum) void {
    return glad_glClampColor.?(arg_658, arg_659);
}
pub inline fn glBeginConditionalRender(arg_660: GLuint, arg_661: GLenum) void {
    return glad_glBeginConditionalRender.?(arg_660, arg_661);
}
pub inline fn glEndConditionalRender() void {
    return glad_glEndConditionalRender.?();
}
pub inline fn glVertexAttribIPointer(arg_662: GLuint, arg_663: GLint, arg_664: GLenum, arg_665: GLsizei, arg_666: ?*const anyopaque) void {
    return glad_glVertexAttribIPointer.?(arg_662, arg_663, arg_664, arg_665, arg_666);
}
pub inline fn glGetVertexAttribIiv(arg_667: GLuint, arg_668: GLenum, arg_669: [*c]GLint) void {
    return glad_glGetVertexAttribIiv.?(arg_667, arg_668, arg_669);
}
pub inline fn glGetVertexAttribIuiv(arg_670: GLuint, arg_671: GLenum, arg_672: [*c]GLuint) void {
    return glad_glGetVertexAttribIuiv.?(arg_670, arg_671, arg_672);
}
pub inline fn glVertexAttribI1i(arg_673: GLuint, arg_674: GLint) void {
    return glad_glVertexAttribI1i.?(arg_673, arg_674);
}
pub inline fn glVertexAttribI2i(arg_675: GLuint, arg_676: GLint, arg_677: GLint) void {
    return glad_glVertexAttribI2i.?(arg_675, arg_676, arg_677);
}
pub inline fn glVertexAttribI3i(arg_678: GLuint, arg_679: GLint, arg_680: GLint, arg_681: GLint) void {
    return glad_glVertexAttribI3i.?(arg_678, arg_679, arg_680, arg_681);
}
pub inline fn glVertexAttribI4i(arg_682: GLuint, arg_683: GLint, arg_684: GLint, arg_685: GLint, arg_686: GLint) void {
    return glad_glVertexAttribI4i.?(arg_682, arg_683, arg_684, arg_685, arg_686);
}
pub inline fn glVertexAttribI1ui(arg_687: GLuint, arg_688: GLuint) void {
    return glad_glVertexAttribI1ui.?(arg_687, arg_688);
}
pub inline fn glVertexAttribI2ui(arg_689: GLuint, arg_690: GLuint, arg_691: GLuint) void {
    return glad_glVertexAttribI2ui.?(arg_689, arg_690, arg_691);
}
pub inline fn glVertexAttribI3ui(arg_692: GLuint, arg_693: GLuint, arg_694: GLuint, arg_695: GLuint) void {
    return glad_glVertexAttribI3ui.?(arg_692, arg_693, arg_694, arg_695);
}
pub inline fn glVertexAttribI4ui(arg_696: GLuint, arg_697: GLuint, arg_698: GLuint, arg_699: GLuint, arg_700: GLuint) void {
    return glad_glVertexAttribI4ui.?(arg_696, arg_697, arg_698, arg_699, arg_700);
}
pub inline fn glVertexAttribI1iv(arg_701: GLuint, arg_702: [*c]const GLint) void {
    return glad_glVertexAttribI1iv.?(arg_701, arg_702);
}
pub inline fn glVertexAttribI2iv(arg_703: GLuint, arg_704: [*c]const GLint) void {
    return glad_glVertexAttribI2iv.?(arg_703, arg_704);
}
pub inline fn glVertexAttribI3iv(arg_705: GLuint, arg_706: [*c]const GLint) void {
    return glad_glVertexAttribI3iv.?(arg_705, arg_706);
}
pub inline fn glVertexAttribI4iv(arg_707: GLuint, arg_708: [*c]const GLint) void {
    return glad_glVertexAttribI4iv.?(arg_707, arg_708);
}
pub inline fn glVertexAttribI1uiv(arg_709: GLuint, arg_710: [*c]const GLuint) void {
    return glad_glVertexAttribI1uiv.?(arg_709, arg_710);
}
pub inline fn glVertexAttribI2uiv(arg_711: GLuint, arg_712: [*c]const GLuint) void {
    return glad_glVertexAttribI2uiv.?(arg_711, arg_712);
}
pub inline fn glVertexAttribI3uiv(arg_713: GLuint, arg_714: [*c]const GLuint) void {
    return glad_glVertexAttribI3uiv.?(arg_713, arg_714);
}
pub inline fn glVertexAttribI4uiv(arg_715: GLuint, arg_716: [*c]const GLuint) void {
    return glad_glVertexAttribI4uiv.?(arg_715, arg_716);
}
pub inline fn glVertexAttribI4bv(arg_717: GLuint, arg_718: [*c]const GLbyte) void {
    return glad_glVertexAttribI4bv.?(arg_717, arg_718);
}
pub inline fn glVertexAttribI4sv(arg_719: GLuint, arg_720: [*c]const GLshort) void {
    return glad_glVertexAttribI4sv.?(arg_719, arg_720);
}
pub inline fn glVertexAttribI4ubv(arg_721: GLuint, arg_722: [*c]const GLubyte) void {
    return glad_glVertexAttribI4ubv.?(arg_721, arg_722);
}
pub inline fn glVertexAttribI4usv(arg_723: GLuint, arg_724: [*c]const GLushort) void {
    return glad_glVertexAttribI4usv.?(arg_723, arg_724);
}
pub inline fn glGetUniformuiv(arg_725: GLuint, arg_726: GLint, arg_727: [*c]GLuint) void {
    return glad_glGetUniformuiv.?(arg_725, arg_726, arg_727);
}
pub inline fn glBindFragDataLocation(arg_728: GLuint, arg_729: GLuint, arg_730: [*c]const GLchar) void {
    return glad_glBindFragDataLocation.?(arg_728, arg_729, arg_730);
}
pub inline fn glGetFragDataLocation(arg_731: GLuint, arg_732: [*c]const GLchar) GLint {
    return glad_glGetFragDataLocation.?(arg_731, arg_732);
}
pub inline fn glUniform1ui(arg_733: GLint, arg_734: GLuint) void {
    return glad_glUniform1ui.?(arg_733, arg_734);
}
pub inline fn glUniform2ui(arg_735: GLint, arg_736: GLuint, arg_737: GLuint) void {
    return glad_glUniform2ui.?(arg_735, arg_736, arg_737);
}
pub inline fn glUniform3ui(arg_738: GLint, arg_739: GLuint, arg_740: GLuint, arg_741: GLuint) void {
    return glad_glUniform3ui.?(arg_738, arg_739, arg_740, arg_741);
}
pub inline fn glUniform4ui(arg_742: GLint, arg_743: GLuint, arg_744: GLuint, arg_745: GLuint, arg_746: GLuint) void {
    return glad_glUniform4ui.?(arg_742, arg_743, arg_744, arg_745, arg_746);
}
pub inline fn glUniform1uiv(arg_747: GLint, arg_748: GLsizei, arg_749: [*c]const GLuint) void {
    return glad_glUniform1uiv.?(arg_747, arg_748, arg_749);
}
pub inline fn glUniform2uiv(arg_750: GLint, arg_751: GLsizei, arg_752: [*c]const GLuint) void {
    return glad_glUniform2uiv.?(arg_750, arg_751, arg_752);
}
pub inline fn glUniform3uiv(arg_753: GLint, arg_754: GLsizei, arg_755: [*c]const GLuint) void {
    return glad_glUniform3uiv.?(arg_753, arg_754, arg_755);
}
pub inline fn glUniform4uiv(arg_756: GLint, arg_757: GLsizei, arg_758: [*c]const GLuint) void {
    return glad_glUniform4uiv.?(arg_756, arg_757, arg_758);
}
pub inline fn glTexParameterIiv(arg_759: GLenum, arg_760: GLenum, arg_761: [*c]const GLint) void {
    return glad_glTexParameterIiv.?(arg_759, arg_760, arg_761);
}
pub inline fn glTexParameterIuiv(arg_762: GLenum, arg_763: GLenum, arg_764: [*c]const GLuint) void {
    return glad_glTexParameterIuiv.?(arg_762, arg_763, arg_764);
}
pub inline fn glGetTexParameterIiv(arg_765: GLenum, arg_766: GLenum, arg_767: [*c]GLint) void {
    return glad_glGetTexParameterIiv.?(arg_765, arg_766, arg_767);
}
pub inline fn glGetTexParameterIuiv(arg_768: GLenum, arg_769: GLenum, arg_770: [*c]GLuint) void {
    return glad_glGetTexParameterIuiv.?(arg_768, arg_769, arg_770);
}
pub inline fn glClearBufferiv(arg_771: GLenum, arg_772: GLint, arg_773: [*c]const GLint) void {
    return glad_glClearBufferiv.?(arg_771, arg_772, arg_773);
}
pub inline fn glClearBufferuiv(arg_774: GLenum, arg_775: GLint, arg_776: [*c]const GLuint) void {
    return glad_glClearBufferuiv.?(arg_774, arg_775, arg_776);
}
pub inline fn glClearBufferfv(arg_777: GLenum, arg_778: GLint, arg_779: [*c]const GLfloat) void {
    return glad_glClearBufferfv.?(arg_777, arg_778, arg_779);
}
pub inline fn glClearBufferfi(arg_780: GLenum, arg_781: GLint, arg_782: GLfloat, arg_783: GLint) void {
    return glad_glClearBufferfi.?(arg_780, arg_781, arg_782, arg_783);
}
pub inline fn glGetStringi(arg_784: GLenum, arg_785: GLuint) [*c]const GLubyte {
    return glad_glGetStringi.?(arg_784, arg_785);
}
pub inline fn glIsRenderbuffer(arg_786: GLuint) GLboolean {
    return glad_glIsRenderbuffer.?(arg_786);
}
pub inline fn glBindRenderbuffer(arg_787: GLenum, arg_788: GLuint) void {
    return glad_glBindRenderbuffer.?(arg_787, arg_788);
}
pub inline fn glDeleteRenderbuffers(arg_789: GLsizei, arg_790: [*c]const GLuint) void {
    return glad_glDeleteRenderbuffers.?(arg_789, arg_790);
}
pub inline fn glGenRenderbuffers(arg_791: GLsizei, arg_792: [*c]GLuint) void {
    return glad_glGenRenderbuffers.?(arg_791, arg_792);
}
pub inline fn glRenderbufferStorage(arg_793: GLenum, arg_794: GLenum, arg_795: GLsizei, arg_796: GLsizei) void {
    return glad_glRenderbufferStorage.?(arg_793, arg_794, arg_795, arg_796);
}
pub inline fn glGetRenderbufferParameteriv(arg_797: GLenum, arg_798: GLenum, arg_799: [*c]GLint) void {
    return glad_glGetRenderbufferParameteriv.?(arg_797, arg_798, arg_799);
}
pub inline fn glIsFramebuffer(arg_800: GLuint) GLboolean {
    return glad_glIsFramebuffer.?(arg_800);
}
pub inline fn glBindFramebuffer(arg_801: GLenum, arg_802: GLuint) void {
    return glad_glBindFramebuffer.?(arg_801, arg_802);
}
pub inline fn glDeleteFramebuffers(arg_803: GLsizei, arg_804: [*c]const GLuint) void {
    return glad_glDeleteFramebuffers.?(arg_803, arg_804);
}
pub inline fn glGenFramebuffers(arg_805: GLsizei, arg_806: [*c]GLuint) void {
    return glad_glGenFramebuffers.?(arg_805, arg_806);
}
pub inline fn glCheckFramebufferStatus(arg_807: GLenum) GLenum {
    return glad_glCheckFramebufferStatus.?(arg_807);
}
pub inline fn glFramebufferTexture1D(arg_808: GLenum, arg_809: GLenum, arg_810: GLenum, arg_811: GLuint, arg_812: GLint) void {
    return glad_glFramebufferTexture1D.?(arg_808, arg_809, arg_810, arg_811, arg_812);
}
pub inline fn glFramebufferTexture2D(arg_813: GLenum, arg_814: GLenum, arg_815: GLenum, arg_816: GLuint, arg_817: GLint) void {
    return glad_glFramebufferTexture2D.?(arg_813, arg_814, arg_815, arg_816, arg_817);
}
pub inline fn glFramebufferTexture3D(arg_818: GLenum, arg_819: GLenum, arg_820: GLenum, arg_821: GLuint, arg_822: GLint, arg_823: GLint) void {
    return glad_glFramebufferTexture3D.?(arg_818, arg_819, arg_820, arg_821, arg_822, arg_823);
}
pub inline fn glFramebufferRenderbuffer(arg_824: GLenum, arg_825: GLenum, arg_826: GLenum, arg_827: GLuint) void {
    return glad_glFramebufferRenderbuffer.?(arg_824, arg_825, arg_826, arg_827);
}
pub inline fn glGetFramebufferAttachmentParameteriv(arg_828: GLenum, arg_829: GLenum, arg_830: GLenum, arg_831: [*c]GLint) void {
    return glad_glGetFramebufferAttachmentParameteriv.?(arg_828, arg_829, arg_830, arg_831);
}
pub inline fn glGenerateMipmap(arg_832: GLenum) void {
    return glad_glGenerateMipmap.?(arg_832);
}
pub inline fn glBlitFramebuffer(arg_833: GLint, arg_834: GLint, arg_835: GLint, arg_836: GLint, arg_837: GLint, arg_838: GLint, arg_839: GLint, arg_840: GLint, arg_841: GLbitfield, arg_842: GLenum) void {
    return glad_glBlitFramebuffer.?(arg_833, arg_834, arg_835, arg_836, arg_837, arg_838, arg_839, arg_840, arg_841, arg_842);
}
pub inline fn glRenderbufferStorageMultisample(arg_843: GLenum, arg_844: GLsizei, arg_845: GLenum, arg_846: GLsizei, arg_847: GLsizei) void {
    return glad_glRenderbufferStorageMultisample.?(arg_843, arg_844, arg_845, arg_846, arg_847);
}
pub inline fn glFramebufferTextureLayer(arg_848: GLenum, arg_849: GLenum, arg_850: GLuint, arg_851: GLint, arg_852: GLint) void {
    return glad_glFramebufferTextureLayer.?(arg_848, arg_849, arg_850, arg_851, arg_852);
}
pub inline fn glMapBufferRange(arg_853: GLenum, arg_854: GLintptr, arg_855: GLsizeiptr, arg_856: GLbitfield) ?*anyopaque {
    return glad_glMapBufferRange.?(arg_853, arg_854, arg_855, arg_856);
}
pub inline fn glFlushMappedBufferRange(arg_857: GLenum, arg_858: GLintptr, arg_859: GLsizeiptr) void {
    return glad_glFlushMappedBufferRange.?(arg_857, arg_858, arg_859);
}
pub inline fn glBindVertexArray(arg_860: GLuint) void {
    return glad_glBindVertexArray.?(arg_860);
}
pub inline fn glDeleteVertexArrays(arg_861: GLsizei, arg_862: [*c]const GLuint) void {
    return glad_glDeleteVertexArrays.?(arg_861, arg_862);
}
pub inline fn glGenVertexArrays(arg_863: GLsizei, arg_864: [*c]GLuint) void {
    return glad_glGenVertexArrays.?(arg_863, arg_864);
}
pub inline fn glIsVertexArray(arg_865: GLuint) GLboolean {
    return glad_glIsVertexArray.?(arg_865);
}
pub const GL_VERSION_3_1 = @as(c_int, 1);
pub inline fn glDrawArraysInstanced(arg_866: GLenum, arg_867: GLint, arg_868: GLsizei, arg_869: GLsizei) void {
    return glad_glDrawArraysInstanced.?(arg_866, arg_867, arg_868, arg_869);
}
pub inline fn glDrawElementsInstanced(arg_870: GLenum, arg_871: GLsizei, arg_872: GLenum, arg_873: ?*const anyopaque, arg_874: GLsizei) void {
    return glad_glDrawElementsInstanced.?(arg_870, arg_871, arg_872, arg_873, arg_874);
}
pub inline fn glTexBuffer(arg_875: GLenum, arg_876: GLenum, arg_877: GLuint) void {
    return glad_glTexBuffer.?(arg_875, arg_876, arg_877);
}
pub inline fn glPrimitiveRestartIndex(arg_878: GLuint) void {
    return glad_glPrimitiveRestartIndex.?(arg_878);
}
pub inline fn glCopyBufferSubData(arg_879: GLenum, arg_880: GLenum, arg_881: GLintptr, arg_882: GLintptr, arg_883: GLsizeiptr) void {
    return glad_glCopyBufferSubData.?(arg_879, arg_880, arg_881, arg_882, arg_883);
}
pub inline fn glGetUniformIndices(arg_884: GLuint, arg_885: GLsizei, arg_886: [*c]const [*c]const GLchar, arg_887: [*c]GLuint) void {
    return glad_glGetUniformIndices.?(arg_884, arg_885, arg_886, arg_887);
}
pub inline fn glGetActiveUniformsiv(arg_888: GLuint, arg_889: GLsizei, arg_890: [*c]const GLuint, arg_891: GLenum, arg_892: [*c]GLint) void {
    return glad_glGetActiveUniformsiv.?(arg_888, arg_889, arg_890, arg_891, arg_892);
}
pub inline fn glGetActiveUniformName(arg_893: GLuint, arg_894: GLuint, arg_895: GLsizei, arg_896: [*c]GLsizei, arg_897: [*c]GLchar) void {
    return glad_glGetActiveUniformName.?(arg_893, arg_894, arg_895, arg_896, arg_897);
}
pub inline fn glGetUniformBlockIndex(arg_898: GLuint, arg_899: [*c]const GLchar) GLuint {
    return glad_glGetUniformBlockIndex.?(arg_898, arg_899);
}
pub inline fn glGetActiveUniformBlockiv(arg_900: GLuint, arg_901: GLuint, arg_902: GLenum, arg_903: [*c]GLint) void {
    return glad_glGetActiveUniformBlockiv.?(arg_900, arg_901, arg_902, arg_903);
}
pub inline fn glGetActiveUniformBlockName(arg_904: GLuint, arg_905: GLuint, arg_906: GLsizei, arg_907: [*c]GLsizei, arg_908: [*c]GLchar) void {
    return glad_glGetActiveUniformBlockName.?(arg_904, arg_905, arg_906, arg_907, arg_908);
}
pub inline fn glUniformBlockBinding(arg_909: GLuint, arg_910: GLuint, arg_911: GLuint) void {
    return glad_glUniformBlockBinding.?(arg_909, arg_910, arg_911);
}
pub const GL_VERSION_3_2 = @as(c_int, 1);
pub inline fn glDrawElementsBaseVertex(arg_912: GLenum, arg_913: GLsizei, arg_914: GLenum, arg_915: ?*const anyopaque, arg_916: GLint) void {
    return glad_glDrawElementsBaseVertex.?(arg_912, arg_913, arg_914, arg_915, arg_916);
}
pub inline fn glDrawRangeElementsBaseVertex(arg_917: GLenum, arg_918: GLuint, arg_919: GLuint, arg_920: GLsizei, arg_921: GLenum, arg_922: ?*const anyopaque, arg_923: GLint) void {
    return glad_glDrawRangeElementsBaseVertex.?(arg_917, arg_918, arg_919, arg_920, arg_921, arg_922, arg_923);
}
pub inline fn glDrawElementsInstancedBaseVertex(arg_924: GLenum, arg_925: GLsizei, arg_926: GLenum, arg_927: ?*const anyopaque, arg_928: GLsizei, arg_929: GLint) void {
    return glad_glDrawElementsInstancedBaseVertex.?(arg_924, arg_925, arg_926, arg_927, arg_928, arg_929);
}
pub inline fn glMultiDrawElementsBaseVertex(arg_930: GLenum, arg_931: [*c]const GLsizei, arg_932: GLenum, arg_933: [*c]const ?*const anyopaque, arg_934: GLsizei, arg_935: [*c]const GLint) void {
    return glad_glMultiDrawElementsBaseVertex.?(arg_930, arg_931, arg_932, arg_933, arg_934, arg_935);
}
pub inline fn glProvokingVertex(arg_936: GLenum) void {
    return glad_glProvokingVertex.?(arg_936);
}
pub inline fn glFenceSync(arg_937: GLenum, arg_938: GLbitfield) GLsync {
    return glad_glFenceSync.?(arg_937, arg_938);
}
pub inline fn glIsSync(arg_939: GLsync) GLboolean {
    return glad_glIsSync.?(arg_939);
}
pub inline fn glDeleteSync(arg_940: GLsync) void {
    return glad_glDeleteSync.?(arg_940);
}
pub inline fn glClientWaitSync(arg_941: GLsync, arg_942: GLbitfield, arg_943: GLuint64) GLenum {
    return glad_glClientWaitSync.?(arg_941, arg_942, arg_943);
}
pub inline fn glWaitSync(arg_944: GLsync, arg_945: GLbitfield, arg_946: GLuint64) void {
    return glad_glWaitSync.?(arg_944, arg_945, arg_946);
}
pub inline fn glGetInteger64v(arg_947: GLenum, arg_948: [*c]GLint64) void {
    return glad_glGetInteger64v.?(arg_947, arg_948);
}
pub inline fn glGetSynciv(arg_949: GLsync, arg_950: GLenum, arg_951: GLsizei, arg_952: [*c]GLsizei, arg_953: [*c]GLint) void {
    return glad_glGetSynciv.?(arg_949, arg_950, arg_951, arg_952, arg_953);
}
pub inline fn glGetInteger64i_v(arg_954: GLenum, arg_955: GLuint, arg_956: [*c]GLint64) void {
    return glad_glGetInteger64i_v.?(arg_954, arg_955, arg_956);
}
pub inline fn glGetBufferParameteri64v(arg_957: GLenum, arg_958: GLenum, arg_959: [*c]GLint64) void {
    return glad_glGetBufferParameteri64v.?(arg_957, arg_958, arg_959);
}
pub inline fn glFramebufferTexture(arg_960: GLenum, arg_961: GLenum, arg_962: GLuint, arg_963: GLint) void {
    return glad_glFramebufferTexture.?(arg_960, arg_961, arg_962, arg_963);
}
pub inline fn glTexImage2DMultisample(arg_964: GLenum, arg_965: GLsizei, arg_966: GLenum, arg_967: GLsizei, arg_968: GLsizei, arg_969: GLboolean) void {
    return glad_glTexImage2DMultisample.?(arg_964, arg_965, arg_966, arg_967, arg_968, arg_969);
}
pub inline fn glTexImage3DMultisample(arg_970: GLenum, arg_971: GLsizei, arg_972: GLenum, arg_973: GLsizei, arg_974: GLsizei, arg_975: GLsizei, arg_976: GLboolean) void {
    return glad_glTexImage3DMultisample.?(arg_970, arg_971, arg_972, arg_973, arg_974, arg_975, arg_976);
}
pub inline fn glGetMultisamplefv(arg_977: GLenum, arg_978: GLuint, arg_979: [*c]GLfloat) void {
    return glad_glGetMultisamplefv.?(arg_977, arg_978, arg_979);
}
pub inline fn glSampleMaski(arg_980: GLuint, arg_981: GLbitfield) void {
    return glad_glSampleMaski.?(arg_980, arg_981);
}
pub const GL_VERSION_3_3 = @as(c_int, 1);
pub inline fn glBindFragDataLocationIndexed(arg_982: GLuint, arg_983: GLuint, arg_984: GLuint, arg_985: [*c]const GLchar) void {
    return glad_glBindFragDataLocationIndexed.?(arg_982, arg_983, arg_984, arg_985);
}
pub inline fn glGetFragDataIndex(arg_986: GLuint, arg_987: [*c]const GLchar) GLint {
    return glad_glGetFragDataIndex.?(arg_986, arg_987);
}
pub inline fn glGenSamplers(arg_988: GLsizei, arg_989: [*c]GLuint) void {
    return glad_glGenSamplers.?(arg_988, arg_989);
}
pub inline fn glDeleteSamplers(arg_990: GLsizei, arg_991: [*c]const GLuint) void {
    return glad_glDeleteSamplers.?(arg_990, arg_991);
}
pub inline fn glIsSampler(arg_992: GLuint) GLboolean {
    return glad_glIsSampler.?(arg_992);
}
pub inline fn glBindSampler(arg_993: GLuint, arg_994: GLuint) void {
    return glad_glBindSampler.?(arg_993, arg_994);
}
pub inline fn glSamplerParameteri(arg_995: GLuint, arg_996: GLenum, arg_997: GLint) void {
    return glad_glSamplerParameteri.?(arg_995, arg_996, arg_997);
}
pub inline fn glSamplerParameteriv(arg_998: GLuint, arg_999: GLenum, arg_1000: [*c]const GLint) void {
    return glad_glSamplerParameteriv.?(arg_998, arg_999, arg_1000);
}
pub inline fn glSamplerParameterf(arg_1001: GLuint, arg_1002: GLenum, arg_1003: GLfloat) void {
    return glad_glSamplerParameterf.?(arg_1001, arg_1002, arg_1003);
}
pub inline fn glSamplerParameterfv(arg_1004: GLuint, arg_1005: GLenum, arg_1006: [*c]const GLfloat) void {
    return glad_glSamplerParameterfv.?(arg_1004, arg_1005, arg_1006);
}
pub inline fn glSamplerParameterIiv(arg_1007: GLuint, arg_1008: GLenum, arg_1009: [*c]const GLint) void {
    return glad_glSamplerParameterIiv.?(arg_1007, arg_1008, arg_1009);
}
pub inline fn glSamplerParameterIuiv(arg_1010: GLuint, arg_1011: GLenum, arg_1012: [*c]const GLuint) void {
    return glad_glSamplerParameterIuiv.?(arg_1010, arg_1011, arg_1012);
}
pub inline fn glGetSamplerParameteriv(arg_1013: GLuint, arg_1014: GLenum, arg_1015: [*c]GLint) void {
    return glad_glGetSamplerParameteriv.?(arg_1013, arg_1014, arg_1015);
}
pub inline fn glGetSamplerParameterIiv(arg_1016: GLuint, arg_1017: GLenum, arg_1018: [*c]GLint) void {
    return glad_glGetSamplerParameterIiv.?(arg_1016, arg_1017, arg_1018);
}
pub inline fn glGetSamplerParameterfv(arg_1019: GLuint, arg_1020: GLenum, arg_1021: [*c]GLfloat) void {
    return glad_glGetSamplerParameterfv.?(arg_1019, arg_1020, arg_1021);
}
pub inline fn glGetSamplerParameterIuiv(arg_1022: GLuint, arg_1023: GLenum, arg_1024: [*c]GLuint) void {
    return glad_glGetSamplerParameterIuiv.?(arg_1022, arg_1023, arg_1024);
}
pub inline fn glQueryCounter(arg_1025: GLuint, arg_1026: GLenum) void {
    return glad_glQueryCounter.?(arg_1025, arg_1026);
}
pub inline fn glGetQueryObjecti64v(arg_1027: GLuint, arg_1028: GLenum, arg_1029: [*c]GLint64) void {
    return glad_glGetQueryObjecti64v.?(arg_1027, arg_1028, arg_1029);
}
pub inline fn glGetQueryObjectui64v(arg_1030: GLuint, arg_1031: GLenum, arg_1032: [*c]GLuint64) void {
    return glad_glGetQueryObjectui64v.?(arg_1030, arg_1031, arg_1032);
}
pub inline fn glVertexAttribDivisor(arg_1033: GLuint, arg_1034: GLuint) void {
    return glad_glVertexAttribDivisor.?(arg_1033, arg_1034);
}
pub inline fn glVertexAttribP1ui(arg_1035: GLuint, arg_1036: GLenum, arg_1037: GLboolean, arg_1038: GLuint) void {
    return glad_glVertexAttribP1ui.?(arg_1035, arg_1036, arg_1037, arg_1038);
}
pub inline fn glVertexAttribP1uiv(arg_1039: GLuint, arg_1040: GLenum, arg_1041: GLboolean, arg_1042: [*c]const GLuint) void {
    return glad_glVertexAttribP1uiv.?(arg_1039, arg_1040, arg_1041, arg_1042);
}
pub inline fn glVertexAttribP2ui(arg_1043: GLuint, arg_1044: GLenum, arg_1045: GLboolean, arg_1046: GLuint) void {
    return glad_glVertexAttribP2ui.?(arg_1043, arg_1044, arg_1045, arg_1046);
}
pub inline fn glVertexAttribP2uiv(arg_1047: GLuint, arg_1048: GLenum, arg_1049: GLboolean, arg_1050: [*c]const GLuint) void {
    return glad_glVertexAttribP2uiv.?(arg_1047, arg_1048, arg_1049, arg_1050);
}
pub inline fn glVertexAttribP3ui(arg_1051: GLuint, arg_1052: GLenum, arg_1053: GLboolean, arg_1054: GLuint) void {
    return glad_glVertexAttribP3ui.?(arg_1051, arg_1052, arg_1053, arg_1054);
}
pub inline fn glVertexAttribP3uiv(arg_1055: GLuint, arg_1056: GLenum, arg_1057: GLboolean, arg_1058: [*c]const GLuint) void {
    return glad_glVertexAttribP3uiv.?(arg_1055, arg_1056, arg_1057, arg_1058);
}
pub inline fn glVertexAttribP4ui(arg_1059: GLuint, arg_1060: GLenum, arg_1061: GLboolean, arg_1062: GLuint) void {
    return glad_glVertexAttribP4ui.?(arg_1059, arg_1060, arg_1061, arg_1062);
}
pub inline fn glVertexAttribP4uiv(arg_1063: GLuint, arg_1064: GLenum, arg_1065: GLboolean, arg_1066: [*c]const GLuint) void {
    return glad_glVertexAttribP4uiv.?(arg_1063, arg_1064, arg_1065, arg_1066);
}
pub inline fn glVertexP2ui(arg_1067: GLenum, arg_1068: GLuint) void {
    return glad_glVertexP2ui.?(arg_1067, arg_1068);
}
pub inline fn glVertexP2uiv(arg_1069: GLenum, arg_1070: [*c]const GLuint) void {
    return glad_glVertexP2uiv.?(arg_1069, arg_1070);
}
pub inline fn glVertexP3ui(arg_1071: GLenum, arg_1072: GLuint) void {
    return glad_glVertexP3ui.?(arg_1071, arg_1072);
}
pub inline fn glVertexP3uiv(arg_1073: GLenum, arg_1074: [*c]const GLuint) void {
    return glad_glVertexP3uiv.?(arg_1073, arg_1074);
}
pub inline fn glVertexP4ui(arg_1075: GLenum, arg_1076: GLuint) void {
    return glad_glVertexP4ui.?(arg_1075, arg_1076);
}
pub inline fn glVertexP4uiv(arg_1077: GLenum, arg_1078: [*c]const GLuint) void {
    return glad_glVertexP4uiv.?(arg_1077, arg_1078);
}
pub inline fn glTexCoordP1ui(arg_1079: GLenum, arg_1080: GLuint) void {
    return glad_glTexCoordP1ui.?(arg_1079, arg_1080);
}
pub inline fn glTexCoordP1uiv(arg_1081: GLenum, arg_1082: [*c]const GLuint) void {
    return glad_glTexCoordP1uiv.?(arg_1081, arg_1082);
}
pub inline fn glTexCoordP2ui(arg_1083: GLenum, arg_1084: GLuint) void {
    return glad_glTexCoordP2ui.?(arg_1083, arg_1084);
}
pub inline fn glTexCoordP2uiv(arg_1085: GLenum, arg_1086: [*c]const GLuint) void {
    return glad_glTexCoordP2uiv.?(arg_1085, arg_1086);
}
pub inline fn glTexCoordP3ui(arg_1087: GLenum, arg_1088: GLuint) void {
    return glad_glTexCoordP3ui.?(arg_1087, arg_1088);
}
pub inline fn glTexCoordP3uiv(arg_1089: GLenum, arg_1090: [*c]const GLuint) void {
    return glad_glTexCoordP3uiv.?(arg_1089, arg_1090);
}
pub inline fn glTexCoordP4ui(arg_1091: GLenum, arg_1092: GLuint) void {
    return glad_glTexCoordP4ui.?(arg_1091, arg_1092);
}
pub inline fn glTexCoordP4uiv(arg_1093: GLenum, arg_1094: [*c]const GLuint) void {
    return glad_glTexCoordP4uiv.?(arg_1093, arg_1094);
}
pub inline fn glMultiTexCoordP1ui(arg_1095: GLenum, arg_1096: GLenum, arg_1097: GLuint) void {
    return glad_glMultiTexCoordP1ui.?(arg_1095, arg_1096, arg_1097);
}
pub inline fn glMultiTexCoordP1uiv(arg_1098: GLenum, arg_1099: GLenum, arg_1100: [*c]const GLuint) void {
    return glad_glMultiTexCoordP1uiv.?(arg_1098, arg_1099, arg_1100);
}
pub inline fn glMultiTexCoordP2ui(arg_1101: GLenum, arg_1102: GLenum, arg_1103: GLuint) void {
    return glad_glMultiTexCoordP2ui.?(arg_1101, arg_1102, arg_1103);
}
pub inline fn glMultiTexCoordP2uiv(arg_1104: GLenum, arg_1105: GLenum, arg_1106: [*c]const GLuint) void {
    return glad_glMultiTexCoordP2uiv.?(arg_1104, arg_1105, arg_1106);
}
pub inline fn glMultiTexCoordP3ui(arg_1107: GLenum, arg_1108: GLenum, arg_1109: GLuint) void {
    return glad_glMultiTexCoordP3ui.?(arg_1107, arg_1108, arg_1109);
}
pub inline fn glMultiTexCoordP3uiv(arg_1110: GLenum, arg_1111: GLenum, arg_1112: [*c]const GLuint) void {
    return glad_glMultiTexCoordP3uiv.?(arg_1110, arg_1111, arg_1112);
}
pub inline fn glMultiTexCoordP4ui(arg_1113: GLenum, arg_1114: GLenum, arg_1115: GLuint) void {
    return glad_glMultiTexCoordP4ui.?(arg_1113, arg_1114, arg_1115);
}
pub inline fn glMultiTexCoordP4uiv(arg_1116: GLenum, arg_1117: GLenum, arg_1118: [*c]const GLuint) void {
    return glad_glMultiTexCoordP4uiv.?(arg_1116, arg_1117, arg_1118);
}
pub inline fn glNormalP3ui(arg_1119: GLenum, arg_1120: GLuint) void {
    return glad_glNormalP3ui.?(arg_1119, arg_1120);
}
pub inline fn glNormalP3uiv(arg_1121: GLenum, arg_1122: [*c]const GLuint) void {
    return glad_glNormalP3uiv.?(arg_1121, arg_1122);
}
pub inline fn glColorP3ui(arg_1123: GLenum, arg_1124: GLuint) void {
    return glad_glColorP3ui.?(arg_1123, arg_1124);
}
pub inline fn glColorP3uiv(arg_1125: GLenum, arg_1126: [*c]const GLuint) void {
    return glad_glColorP3uiv.?(arg_1125, arg_1126);
}
pub inline fn glColorP4ui(arg_1127: GLenum, arg_1128: GLuint) void {
    return glad_glColorP4ui.?(arg_1127, arg_1128);
}
pub inline fn glColorP4uiv(arg_1129: GLenum, arg_1130: [*c]const GLuint) void {
    return glad_glColorP4uiv.?(arg_1129, arg_1130);
}
pub inline fn glSecondaryColorP3ui(arg_1131: GLenum, arg_1132: GLuint) void {
    return glad_glSecondaryColorP3ui.?(arg_1131, arg_1132);
}
pub inline fn glSecondaryColorP3uiv(arg_1133: GLenum, arg_1134: [*c]const GLuint) void {
    return glad_glSecondaryColorP3uiv.?(arg_1133, arg_1134);
}
pub const _glfw3_h_ = "";
pub const __need_ptrdiff_t = "";
pub const __need_size_t = "";
pub const __need_NULL = "";
pub const __need_max_align_t = "";
pub const __need_offsetof = "";
pub const __STDDEF_H = "";
pub const _PTRDIFF_T = "";
pub const _SIZE_T = "";
pub const NULL = @import("std").zig.c_translation.cast(?*anyopaque, @as(c_int, 0));
pub const __CLANG_MAX_ALIGN_T_DEFINED = "";
pub const offsetof = @compileError("unable to translate C expr: unexpected token 'an identifier'");
// C:\Zig\lib\include/__stddef_offsetof.h:16:9
pub const WINGDIAPI = @compileError("unable to translate macro: undefined identifier `dllimport`");
// vcpkg\installed\x64-windows\include/GLFW/glfw3.h:133:10
pub const GLFW_WINGDIAPI_DEFINED = "";
pub const CALLBACK = @compileError("unable to translate C expr: unexpected token '__stdcall'");
// vcpkg\installed\x64-windows\include/GLFW/glfw3.h:140:10
pub const GLFW_CALLBACK_DEFINED = "";
pub const GLFWAPI = "";
pub const GLFW_VERSION_MAJOR = @as(c_int, 3);
pub const GLFW_VERSION_MINOR = @as(c_int, 4);
pub const GLFW_VERSION_REVISION = @as(c_int, 0);
pub const GLFW_TRUE = @as(c_int, 1);
pub const GLFW_FALSE = @as(c_int, 0);
pub const GLFW_RELEASE = @as(c_int, 0);
pub const GLFW_PRESS = @as(c_int, 1);
pub const GLFW_REPEAT = @as(c_int, 2);
pub const GLFW_HAT_CENTERED = @as(c_int, 0);
pub const GLFW_HAT_UP = @as(c_int, 1);
pub const GLFW_HAT_RIGHT = @as(c_int, 2);
pub const GLFW_HAT_DOWN = @as(c_int, 4);
pub const GLFW_HAT_LEFT = @as(c_int, 8);
pub const GLFW_HAT_RIGHT_UP = GLFW_HAT_RIGHT | GLFW_HAT_UP;
pub const GLFW_HAT_RIGHT_DOWN = GLFW_HAT_RIGHT | GLFW_HAT_DOWN;
pub const GLFW_HAT_LEFT_UP = GLFW_HAT_LEFT | GLFW_HAT_UP;
pub const GLFW_HAT_LEFT_DOWN = GLFW_HAT_LEFT | GLFW_HAT_DOWN;
pub const GLFW_KEY_UNKNOWN = -@as(c_int, 1);
pub const GLFW_KEY_SPACE = @as(c_int, 32);
pub const GLFW_KEY_APOSTROPHE = @as(c_int, 39);
pub const GLFW_KEY_COMMA = @as(c_int, 44);
pub const GLFW_KEY_MINUS = @as(c_int, 45);
pub const GLFW_KEY_PERIOD = @as(c_int, 46);
pub const GLFW_KEY_SLASH = @as(c_int, 47);
pub const GLFW_KEY_0 = @as(c_int, 48);
pub const GLFW_KEY_1 = @as(c_int, 49);
pub const GLFW_KEY_2 = @as(c_int, 50);
pub const GLFW_KEY_3 = @as(c_int, 51);
pub const GLFW_KEY_4 = @as(c_int, 52);
pub const GLFW_KEY_5 = @as(c_int, 53);
pub const GLFW_KEY_6 = @as(c_int, 54);
pub const GLFW_KEY_7 = @as(c_int, 55);
pub const GLFW_KEY_8 = @as(c_int, 56);
pub const GLFW_KEY_9 = @as(c_int, 57);
pub const GLFW_KEY_SEMICOLON = @as(c_int, 59);
pub const GLFW_KEY_EQUAL = @as(c_int, 61);
pub const GLFW_KEY_A = @as(c_int, 65);
pub const GLFW_KEY_B = @as(c_int, 66);
pub const GLFW_KEY_C = @as(c_int, 67);
pub const GLFW_KEY_D = @as(c_int, 68);
pub const GLFW_KEY_E = @as(c_int, 69);
pub const GLFW_KEY_F = @as(c_int, 70);
pub const GLFW_KEY_G = @as(c_int, 71);
pub const GLFW_KEY_H = @as(c_int, 72);
pub const GLFW_KEY_I = @as(c_int, 73);
pub const GLFW_KEY_J = @as(c_int, 74);
pub const GLFW_KEY_K = @as(c_int, 75);
pub const GLFW_KEY_L = @as(c_int, 76);
pub const GLFW_KEY_M = @as(c_int, 77);
pub const GLFW_KEY_N = @as(c_int, 78);
pub const GLFW_KEY_O = @as(c_int, 79);
pub const GLFW_KEY_P = @as(c_int, 80);
pub const GLFW_KEY_Q = @as(c_int, 81);
pub const GLFW_KEY_R = @as(c_int, 82);
pub const GLFW_KEY_S = @as(c_int, 83);
pub const GLFW_KEY_T = @as(c_int, 84);
pub const GLFW_KEY_U = @as(c_int, 85);
pub const GLFW_KEY_V = @as(c_int, 86);
pub const GLFW_KEY_W = @as(c_int, 87);
pub const GLFW_KEY_X = @as(c_int, 88);
pub const GLFW_KEY_Y = @as(c_int, 89);
pub const GLFW_KEY_Z = @as(c_int, 90);
pub const GLFW_KEY_LEFT_BRACKET = @as(c_int, 91);
pub const GLFW_KEY_BACKSLASH = @as(c_int, 92);
pub const GLFW_KEY_RIGHT_BRACKET = @as(c_int, 93);
pub const GLFW_KEY_GRAVE_ACCENT = @as(c_int, 96);
pub const GLFW_KEY_WORLD_1 = @as(c_int, 161);
pub const GLFW_KEY_WORLD_2 = @as(c_int, 162);
pub const GLFW_KEY_ESCAPE = @as(c_int, 256);
pub const GLFW_KEY_ENTER = @as(c_int, 257);
pub const GLFW_KEY_TAB = @as(c_int, 258);
pub const GLFW_KEY_BACKSPACE = @as(c_int, 259);
pub const GLFW_KEY_INSERT = @as(c_int, 260);
pub const GLFW_KEY_DELETE = @as(c_int, 261);
pub const GLFW_KEY_RIGHT = @as(c_int, 262);
pub const GLFW_KEY_LEFT = @as(c_int, 263);
pub const GLFW_KEY_DOWN = @as(c_int, 264);
pub const GLFW_KEY_UP = @as(c_int, 265);
pub const GLFW_KEY_PAGE_UP = @as(c_int, 266);
pub const GLFW_KEY_PAGE_DOWN = @as(c_int, 267);
pub const GLFW_KEY_HOME = @as(c_int, 268);
pub const GLFW_KEY_END = @as(c_int, 269);
pub const GLFW_KEY_CAPS_LOCK = @as(c_int, 280);
pub const GLFW_KEY_SCROLL_LOCK = @as(c_int, 281);
pub const GLFW_KEY_NUM_LOCK = @as(c_int, 282);
pub const GLFW_KEY_PRINT_SCREEN = @as(c_int, 283);
pub const GLFW_KEY_PAUSE = @as(c_int, 284);
pub const GLFW_KEY_F1 = @as(c_int, 290);
pub const GLFW_KEY_F2 = @as(c_int, 291);
pub const GLFW_KEY_F3 = @as(c_int, 292);
pub const GLFW_KEY_F4 = @as(c_int, 293);
pub const GLFW_KEY_F5 = @as(c_int, 294);
pub const GLFW_KEY_F6 = @as(c_int, 295);
pub const GLFW_KEY_F7 = @as(c_int, 296);
pub const GLFW_KEY_F8 = @as(c_int, 297);
pub const GLFW_KEY_F9 = @as(c_int, 298);
pub const GLFW_KEY_F10 = @as(c_int, 299);
pub const GLFW_KEY_F11 = @as(c_int, 300);
pub const GLFW_KEY_F12 = @as(c_int, 301);
pub const GLFW_KEY_F13 = @as(c_int, 302);
pub const GLFW_KEY_F14 = @as(c_int, 303);
pub const GLFW_KEY_F15 = @as(c_int, 304);
pub const GLFW_KEY_F16 = @as(c_int, 305);
pub const GLFW_KEY_F17 = @as(c_int, 306);
pub const GLFW_KEY_F18 = @as(c_int, 307);
pub const GLFW_KEY_F19 = @as(c_int, 308);
pub const GLFW_KEY_F20 = @as(c_int, 309);
pub const GLFW_KEY_F21 = @as(c_int, 310);
pub const GLFW_KEY_F22 = @as(c_int, 311);
pub const GLFW_KEY_F23 = @as(c_int, 312);
pub const GLFW_KEY_F24 = @as(c_int, 313);
pub const GLFW_KEY_F25 = @as(c_int, 314);
pub const GLFW_KEY_KP_0 = @as(c_int, 320);
pub const GLFW_KEY_KP_1 = @as(c_int, 321);
pub const GLFW_KEY_KP_2 = @as(c_int, 322);
pub const GLFW_KEY_KP_3 = @as(c_int, 323);
pub const GLFW_KEY_KP_4 = @as(c_int, 324);
pub const GLFW_KEY_KP_5 = @as(c_int, 325);
pub const GLFW_KEY_KP_6 = @as(c_int, 326);
pub const GLFW_KEY_KP_7 = @as(c_int, 327);
pub const GLFW_KEY_KP_8 = @as(c_int, 328);
pub const GLFW_KEY_KP_9 = @as(c_int, 329);
pub const GLFW_KEY_KP_DECIMAL = @as(c_int, 330);
pub const GLFW_KEY_KP_DIVIDE = @as(c_int, 331);
pub const GLFW_KEY_KP_MULTIPLY = @as(c_int, 332);
pub const GLFW_KEY_KP_SUBTRACT = @as(c_int, 333);
pub const GLFW_KEY_KP_ADD = @as(c_int, 334);
pub const GLFW_KEY_KP_ENTER = @as(c_int, 335);
pub const GLFW_KEY_KP_EQUAL = @as(c_int, 336);
pub const GLFW_KEY_LEFT_SHIFT = @as(c_int, 340);
pub const GLFW_KEY_LEFT_CONTROL = @as(c_int, 341);
pub const GLFW_KEY_LEFT_ALT = @as(c_int, 342);
pub const GLFW_KEY_LEFT_SUPER = @as(c_int, 343);
pub const GLFW_KEY_RIGHT_SHIFT = @as(c_int, 344);
pub const GLFW_KEY_RIGHT_CONTROL = @as(c_int, 345);
pub const GLFW_KEY_RIGHT_ALT = @as(c_int, 346);
pub const GLFW_KEY_RIGHT_SUPER = @as(c_int, 347);
pub const GLFW_KEY_MENU = @as(c_int, 348);
pub const GLFW_KEY_LAST = GLFW_KEY_MENU;
pub const GLFW_MOD_SHIFT = @as(c_int, 0x0001);
pub const GLFW_MOD_CONTROL = @as(c_int, 0x0002);
pub const GLFW_MOD_ALT = @as(c_int, 0x0004);
pub const GLFW_MOD_SUPER = @as(c_int, 0x0008);
pub const GLFW_MOD_CAPS_LOCK = @as(c_int, 0x0010);
pub const GLFW_MOD_NUM_LOCK = @as(c_int, 0x0020);
pub const GLFW_MOUSE_BUTTON_1 = @as(c_int, 0);
pub const GLFW_MOUSE_BUTTON_2 = @as(c_int, 1);
pub const GLFW_MOUSE_BUTTON_3 = @as(c_int, 2);
pub const GLFW_MOUSE_BUTTON_4 = @as(c_int, 3);
pub const GLFW_MOUSE_BUTTON_5 = @as(c_int, 4);
pub const GLFW_MOUSE_BUTTON_6 = @as(c_int, 5);
pub const GLFW_MOUSE_BUTTON_7 = @as(c_int, 6);
pub const GLFW_MOUSE_BUTTON_8 = @as(c_int, 7);
pub const GLFW_MOUSE_BUTTON_LAST = GLFW_MOUSE_BUTTON_8;
pub const GLFW_MOUSE_BUTTON_LEFT = GLFW_MOUSE_BUTTON_1;
pub const GLFW_MOUSE_BUTTON_RIGHT = GLFW_MOUSE_BUTTON_2;
pub const GLFW_MOUSE_BUTTON_MIDDLE = GLFW_MOUSE_BUTTON_3;
pub const GLFW_JOYSTICK_1 = @as(c_int, 0);
pub const GLFW_JOYSTICK_2 = @as(c_int, 1);
pub const GLFW_JOYSTICK_3 = @as(c_int, 2);
pub const GLFW_JOYSTICK_4 = @as(c_int, 3);
pub const GLFW_JOYSTICK_5 = @as(c_int, 4);
pub const GLFW_JOYSTICK_6 = @as(c_int, 5);
pub const GLFW_JOYSTICK_7 = @as(c_int, 6);
pub const GLFW_JOYSTICK_8 = @as(c_int, 7);
pub const GLFW_JOYSTICK_9 = @as(c_int, 8);
pub const GLFW_JOYSTICK_10 = @as(c_int, 9);
pub const GLFW_JOYSTICK_11 = @as(c_int, 10);
pub const GLFW_JOYSTICK_12 = @as(c_int, 11);
pub const GLFW_JOYSTICK_13 = @as(c_int, 12);
pub const GLFW_JOYSTICK_14 = @as(c_int, 13);
pub const GLFW_JOYSTICK_15 = @as(c_int, 14);
pub const GLFW_JOYSTICK_16 = @as(c_int, 15);
pub const GLFW_JOYSTICK_LAST = GLFW_JOYSTICK_16;
pub const GLFW_GAMEPAD_BUTTON_A = @as(c_int, 0);
pub const GLFW_GAMEPAD_BUTTON_B = @as(c_int, 1);
pub const GLFW_GAMEPAD_BUTTON_X = @as(c_int, 2);
pub const GLFW_GAMEPAD_BUTTON_Y = @as(c_int, 3);
pub const GLFW_GAMEPAD_BUTTON_LEFT_BUMPER = @as(c_int, 4);
pub const GLFW_GAMEPAD_BUTTON_RIGHT_BUMPER = @as(c_int, 5);
pub const GLFW_GAMEPAD_BUTTON_BACK = @as(c_int, 6);
pub const GLFW_GAMEPAD_BUTTON_START = @as(c_int, 7);
pub const GLFW_GAMEPAD_BUTTON_GUIDE = @as(c_int, 8);
pub const GLFW_GAMEPAD_BUTTON_LEFT_THUMB = @as(c_int, 9);
pub const GLFW_GAMEPAD_BUTTON_RIGHT_THUMB = @as(c_int, 10);
pub const GLFW_GAMEPAD_BUTTON_DPAD_UP = @as(c_int, 11);
pub const GLFW_GAMEPAD_BUTTON_DPAD_RIGHT = @as(c_int, 12);
pub const GLFW_GAMEPAD_BUTTON_DPAD_DOWN = @as(c_int, 13);
pub const GLFW_GAMEPAD_BUTTON_DPAD_LEFT = @as(c_int, 14);
pub const GLFW_GAMEPAD_BUTTON_LAST = GLFW_GAMEPAD_BUTTON_DPAD_LEFT;
pub const GLFW_GAMEPAD_BUTTON_CROSS = GLFW_GAMEPAD_BUTTON_A;
pub const GLFW_GAMEPAD_BUTTON_CIRCLE = GLFW_GAMEPAD_BUTTON_B;
pub const GLFW_GAMEPAD_BUTTON_SQUARE = GLFW_GAMEPAD_BUTTON_X;
pub const GLFW_GAMEPAD_BUTTON_TRIANGLE = GLFW_GAMEPAD_BUTTON_Y;
pub const GLFW_GAMEPAD_AXIS_LEFT_X = @as(c_int, 0);
pub const GLFW_GAMEPAD_AXIS_LEFT_Y = @as(c_int, 1);
pub const GLFW_GAMEPAD_AXIS_RIGHT_X = @as(c_int, 2);
pub const GLFW_GAMEPAD_AXIS_RIGHT_Y = @as(c_int, 3);
pub const GLFW_GAMEPAD_AXIS_LEFT_TRIGGER = @as(c_int, 4);
pub const GLFW_GAMEPAD_AXIS_RIGHT_TRIGGER = @as(c_int, 5);
pub const GLFW_GAMEPAD_AXIS_LAST = GLFW_GAMEPAD_AXIS_RIGHT_TRIGGER;
pub const GLFW_NO_ERROR = @as(c_int, 0);
pub const GLFW_NOT_INITIALIZED = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00010001, .hex);
pub const GLFW_NO_CURRENT_CONTEXT = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00010002, .hex);
pub const GLFW_INVALID_ENUM = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00010003, .hex);
pub const GLFW_INVALID_VALUE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00010004, .hex);
pub const GLFW_OUT_OF_MEMORY = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00010005, .hex);
pub const GLFW_API_UNAVAILABLE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00010006, .hex);
pub const GLFW_VERSION_UNAVAILABLE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00010007, .hex);
pub const GLFW_PLATFORM_ERROR = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00010008, .hex);
pub const GLFW_FORMAT_UNAVAILABLE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00010009, .hex);
pub const GLFW_NO_WINDOW_CONTEXT = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x0001000A, .hex);
pub const GLFW_CURSOR_UNAVAILABLE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x0001000B, .hex);
pub const GLFW_FEATURE_UNAVAILABLE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x0001000C, .hex);
pub const GLFW_FEATURE_UNIMPLEMENTED = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x0001000D, .hex);
pub const GLFW_PLATFORM_UNAVAILABLE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x0001000E, .hex);
pub const GLFW_FOCUSED = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00020001, .hex);
pub const GLFW_ICONIFIED = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00020002, .hex);
pub const GLFW_RESIZABLE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00020003, .hex);
pub const GLFW_VISIBLE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00020004, .hex);
pub const GLFW_DECORATED = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00020005, .hex);
pub const GLFW_AUTO_ICONIFY = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00020006, .hex);
pub const GLFW_FLOATING = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00020007, .hex);
pub const GLFW_MAXIMIZED = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00020008, .hex);
pub const GLFW_CENTER_CURSOR = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00020009, .hex);
pub const GLFW_TRANSPARENT_FRAMEBUFFER = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x0002000A, .hex);
pub const GLFW_HOVERED = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x0002000B, .hex);
pub const GLFW_FOCUS_ON_SHOW = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x0002000C, .hex);
pub const GLFW_MOUSE_PASSTHROUGH = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x0002000D, .hex);
pub const GLFW_POSITION_X = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x0002000E, .hex);
pub const GLFW_POSITION_Y = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x0002000F, .hex);
pub const GLFW_RED_BITS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00021001, .hex);
pub const GLFW_GREEN_BITS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00021002, .hex);
pub const GLFW_BLUE_BITS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00021003, .hex);
pub const GLFW_ALPHA_BITS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00021004, .hex);
pub const GLFW_DEPTH_BITS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00021005, .hex);
pub const GLFW_STENCIL_BITS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00021006, .hex);
pub const GLFW_ACCUM_RED_BITS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00021007, .hex);
pub const GLFW_ACCUM_GREEN_BITS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00021008, .hex);
pub const GLFW_ACCUM_BLUE_BITS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00021009, .hex);
pub const GLFW_ACCUM_ALPHA_BITS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x0002100A, .hex);
pub const GLFW_AUX_BUFFERS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x0002100B, .hex);
pub const GLFW_STEREO = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x0002100C, .hex);
pub const GLFW_SAMPLES = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x0002100D, .hex);
pub const GLFW_SRGB_CAPABLE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x0002100E, .hex);
pub const GLFW_REFRESH_RATE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x0002100F, .hex);
pub const GLFW_DOUBLEBUFFER = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00021010, .hex);
pub const GLFW_CLIENT_API = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00022001, .hex);
pub const GLFW_CONTEXT_VERSION_MAJOR = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00022002, .hex);
pub const GLFW_CONTEXT_VERSION_MINOR = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00022003, .hex);
pub const GLFW_CONTEXT_REVISION = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00022004, .hex);
pub const GLFW_CONTEXT_ROBUSTNESS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00022005, .hex);
pub const GLFW_OPENGL_FORWARD_COMPAT = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00022006, .hex);
pub const GLFW_CONTEXT_DEBUG = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00022007, .hex);
pub const GLFW_OPENGL_DEBUG_CONTEXT = GLFW_CONTEXT_DEBUG;
pub const GLFW_OPENGL_PROFILE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00022008, .hex);
pub const GLFW_CONTEXT_RELEASE_BEHAVIOR = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00022009, .hex);
pub const GLFW_CONTEXT_NO_ERROR = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x0002200A, .hex);
pub const GLFW_CONTEXT_CREATION_API = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x0002200B, .hex);
pub const GLFW_SCALE_TO_MONITOR = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x0002200C, .hex);
pub const GLFW_SCALE_FRAMEBUFFER = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x0002200D, .hex);
pub const GLFW_COCOA_RETINA_FRAMEBUFFER = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00023001, .hex);
pub const GLFW_COCOA_FRAME_NAME = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00023002, .hex);
pub const GLFW_COCOA_GRAPHICS_SWITCHING = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00023003, .hex);
pub const GLFW_X11_CLASS_NAME = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00024001, .hex);
pub const GLFW_X11_INSTANCE_NAME = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00024002, .hex);
pub const GLFW_WIN32_KEYBOARD_MENU = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00025001, .hex);
pub const GLFW_WIN32_SHOWDEFAULT = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00025002, .hex);
pub const GLFW_WAYLAND_APP_ID = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00026001, .hex);
pub const GLFW_NO_API = @as(c_int, 0);
pub const GLFW_OPENGL_API = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00030001, .hex);
pub const GLFW_OPENGL_ES_API = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00030002, .hex);
pub const GLFW_NO_ROBUSTNESS = @as(c_int, 0);
pub const GLFW_NO_RESET_NOTIFICATION = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00031001, .hex);
pub const GLFW_LOSE_CONTEXT_ON_RESET = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00031002, .hex);
pub const GLFW_OPENGL_ANY_PROFILE = @as(c_int, 0);
pub const GLFW_OPENGL_CORE_PROFILE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00032001, .hex);
pub const GLFW_OPENGL_COMPAT_PROFILE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00032002, .hex);
pub const GLFW_CURSOR = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00033001, .hex);
pub const GLFW_STICKY_KEYS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00033002, .hex);
pub const GLFW_STICKY_MOUSE_BUTTONS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00033003, .hex);
pub const GLFW_LOCK_KEY_MODS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00033004, .hex);
pub const GLFW_RAW_MOUSE_MOTION = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00033005, .hex);
pub const GLFW_CURSOR_NORMAL = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00034001, .hex);
pub const GLFW_CURSOR_HIDDEN = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00034002, .hex);
pub const GLFW_CURSOR_DISABLED = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00034003, .hex);
pub const GLFW_CURSOR_CAPTURED = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00034004, .hex);
pub const GLFW_ANY_RELEASE_BEHAVIOR = @as(c_int, 0);
pub const GLFW_RELEASE_BEHAVIOR_FLUSH = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00035001, .hex);
pub const GLFW_RELEASE_BEHAVIOR_NONE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00035002, .hex);
pub const GLFW_NATIVE_CONTEXT_API = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00036001, .hex);
pub const GLFW_EGL_CONTEXT_API = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00036002, .hex);
pub const GLFW_OSMESA_CONTEXT_API = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00036003, .hex);
pub const GLFW_ANGLE_PLATFORM_TYPE_NONE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00037001, .hex);
pub const GLFW_ANGLE_PLATFORM_TYPE_OPENGL = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00037002, .hex);
pub const GLFW_ANGLE_PLATFORM_TYPE_OPENGLES = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00037003, .hex);
pub const GLFW_ANGLE_PLATFORM_TYPE_D3D9 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00037004, .hex);
pub const GLFW_ANGLE_PLATFORM_TYPE_D3D11 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00037005, .hex);
pub const GLFW_ANGLE_PLATFORM_TYPE_VULKAN = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00037007, .hex);
pub const GLFW_ANGLE_PLATFORM_TYPE_METAL = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00037008, .hex);
pub const GLFW_WAYLAND_PREFER_LIBDECOR = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00038001, .hex);
pub const GLFW_WAYLAND_DISABLE_LIBDECOR = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00038002, .hex);
pub const GLFW_ANY_POSITION = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x80000000, .hex);
pub const GLFW_ARROW_CURSOR = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00036001, .hex);
pub const GLFW_IBEAM_CURSOR = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00036002, .hex);
pub const GLFW_CROSSHAIR_CURSOR = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00036003, .hex);
pub const GLFW_POINTING_HAND_CURSOR = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00036004, .hex);
pub const GLFW_RESIZE_EW_CURSOR = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00036005, .hex);
pub const GLFW_RESIZE_NS_CURSOR = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00036006, .hex);
pub const GLFW_RESIZE_NWSE_CURSOR = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00036007, .hex);
pub const GLFW_RESIZE_NESW_CURSOR = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00036008, .hex);
pub const GLFW_RESIZE_ALL_CURSOR = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00036009, .hex);
pub const GLFW_NOT_ALLOWED_CURSOR = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x0003600A, .hex);
pub const GLFW_HRESIZE_CURSOR = GLFW_RESIZE_EW_CURSOR;
pub const GLFW_VRESIZE_CURSOR = GLFW_RESIZE_NS_CURSOR;
pub const GLFW_HAND_CURSOR = GLFW_POINTING_HAND_CURSOR;
pub const GLFW_CONNECTED = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00040001, .hex);
pub const GLFW_DISCONNECTED = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00040002, .hex);
pub const GLFW_JOYSTICK_HAT_BUTTONS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00050001, .hex);
pub const GLFW_ANGLE_PLATFORM_TYPE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00050002, .hex);
pub const GLFW_PLATFORM = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00050003, .hex);
pub const GLFW_COCOA_CHDIR_RESOURCES = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00051001, .hex);
pub const GLFW_COCOA_MENUBAR = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00051002, .hex);
pub const GLFW_X11_XCB_VULKAN_SURFACE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00052001, .hex);
pub const GLFW_WAYLAND_LIBDECOR = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00053001, .hex);
pub const GLFW_ANY_PLATFORM = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00060000, .hex);
pub const GLFW_PLATFORM_WIN32 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00060001, .hex);
pub const GLFW_PLATFORM_COCOA = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00060002, .hex);
pub const GLFW_PLATFORM_WAYLAND = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00060003, .hex);
pub const GLFW_PLATFORM_X11 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00060004, .hex);
pub const GLFW_PLATFORM_NULL = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00060005, .hex);
pub const GLFW_DONT_CARE = -@as(c_int, 1);
pub const gladGLversionStruct = struct_gladGLversionStruct;
pub const threadlocaleinfostruct = struct_threadlocaleinfostruct;
pub const threadmbcinfostruct = struct_threadmbcinfostruct;
pub const __lc_time_data = struct___lc_time_data;
pub const localeinfo_struct = struct_localeinfo_struct;
pub const tagLC_ID = struct_tagLC_ID;
pub const __GLsync = struct___GLsync;
pub const _cl_context = struct__cl_context;
pub const _cl_event = struct__cl_event;
