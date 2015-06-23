confirmEvent = function()
	index=tonumber(forms.gettext(i));
	current=actualStart+112*index; --each event is 112 bytes big
	
	xAdr=current+28; --the x position is the 28th byte of an event

	curX=forms.gettext(x);
	if(curX~="")
	then
		memory.write_s16_le(xAdr, tonumber(curX));
	end
	
	curY=forms.gettext(y);
	if(curY~="")
	then
		memory.write_s16_le(xAdr+2, tonumber(curY));
	end
	console.writeline(bizstring.hex(current) .. " (" .. index .. ") set to " .. curX .. ", " .. curY);
end

f=forms.newform("RaymanEvents");

fWidth=50;
fHeight=20;
hSpacing=10;
vSpacing=10;

--row 1
indexDescription=forms.label(f, "Index:", 0, 0, fWidth, fHeight);
i=forms.textbox(f, 0, fWidth, fHeight, "UNSIGNED", fWidth+hSpacing, 0);
size=forms.label(f, "", (fWidth+hSpacing)*2, 0, fWidth*2, fHeight);

--row 2
positionDescription=forms.label(f, "Position:", 0, fHeight+vSpacing, fWidth, fHeight);
x=forms.textbox(f, 1, fWidth, fHeight, "UNSIGNED", fWidth+hSpacing, fHeight+vSpacing); --TODO: position can actually be negative?
y=forms.textbox(f, 1, fWidth, fHeight, "UNSIGNED", (fWidth+hSpacing)*2, fHeight+vSpacing);
confirm=forms.button(f, "Confirm", confirmEvent, (fWidth+hSpacing)*3, fHeight+vSpacing);

--row 3
rayX=forms.label(f, "", fWidth+hSpacing, (fHeight+vSpacing)*2, fWidth, fHeight);
rayY=forms.label(f, "", (fWidth+hSpacing)*2, (fHeight+vSpacing)*2, fWidth, fHeight);

start=mainmemory.read_u32_le(0x1f4410)-0x80000000; --switching levels while the script is running might cause issues because this variable won't be updated!
actualStart=start+424; --1f4410 points to 424 bytes BEFORE the actual event list starts

actualEnd=mainmemory.read_u32_le(start+416)-0x80000000; --8 bytes before the first event there is the address for the end of the list
forms.settext(size, "(Maximum " .. ((actualEnd-actualStart)/112)-1 .. ")");

while true do
	forms.settext(rayX, memory.read_s16_le(0x1f61bc));
	forms.settext(rayY, memory.read_s16_le(0x1f61be));
	emu.frameadvance();
end
