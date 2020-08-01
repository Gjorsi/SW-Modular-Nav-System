ini,on = false,false
io={}
io.gN,io.gB,io.sN,io.sB=input.getNumber,input.getBool,output.setNumber,output.setBool
s={}
s.drf,s.dr,s.dt,s.dtb,s.sc=screen.drawRectF,screen.drawRect,screen.drawText,screen.drawTextBox,screen.setColor
alphabet={'Q','W','E','R','T','Y','U','I','O','P','A','S','D','F','G','H','J','K','L','Z','X','C','V','B','N','M'}
text=""
message={0,0,0,0}
rec={0,0,0,0}

function onTick()
  
  if on ~= io.gB(3) and on then
    for i=1,4 do
      io.sN(i,0)
    end
  end
  on=io.gB(3)
  
	if ini and on then
  
    click=io.gB(1)
    tX,tY=io.gN(3),io.gN(4)
    screenClk(tX,tY,click)
    
    for i=1,4 do
      rec[i]=io.gN(6+i)
      
      if message[i] > 0 then
        io.sN(i,message[i])
      else 
        io.sN(i,0)
      end
    end
  end
end

function addChar(ch)
  if #text < 12 then
    text=text..ch
  end
end

function backspace()
  if #text > 0 then
    text = text:sub(1,-2)
  end
end

function send()
  message={0,0,0,0}
  if #text > 0 then
    str=""
    for i=1,#text do
      str = str..code[text:sub(i,i)]
    end
    for i=1,#str,6 do
      message[1+math.floor(i/6)]=tonumber(str:sub(i,math.min(i+5,#str)))
    end
  end
end

function receive()
  received=""
  for i=1,4 do
    if rec[i] > 0 then
      r = string.format("%d",rec[i])
      for j=1,#r,2 do
      received = received..deco[tonumber(r:sub(j,j+1))]
      end
    end
  end
end

function init()
	ini=true
  c={x=w/2,y=h/2}
  f=h/32
  
  code = {}
  deco = {}
  for i=0,9 do
    deco[10+i]=string.format("%d",i)
    code[string.format("%d",i)]=10+i
  end
  
  for i=1,26 do
    deco[19+i]=alphabet[i]
    code[alphabet[i]]=19+i
  end
  
  buttons={}
  for i=1,9 do
    addBtn(1+6*(i-1),c.y+3,6,6,i, function() addChar(i) end, true,true)
  end
  addBtn(1+6*(9),c.y+3,6,6,0, function() addChar(0) end, true,true)
  for i=1,10 do
    addBtn(1+6*(i-1),c.y+9,6,6,alphabet[i], function() addChar(alphabet[i]) end, true,true)
  end
  for i=1,9 do
    addBtn(1+6*(i-1),c.y+15,6,6,alphabet[10+i], function() addChar(alphabet[10+i]) end, true,true)
  end
  for i=1,7 do
    addBtn(1+6*(i-1),c.y+21,6,6,alphabet[19+i], function() addChar(alphabet[19+i]) end, true,true)
  end
  
  addBtn(1+6*(9),c.y+15,6,6,"<", function() backspace() end, true,true)
  addBtn(1+6*(7),c.y+21,16,6,"ENT", function() send() end, true,true)
end

function addBtn(x,y,w,h,t,f,r,hold)
	local data = {
		['x']=(x or 0),
		['y']=(y or 0),
		['w']=(w or 0),
		['h']=(h or 0),
		['t']=(t or "err"),
		['f']=(f or nil),
    ['r']=(r or false),
    ['hold']=(hold or false),
    ['p']=(false)
	}
	table.insert(buttons,data)
end

function inrange(cx, cy, x, y, w, h)
	return (cx > x and cy > y and cx <= (x + w) and cy <= (y + h)) and true or false
end

function screenClk(x, y,click)
	for k,b in pairs(buttons) do
		if inrange(x,y,b.x,b.y,b.w,b.h) and click then
      if b.hold and not b.p then
        b.f(b)
      elseif not b.hold then
        b.f(b)
      end
      b.p=true
    else
      b.p=false
		end
	end
end

function onDraw()
  if not on then return end
	w = screen.getWidth()
	h = screen.getHeight()
	if not ini then init() end
  
  s.dt(3,25,text)
  
  if rec[1] > 0 then
    receive()
    s.dt(3,8,received)
  end
  
  s.sc(20,20,20)
  screen.drawLine(0,18,w,18)
  
  for k,b in pairs(buttons) do
    if b.p then
      s.sc(255,255,255)
      s.drf(b.x,b.y,b.w,b.h)
      s.dr(b.x,b.y,b.w,b.h)
      s.sc(0,0,0)
      s.dtb(b.x+1,b.y+1,b.w,b.h,b.t,0,0)
    else
      if b.r then s.sc(20,20,20); s.dr(b.x,b.y,b.w,b.h) end
      s.sc(200,200,200,200)
      s.dtb(b.x+1,b.y+1,b.w,b.h,b.t,0,0)
    end
	end
end