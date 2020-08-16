ini,on = false,false
headD,zoom,ttl,ttlT,ru=0,0.5,0,0,0
cX,cY,cT,d,zF,ti,hl,nWP = 0,0,0,10,0.03,0,0,0
t={d=0,b=0}
wPb,AP=false,false
arr={}
io={}
io.gN,io.gB,io.sN,io.sB=input.getNumber,input.getBool,output.setNumber,output.setBool
s={}
s.drf,s.dt,s.sc,s.dtb,s.dr=screen.drawRectF,screen.drawText,screen.setColor,screen.drawTextBox,screen.drawRect
m={ms=map.mapToScreen}

function onTick()
  if on ~= io.gB(3) and on==true then stop() end
  on = io.gB(3)
  
	if ini and on then
    gX=io.gN(7);gY=io.gN(8);sp=io.gN(10);head=io.gN(11);mT=io.gN(12);acc=io.gN(13);dec=io.gN(14);ruD=io.gN(15);dX=io.gN(16);dY=io.gN(17);cX=io.gN(18);cY=io.gN(19);zoom=io.gN(20)
    
    cl = io.gB(1);tX=io.gN(3);tY=io.gN(4);clk(tX,tY,cl)
    if cl then hl=hl+1 else hl=0 end
    toDeg(head)
    if wPb then
      t=bD(arr[1].x,arr[1].y)
      if t.d<50 and ti>30 then
        nWP=nWP-1
        for i=1,7 do
          arr[i].x=arr[i+1].x;arr[i].y=arr[i+1].y
        end
        if nWP==0 then stop() end;ti=0
      end
    end
    
    if AP then
      setRu();setTh()
    end
    io.sB(1,AP);io.sN(1,ru);io.sN(2,ttl)
  end
end

function clk(x, y,c)
	for k,b in pairs(buttons) do
		if inrange(x,y,b.x,b.y,b.w,b.h) and c then
      if b.hold and hl>=b.ti and not b.a then
        b.f(b)
        b.a=true
      elseif not b.hold then
        b.f(b)
      end
      b.p=true
    else
      b.p=false;b.a=false
		end
	end
end

function addBtn(x,y,w,h,t,f,ti,hold,r)
	data = {
		['x']=(x or 0),['y']=(y or 0),
		['w']=(w or 0),['h']=(h or 0),
		['t']=(t or "err"),['f']=(f or nil),
    ['r']=(r or false),['ti']=(ti or 0),
    ['hold']=(hold or false),['a']=false,
    ['p']=false
	}
	table.insert(buttons,data)
end

function toDeg(head)
  if head < 0 then headD = (math.abs(head))*360
  elseif head == 0 then headD = 0
  else headD = 360-head*360 end
end

function setRu()
  diffL=((headD-t.b+360)%360);diffR=((t.b-headD+360)%360);diff=math.min(diffL,diffR)
  if diffL<diffR then ru=ru-ruD else ru=ru+ruD end
  if ru<0 and ru<-diff/30 then ru=math.max(-diff/30,-1) end
  if ru>0 and ru>diff/30 then ru=math.min(diff/30,1) end
  if ru<-1 then ru=-1 elseif ru>1 then ru=1 end
end

function setTh()
  if nWP>1 then tuTh=math.max(mT-mT*(diff/160),mT/4)
  else tuTh=math.max(mT-mT*(diff/120),mT/6) end
  if t.d>250 then dTh=mT
  elseif t.d<=250 and t.d>50 then dTh=t.d*(mT/200)
  else dTh=0 end
  ttlT=math.min(tuTh, dTh)
  if ttl<ttlT then ttl=ttl+acc elseif ttl>ttlT then ttl=ttl-dec end
end
function stop()
  AP=false;wPb=false;ttl=0;ru=0
end
function init()
	ini=true;c={x=w/2,y=h/2};f=h/32
  for i=1,8 do arr[i]={x=0,y=0} end
  buttons={}
  addBtn(w-14,h-7,12,6,"WP",function() addWP() end,0,true)
  addBtn(w-22,0,12,6,"AP",function() AP=not AP;ru=0;ttl=0;hl=0 end,30,true)
  addBtn(w-11,0,8,6,"X",function() nWP=0;hl=0;stop() end,50,true)
end

function addWP()
  wPb=true;nWP=math.min(nWP+1,8)
  arr[nWP].x,arr[nWP].y=map.screenToMap(cX,cY,zoom,w,h,c.x,c.y)
end

function inrange(cx, cy, x, y, w, h)
	return (cx>=x and cy>=y and cx<=(x+w) and cy<=(y+h))
end

function onDraw()
  w=screen.getWidth();h=screen.getHeight()
  if not ini then init() end
  if on then
    for k,b in pairs(buttons) do
      if b.p then
        s.sc(255,255,255);s.drf(b.x,b.y,b.w,b.h)
        s.dr(b.x,b.y,b.w,b.h);s.sc(0,0,0)
        s.dtb(b.x+1,b.y+1,b.w,b.h,b.t,0,0)
      else
        s.sc(150,0,0,150)
        if b.r then s.dr(b.x,b.y,b.w,b.h) end
        s.dtb(b.x+1,b.y+1,b.w,b.h,b.t,0,0)
      end
    end
    
    if AP then s.sc(0,100,0,150);s.dr(w-22,0,12,6) end

    if wPb then
      for i=1,nWP do
        tarX,tarY=m.ms(cX,cY,zoom,w,h,arr[i].x,arr[i].y)
        s.sc(100,0,0,100);s.drf(tarX-2,tarY-2,6,7)
        s.sc(0,0,0,100);s.dt(tarX-1,tarY-1,i)
      end
    end
    
    if dX~=0 and dY~=0 then
      s.sc(35, 96, 14,200)
      dpX,dpY=m.ms(cX,cY,zoom,w,h,dX,dY)
      s.dt(dpX-2,dpY-2,"X")
    end
  end
end

function bD(x,y)
  t.d=math.sqrt((x-gX)^2+(y-gY)^2)
  t.b=180*(math.atan(x-gX, y-gY))/math.pi
  if t.b<0 then t.b=360+t.b end
  return t
end