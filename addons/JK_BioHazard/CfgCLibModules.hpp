#include "\tc\CLib\addons\CLib\ModuleMacros.hpp"

class CfgCLibModules {
    class JK_BioHazard {
        path = "\jk\JK_BioHazard\addons\JK_BioHazard";
        dependency[] = {"CLib"};

        MODULE(BioHazard) {
            dependency[] = {"CLib"};
            FNC(clientInit);
            FNC(serverInit);
            FNC(Modules);
        };
    };
};
