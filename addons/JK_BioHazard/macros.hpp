#define PREFIX JK_BioHazard
#define PATH JK
#define MOD JK_BioHazard

// define Version Information
#define MAJOR 0
#define MINOR 1
#define PATCHLVL 0
#define BUILD 1

#ifdef VERSION
    #undef VERSION
#endif
#ifdef VERSION_AR
    #undef VERSION_AR
#endif
#define VERSION_AR MAJOR,MINOR,PATCHLVL,BUILD
#define VERSION MAJOR.MINOR.PATCHLVL.BUILD

#define ISDEV

#include "\tc\CLib\addons\CLib\macros.hpp"

// MFUNC Macro for Calls in COMMON Module
#define MFUNC(var) EFUNC(Common,var)
#define QMFUNC(var) QEFUNC(Common,var)
#define MGVAR(var) EGVAR(Common,var)
#define QMGVAR(var) QUOTE(MGVAR(var))
