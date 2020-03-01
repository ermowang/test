function  [radar_temp,mapsize]=coordinate(radar,resol,begin,over)
%程序功能：得到雷达数据对应的图上栅格坐标和最小范围地图
%输入：雷达数据，分辨率，开始时刻，结束时刻
%输出：雷达数据对应的图上栅格坐标，最小范围地图

radar_temp=radar;
%补偿yaw
for i=begin:over
    radar_temp.gps(i).yaw=deg2rad(radar_temp.gps(i).yaw-radar.gps(1).yaw+180);  %初始补偿角，右侧雷达180度
    %     target.gps(i).yaw=deg2rad(target.gps(i).yaw-radar.gps(1).yaw);  %初始补偿角，左侧雷达
    %     target.gps(i).yaw=deg2rad(target.gps(i).yaw-radar.gps(1).yaw+90);  %初始补偿角，前侧雷达180度
end

%计算各目标图上栅格坐标
for i=begin:over                  %每一个时间点
    if(size(radar_temp.data{i},2)==1)   %没有点云就跳过
        continue
    end
    for j=1:size(radar_temp.data{i},1)   %每一个点云内部
        %计算各目标实际坐标
        theta=radar_temp.gps(i).yaw;
        radar_temp.data{i}(j,1)=radar_temp.gps(i).x+radar.data{i}(j,1)*cos(theta)+radar.data{i}(j,2)*sin(theta);
        radar_temp.data{i}(j,2)=radar_temp.gps(i).y-radar.data{i}(j,1)*sin(theta)+radar.data{i}(j,2)*cos(theta);
        %计算各目标图上栅格坐标
        radar_temp.data{i}(j,1)= ceil(resol*radar_temp.data{i}(j,1));            %计算各目标图上栅格坐标
        radar_temp.data{i}(j,2)= ceil(resol*radar_temp.data{i}(j,2));
    end
end

%找到把坐标全部变为正数的偏置和栅格地图尺寸
k=1;
for i=begin:over            %i=1:size(target.time,2)
    if(size(radar_temp.data{i},2)==1)
        continue
    end
    for j=1:size(radar_temp.data{i},1)
        find_offset.x(k)=radar_temp.data{i}(j,1);
        find_offset.y(k)=radar_temp.data{i}(j,2);
        k=k+1;
    end
end
minval.x=min(find_offset.x);
minval.y=min(find_offset.y);
maxval.x=max(find_offset.x);
maxval.y=max(find_offset.y);
offset.x=1-minval.x;
offset.y=1-minval.y;
mapsize.x=(maxval.x-minval.x)+1;
mapsize.y=(maxval.y-minval.y)+1;

%把目标图上坐标全部变为正数
for i=begin:over
    if(size(radar_temp.data{i},2)==1)
        continue
    end
    for j=1:size(radar_temp.data{i},1)
        radar_temp.data{i}(j,1)= radar_temp.data{i}(j,1)+offset.x;
        radar_temp.data{i}(j,2)=radar_temp.data{i}(j,2)+offset.y;
    end
end

%计算雷达gps位置的图上坐标
for i=begin:over
    radar_temp.gps(i).x= ceil(resol*radar_temp.gps(i).x)+offset.x;
    radar_temp.gps(i).y= ceil(resol*radar_temp.gps(i).y)+offset.y;
end

