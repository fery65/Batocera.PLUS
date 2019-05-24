/*** Autogenerated by WIDL 4.7 from dcommon.idl - Do not edit ***/

#ifdef _WIN32
#ifndef __REQUIRED_RPCNDR_H_VERSION__
#define __REQUIRED_RPCNDR_H_VERSION__ 475
#endif
#include <rpc.h>
#include <rpcndr.h>
#endif

#ifndef COM_NO_WINDOWS_H
#include <windows.h>
#include <ole2.h>
#endif

#ifndef __dcommon_h__
#define __dcommon_h__

/* Forward declarations */

/* Headers for imported files */

#include <dxgiformat.h>

#ifdef __cplusplus
extern "C" {
#endif

#if 0
typedef struct __WIDL_dcommon_generated_name_00000000 {
    LONG x;
    LONG y;
} POINT;
typedef unsigned int UINT32;
#endif
typedef enum DWRITE_MEASURING_MODE {
    DWRITE_MEASURING_MODE_NATURAL = 0,
    DWRITE_MEASURING_MODE_GDI_CLASSIC = 1,
    DWRITE_MEASURING_MODE_GDI_NATURAL = 2
} DWRITE_MEASURING_MODE;
typedef enum D2D1_ALPHA_MODE {
    D2D1_ALPHA_MODE_UNKNOWN = 0,
    D2D1_ALPHA_MODE_PREMULTIPLIED = 1,
    D2D1_ALPHA_MODE_STRAIGHT = 2,
    D2D1_ALPHA_MODE_IGNORE = 3,
    D2D1_ALPHA_MODE_FORCE_DWORD = 0xffffffff
} D2D1_ALPHA_MODE;
typedef struct D2D1_PIXEL_FORMAT {
    DXGI_FORMAT format;
    D2D1_ALPHA_MODE alphaMode;
} D2D1_PIXEL_FORMAT;
typedef struct D2D_POINT_2F {
    float x;
    float y;
} D2D_POINT_2F;
typedef struct D2D_POINT_2F D2D1_POINT_2F;
typedef POINT D2D_POINT_2L;
typedef POINT D2D1_POINT_2L;
typedef struct D2D_SIZE_U {
    UINT32 width;
    UINT32 height;
} D2D_SIZE_U;
typedef struct D2D_SIZE_U D2D1_SIZE_U;
typedef struct D2D_MATRIX_4X4_F {
    __C89_NAMELESS union {
        __C89_NAMELESS struct {
            float _11;
            float _12;
            float _13;
            float _14;
            float _21;
            float _22;
            float _23;
            float _24;
            float _31;
            float _32;
            float _33;
            float _34;
            float _41;
            float _42;
            float _43;
            float _44;
        } __C89_NAMELESSSTRUCTNAME;
        float m[4][4];
    } __C89_NAMELESSUNIONNAME;
} D2D_MATRIX_4X4_F;
/* Begin additional prototypes for all interfaces */


/* End additional prototypes */

#ifdef __cplusplus
}
#endif

#endif /* __dcommon_h__ */
