function [] = timePlotting(data,scale_factors,electrodes,tile_size)
%arbitrarily chosen - make user input
prompt = 'Enter instance before event (value from 1-749)';
x = input(prompt);

prompt = 'Enter instance after event (value from 1-749)';
y = input(prompt);
instances = [x,y];

colour = ['r','b'];
[rows, cols] = size(electrodes);

hold on
for i = 1:length(instances)
    for row = 1:rows

        nonzero = find(electrodes(row,:));
        idx = electrodes(row,nonzero);
        mv_scale = 128*scale_factors(electrodes(row,nonzero),1);
        
        mid = (max(data(idx,:),[],2) + min(data(idx,:),[],2))/2;
        diff = (max(data(idx,:),[],2) - min(data(idx,:),[],2))/2;
        y = (data(idx,instances(i))-mid)./diff;
        y = -mv_scale.*y;
        offset = tile_size(1)/2 + (row-1)*tile_size(1);
        y = y + offset;
        xaxis = tile_size(2)/2 + tile_size(2)*(nonzero -1);
        hold on
        plot(xaxis, y,colour(i));
    end
end
hold off
end

