prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_200200 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2020.10.01'
,p_release=>'20.2.0.00.20'
,p_default_workspace_id=>18210681090618307
,p_default_application_id=>108
,p_default_id_offset=>0
,p_default_owner=>'DIGIBILZ'
);
end;
/
 
prompt APPLICATION 108 - digiBILZ 2.0
--
-- Application Export:
--   Application:     108
--   Name:            digiBILZ 2.0
--   Date and Time:   19:45 Sunday March 28, 2021
--   Exported By:     GROTE_DBA
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 16874700833335002
--   Manifest End
--   Version:         20.2.0.00.20
--   Instance ID:     108898109376529
--

begin
  -- replace components
  wwv_flow_api.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/item_type/de_fgrote_ig_quick_values
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(16874700833335002)
,p_plugin_type=>'ITEM TYPE'
,p_name=>'DE.FGROTE.IG.QUICK_VALUES'
,p_display_name=>'IG Quick Values'
,p_supported_ui_types=>'DESKTOP'
,p_supported_component_types=>'APEX_APPL_PAGE_IG_COLUMNS'
,p_javascript_file_urls=>'#PLUGIN_FILES#js/igquickvalues.js'
,p_css_file_urls=>'#PLUGIN_FILES#css/igquickvalues.css'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'--------------------------------------------------------------------------------',
'-- Render Procedure',
'--------------------------------------------------------------------------------',
'procedure render_ig_quick_values (',
'  p_item   in            apex_plugin.t_item,',
'  p_plugin in            apex_plugin.t_plugin,',
'  p_param  in            apex_plugin.t_item_render_param,',
'  p_result in out nocopy apex_plugin.t_item_render_result',
')',
'is',
'  c_name            constant varchar2(30)    := apex_plugin.get_input_name_for_item;',
'  c_escaped_value   constant varchar2(32767) := apex_escape.html_attribute(p_param.value);',
'  c_seperator       constant varchar2(1)     := APEX_PLUGIN_UTIL.REPLACE_SUBSTITUTIONS(p_item.attribute_01);',
'  c_column          constant varchar2(255)   := APEX_PLUGIN_UTIL.REPLACE_SUBSTITUTIONS(p_item.attribute_02);',
'  c_link_classes    constant varchar2(255)   := APEX_PLUGIN_UTIL.REPLACE_SUBSTITUTIONS(p_item.attribute_03);',
'  c_link_attr       constant varchar2(255)   := APEX_PLUGIN_UTIL.REPLACE_SUBSTITUTIONS(p_item.attribute_04);',
'begin',
'  if p_param.is_readonly or p_param.is_printer_friendly then',
'    apex_plugin_util.print_hidden_if_readonly (',
'      p_item_name           => p_item.name,',
'      p_value               => p_param.value,',
'      p_is_readonly         => p_param.is_readonly,',
'      p_is_printer_friendly => p_param.is_printer_friendly',
'    );',
'',
'    sys.htp.prn(',
'      apex_string.format(',
'        ''<input type="text" %s id="%s" value="%s"/>''',
'        , apex_plugin_util.get_element_attributes(p_item, p_item.name, ''text_field apex-item-text apex-item-igquickvalues apex-item-plugin'')',
'        , p_item.name|| ''_DISPLAY''',
'        , case when p_param.value is null then '''' else ltrim( rtrim ( c_escaped_value ) ) end',
'      )',
'    );',
'  else',
'    sys.htp.prn(',
'      apex_string.format(',
'        ''<input type="text" %s id="%s" value="%s" data-seperator="%s" data-column="%s"/>''',
'        , apex_plugin_util.get_element_attributes(p_item, c_name, ''apex-item-igquickvalues apex-item-plugin'')',
'        , p_item.name',
'        , case when p_param.value is null then '''' else ltrim( rtrim ( c_escaped_value ) ) end',
'        , c_seperator',
'        , c_column',
'      )',
'    );',
'',
'    apex_javascript.add_onload_code (',
'      p_code => apex_string.format(',
'                  ''de_fgrote_ig_quick_values.init("%s", {readOnly: %s, isRequired: %s, seperator: "%s", column: "%s", linkClasses: "%s", linkAttributes: "%s"});''',
'                  , case when p_param.is_readonly or p_param.is_printer_friendly then p_item.name || ''_DISPLAY'' else p_item.name end',
'                  , case when p_param.is_readonly then ''true'' else ''false'' end',
'                  , case when p_item.is_required then ''true'' else ''false'' end',
'                  , c_seperator',
'                  , c_column',
'                  , c_link_classes',
'                  , c_link_attr',
'                )',
'    );',
'  end if;',
'',
'  p_result.is_navigable := (not p_param.is_readonly = false and not p_param.is_printer_friendly);',
'end render_ig_quick_values;',
'',
'--------------------------------------------------------------------------------',
'-- Meta Data Procedure',
'--------------------------------------------------------------------------------',
'procedure metadata_ig_quick_values (',
'  p_item   in            apex_plugin.t_item,',
'  p_plugin in            apex_plugin.t_plugin,',
'  p_param  in            apex_plugin.t_item_meta_data_param,',
'  p_result in out nocopy apex_plugin.t_item_meta_data_result )',
'is',
'begin',
'  p_result.escape_output := false;',
'end metadata_ig_quick_values;'))
,p_api_version=>2
,p_render_function=>'render_ig_quick_values'
,p_meta_data_function=>'metadata_ig_quick_values'
,p_standard_attributes=>'VISIBLE:SESSION_STATE:READONLY:SOURCE:ENCRYPT'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<b>Quick Picks for Interactive Grid</b><br>',
'<br>',
'<p>A seperated String becomes a list of Values that sets a different Columns Value.</p>'))
,p_version_identifier=>'1.0.0'
,p_files_version=>38
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(16877010001360394)
,p_plugin_id=>wwv_flow_api.id(16874700833335002)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Seperator'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>':'
,p_is_translatable=>false
,p_examples=>'Value1:Value2'
,p_help_text=>'Seperator for splitting the valus'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(17083029888010738)
,p_plugin_id=>wwv_flow_api.id(16874700833335002)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Save Value to Column'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>true
,p_is_translatable=>false
,p_examples=>'C001, COLUMN1'
,p_help_text=>'Select a Column to save the selected Quick Value to'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(17133940642766836)
,p_plugin_id=>wwv_flow_api.id(16874700833335002)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Link classes'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>'hideEmpty a-Button u-info-text'
,p_is_translatable=>false
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Link classes. Defaults to Apex Button with link Color<br>',
'<code>a-Button u-info-text</code>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(17134233375770687)
,p_plugin_id=>wwv_flow_api.id(16874700833335002)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'Link Attributes'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_translatable=>false
,p_help_text=>'Optional Link Attributes'
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '7661722064655F6667726F74655F69675F717569636B5F76616C756573203D202866756E6374696F6E20286129207B0D0A20202F2F20636F6E736F6C652E646562756728274578706F727420506172616D6574657220613A20272C206129202F2F203220';
wwv_flow_api.g_varchar2_table(2) := '46756E6B74696F6E656E206D69742064656E203320506172616D657465726E0D0A0D0A202066756E6374696F6E2062286429207B0D0A202020202F2F20636F6E736F6C652E646562756728274578706F72742066756E6374696F6E206220706172616D65';
wwv_flow_api.g_varchar2_table(3) := '74657220643A20272C206429202F2F2045696E20696E646578207A756D204578706F72740D0A202020202F2F20636F6E736F6C652E646562756728274578706F72742066756E6374696F6E206220706172616D6574657220633A20272C206329202F2F20';
wwv_flow_api.g_varchar2_table(4) := '4F626A656B74206D697420496E64657820756E6420646572206578706F727469657274656E2046756E6B74696F6E2028696E6974290D0A2020202069662028635B645D292072657475726E20635B645D2E6578706F7274730D0A20202020766172206520';
wwv_flow_api.g_varchar2_table(5) := '3D2028635B645D203D207B20693A20642C206C3A2066616C73652C206578706F7274733A207B7D207D290D0A2020202072657475726E20615B645D2E63616C6C28652E6578706F7274732C20652C20652E6578706F7274732C2062292C2028652E6C203D';
wwv_flow_api.g_varchar2_table(6) := '2074727565292C20652E6578706F7274730D0A20207D0D0A20207661722063203D207B7D0D0A202072657475726E20280D0A2020202028622E6D203D2061292C0D0A2020202028622E63203D2063292C0D0A2020202028622E64203D2066756E6374696F';
wwv_flow_api.g_varchar2_table(7) := '6E2028612C20632C206429207B0D0A202020202020622E6F28612C206329207C7C0D0A20202020202020204F626A6563742E646566696E6550726F706572747928612C20632C207B0D0A20202020202020202020636F6E666967757261626C653A206661';
wwv_flow_api.g_varchar2_table(8) := '6C73652C0D0A20202020202020202020656E756D657261626C653A20747275652C0D0A202020202020202020206765743A20642C0D0A20202020202020207D290D0A202020207D292C0D0A2020202028622E6E203D2066756E6374696F6E20286129207B';
wwv_flow_api.g_varchar2_table(9) := '0D0A2020202020207661722063203D0D0A20202020202020206120262620612E5F5F65734D6F64756C650D0A202020202020202020203F2066756E6374696F6E202829207B0D0A202020202020202020202020202072657475726E20615B276465666175';
wwv_flow_api.g_varchar2_table(10) := '6C74275D0D0A2020202020202020202020207D0D0A202020202020202020203A2066756E6374696F6E202829207B0D0A202020202020202020202020202072657475726E20610D0A2020202020202020202020207D0D0A20202020202072657475726E20';
wwv_flow_api.g_varchar2_table(11) := '622E6428632C202761272C2063292C20630D0A202020207D292C0D0A2020202028622E6F203D2066756E6374696F6E2028612C206229207B0D0A20202020202072657475726E204F626A6563742E70726F746F747970652E6861734F776E50726F706572';
wwv_flow_api.g_varchar2_table(12) := '74792E63616C6C28612C2062290D0A202020207D292C0D0A2020202028622E70203D202727292C0D0A202020202F2F20636F6E736F6C652E646562756728274578706F72742072657475726E20623A20272C2062292C202F2F20696E6566616368206469';
wwv_flow_api.g_varchar2_table(13) := '65206F626572652046756E6B74696F6E0D0A20202020622828622E73203D203029290D0A2020290D0A7D29285B0D0A202066756E6374696F6E2028612C20622C206329207B0D0A20202020612E6578706F727473203D20632831290D0A202020202F2F20';
wwv_flow_api.g_varchar2_table(14) := '636F6E736F6C652E646562756728274578706F72742063616C6C203120706172616D657465722061206220633A20272C20612C20622C206329202F2F2061206578706F7274206F626A656B742C2062206578706F72742046756E6B74696F6E206F6E6C79';
wwv_flow_api.g_varchar2_table(15) := '2C2063203D20422066756E6B74696F6E0D0A20207D2C0D0A202066756E6374696F6E2028612C20622C206329207B0D0A202020202775736520737472696374270D0A202020204F626A6563742E646566696E6550726F706572747928622C20275F5F6573';
wwv_flow_api.g_varchar2_table(16) := '4D6F64756C65272C207B2076616C75653A2074727565207D292C0D0A202020202020632E6428622C2027696E6974272C2066756E6374696F6E202829207B0D0A202020202020202072657475726E20637265617465506C7567696E4974656D0D0A202020';
wwv_flow_api.g_varchar2_table(17) := '2020207D290D0A202020202F2F20636F6E736F6C652E646562756728274578706F72742063616C6C203220706172616D657465722061206220633A20272C20612C20622C206329202F2F2061206578706F7274206F626A656B742C2062206578706F7274';
wwv_flow_api.g_varchar2_table(18) := '2046756E6B74696F6E206F6E6C792C2063203D20422066756E6B74696F6E0D0A202020202F2A2A0D0A20202020202A2040617574686F722052616661656C20547265766973616E203C72616661656C407472657669732E63613E0D0A20202020202A2040';
wwv_flow_api.g_varchar2_table(19) := '6C6963656E73650D0A20202020202A20436F707972696768742028632920323031382052616661656C20547265766973616E0D0A20202020202A0D0A20202020202A205065726D697373696F6E20697320686572656279206772616E7465642C20667265';
wwv_flow_api.g_varchar2_table(20) := '65206F66206368617267652C20746F20616E7920706572736F6E206F627461696E696E67206120636F70790D0A20202020202A206F66207468697320736F66747761726520616E64206173736F63696174656420646F63756D656E746174696F6E206669';
wwv_flow_api.g_varchar2_table(21) := '6C657320287468652027536F66747761726527292C20746F206465616C0D0A20202020202A20696E2074686520536F66747761726520776974686F7574207265737472696374696F6E2C20696E636C7564696E6720776974686F7574206C696D69746174';
wwv_flow_api.g_varchar2_table(22) := '696F6E20746865207269676874730D0A20202020202A20746F207573652C20636F70792C206D6F646966792C206D657267652C207075626C6973682C20646973747269627574652C207375626C6963656E73652C20616E642F6F722073656C6C0D0A2020';
wwv_flow_api.g_varchar2_table(23) := '2020202A20636F70696573206F662074686520536F6674776172652C20616E6420746F207065726D697420706572736F6E7320746F2077686F6D2074686520536F6674776172652069730D0A20202020202A206675726E697368656420746F20646F2073';
wwv_flow_api.g_varchar2_table(24) := '6F2C207375626A65637420746F2074686520666F6C6C6F77696E6720706C61796572733A0D0A20202020202A0D0A20202020202A205468652061626F766520636F70797269676874206E6F7469636520616E642074686973207065726D697373696F6E20';
wwv_flow_api.g_varchar2_table(25) := '6E6F74696365207368616C6C20626520696E636C7564656420696E20616C6C0D0A20202020202A20636F70696573206F72207375627374616E7469616C20706F7274696F6E73206F662074686520536F6674776172652E0D0A20202020202A0D0A202020';
wwv_flow_api.g_varchar2_table(26) := '20202A2054484520534F4654574152452049532050524F564944454420274153204953272C20574954484F55542057415252414E5459204F4620414E59204B494E442C2045585052455353204F520D0A20202020202A20494D504C4945442C20494E434C';
wwv_flow_api.g_varchar2_table(27) := '5544494E4720425554204E4F54204C494D4954454420544F205448452057415252414E54494553204F46204D45524348414E544142494C4954592C0D0A20202020202A204649544E45535320464F52204120504152544943554C415220505552504F5345';
wwv_flow_api.g_varchar2_table(28) := '20414E44204E4F4E494E4652494E47454D454E542E20494E204E4F204556454E54205348414C4C205448450D0A20202020202A20415554484F5253204F5220434F5059524947485420484F4C44455253204245204C4941424C4520464F5220414E592043';
wwv_flow_api.g_varchar2_table(29) := '4C41494D2C2044414D41474553204F52204F544845520D0A20202020202A204C494142494C4954592C205748455448455220494E20414E20414354494F4E204F4620434F4E54524143542C20544F5254204F52204F54484552574953452C204152495349';
wwv_flow_api.g_varchar2_table(30) := '4E472046524F4D2C0D0A20202020202A204F5554204F46204F5220494E20434F4E4E454354494F4E20574954482054484520534F465457415245204F522054484520555345204F52204F54484552204445414C494E475320494E205448450D0A20202020';
wwv_flow_api.g_varchar2_table(31) := '202A20534F4654574152452E0D0A20202020202A2F0D0A0D0A20202020636F6E737420637265617465506C7567696E4974656D203D20286974656D49442C206974656D4A534F4E29203D3E207B0D0A202020202020636F6E7374207B0D0A202020202020';
wwv_flow_api.g_varchar2_table(32) := '20202F2F2064657374727563746572696E67204A534F4E0D0A2020202020202020726561644F6E6C793A20726561644F6E6C792C0D0A2020202020202020736570657261746F723A20736570657261746F722C0D0A2020202020202020636F6C756D6E3A';
wwv_flow_api.g_varchar2_table(33) := '20636F6C756D6E2C0D0A20202020202020206C696E6B436C61737365733A206C696E6B436C61737365732C0D0A20202020202020206C696E6B417474726962757465733A206C696E6B417474726962757465732C0D0A2020202020207D203D206974656D';
wwv_flow_api.g_varchar2_table(34) := '4A534F4E0D0A0D0A2020202020206C6574206974656D496478203D20300D0A0D0A202020202020636F6E737420706C7567696E6E616D65203D20276967717569636B76616C75657327202F2F20506C7567696E204E616D65207A75722065696E68656974';
wwv_flow_api.g_varchar2_table(35) := '6C696368656E2045727374656C6C756E6720766F6E205661726961626C656E0D0A2020202020202F2A20435353205661726961626C656E202A2F0D0A202020202020636F6E737420435353706C7567696E436C617373203D20706C7567696E6E616D6520';
wwv_flow_api.g_varchar2_table(36) := '2F2F204D61726B6965727420506C7567696E20446F6D20456C656D656E74650D0A202020202020636F6E737420435353706C7567696E436C61737347726F7570203D20706C7567696E6E616D65202B20272D67726F757027202F2F20506172656E74206D';
wwv_flow_api.g_varchar2_table(37) := '697420626973207A75206D6568726572656E204974656D730D0A202020202020636F6E737420435353706C7567696E436C6173734974656D203D20706C7567696E6E616D65202B20272D6974656D27202F2F2045696E7A656C6E6573204974656D0D0A20';
wwv_flow_api.g_varchar2_table(38) := '2020202020636F6E737420435353706C7567696E436C617373456E61626C6564203D20706C7567696E6E616D65202B20272D656E61626C656427202F2F20456E61626C65642053746174650D0A202020202020636F6E737420435353706C7567696E436C';
wwv_flow_api.g_varchar2_table(39) := '61737344697361626C6564203D20706C7567696E6E616D65202B20272D64697361626C656427202F2F2044697361626C65642053746174650D0A0D0A202020202020636F6E737420706C7567696E4974656D24203D2024286023247B6974656D49447D60';
wwv_flow_api.g_varchar2_table(40) := '290D0A2020202020202F2F20636F6E736F6C652E64656275672827706C7567696E4974656D24272C20706C7567696E4974656D24290D0A0D0A202020202020636F6E737420676574446973706C61794974656D4D61726B7570203D2028626F6F6C2C2076';
wwv_flow_api.g_varchar2_table(41) := '616C756529203D3E207B0D0A2020202020202020636F6E73742068746D6C203D20617065782E7574696C2E68746D6C4275696C64657228290D0A2020202020202020636F6E73742076616C756573203D2076616C7565203F2076616C75652E73706C6974';
wwv_flow_api.g_varchar2_table(42) := '28736570657261746F7229203A205B27275D0D0A0D0A20202020202020202F2F205772617070696E67204449560D0A202020202020202068746D6C0D0A202020202020202020202E6D61726B757028273C64697627290D0A202020202020202020202E61';
wwv_flow_api.g_varchar2_table(43) := '7474722827636C617373272C2060247B435353706C7567696E436C6173737D20247B435353706C7567696E436C61737347726F75707D6029202F2F544F444F20497267656E6465696E65204E6174697665204B6C617373653F0D0A202020202020202020';
wwv_flow_api.g_varchar2_table(44) := '202E6D61726B757028273E27290D0A20202020202020202F2F204D756C7469706C6520416E63686F72730D0A2020202020202020666F7220286C65742078203D20303B2078203C2076616C7565732E6C656E6774683B20782B2B29207B0D0A2020202020';
wwv_flow_api.g_varchar2_table(45) := '2020202020636F6E73742076616C203D2076616C7565735B785D0D0A202020202020202020202F2F20446973706C6179204974656D0D0A2020202020202020202068746D6C0D0A2020202020202020202020202E6D61726B757028273C6127290D0A2020';
wwv_flow_api.g_varchar2_table(46) := '202020202020202020202E6174747228276964272C2060247B6974656D49447D5F247B6974656D4964787D5F3060290D0A2020202020202020202020202E617474722827636C617373272C206C696E6B436C6173736573290D0A20202020202020202020';
wwv_flow_api.g_varchar2_table(47) := '20202E6D61726B7570286C696E6B41747472696275746573290D0A2020202020202020202020202E617474722827746162696E646578272C202D31290D0A2020202020202020202020202E6F7074696F6E616C41747472282764697361626C6564272C20';
wwv_flow_api.g_varchar2_table(48) := '726561644F6E6C79290D0A2020202020202020202020202E6D61726B757028273E27290D0A2020202020202020202020202E636F6E74656E742876616C290D0A2020202020202020202020202E6D61726B757028273C2F613E27290D0A20202020202020';
wwv_flow_api.g_varchar2_table(49) := '2020206974656D496478202B3D20310D0A20202020202020207D0D0A20202020202020202F2F20636F6E736F6C652E64656275672827676574446973706C61794974656D4D61726B75703A272C2068746D6C290D0A202020202020202072657475726E20';
wwv_flow_api.g_varchar2_table(50) := '68746D6C2E746F537472696E6728290D0A2020202020207D0D0A0D0A202020202020636F6E7374207361766556616C7565546F477269644D6F64656C203D20286A71756572794974656D2429203D3E207B0D0A20202020202020202F2F20636F6E736F6C';
wwv_flow_api.g_varchar2_table(51) := '652E646562756728277361766556616C7565546F477269644D6F64656C3A206A71756572794974656D243A272C206A71756572794974656D24290D0A20202020202020202F2F2053706563686572742064656E205765727420696E732049472047726964';
wwv_flow_api.g_varchar2_table(52) := '204D6F64656C0D0A2020202020202020636F6E7374207265636F72644944203D206A71756572794974656D242E636C6F736573742827747227292E646174612827696427290D0A20202020202020202F2F20636F6E736F6C652E64656275672827736176';
wwv_flow_api.g_varchar2_table(53) := '6556616C7565546F477269644D6F64656C3A207265636F726449443A272C207265636F72644944290D0A0D0A2020202020202020636F6E737420726567696F6E4944203D2024286A71756572794974656D242E706172656E747328272E612D4947272929';
wwv_flow_api.g_varchar2_table(54) := '2E617474722827696427292E736C69636528302C202D3329202F2F526567696F6E205374617469632049440D0A20202020202020202F2F20636F6E736F6C652E646562756728277361766556616C7565546F477269644D6F64656C3A20726567696F6E49';
wwv_flow_api.g_varchar2_table(55) := '443A272C20726567696F6E4944290D0A0D0A2020202020202020636F6E737420726567696F6E576964676574203D20617065782E726567696F6E28726567696F6E4944292E77696467657428290D0A20202020202020202F2F20636F6E736F6C652E6465';
wwv_flow_api.g_varchar2_table(56) := '62756728277361766556616C7565546F477269644D6F64656C3A20726567696F6E5769646765743A272C20726567696F6E576964676574290D0A0D0A2020202020202020636F6E7374207B206D6F64656C3A20677269644D6F64656C207D203D20726567';
wwv_flow_api.g_varchar2_table(57) := '696F6E5769646765742E696E74657261637469766547726964280D0A20202020202020202020276765745669657773272C0D0A202020202020202020202767726964270D0A2020202020202020290D0A20202020202020202F2F20636F6E736F6C652E64';
wwv_flow_api.g_varchar2_table(58) := '6562756728277361766556616C7565546F477269644D6F64656C3A20677269644D6F64656C3A272C20677269644D6F64656C290D0A0D0A2020202020202020636F6E7374207265636F7264203D20677269644D6F64656C2E6765745265636F7264287265';
wwv_flow_api.g_varchar2_table(59) := '636F72644944290D0A20202020202020202F2F20636F6E736F6C652E646562756728277361766556616C7565546F477269644D6F64656C3A207265636F72643A272C207265636F7264290D0A0D0A2020202020202020677269644D6F64656C2E73657456';
wwv_flow_api.g_varchar2_table(60) := '616C7565287265636F72642C20636F6C756D6E2C206A71756572794974656D242E746578742829290D0A20202020202020202F2F20636F6E736F6C652E646562756728277361766556616C7565546F477269644D6F64656C3A206974656D2056616C7565';
wwv_flow_api.g_varchar2_table(61) := '3A272C206A71756572794974656D242E746578742829290D0A2020202020207D0D0A0D0A2020202020202F2F20416464204576656E742048616E646C657220666F7220436C69636B206F6E20416E63686F72730D0A2020202020202F2F204E6963687420';
wwv_flow_api.g_varchar2_table(62) := '646965206265737465204CC3B673756E670D0A202020202020706C7567696E4974656D242E706172656E747328276469765B69642A3D225F6967225D27292E6F6E2822636C69636B222C20602E247B435353706C7567696E436C6173737D2061602C2028';
wwv_flow_api.g_varchar2_table(63) := '6529203D3E207B0D0A20202020202020202F2F20636F6E736F6C652E64656275672822636C69636B206576656E7420666F7220706C7567696E3A20222C2065290D0A0D0A20202020202020202F2F205365742056616C75652066726F6D20416E63686F72';
wwv_flow_api.g_varchar2_table(64) := '20746F204772696420436F6C756D6E0D0A2020202020202020636F6E737420616E63686F7242746E24203D202428652E63757272656E74546172676574290D0A20202020202020207361766556616C7565546F477269644D6F64656C28616E63686F7242';
wwv_flow_api.g_varchar2_table(65) := '746E24290D0A2020202020207D290D0A0D0A2020202020202F2F20456E61626C65206974656D0D0A202020202020696620286974656D4A534F4E2E726561644F6E6C7929207B0D0A2020202020202020706C7567696E4974656D240D0A20202020202020';
wwv_flow_api.g_varchar2_table(66) := '2020202E636C6F7365737428602E247B435353706C7567696E436C6173737D60290D0A202020202020202020202E72656D6F7665436C61737328435353706C7567696E436C61737344697361626C6564290D0A202020202020202020202E616464436C61';
wwv_flow_api.g_varchar2_table(67) := '737328435353706C7567696E436C617373456E61626C6564290D0A2020202020207D0D0A0D0A2020202020202F2F2063726561746520616E2041706578204974656D0D0A202020202020617065782E6974656D2E637265617465286974656D49442C207B';
wwv_flow_api.g_varchar2_table(68) := '0D0A202020202020202073657456616C75652876616C756529207B0D0A20202020202020202020706C7567696E4974656D242E76616C2876616C7565290D0A20202020202020207D2C0D0A202020202020202064697361626C652829207B0D0A20202020';
wwv_flow_api.g_varchar2_table(69) := '202020202020706C7567696E4974656D240D0A2020202020202020202020202E636C6F7365737428602E247B435353706C7567696E436C6173737D60290D0A2020202020202020202020202E616464436C61737328435353706C7567696E436C61737344';
wwv_flow_api.g_varchar2_table(70) := '697361626C6564290D0A2020202020202020202020202E72656D6F7665436C61737328435353706C7567696E436C617373456E61626C6564290D0A20202020202020202020706C7567696E4974656D242E70726F70282764697361626C6564272C207472';
wwv_flow_api.g_varchar2_table(71) := '7565290D0A20202020202020207D2C0D0A2020202020202020656E61626C652829207B0D0A20202020202020202020696620286974656D4A534F4E2E726561644F6E6C7929207B0D0A202020202020202020202020706C7567696E4974656D240D0A2020';
wwv_flow_api.g_varchar2_table(72) := '2020202020202020202020202E636C6F7365737428602E247B435353706C7567696E436C6173737D60290D0A20202020202020202020202020202E72656D6F7665436C61737328435353706C7567696E436C61737344697361626C6564290D0A20202020';
wwv_flow_api.g_varchar2_table(73) := '202020202020202020202E616464436C61737328435353706C7567696E436C617373456E61626C6564290D0A202020202020202020202020706C7567696E4974656D242E70726F70282764697361626C6564272C2066616C7365290D0A20202020202020';
wwv_flow_api.g_varchar2_table(74) := '2020207D0D0A20202020202020207D2C0D0A2020202020202020646973706C617956616C7565466F722876616C756529207B0D0A2020202020202020202072657475726E20676574446973706C61794974656D4D61726B757028747275652C2076616C75';
wwv_flow_api.g_varchar2_table(75) := '65290D0A20202020202020207D2C0D0A2020202020207D290D0A202020207D0D0A20207D2C0D0A5D290D0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(16883482435635550)
,p_plugin_id=>wwv_flow_api.id(16874700833335002)
,p_file_name=>'js/igquickvalues.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2E612D47562D636F6C756D6E4974656D202E6967717569636B76616C75657320696E7075745B747970653D2774657874275D2C0A2E612D47562D636F6C756D6E4974656D202E6967717569636B76616C75657320696E7075745B747970653D2774657874';
wwv_flow_api.g_varchar2_table(2) := '275D3A666F6375732C0A2E6967717569636B76616C75657320696E7075745B747970653D2774657874275D2C0A2E6967717569636B76616C75657320696E7075745B747970653D2774657874275D3A666F637573207B0A2020626F726465722D77696474';
wwv_flow_api.g_varchar2_table(3) := '683A20302021696D706F7274616E743B0A20206865696768743A20302021696D706F7274616E743B0A202070616464696E673A20302021696D706F7274616E743B0A202077696474683A20302021696D706F7274616E743B0A7D0A2E6967717569636B76';
wwv_flow_api.g_varchar2_table(4) := '616C756573207B0A202070616464696E672D6C6566743A20303B0A2020746578742D616C69676E3A2063656E7465723B0A202077696474683A20313030253B0A7D0A2E6967717569636B76616C7565732D67726F7570207B0A2020646973706C61793A20';
wwv_flow_api.g_varchar2_table(5) := '666C65783B0A2020666C65783A20312030206175746F3B0A2020666C65782D777261703A206E6F777261703B0A7D0A2E6967717569636B76616C7565732D67726F75702061207B0A2020666C65783A312030206175746F3B0A7D0A2E68696465456D7074';
wwv_flow_api.g_varchar2_table(6) := '793A656D707479207B0A2020646973706C61793A6E6F6E653B200A7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(17076376256573368)
,p_plugin_id=>wwv_flow_api.id(16874700833335002)
,p_file_name=>'css/igquickvalues.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
prompt --application/end_environment
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/
set verify on feedback on define on
prompt  ...done