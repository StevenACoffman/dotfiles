#!/bin/bash
#Example
#follow-logs.sh --topic captains-log | jq 'select(.eventtype=="advanced_search" or .eventtype=="basic_search" or .eventtype=="homepage")'
follow-logs.sh --topic captains-log | jq 'select(.eventtype=="unauth_pdf")'


#SuperDashboard url:
#http://super-dashboard.apps.prod.cirrostratus.org/index/search?url=http%3A%2F%2Fsuper-index.apps.prod.cirrostratus.org%2F_all%2Flog%2F_search#{ %0A    "query":{ %0A        "filtered":{ %0A            "filter":{ %0A                "bool":{ %0A                    "must":{ %0A                        "and":[ %0A                            {"missing" : { "field" : "item_id" }}, %0A                            {"term":{"eventtype":"unauth_pdf"}} %0A                        ] %0A                    } %0A                } %0A            } %0A        } %0A    }, %0A    "sort" : [ %0A        { "gen_super_index_tstamp" : {"unmapped_type" : "long", "order":"desc"} } %0A    ], %0A    "size":100 %0A}
#
# {
#    "query":{
#        "filtered":{
#            "filter":{
#                "bool":{
#                    "must":{
#                        "and":[
#                            {"missing" : { "field" : "item_id" }},
#                            {"term":{"eventtype":"unauth_pdf"}}
#                        ]
#                    }
#                }
#            }
#        }
#    },
#    "sort" : [
#        { "gen_super_index_tstamp" : {"unmapped_type" : "long", "order":"desc"} }
#    ],
#    "size":100
#}
