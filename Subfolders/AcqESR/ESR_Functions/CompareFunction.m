function CompareFunction(hobject,eventdata)
if get(hobject,'Value')==1

set(hobject,'ForegroundColor',[0,0,1]);
h=guidata(gcbo);
h.l32=line('parent',h.Axes3);
h.l22=line('parent',h.Axes2);
h.l32.XData=h.l31.XData;
h.l22.XData=h.l21.XData;
h.l32.YData=h.l31.YData;
h.l31.YData=h.l32.YData;
lum1_tag = findobj('tag','lum1text');
lum2value = str2num(lum1_tag.String);
lum0_tag = findobj('tag','lum0text');
lum02value = str2num(lum0_tag.String);
h.l22.YData=h.l21.YData;
h.l21.YData=h.l22.YData;
set(h.l22,'Color','r')
set(h.l32,'Color','r')
ax3=findobj('Tag','Axes3');
text(1.02,0.77,num2str(lum2value),'FontSize',12,'Tag','lum2text','Units','Normalized','Parent',ax3,'Color','red');
ax2=findobj('Tag','Axes2');
text(1.02,0.77,num2str(lum02value),'FontSize',12,'Tag','lum2text','Units','Normalized','Parent',ax2,'Color','red');

else
    
h=guidata(gcbo);
set(hobject,'ForegroundColor',[1,0,0]);
delete(h.l32)
delete(h.l22)
lum2_tag = findobj('tag','lum2text');
delete(lum2_tag)
lum02_tag = findobj('tag','lum02text');
delete(lum02_tag)

end
guidata(gcbo,h)
end
