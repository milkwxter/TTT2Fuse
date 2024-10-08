local L = LANG.GetLanguageTableReference("en")

-- GENERAL ROLE LANGUAGE STRINGS
L[FUSE.name] = "Fuse"
L["info_popup_" .. FUSE.name] = [[You are the Fuse! Kill other players fast or else you will explode!]]
L["body_found_" .. FUSE.abbr] = "They were a Fuse."
L["search_role_" .. FUSE.abbr] = "This person was a Fuse!"
L["target_" .. FUSE.name] = "Fuse"
L["ttt2_desc_" .. FUSE.name] = [[The Fuse must kill other players quickly, or else he explodes!]]

-- CUSTOM ROLE LANGUAGE STRINGS
L["label_fuse_explosion_title"] = "Fuse Detonation Timer"
L["label_fuse_explosion_desc"] = "Kill someone to reset the timer. If it reaches 0 you will explode."