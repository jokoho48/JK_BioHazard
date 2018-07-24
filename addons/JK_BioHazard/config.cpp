#include "macros.hpp"
class CfgPatches {
    class FKFramework {
        units[] = {};
        weapons[] = {};
        requiredVersion = 1.56;
        author = "joko // Jonas";
        authors[] = {"joko // Jonas"};
        authorUrl = "";
        version = VERSION;
        versionStr = QUOTE(VERSION);
        versionAr[] = {VERSION_AR};
        requiredAddons[] = {"CLib"};
    };
};

#include "CfgCLibModules.hpp"

class CfgCLibSettings {
};
