function plot_jmeter_results(file)
csv=csvread(file);
[csv,i]=sortrows(csv,1);

plot_every=100

s=size(csv);
sx=s(1,1);

%prepare timestamp
time=csv(1:end,1);
min_time=min(time);
max_time=max(time);
time=time.-min_time;
time=time(1:plot_every:end);

%prepare response times

resp=csv(1:end,2);
%resp=csv(1:end,5)/1000; %submillisecond resolution if supported by sampler
resp=rmoutlier(resp,1,0,0);
resp=resp;
resp=resp(1:plot_every:end);

%calculate errors
errors=csv(1:end,4);
ok_count=sum(errors==200);


p = polyfit (time, resp, 1);
trendy=polyval(p,time);

%print data
samples=sx
error_count_percent=(sx-ok_count)/sx*100
time_to_finish=(max_time-min_time)/1000
average_response_time=mean(resp)
standard_deviation=std(resp)
maximum_response_time=max(resp)
minimum_response_time=min(resp)


%plot data
x=time./1000;
y=resp./1000;
ty=trendy./1000;

clf;
plot(x,y,'.');
hold on;
plot(x,ty,'r');
ax = gca();
set(ax, 'outerposition', [0.1, 0.1, 0.8, 0.8]);
ylabel('time (s) lower is better');
xlabel('request time (s)');
set(ax,'xlim',[x(1,1),x(end,1)]);
legend(['rsp';'trnd']);

title(["Plot of dataset: " file " every " int2str(plot_every) "th request"]);
print(strcat(file,".eps"),"-deps");


