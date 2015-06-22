confirmEvent = function()
	index=tonumber(forms.gettext(i));
	current=actualStart+112*index;
	
	xAdr=current+28;

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

--add reset button?
f=forms.newform("RaymanEvents");
i=forms.textbox(f, 0, 50, 20, "UNSIGNED", 0, 0);
x=forms.textbox(f, 1, 50, 20, "UNSIGNED", 0, 30);
y=forms.textbox(f, 1, 50, 20, "UNSIGNED", 60, 30);
confirm=forms.button(f, "Confirm", confirmEvent, 120, 30);

rayX=forms.label(f, "", 0, 60, 50, 20);
rayY=forms.label(f, "", 60, 60, 50, 20);

start=mainmemory.read_u32_le(0x1f4410)-0x80000000;
actualStart=start+424;

while true do
	forms.settext(rayX, memory.read_s16_le(0x1f61bc));
	forms.settext(rayY, memory.read_s16_le(0x1f61be));
	emu.frameadvance();
end
