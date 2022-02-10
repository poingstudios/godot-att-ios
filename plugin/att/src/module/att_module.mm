//
//  att_module.mm
//  att_module
//
//  Created by Gustavo Maciel on 06/02/22.
//


#import "att_module.h"

#import "core/engine.h"

ATT *att;

void register_att_types() {
    att = memnew(ATT);
    Engine::get_singleton()->add_singleton(Engine::Singleton("ATT", att));
}

void unregister_att_types() {
    if (att) {
        memdelete(att);
    }
}
