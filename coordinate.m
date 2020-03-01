function  [radar_temp,mapsize]=coordinate(radar,resol,begin,over)
%�����ܣ��õ��״����ݶ�Ӧ��ͼ��դ���������С��Χ��ͼ
%���룺�״����ݣ��ֱ��ʣ���ʼʱ�̣�����ʱ��
%������״����ݶ�Ӧ��ͼ��դ�����꣬��С��Χ��ͼ

radar_temp=radar;
%����yaw
for i=begin:over
    radar_temp.gps(i).yaw=deg2rad(radar_temp.gps(i).yaw-radar.gps(1).yaw+180);  %��ʼ�����ǣ��Ҳ��״�180��
    %     target.gps(i).yaw=deg2rad(target.gps(i).yaw-radar.gps(1).yaw);  %��ʼ�����ǣ�����״�
    %     target.gps(i).yaw=deg2rad(target.gps(i).yaw-radar.gps(1).yaw+90);  %��ʼ�����ǣ�ǰ���״�180��
end

%�����Ŀ��ͼ��դ������
for i=begin:over                  %ÿһ��ʱ���
    if(size(radar_temp.data{i},2)==1)   %û�е��ƾ�����
        continue
    end
    for j=1:size(radar_temp.data{i},1)   %ÿһ�������ڲ�
        %�����Ŀ��ʵ������
        theta=radar_temp.gps(i).yaw;
        radar_temp.data{i}(j,1)=radar_temp.gps(i).x+radar.data{i}(j,1)*cos(theta)+radar.data{i}(j,2)*sin(theta);
        radar_temp.data{i}(j,2)=radar_temp.gps(i).y-radar.data{i}(j,1)*sin(theta)+radar.data{i}(j,2)*cos(theta);
        %�����Ŀ��ͼ��դ������
        radar_temp.data{i}(j,1)= ceil(resol*radar_temp.data{i}(j,1));            %�����Ŀ��ͼ��դ������
        radar_temp.data{i}(j,2)= ceil(resol*radar_temp.data{i}(j,2));
    end
end

%�ҵ�������ȫ����Ϊ������ƫ�ú�դ���ͼ�ߴ�
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

%��Ŀ��ͼ������ȫ����Ϊ����
for i=begin:over
    if(size(radar_temp.data{i},2)==1)
        continue
    end
    for j=1:size(radar_temp.data{i},1)
        radar_temp.data{i}(j,1)= radar_temp.data{i}(j,1)+offset.x;
        radar_temp.data{i}(j,2)=radar_temp.data{i}(j,2)+offset.y;
    end
end

%�����״�gpsλ�õ�ͼ������
for i=begin:over
    radar_temp.gps(i).x= ceil(resol*radar_temp.gps(i).x)+offset.x;
    radar_temp.gps(i).y= ceil(resol*radar_temp.gps(i).y)+offset.y;
end

