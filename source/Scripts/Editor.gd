extends Node2D

var i=0
var li=[] #level data
var line=-1 #li line pointer
var doli=0 #li cell pointer
var skala #skala to instantiate
var stal #level lengt
var done=false #create
var sw
var s
var act=1 #level number
var now
var stab=-1
var kafl=-1 #pos of edited stone
var kafm=-1 #pos of edited middle stone
var kafe=-1 #pos of edited enemy
var y_ms=0
var name
var enm=0 #selected enemy
onready var pan=get_node("../Control/Panel")

const sk50 = preload("res://Objects/Skala50.tscn")
const sk100 = preload("res://Objects/Skala100.tscn")
const sk150 = preload("res://Objects/Skala150.tscn")
const sk200 = preload("res://Objects/Skala200.tscn")
const sk250 = preload("res://Objects/Skala250.tscn")
const sk400 = preload("res://Objects/Skala400.tscn")
const skm = preload("res://Objects/SkalaMid.tscn")
const sk450 = preload("res://Objects/Skala450.tscn")
const P0 = preload("res://Objects/P0.tscn")
const P1 = preload("res://Objects/P1.tscn")
const P2 = preload("res://Objects/P2.tscn")
const P3 = preload("res://Objects/P3.tscn")
const P4 = preload("res://Objects/P4.tscn")
const P5 = preload("res://Objects/P5.tscn")
const P6 = preload("res://Objects/P6.tscn")
const P7 = preload("res://Objects/P7.tscn")
const P8 = preload("res://Objects/P8.tscn")
const P9 = preload("res://Objects/P9.tscn")
const P10 = preload("res://Objects/P10.tscn")
const P11 = preload("res://Objects/P11.tscn")
const P12 = preload("res://Objects/P12.tscn")
const P13 = preload("res://Objects/P13.tscn")
const P15 = preload("res://Objects/P15.tscn")
const P16 = preload("res://Objects/P16.tscn")

func _ready():
	var file = File.new()
	if(file.file_exists("res://Bazy/baza"+str(act)+".txt")==true): #Load level
		file.open("res://Bazy/baza"+str(act)+".txt", file.READ)
		li.clear()
		while file.eof_reached()==false:
			var lv = file.get_line()
			i=0
			line+=1
			doli=0
			li.append([8,8,8,8])
			var ten=0
			while(i<lv.length()):
				if(lv[i]!='|'):
					ten+=1
				else:
					if(ten>=3):
						li[line][doli]=int(lv[i-ten])*100+int(lv[i-ten+1])*10+int(lv[i-ten+2])
					if(ten==2):
						li[line][doli]=int(lv[i-ten])*10+int(lv[i-ten+1])
					if(ten<=1):
						li[line][doli]=int(lv[i-ten])
					ten=0
					doli+=1
				i+=1
		stal=line+1
	else: #Create new level
		line=0
		file.open("res://Bazy/baza"+str(act)+".txt", file.WRITE)
		li.clear()
		while line<50:
			file.store_line("50|00|50|0|")
			li.append([50,0,50,0])
			line+=1
		stal=line
	file.close()
	line=-1
	length()
	text()
	set_fixed_process(true)
	set_process_input(true)
	
	
func _fixed_process(delta):
	
	if(done==false):
		done=create()
	if(kafl!=-1):
		if y_ms+50<get_global_mouse_pos().y||y_ms-50>get_global_mouse_pos().y:
			if stab==0||stab==2:
				if stab==0:
					if(y_ms+50<get_global_mouse_pos().y):
						li[kafl][stab]-=50
					if(y_ms-50>get_global_mouse_pos().y):
						li[kafl][stab]+=50
					if li[kafl][stab]==300:
						li[kafl][stab]=400
					if li[kafl][stab]==350:
						li[kafl][stab]=250
				if stab==2:
					if(y_ms+50<get_global_mouse_pos().y):
						li[kafl][stab]+=50
					if(y_ms-50>get_global_mouse_pos().y):
						li[kafl][stab]-=50
					if li[kafl][stab]==250:
						li[kafl][stab]=400
					if li[kafl][stab]==350:
						li[kafl][stab]=200
				if li[kafl][stab]<50:
					li[kafl][stab]=50
				if li[kafl][stab]>400:
					li[kafl][stab]=400
				y_ms=get_global_mouse_pos().y
				speed_create(kafl)

func _input(event):
	if event.type == InputEvent.MOUSE_BUTTON:
		if get_global_mouse_pos().y>0&&get_global_mouse_pos().y<600:
			if event.is_action_pressed("lmb"):
				kafl=get_global_mouse_pos().x/149
				kafl=int(kafl)
				if get_global_mouse_pos().y<li[kafl][2]+50&&get_global_mouse_pos().y>0:
					stab=2
				if get_global_mouse_pos().y>600-li[kafl][0]&&get_global_mouse_pos().y<600:
					stab=0
				y_ms=get_global_mouse_pos().y
			if event.is_action_pressed("mmb"):
				kafm=get_global_mouse_pos().x/149
				kafm=int(kafm)
				if get_global_mouse_pos().y>0&&get_global_mouse_pos().y<600:
					li[kafm][3]=!li[kafm][3]
					speed_create(kafm)
			if event.is_action_pressed("rmb"):
				kafe=get_global_mouse_pos().x/149
				kafe=int(kafe)
				li[kafe][1]=enm*10+1
				speed_create(kafe)
			if event.is_action_pressed("s_up"):
				kafe=get_global_mouse_pos().x/149
				kafe=int(kafe)
				if li[kafe][1]!=0:
					li[kafe][1]+=1
				if(li[kafe][1]<60):
					if li[kafe][1]%10>2:
						li[kafe][1]=li[kafe][1]-li[kafe][1]%10+2
				if(li[kafe][1]>=60&&li[kafe][1]<120):
					if li[kafe][1]%10>4:
						li[kafe][1]=li[kafe][1]-li[kafe][1]%10+4
				if(li[kafe][1]>=120&&li[kafe][1]<170):
					if li[kafe][1]%10>1:
						li[kafe][1]=li[kafe][1]-li[kafe][1]%10+1
				speed_create(kafe)
			if event.is_action_pressed("s_down"):
				kafe=get_global_mouse_pos().x/149
				kafe=int(kafe)
				if(li[kafe][1]%10>0):
					
					li[kafe][1]-=1
					speed_create(kafe)
					print(li[kafe][1])
		if  event.is_action_released("lmb"):
				stab=-1



func speed_create(doo):
	line=doo
	get_node("../spr").destr(doo)

func create():
	var ch=get_child_count()
	var z=0
	while z<ch:
		get_child(z).queue_free()
		z+=1
	line=0
	while(line<stal):
		core_create()
		line+=1
	return true
	
func core_create():
	doli=0
	while doli<4:
		if(doli==0):
			if(li[line][doli]==50):
				skala=sk50.instance()
				skala.set_pos(Vector2(74+line*149,575))
			if(li[line][doli]==100):
				skala=sk100.instance()
				skala.set_pos(Vector2(74+line*149,550))
			if(li[line][doli]==150):
				skala=sk150.instance()
				skala.set_pos(Vector2(74+line*149,525))
			if(li[line][doli]==200):
				skala=sk200.instance()
				skala.set_pos(Vector2(74+line*149,500))
			if(li[line][doli]==250):
				skala=sk250.instance()
				skala.set_pos(Vector2(74+line*149,475))
			if(li[line][doli]==400):
				skala=sk400.instance()
				skala.set_pos(Vector2(74+line*149,400))
			get_tree().get_root().get_node("/root/Editor/Skala").add_child(skala)
		if(doli==1):
			sw=(li[line][doli]-(li[line][doli]%10))/10
			if(sw==10):
				s=0
				while s<li[line][doli]%10&&s<(550-li[line][doli+1]-li[line][doli-1])/100:
					skala=P10.instance()
					skala.set_pos(Vector2(74+line*149,50+li[line][doli+1]+(skala.get_node("Sprite").get_texture().get_size().y/2)+s*100))
					get_tree().get_root().get_node("/root/Editor/Skala").add_child(skala)
					s+=1
			if(sw==11):
				s=0
				while s<li[line][doli]%10&&s<4:
					skala=P11.instance()
					skala.set_pos(Vector2(74+line*149,50+li[line][doli+1]+(skala.get_node("Sprite").get_texture().get_size().y/2)+s*100))
					get_tree().get_root().get_node("/root/Editor/Skala").add_child(skala)
					s+=1
			if(sw==12):
				if(li[line][doli]%10>0):
					skala=P12.instance()
					skala.set_pos(Vector2(74+line*149,600-li[line][doli-1]-skala.get_node("Sprite").get_texture().get_size().y/2))
					get_tree().get_root().get_node("/root/Editor/Skala").add_child(skala)
			if(sw==13):
				if(li[line][doli]%10>0):
					skala=P13.instance()
					skala.set_pos(Vector2(74+line*149,600-li[line][doli-1]-skala.get_node("Sprite").get_texture().get_size().y/2))
					get_tree().get_root().get_node("/root/Editor/Skala").add_child(skala)
			if(sw==15):
				if(li[line][doli]%10>0):
					skala=P15.instance()
					skala.set_pos(Vector2(74+line*149,600-li[line][doli-1]-skala.get_node("Sprite").get_texture().get_size().y/2))
					get_tree().get_root().get_node("/root/Editor/Skala").add_child(skala)
			if(sw==16):
				if(li[line][doli]%10>0):
					skala=P16.instance()
					skala.set_pos(Vector2(74+line*149,50+li[line][doli+1]+(skala.get_node("Sprite").get_texture().get_size().y/2)))
					get_tree().get_root().get_node("/root/Editor/Skala").add_child(skala)
			if(sw==0):
	#					if(li[line][doli+2]>=1):
	#						pass
	#					else:
					if(li[line][doli]%10==1):
						skala=P0.instance()
						skala.set_pos(Vector2(74+line*149,li[line][doli+1]/2+350-li[line][doli-1]/2))
						get_tree().get_root().get_node("/root/Editor/Skala").add_child(skala)
					if(li[line][doli]%10>=2):
						skala=P0.instance()
						skala.set_pos(Vector2(74+line*149,li[line][doli+1]+50+(600-li[line][doli-1]-li[line][doli+1])/3))
						get_tree().get_root().get_node("/root/Editor/Skala").add_child(skala)
						skala=P0.instance()
						skala.set_pos(Vector2(74+line*149,li[line][doli+1]+50+((600-li[line][doli-1]-li[line][doli+1])/3)*2))
						get_tree().get_root().get_node("/root/Editor/Skala").add_child(skala)
			if(sw==1):
				if(li[line][doli]%10==1):
					skala=P1.instance()
					skala.set_pos(Vector2(74+line*149,li[line][doli+1]/2+350-li[line][doli-1]/2))
					get_tree().get_root().get_node("/root/Editor/Skala").add_child(skala)
				if(li[line][doli]%10>=2):
					skala=P1.instance()
					skala.set_pos(Vector2(74+line*149,li[line][doli+1]+50+(600-li[line][doli-1]-li[line][doli+1])/3))
					get_tree().get_root().get_node("/root/Editor/Skala").add_child(skala)
					skala=P1.instance()
					skala.set_pos(Vector2(74+line*149,li[line][doli+1]+50+((600-li[line][doli-1]-li[line][doli+1])/3)*2))
					get_tree().get_root().get_node("/root/Editor/Skala").add_child(skala)
			if(sw==2):
				if(li[line][doli]%10==1):
					skala=P2.instance()
					skala.set_pos(Vector2(74+line*149,li[line][doli+1]/2+350-li[line][doli-1]/2))
					get_tree().get_root().get_node("/root/Editor/Skala").add_child(skala)
				if(li[line][doli]%10>=2):
					skala=P2.instance()
					skala.set_pos(Vector2(74+line*149,li[line][doli+1]+50+(600-li[line][doli-1]-li[line][doli+1])/3))
					get_tree().get_root().get_node("/root/Editor/Skala").add_child(skala)
					skala=P2.instance()
					skala.set_pos(Vector2(74+line*149,li[line][doli+1]+50+((600-li[line][doli-1]-li[line][doli+1])/3)*2))
					get_tree().get_root().get_node("/root/Editor/Skala").add_child(skala)
			if(sw==3):
				if(li[line][doli]%10==1):
					skala=P3.instance()
					skala.set_pos(Vector2(74+line*149,li[line][doli+1]/2+350-li[line][doli-1]/2))
					get_tree().get_root().get_node("/root/Editor/Skala").add_child(skala)
				if(li[line][doli]%10>=2):
					skala=P3.instance()
					skala.set_pos(Vector2(74+line*149,li[line][doli+1]+50+(600-li[line][doli-1]-li[line][doli+1])/3))
					get_tree().get_root().get_node("/root/Editor/Skala").add_child(skala)
					skala=P3.instance()
					skala.set_pos(Vector2(74+line*149,li[line][doli+1]+50+((600-li[line][doli-1]-li[line][doli+1])/3)*2))
					get_tree().get_root().get_node("/root/Editor/Skala").add_child(skala)
			if(sw==4):
				if(li[line][doli]%10==1):
					skala=P4.instance()
					skala.set_pos(Vector2(74+line*149,li[line][doli+1]/2+350-li[line][doli-1]/2))
					get_tree().get_root().get_node("/root/Editor/Skala").add_child(skala)
				if(li[line][doli]%10>=2):
					skala=P4.instance()
					skala.set_pos(Vector2(74+line*149,li[line][doli+1]+50+(600-li[line][doli-1]-li[line][doli+1])/3))
					get_tree().get_root().get_node("/root/Editor/Skala").add_child(skala)
					skala=P4.instance()
					skala.set_pos(Vector2(74+line*149,li[line][doli+1]+50+((600-li[line][doli-1]-li[line][doli+1])/3)*2))
					get_tree().get_root().get_node("/root/Editor/Skala").add_child(skala)
			if(sw==5):
				if(li[line][doli]%10==1):
					skala=P5.instance()
					skala.set_pos(Vector2(74+line*149,li[line][doli+1]/2+350-li[line][doli-1]/2))
					get_tree().get_root().get_node("/root/Editor/Skala").add_child(skala)
				if(li[line][doli]%10>=2):
					skala=P5.instance()
					skala.set_pos(Vector2(74+line*149,li[line][doli+1]+50+(600-li[line][doli-1]-li[line][doli+1])/3))
					get_tree().get_root().get_node("/root/Editor/Skala").add_child(skala)
					skala=P5.instance()
					skala.set_pos(Vector2(74+line*149,li[line][doli+1]+50+((600-li[line][doli-1]-li[line][doli+1])/3)*2))
					get_tree().get_root().get_node("/root/Editor/Skala").add_child(skala)
			if(sw==6):
				s=0
				while s<li[line][doli]%10&&s<4:
					skala=P6.instance()
					skala.set_pos(Vector2(74+line*149,50+li[line][doli+1]+(skala.get_node("Sprite").get_texture().get_size().y/2)+s*100))
					get_tree().get_root().get_node("/root/Editor/Skala").add_child(skala)
					s+=1
			if(sw==7):
				s=0
				while s<li[line][doli]%10&&s<4:
					skala=P7.instance()
					skala.set_pos(Vector2(74+line*149,50+li[line][doli+1]+(skala.get_node("Sprite").get_texture().get_size().y/2)+s*100))
					get_tree().get_root().get_node("/root/Editor/Skala").add_child(skala)
					s+=1
			if(sw==8):
				s=0
				while s<li[line][doli]%10&&s<4:
					skala=P8.instance()
					skala.set_pos(Vector2(74+line*149,50+li[line][doli+1]+(skala.get_node("Sprite").get_texture().get_size().y/2)+s*100))
					get_tree().get_root().get_node("/root/Editor/Skala").add_child(skala)
					s+=1
			if(sw==9):
				s=0
				while s<li[line][doli]%10&&s<4:
					skala=P9.instance()
					skala.set_pos(Vector2(74+line*149,50+li[line][doli+1]+(skala.get_node("Sprite").get_texture().get_size().y/2)+s*100))
					get_tree().get_root().get_node("/root/Editor/Skala").add_child(skala)
					s+=1
				
		if(doli==2):
			if(li[line][doli]==50):
				skala=sk100.instance()
				skala.set_pos(Vector2(74+line*149,50))
				skala.get_node("Sprite").set_flip_v(true)
			if(li[line][doli]==100):
				skala=sk150.instance()
				skala.set_pos(Vector2(74+line*149,75))
				skala.get_node("Sprite").set_flip_v(true)
			if(li[line][doli]==150):
				skala=sk200.instance()
				skala.set_pos(Vector2(74+line*149,100))
				skala.get_node("Sprite").set_flip_v(true)
			if(li[line][doli]==200):
				skala=sk250.instance()
				skala.set_pos(Vector2(74+line*149,125))
				skala.get_node("Sprite").set_flip_v(true)
			if(li[line][doli]==400):
				skala=sk450.instance()
				skala.set_pos(Vector2(74+line*149,225))
			get_tree().get_root().get_node("/root/Editor/Skala").add_child(skala)
		if(doli==3):
			if(li[line][doli]>=1):
				skala=skm.instance()
				skala.set_pos(Vector2(74+line*149,297))
				get_tree().get_root().get_node("/root/Editor/Skala").add_child(skala)
		doli+=1


func _on_Lv_text_changed( text ):
	act=int(text)
	if(str(act)!=text):
		get_node("../Control/Lv").set_text(str(act))
	get_node("../Control/Lv").set_cursor_pos(2)


func _on_Load_pressed():
	line=-1
	var file = File.new()
	if(file.file_exists("res://Bazy/baza"+str(act)+".txt")==true): #Load level
		file.open("res://Bazy/baza"+str(act)+".txt", file.READ)
		li.clear()
		while file.eof_reached()==false:
			var lv = file.get_line()
			i=0
			line+=1
			doli=0
			li.append([8,8,8,8])
			var ten=0
			while(i<lv.length()):
				if(lv[i]!='|'):
					ten+=1
				else:
					if(ten>=3):
						li[line][doli]=int(lv[i-ten])*100+int(lv[i-ten+1])*10+int(lv[i-ten+2])
					if(ten==2):
						li[line][doli]=int(lv[i-ten])*10+int(lv[i-ten+1])
					if(ten<=1):
						li[line][doli]=int(lv[i-ten])
					ten=0
					doli+=1
				i+=1
		stal=line+1
	else:
		line=0
		file.open("res://Bazy/baza"+str(act)+".txt", file.WRITE)
		li.clear()
		while line<50:
			file.store_line("50|00|50|0|")
			li.append([50,0,50,0])
			line+=1
		file.close()
		stal=line
	file.close()
	line=-1
	done=false
	length()
	text()


func _on_Up_pressed():
	var text =get_node("../Control/Lv").get_text()
	act=int(text)
	act+=1
	if(str(act)!=text):
		get_node("../Control/Lv").set_text(str(act))
	get_node("../Control/Lv").set_cursor_pos(2)


func _on_Down_pressed():
	var text =get_node("../Control/Lv").get_text()
	act=int(text)
	act-=1
	if(act<0):
		act=0
	if(str(act)!=text):
		get_node("../Control/Lv").set_text(str(act))
	get_node("../Control/Lv").set_cursor_pos(2)


func _on_Save_pressed():
	line=0
	var file = File.new()
	file.open("res://Bazy/baza"+str(act)+".txt", file.WRITE)
	while line<stal:
		doli=0
		while(doli<4):
			if(int(li[line][doli])%10==0&&doli==1):
				file.store_string("00")
			else:
				if(int(li[line][1])<10&&doli==1):
					file.store_string("0")
				file.store_string(str(int(li[line][doli])))
			file.store_string("|")
			doli+=1
		line+=1
		if(line<stal):
			file.store_string("\n")
	file.close()
	line=0

func _on_Clear_pressed():
	line=0
	var file = File.new()
	file.open("res://Bazy/baza"+str(act)+".txt", file.WRITE)
	li.clear()
	while line<50:
		file.store_line("50|00|50|0|")
		li.append([50,0,50,0])
		line+=1
	file.close()
	stal=line
	line=0
	length()
	done=false

func text(): #show level name
	now=act
	get_node("../Control/attribute1").set_text("Poziom: "+str(now)+" - ")
	var tx=get_node("../Control/attribute1").get_text()
	if(now==0):
		get_node("../Control/attribute1").set_text(tx+"Test")
	if now>0&&now<=4:
		get_node("../Control/attribute1").set_text(tx+"Kosmos")
	if now>4&&now<=8:
		get_node("../Control/attribute1").set_text(tx+"Indor")
	if now>8&&now<=12:
		get_node("../Control/attribute1").set_text(tx+"Jajo")
	if now>12:
		get_node("../Control/attribute1").set_text(tx+"?")
	if now==4||now==8||now==12:
		get_node("../Control/attribute2").set_text("Boss")
	else:
		get_node("../Control/attribute2").set_text("")

func length():
	get_node("/root/Editor/Control/ScrollBar").set_max((stal-9)*149) #set length bar
	get_node("../Control/leng").set_text(str(stal))

func _on_Left_pressed():
	stal-=1
	done=false
	length()

func _on_Right_pressed():
	stal+=1
	if(stal>li.size()):
		li.append([50,0,50,0])
	done=false
	length()

func _on_leng_text_changed( text ):
	var a=stal
	stal=int(text)
	while(a<stal):
		li.append([50,0,50,0])
		a+=1
	done=false
	length()
	
