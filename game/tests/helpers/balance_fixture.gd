class_name BalanceFixture
extends RefCounted
## Smallest set of CSV tables that passes every importer validation:
## one saint with a full kit, one enemy, one encounter and one provision.
## Tests change one table at a time to provoke a specific error.


static func valid_tables() -> Dictionary:
	return {
		"constants": "key,value,description\nfervor_cap,6,Máximo\nbread_heal,5,Cura do Pão\nxp_thresholds,0|40|100,Níveis\n",
		"economy": "key,value,description\nreward_battle,70,Esmolas por combate comum\n",
		"conditions": "id,kind,polarity,max_stacks,stacking,decay,tick,consume_on,resisted_by_will,hook,icon,display_priority,name_pt,desc_pt\n"
			+ "stun,token,negative,1,none,none,none,on_action_attempt,false,stun_cancel,res://x.png,1,Atordoamento,Perde a ação.\n"
			+ "ward,token,positive,3,add,none,none,on_hit_received,false,ward_halve,res://y.png,5,Amparo,\"Metade, do dano.\"\n",
		"traits": "id,owner,name_pt,trigger,hook,params,desc_pt\ntrait_t,saint_t,Traço,passive,test_hook,mult=2,Descrição.\n",
		"camp_skills": "id,owner,name_pt,effect,params,desc_pt\ncamp_t,saint_t,Guarda,ambush_mult,value=0.5,Descrição.\n",
		"abilities": "id,owner,name_pt,kind,cost,use_slots,targeting,target_slots,allow_self,once_per_battle,origin,upgrade,desc_pt\n"
			+ "t_strike,saint_t,Golpe,basic,0,1|2|3,enemy,1|2,,,game_fiction,,Golpe.\n"
			+ "t_bash,saint_t,Pancada,basic,1,1,enemy,1,,,game_fiction,,Atordoa.\n"
			+ "t_guard,saint_t,Guarda,basic,0,1|2|3,ally,1|2|3,y,,tradition,,Amparo.\n"
			+ "t_pray,saint_t,Prece,basic,0,2|3,self,,,,legend,,Alívio.\n"
			+ "t_charge,saint_t,Investida,fervor,2,1,enemy_group,1|2,,,game_fiction,,Grupo.\n"
			+ "t_rally,saint_t,Reunir,fervor,2,1|2|3,all_allies,,,,game_fiction,,Todos.\n"
			+ "t_miracle,saint_t,Milagre,miracle,3,1|2|3,chosen_enemy_slots(2),1|2|3|4,,,legend,,Dois alvos.\n",
		"effects": "owner_id,order,type,amount,damage_type,condition_id,stacks,polarity,move_kind,n,summon_id,max_alive,target_override,params\n"
			+ "t_strike,1,damage,7,strike,,,,,,,,,\n"
			+ "t_bash,1,damage,4,strike,,,,,,,,,\n"
			+ "t_bash,2,apply_condition,,,stun,1,,,,,,,\n"
			+ "t_guard,1,apply_condition,,,ward,1,,,,,,,\n"
			+ "t_pray,1,desolation,-10,,,,,,,,,,\n"
			+ "t_charge,1,damage,6,strike,,,,,,,,,elite=2.0;boss=2.0\n"
			+ "t_rally,1,remove_condition,,,,1,negative,,,,,,\n"
			+ "t_miracle,1,damage,6,exorcism,,,,,,,,,\n"
			+ "t_miracle,2,move,,,,,,push,1,,,,\n"
			+ "e_hit,1,damage,4,untyped,,,,,,,,,\n"
			+ "e_brood,1,summon,,,,,,,,enemy_e,2,,\n"
			+ "bread,1,heal,99,,,,,,,,,,const=bread_heal\n",
		"enemy_actions": "id,priority,use_slots,target_slots,targeting,target_rule,conditions,cooldown,intent_icon\n"
			+ "e_brood,1,3|4,,self,front_most,every_n_rounds:2|free_enemy_slot,0,summon\n"
			+ "e_hit,2,1|2|3|4,1|2,single,front_most,always,0,attack\n",
		"enemies": "id,name_pt,family,circles,nature,role,size,max_hp,armor,immune,leaves_remains,remains_rounds,actions,art_id\n"
			+ "enemy_e,Demônio,a,2|3,corporeal,brute,1,30,1,stun,,,e_hit|e_brood,enemy_e\n",
		"encounters": "id,circle,pool,slot_1,slot_2,slot_3,slot_4,type\nenc_1,m0,easy,enemy_e,enemy_e,,,common\n",
		"provisions": "id,name_pt,price,usable_in_battle,targeting,effect_ids\nbread,Pão,15,y,ally,bread\n",
		"ui_text": "id,text_pt\nend_turn,Encerrar turno\nround,Rodada {round}\n",
		"map_templates": "id,leg,layer,index,role,type,links\n"
			+ "t_leg,1,1,0,battle,node_battle,0\nt_leg,1,2,0,temptation,node_temptation,0\n"
			+ "t_leg,1,3,0,variable,node_relic,0\nt_leg,1,4,0,battle,node_battle,\n",
		"saints": "id,name_pt,roles,preferred_slots,max_hp,armor,faith,will,hp_per_level,faith_per_level,abilities,default_equipped,miracle,trait,camp_skill,affinities,unlock,m0\n"
			+ "saint_t,Santo Teste,fighter|protector,1|2,32,2,4,1,4,1,t_strike|t_bash|t_guard|t_pray|t_charge|t_rally,t_strike|t_bash|t_guard|t_charge,t_miracle,trait_t,camp_t,soldiers,start,y\n",
	}


## Returns `tables` with `old` replaced by `new` in table `table_name`.
## Fails loudly if `old` is not present, so a typo never makes a test pass.
static func replaced(table_name: String, old: String, new: String) -> Dictionary:
	var tables: Dictionary = valid_tables()
	var text: String = tables[table_name]
	assert(text.contains(old), "Fixture text not found: %s" % old)
	tables[table_name] = text.replace(old, new)
	return tables


static func appended(table_name: String, line: String) -> Dictionary:
	var tables: Dictionary = valid_tables()
	tables[table_name] = String(tables[table_name]) + line + "\n"
	return tables
