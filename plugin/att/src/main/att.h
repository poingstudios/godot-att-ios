//
//  att.h
//  att
//
//  Created by Gustavo Maciel on 06/02/22.
//


#ifndef att_plugin_implementation_h
    #define att_plugin_implementation_h

    #include "core/object.h"

    class ATT : public Object {
        GDCLASS(ATT, Object);
        
        static void _bind_methods();
        
    public:
        
        int get_tracking_authorization_status();
        void request_tracking_authorization();
        
        ATT();
        ~ATT();
    };

#endif /* att_plugin_implementation_h */
